# lectl

Script to check issued certificates by Let's Encrypt on CTL (Certificate Transparency Log) using https://crt.sh 

Note: crt.sh is property of COMODO CA Limited 2015-2018


**Usage**
```
lectl [-h|--help] [-v|--version] [-l|--extraline] [-s|--sans] [-e|--expired] [-u|--utc] [-m] [-p|--pre] [-f|--final] domain
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

 -m               [Default: 100] searchs for more or less than 100 certificates
                  per domain OR subdomain. It means that if for example you use
                  option -m25 you could receive an output of max 50 certs (25 for
                  the domain and 25 for *.domain).
                  If this option is not used, lectl searchs only for last 100
                  certificates. If the option is used it searches by default
                  for last 1000 certificates.
                  If you want to search for more or less certificates, append
                  the number after the option with no spaces (Ex: -m500). If
                  you specify a number, then the option must be specified
                  independently.
                  Wrong: lectl -seulm500 domain.tld
                  Good: lectl -seul -m500 domain.tld

 -p | --pre       [Default: true] shows only logged pre certs.

 -f | --final     [Default: true] shows only logged final certs.
```

**Examples**
```
lectl letsencryt.org
lectl -s -e -u -l -p letsencryt.org
lectl -seulmf letsencryt.org
lectl -lumsep letsencryt.org
lectl -su --extraline letsencryt.org
lectl -u letsencryt.org -esm --final
lectl -seulp -m500 letsencryt.org
...and so on
```
<img src="https://cloud.githubusercontent.com/assets/10560305/14279272/a58c6f7c-fb2c-11e5-9456-364765fe1c46.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279274/a58d1ca6-fb2c-11e5-823a-2b9f4a3bd6d6.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279270/a5896bf6-fb2c-11e5-98c3-0ce7e30e7806.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279271/a58ae83c-fb2c-11e5-8cf2-de0401d30ccc.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279269/a5882386-fb2c-11e5-9977-37b4e7ac2703.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279273/a58d159e-fb2c-11e5-8b73-be5b220f70ad.png" width="90%"></img> 
