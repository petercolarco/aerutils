sdfopen /output/tc4/a_flk_04C/chem/Y2007/M08/a_flk_04C.chem_diag.sfc.200708.hdf

duem = duem001+duem002+duem003+duem004+duem005
dusd = dusd001+dusd002+dusd003+dusd004+dusd005
dusv = dusv001+dusv002+dusv003+dusv004+dusv005
dudp = dudp001+dudp002+dudp003+dudp004+dudp005
duwt = duwt001+duwt002+duwt003+duwt004+duwt005
duloss = dudp+dusd+dusv+duwt
d aave(duem,g)*5.1e5*31*86400
d aave(ducmass,g)*5.1e5
d aave(ducmass,g)/aave(duem,g)/86400
d aave(ducmass,g)/aave(duloss,g)/86400.

ssem = ssem001+ssem002+ssem003+ssem004+ssem005
sssd = sssd001+sssd002+sssd003+sssd004+sssd005
sssv = sssv001+sssv002+sssv003+sssv004+sssv005
ssdp = ssdp001+ssdp002+ssdp003+ssdp004+ssdp005
sswt = sswt001+sswt002+sswt003+sswt004+sswt005
ssloss = ssdp+sssd+sssv+sswt
d aave(ssem,g)*5.1e5*31*86400
d aave(sscmass,g)*5.1e5
d aave(sscmass,g)/aave(ssem,g)/86400
d aave(sscmass,g)/aave(ssloss,g)/86400.

ocem = ocem001+ocem002
ocsv = ocsv001+ocsv002
ocdp = ocdp001+ocdp002
ocwt = ocwt001+ocwt002
ocloss = ocdp+ocsv+ocwt
d aave(ocem,g)*5.1e5*31*86400
d aave(occmass,g)*5.1e5
d aave(occmass,g)/aave(ocem,g)/86400
d aave(occmass,g)/aave(ocloss,g)/86400.

bcem = bcem001+bcem002
bcsv = bcsv001+bcsv002
bcdp = bcdp001+bcdp002
bcwt = bcwt001+bcwt002
bcloss = bcdp+bcsv+bcwt
d aave(bcem,g)*5.1e5*31*86400
d aave(bccmass,g)*5.1e5
d aave(bccmass,g)/aave(bcem,g)/86400
d aave(bccmass,g)/aave(bcloss,g)/86400.

d aave(so4cmass,g)*5.1e5
d aave(supso4g,g)*5.1e5*31*86400
d aave(supso4wt+supso4aq,g)*5.1e5*31*86400
d aave(suem003,g)*5.1e5*31*86400
d aave(suem002,g)*5.1e5*31*86400

reinit
sdfopen /output/tc4/a_flk_04C/chem/Y2007/M09/a_flk_04C.chem_diag.sfc.200709.hdf

duem = duem001+duem002+duem003+duem004+duem005
dusd = dusd001+dusd002+dusd003+dusd004+dusd005
dusv = dusv001+dusv002+dusv003+dusv004+dusv005
dudp = dudp001+dudp002+dudp003+dudp004+dudp005
duwt = duwt001+duwt002+duwt003+duwt004+duwt005
duloss = dudp+dusd+dusv+duwt
d aave(duem,g)*5.1e5*31*86400
d aave(ducmass,g)*5.1e5
d aave(ducmass,g)/aave(duem,g)/86400
d aave(ducmass,g)/aave(duloss,g)/86400.

ssem = ssem001+ssem002+ssem003+ssem004+ssem005
sssd = sssd001+sssd002+sssd003+sssd004+sssd005
sssv = sssv001+sssv002+sssv003+sssv004+sssv005
ssdp = ssdp001+ssdp002+ssdp003+ssdp004+ssdp005
sswt = sswt001+sswt002+sswt003+sswt004+sswt005
ssloss = ssdp+sssd+sssv+sswt
d aave(ssem,g)*5.1e5*31*86400
d aave(sscmass,g)*5.1e5
d aave(sscmass,g)/aave(ssem,g)/86400
d aave(sscmass,g)/aave(ssloss,g)/86400.

ocem = ocem001+ocem002
ocsv = ocsv001+ocsv002
ocdp = ocdp001+ocdp002
ocwt = ocwt001+ocwt002
ocloss = ocdp+ocsv+ocwt
d aave(ocem,g)*5.1e5*31*86400
d aave(occmass,g)*5.1e5
d aave(occmass,g)/aave(ocem,g)/86400
d aave(occmass,g)/aave(ocloss,g)/86400.

bcem = bcem001+bcem002
bcsv = bcsv001+bcsv002
bcdp = bcdp001+bcdp002
bcwt = bcwt001+bcwt002
bcloss = bcdp+bcsv+bcwt
d aave(bcem,g)*5.1e5*31*86400
d aave(bccmass,g)*5.1e5
d aave(bccmass,g)/aave(bcem,g)/86400
d aave(bccmass,g)/aave(bcloss,g)/86400.

d aave(so4cmass,g)*5.1e5
d aave(supso4g,g)*5.1e5*30*86400
d aave(supso4wt+supso4aq,g)*5.1e5*30*86400
d aave(suem003,g)*5.1e5*30*86400
d aave(suem002,g)*5.1e5*30*86400
