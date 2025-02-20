#!/bin/bash
# ---------------------------------------------------------------------------
# lectl
# Script to check issued certificates by Let's Encrypt in
# CTL (Certificate Transparency Log) using https://crt.sh
#
# Note: crt.sh is property of Sectigo Limited 2015-2020

# Author: sahsanu

# DOWNLOAD lectl
# You'll find last lectl version at https://github.com/sahsanu/lectl

# LICENSE:
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# HELP:
#U Usage:
#U
#U lectl [-h|--help] [-v|--version] [-l|--extraline] [-s|--sans] [-e|--expired] [-u|--utc] [-m] [-p|--pre] [-f|--final] domain
#U
#H Options:
#H
#H -h | --help      [Default: false] shows the help file.
#H
#H -v | --version   shows the script version.
#H
#H -l | --extraline [Default: false] adds extra line separator between found
#H                  certificates (when there are several certs with several
#H                  sans adding this extra line it's easier to read the output).
#H
#H -s | --sans      [Default: false] shows all domains included in the
#H                  certificate as SANs. If you don't use this option you will
#H                  only see the Common Name.
#H
#H -e | --expired   [Default: false] shows all certs issued for the specified
#H                  domain, including the certs that are already expired.
#H
#H -u | --utc       [Default: false] shows the dates in UTC (GMT) instead of
#H                  your machine time zone.
#H
#H -m               [Default: 100] searchs for more or less than 100 certificates
#H                  per domain OR subdomain. It means that if for example you use
#H                  option -m25 you could receive an output of max 50 certs (25 for
#H                  the domain and 25 for *.domain).
#H                  If this option is not used, lectl searchs only for last 100
#H                  certificates. If the option is used it searches by default
#H                  for last 1000 certificates.
#H                  If you want to search for more or less certificates, append
#H                  the number after the option with no spaces (Ex: -m500). If
#H                  you specify a number, then the option must be specified
#H                  independently.
#H                  Wrong: lectl -seulm500 domain.tld
#H                  Good: lectl -seul -m500 domain.tld
#H
#H -p | --pre       [Default: true] shows only logged pre certs.
#H
#H -f | --final     [Default: true] shows only logged final certs.
#H
#H Examples:
#H
#H     lectl letsencryt.org
#H     lectl -s -e -u -l -p letsencryt.org
#H     lectl -seulmf letsencryt.org
#H     lectl -lumsep letsencryt.org
#H     lectl -su --extraline letsencryt.org
#H     lectl -u letsencryt.org -esm --final
#H     lectl -seulp -m500 letsencryt.org
#H     ...and so on
#H
# CHANGELOG:
# 2016-Feb-10: Created (v0.1)
# 2016-Mar-24: Public release with many fixes (v0.2)
# 2016-Mar-25: Add support to new certificate authority X3 (v0.3)
# 2016-Mar-27: Rate limits have changed from 5 per 7 days to 20 per 7 days (v0.4)
# 2016-Mar-28: Add support to Let's Encrypt authorities X2 and X4 (v0.5)
# 2016-Apr-04: Fix, if no domain is found in crt.sh the script didn't perform the housekeeping (v0.6)
# 2016-Jun-04: Fix, add env language variables pointing to C locale so date command output is in english (v0.7)
# 2016-Oct-26: Fix, crt.sh web page changed the html of their pages so lectl was not working at all (v0.8)
# 2016-Oct-26: Enhanced, CA IDs assigned by crt.sh to Let's Encrypt (X1, X2, X3...) are not harcoded anymore, they are fetched dynamically from crt.sh web page (v0.8)
# 2017-Jun-11: Fix, if the number of certificates to display is 100 or more the columns were not displayed correctly (v0.9)
# 2017-Sep-15: Enhanced, added option -m to search for more (or less) than 100 (default option) certificates. This option closes issue https://github.com/sahsanu/lectl/issues/2 (v0.10)
# 2017-Sep-15: I want to thank Github User spikebike (https://github.com/spikebike) for the tip to be able to search more or less than 100 certificates on crt.sh site (v0.10)
# 2017-Oct-06: Enhanced, utilities are defined in variables so it is easier to change them if you are using for example OS X and want to change date by gnu date (ggdate) (v0.11)
# 2017-Oct-06: Fix, if maxnumberofcerts is less than ratelimit there is no need to show any advice because it won't be accurate (v0.11)
# 2018-Jan-17: Enhanced, added option to use gdate and gsed in MacOS thanks to fnkr https://github.com/fnkr (v0.12)
# 2018-Feb-15: Fix, add 1 hour when showing the next date you could issue a cert when hitting the rate limit. This is because Let's Encrypt always issue the certificates using 1 hour less than real time but Let's Encrypt keeps the real time in their DB to remove expired limits (v0.13)
# 2018-Apr-16: Enhanced, added column CERT TYPE to show whether the logged cert is the Final cert or the Pre cert. Due LE is embeding SCT receipts in certificates, the certificates are logged twice, the pre certificate and the final cert with the embeded SCT receipts. As Final certificates are logged a few hours or days after the pre certificate, the script only takes care of pre certificates to check them against the rate limits (v0.14)
# 2018-Apr-16: Enhanced, added options [-p|--pre] and [-f|--final] to show only Pre certificates or to show only Final certificates. If no option, script will show both types of certificates. The rate limits using -f option could not be accurate due this type of cert takes too long to be logged. Rate limits using --pre option or none are counted using only the logged pre certs (v0.15)
# 2018-Aug-05: Fix, Let's Encrypt has raised the rate limit to issue certificates for a domain in 7 days from 20 to 50,so I've updated it too (v0.16).
# 2018-Aug-23: Enhanced, grep pattern modified to allow searches using wildcard subdomains *.domain.tld. Keep in mind that using *.domain.tld searches literally for *.domain.tld and in this case * doesn't act as a wildcard. Thanks to @travisjeffery for requesting it and provide a pull a request (v0.17)
# 2020-Jan-24: Fix, crt.sh has been moved to new servers and has changed how the html is presented so lectl was not able to get the right info and was not working at all. This has been fixed in this release, we'll see how long lasts (v0.18)
# 2020-Jan-25: Fix, some commands were not used as variables (v0.19)
# 2020-Feb-01: Fix, even if there are no certificates for a domain, lectl returns 1 certificate because the wc -l command also counts blank lines (v0.20)
# 2020-Aug-09: Enhanced, added column KEY ALG to show the Key Algorithm used in certificate. Examples; RSA 2048bit, ECC 256bit, etc. (v0.21)
# 2023-Jul-24: Update rate limited error message. Add more checks for required utility tools. (v0.22)
# 2023-Jul-26: Fix quotes on scriptname variable. (v0.22.1)
# 2023-Jul-30: Add auto-update functionality (v0.23.0)
# TODO:
# Clean up and comment the code
# Create auto-update version (comming...some day...or not)

