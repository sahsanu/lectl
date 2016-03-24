# lectl

Script to check issued certificates by Let's Encrypt on CTL (Certificate Transparency Log) using https://crt.sh 

Note: crt.sh is property of COMODO CA Limited 2015-2016


**Usage**
```
lectl [-h|--help] [-v|--version] [-l|--extraline] [-s|--sans] [-e|--expired] [-u|--utc] domain
```
**Options**
```
-h | --help      [Default: false] shows the help file.

-v | --version   shows the script version.

-l | --extraline [Default: false] adds extra line separator between found
                 certificates (when there are several certs with several
                 sans adding this extra line it's easier to read the output).

-s | --sans      [Default: false] shows all domains included in the
                 certificate as SANs. If you don't use this option you will
                 only see the Common Name.

-e | --expired   [Default: false] shows all certs issued for the specified
                 domain, including the certs that are already expired.

-u | --utc       [Default: false] shows the dates in UTC (GMT) instead of
                 your machine time zone.
```

**Examples**
```
lectl letsencryt.org
lectl -s -e -u -l letsencryt.org
lectl -seul letsencryt.org
lectl -luse letsencryt.org
lectl -su --extraline letsencryt.org
lectl -u letsencryt.org -es
...and so on
```
