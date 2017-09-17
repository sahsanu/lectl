# lectl

Script to check issued certificates by Let's Encrypt on CTL (Certificate Transparency Log) using https://crt.sh 

Note: crt.sh is property of COMODO CA Limited 2015-2017


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
<img src="https://cloud.githubusercontent.com/assets/10560305/14279272/a58c6f7c-fb2c-11e5-9456-364765fe1c46.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279274/a58d1ca6-fb2c-11e5-823a-2b9f4a3bd6d6.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279270/a5896bf6-fb2c-11e5-98c3-0ce7e30e7806.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279271/a58ae83c-fb2c-11e5-8cf2-de0401d30ccc.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279269/a5882386-fb2c-11e5-9977-37b4e7ac2703.png" width="90%"></img> <img src="https://cloud.githubusercontent.com/assets/10560305/14279273/a58d159e-fb2c-11e5-8b73-be5b220f70ad.png" width="90%"></img> 