#Variables for utilities
_date=date
_sed=sed
_grep=grep
_curl=curl
_awk=awk
_cat=cat
_sort=sort
_column=column
_tail=tail
_tr=tr
_wc=wc

# macOS compatibility
if [ "$(uname -s)" = "Darwin" ]; then
    _date=gdate
    _sed=gsed
fi

# Script version/name variables
version='0.21.0'
scriptname="${BASH_SOURCE[0]}"
lastmodification='2025-February-20'
checknewversion=1
forceupgrade=1
maxnumberofcerts=100
showprecerts=0
showfinalcerts=0
#Export env language variables to use C locale
export LANG=C
export LANGUAGE=C
export LC_ALL=C

_selfupgrade() {
    if [ $forceupgrade -eq 1 ]; then
        tmp_file=$(mktemp)
        echo "Updating to v$latest_version..."
        echo "$latest_source" > "$tmp_file"
        chmod +x "$tmp_file"
        
        if mv -f "$tmp_file" "$0"; then
            echo "Update successful. Reloading..."
            exec "$0" "${original_args[@]}"  # Re-exec with original arguments
            exit 0
        else
            _echoerr "Failed to install update"
        fi
        rm -f "$tmp_file"
    fi
}

_checkcommands() {
for i in $*;do
    if ! command -v "$i" &>/dev/null ;then
    echo "Command \"$i\" not found."
    echo "Sorry, I can't continue, I need \"$i\" to run."
    exit 1
    fi
done
}

