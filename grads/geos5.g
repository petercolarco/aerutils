sdfopen /output/tc4/d5_tc4_01/das/diag/Y2007/M08/d5_tc4_01.tavg2d_aer_x.200708.hdf

duem = duem001+duem002+duem003+duem004+duem005
d aave(duem,g)*5.1e5*31*86400
d aave(ducmass,g)*5.1e5
d aave(ducmass,g)/aave(duem,g)/86400

ssem = ssem001+ssem002+ssem003+ssem004+ssem005
d aave(ssem,g)*5.1e5*31*86400
d aave(sscmass,g)*5.1e5
d aave(sscmass,g)/aave(ssem,g)/86400

ocem = ocem001+ocem002
d aave(ocem,g)*5.1e5*31*86400
d aave(occmass,g)*5.1e5
d aave(occmass,g)/aave(ocem,g)/86400

bcem = bcem001+bcem002
d aave(bcem,g)*5.1e5*31*86400
d aave(bccmass,g)*5.1e5
d aave(bccmass,g)/aave(bcem,g)/86400

d aave(so4cmass,g)*5.1e5
d aave(supso4g,g)*5.1e5*31*86400
d aave(supso4wt+supso4aq,g)*5.1e5*31*86400
d aave(suem003,g)*5.1e5*31*86400
d aave(suem002,g)*5.1e5*31*86400

reinit
sdfopen /output/tc4/d5_tc4_01/das/diag/Y2007/M09/d5_tc4_01.tavg2d_aer_x.200709.hdf

duem = duem001+duem002+duem003+duem004+duem005
d aave(duem,g)*5.1e5*30*86400
d aave(ducmass,g)*5.1e5
d aave(ducmass,g)/aave(duem,g)/86400

ssem = ssem001+ssem002+ssem003+ssem004+ssem005
d aave(ssem,g)*5.1e5*30*86400
d aave(sscmass,g)*5.1e5
d aave(sscmass,g)/aave(ssem,g)/86400

ocem = ocem001+ocem002
d aave(ocem,g)*5.1e5*30*86400
d aave(occmass,g)*5.1e5
d aave(occmass,g)/aave(ocem,g)/86400

bcem = bcem001+bcem002
d aave(bcem,g)*5.1e5*30*86400
d aave(bccmass,g)*5.1e5
d aave(bccmass,g)/aave(bcem,g)/86400

d aave(so4cmass,g)*5.1e5
d aave(supso4g,g)*5.1e5*30*86400
d aave(supso4wt+supso4aq,g)*5.1e5*30*86400
d aave(suem003,g)*5.1e5*30*86400
d aave(suem002,g)*5.1e5*30*86400