_checkcommands "$_curl $_awk $_grep $_sed $_cat $_date $_sort $_column $_tail ${_tr} ${_wc}"

_checknewversion() {
    if [ $checknewversion = 1 ];then
        echo "Checking for updates..."
        
        # Get latest version
        latest_source=$($_curl -sSk "https://raw.githubusercontent.com/sahsanu/lectl/master/lectl")
        if [ $? -eq 0 ]; then
            latest_version=$(echo "$latest_source" | grep -m1 "version='" | $_sed "s/version='\([^']*\)'.*/\1/")
            if [ "$latest_version" != "$version" ]; then
                echo "New version available: $latest_version"
                echo "Get it here: https://raw.githubusercontent.com/sahsanu/lectl/master/lectl"
                read -n 1 -s -r -p "Do you want to update? (y/n)"
                echo ""
                if [ "$REPLY" = "y" ]; then
                    _selfupgrade
                fi
            fi
        fi
    fi
}

_showversion() {
    echo "${scriptname} $version (${lastmodification})"
    _checknewversion
    printf '\n'
}

_showversion

utc=""
domain=""
extraline=""
showsans="0"
columnsans=""
showexpired="1"
expired='&exclude=expired'
nonexpired="non expired "
ratelimit='50'

# Define message functions
_echoerr()  { echo "Error: $@" >&2; }
_echowarn() { echo "Warning: $@"; }
_echoinf()  { echo "Info: $@"; }

# Function to check error on previous command
_checkerror() {
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        _echoerr "${1}"
        _echoerr "Return code was: ${rc}"
        printf '\n'
        _housekeeping
        exit ${rc}
fi

}

# No comment[s]
_plural() {
    if [ "${1}" -eq "1" ] || [ "${1}" -eq "-1" ];then
        printf ''
    else
        printf 's'
    fi
}

# Help and usage functions
_showusage() {
    usage=$($_grep '^#U' "$0")
    _checkerror "Ups, Where is my help?, Did you modified the comments of my script?"
    $_sed 's/#U//' <<< "${usage}"
}

_showhelp() {
    _showusage
    help=$($_grep '^#H' "$0")
    _checkerror "Ups, Where is my help?, Did you modified the comments of my script?"
    $_sed 's/#H//' <<< "${help}"
}

# Clean the house
_housekeeping() {
    if [ -d "${tempdir}" ];then
        rm -rf "${tempdir}"
    fi
}

# Take care of signals
_trap_exit() { # Handle trapped signals
  case $1 in
    INT)
      _echoerr "${scriptname} has been interrupted by user"
      _housekeeping
      exit 100
      ;;
    TERM)
      _echoerr "${scriptname} terminated"
      _housekeeping
      exit 101
      ;;
    *)
      _echoerr "Terminating ${scriptname} on unknown signal"
      _housekeeping
      exit 102
      ;;
  esac
}

# Trap signals
trap "_trap_exit INT" INT
trap "_trap_exit TERM" TERM HUP

_parsemorecerts() {
    if [ "$1" == "" ]; then
        maxnumberofcerts="100"
        return
    fi
    if [ "$1" == "-m" ]; then
        maxnumberofcerts="1000"
        return
    else
        _tmp_maxnumberofcerts=$(echo "$1" | $_tr -d '\-m')
        re='^[0-9]+$'
        if ! [[ $_tmp_maxnumberofcerts =~ $re ]] ; then
           _echoerr "Option for -m is not a number"
           printf '\n'
           exit 150
        else
           maxnumberofcerts=$_tmp_maxnumberofcerts
           return
        fi
    fi
}

# Parse options
_parseoptions() {
    if [ "$#" -gt "0" ];then
        while [ -n "$1" ]; do
            case $1 in
                    -h | --help) _showhelp; exit ;;
                     -u | --utc) utc="-u" ;;
                      -s|--sans) showsans='1'; columnsans=';SANs' ;;
                   -e|--expired) showexpired="0"; expired=''; nonexpired='' ;;
                 -l|--extraline) extraline='\n' ;;
                 -v | --version) exit ;;
                            -m*) _parsemorecerts "$1" ;;
                   -f | --final) showfinalcerts='1' ;;
                     -p | --pre) showprecerts='1' ;;
                       -* | --*) _echoerr "Unknown option $1"; _showusage; exit 1 ;;
                              *) domain="${1}" ;;
            esac
            shift
        done
    else
        _echoerr "You MUST specify a domain name."
        printf '\n'
        exit 1
    fi
    if [ $showfinalcerts -eq 0 ] && [ $showprecerts -eq 0 ];then
        showfinalcerts=1
        showprecerts=1
        typeofcerts='all'
        rate_limit_type='final'
    fi
    if [ $showfinalcerts -eq 1 ] && [ $showprecerts -eq 1 ];then
        typeofcerts='all'
        rate_limit_type='final'
    fi
    if [ $showfinalcerts -eq 1 ] && [ $showprecerts -eq 0 ];then
        typeofcerts='final'
        rate_limit_type='pre'
    fi
    if [ $showfinalcerts -eq 0 ] && [ $showprecerts -eq 1 ];then
        typeofcerts='pre'
        rate_limit_type='final'
    fi

    if [ -z "${domain}" ];then
        _echoerr "You MUST specify a domain name."
        printf '\n'
        exit 1
    else
        echo "${domain}" | $_grep -E '^[a-zA-Z0-9\*\.-]+\.[A-Za-z]{2,}$' &>/dev/null
        _checkerror "Seems the specified domain ${domain} is not valid"
    fi
}

while [ -n "$1" ];do
    param=$(printf -- "$1" | tr '[:upper:]' '[:lower:]')
    if $_grep -E '^-[a-z]{2,}' <<< $param &>/dev/null ;then
        for i in $(printf -- "$param" | $_sed 's/-//' | $_grep -o .); do options="$options -$i";done
        shift
    else
        options="$options $param"
        shift
    fi
done

_parseoptions $options


# Define temp dir and tempifile
tempdir=".${scriptname}.$$.tmp"
if [ ! -d "${tempdir}" ];then
    mkdir "${tempdir}"
fi
tempfile="${tempdir}/${domain}.$$.rl.tmp"

# Let's go
echo "$($_date +"%Y/%B/%d %H:%M:%S") - Checking ${typeofcerts} certs for ${domain}"
echo " "

#Get CA ids assigned to Let's Encrypt by crt.sh
caidsle=$($_curl -sSk "https://crt.sh/?CAName=%25s+Encrypt%25")
_checkerror "Failed to retrieve Lets Encrypt CA ids"

caidsle=$(echo "$caidsle" | $_awk -F '=|"|<' '/caid/ {print $6}')
_checkerror "Failed to split Lets Encrypt CA ids" 145

# Define crt.sh url
crturldomainid="https://crt.sh/?id="
numberofcerts="&p=1&n=${maxnumberofcerts}"

for caid in ${caidsle};do
# Get issued certificates for domain and subdomains (X1, X2, X3, X4, etc.)
    $_curl -sSk "https://crt.sh/?Identity=${domain}&iCAID=${caid}${expired}${numberofcerts}" >> "${tempfile}" 2>/dev/null
    _checkerror "Failed to retrieve https://crt.sh/?Identity=${domain}&iCAID=${caid}${expired}${numberofcerts}"

# Wildcard % is used by default so no need to perform 2 queries
#    $_curl -sSk "https://crt.sh/?Identity=%.${domain}&iCAID=${caid}${expired}${numberofcerts}" >> "${tempfile}" 2>/dev/null
#    _checkerror "Failed to retrieve https://crt.sh/?Identity=%.${domain}&iCAID=${caid}${expired}${numberofcerts}"
done

# Put certificates found in variable
certsfound=$($_grep -A3 '?id=' "${tempfile}" | $_sed ':a;N;$!ba;s/>\n//g'| $_tr -d ' ')

# Sorting output and removing duplicates so last cert is the first in the list
certsfound=$(echo "$certsfound" | $_sed 's/^.*id=//' | $_sort -run)

# Count certificates
numberofcerts=$(echo "${certsfound}" | grep -cv '^\s*$')
numberofcerts=$(echo "${numberofcerts}" | $_tr -d ' ')

if [ "${numberofcerts}" -le 0 ];then
    _echoinf "I've not found any certificate for the domain ${domain}"
    printf '\n'
    _housekeeping
    exit 0
fi

numberfinalcerts=0
numberprecerts=0

for i in $(echo "${certsfound}");do
    id=$(echo "$i" | $_awk -F'"' '{print $1}')

    $_curl -sS "${crturldomainid}${id}" > "${tempfile}.${id}" 2>/dev/null
    _checkerror "Failed to retrieve ${crturldomainid}${id}"

    algorithm=$($_sed 's/&nbsp;//g' "${tempfile}.${id}" | $_sed 's/<BR>/\n/g' | $_grep PublicKeyAlgorithm | $_grep rsa &>/dev/null && echo RSA || echo ECC)
    publickey=$($_sed 's/&nbsp;//g' "${tempfile}.${id}" | $_sed 's/<BR>/\n/g' | $_grep 'Public-Key:' | $_awk -F':' '{print $2}' | $_tr -d '()')
    keyalgorithm="$algorithm $publickey"

    domainid=$($_sed 's/&nbsp;//g' "${tempfile}.${id}" | $_sed 's/<BR>/\n/g' | $_grep -i commonName | $_tail -n1 | $_awk -F'=' '{print $2}')
    certtype="$($_grep -A1 '>Summary<' "${tempfile}.${id}" | $_grep 'Precertificate' 1>/dev/null 2>&1)"
    if [ $? -eq 0 ];then
        certtype="Pre cert"
        numberprecerts=$((numberprecerts + 1))
        if [ $showprecerts -eq 0 ];then
            continue
        fi
    else
        certtype="Final cert"
        numberfinalcerts=$((numberfinalcerts + 1))
        if [ $showfinalcerts -eq 0 ];then
            continue
        fi
    fi
    validfrom=$($_sed 's/Not&nbsp;Before:/\r\nBxexfxoxrxex:/g' "${tempfile}.${id}" | $_awk -F'<BR>' '/^Bxexfxoxrxex:/ {print $1}' | $_sed 's/Bxexfxoxrxex:&nbsp;//g' | $_sed 's/&nbsp;/ /g')
    validfrom=$($_date ${utc} -d "${validfrom}" +'%Y-%b-%d %H:%M %Z')

    validto=$($_sed 's/Not&nbsp;After&nbsp;:&nbsp;/\r\nAxfxtxexrx:/g' "${tempfile}.${id}" | $_awk -F'<BR>' '/^Axfxtxexrx:/ {print $1}' | $_sed 's/Axfxtxexrx://g' | $_sed 's/&nbsp;/ /g')
    validto=$($_date ${utc} -d "${validto}" +'%Y-%b-%d %H:%M %Z')

    expiresin=$(($(($($_date ${utc} -d "$(echo "${validto}" | $_awk -F'-| ' '{print $2,$3,$4,$5,$1}')" +"%s") - $($_date ${utc} +"%s"))) / 86400))
    expiresin="${expiresin} day$(_plural ${expiresin})"

    if [ "${showsans}" -eq "1" ]; then
        SANS=$($_sed 's/DNS:/\r\nDNS:/g' "${tempfile}.${id}" | $_awk -F'<BR>' '/^DNS:/ {print $1}' | $_sed 's/DNS:/ ; ; ; ; ; ; ;/g' | $_sed ':a;N;$!ba;s/\n/\\n/g' | $_sed 's/ ; ; ; ; ; ; ;//')
        partialresult=$(printf "%s;%s;%s;%s;%s;%s;%s;%s" "$id" "$certtype" "$domainid" "$keyalgorithm" "$validfrom" "$validto" "$expiresin" "$SANS")
        result="${result}\n${partialresult}${extraline}; ; ; ; ; ; ;\n"
    else
        partialresult=$(printf "%s;%s;%s;%s;%s;%s;%s" "$id" "$certtype" "$domainid" "$keyalgorithm" "$validfrom" "$validto" "$expiresin")
        result="${result}\n${partialresult}${extraline}; ; ; ; ; ;\n"
    fi
done

finalresult=$result

echo "I have found ${numberofcerts} ${nonexpired}certificate$(_plural $numberofcerts) ($numberfinalcerts final cert$(_plural $numberfinalcerts) and $numberprecerts pre cert$(_plural $numberprecerts)) (max number of certs searched: ${maxnumberofcerts}) for domain ${domain} and its subdomains *.${domain}"
printf '\n'
echo -e "CRT ID;CERT TYPE;DOMAIN (CN);KEY ALG;VALID FROM;VALID TO;EXPIRES IN${columnsans}\n${finalresult}" | $_column -t -s ';'

count=0
finalresult=$(echo "${finalresult}" | $_sed 's/\\n\\n/TRISCADEICADELICA/g' | $_sed 's/\\n//g' | $_sed 's/TRISCADEICADELICA/\n/g' | $_tr ' ' '_')

for i in $(echo "${finalresult}" | $_grep -iv "$rate_limit_type" | $_awk -F';' '{print $5}');do
    rightnow=$($_date ${utc} +'%s')
    i=$(echo "$i" | $_tr '_' ' ')
    converteddate=$(echo "$i" | $_awk -F'-| ' '{print $2,$3,$4,$5,$1}')
    certdate=$($_date $utc -d "$converteddate" +'%s')
    daystoexpire=$(((${rightnow}-${certdate})/(60*60*24)))

    if [ "${daystoexpire}" -lt "7" ] && [ "${count}" -lt "${ratelimit}" ];then
        count=$((count+1))
        dentrode="${dentrode}\n${converteddate}"
    fi
done

#If maxnumberofcerts is less than ratelimit there is no need to show any advice because it won't be accurate
if [ $maxnumberofcerts -ge $ratelimit ]; then
    remaining=$((${ratelimit}-count))
    if [ $remaining -le 0 ];then
        lastcert=$(echo -e "${dentrode}" | $_tail -n1 )
        next=$($_date ${utc} -d "${lastcert}+7 days 1 hour 1 minute" +'%A %Y-%b-%d %H:%M:%S %Z')
        if [ -z "${extraline}" ];then echo " ";fi
            echo "Sorry, you can't issue any certificate, you already issued $count certificate$(_plural $count) on last 7 days"
            echo "You could issue next certificate on $next"
            printf '\n'
            echo "Note 1: Keep in mind that if ${domain} is included in PSL (Public Suffix List) the rate limit could only be applied to your subdomain instead of your domain."
            echo "Note 2: If you requested a rate limit adjustment for your domain or ACME account ID via https://letsencrypt.org/docs/rate-limits/ that change is not reflected here."
            echo "Note 3: Let's Encrypt has a renewal exemption for the certificates/registered domain/week rate limit. More information can be found at: https://letsencrypt.org/docs/rate-limits/"
            printf '\n'
        else
            if [ -z "${extraline}" ];then echo " ";fi
            echo "You have issued ${count} certificate$(_plural ${count}) in last 7 days so you could issue ${remaining} more certificate$(_plural ${remaining}) now."
            printf '\n'
        fi
else
    printf '\n'
fi

_housekeeping
