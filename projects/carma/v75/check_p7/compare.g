xdfopen c90F_pI33p4_ocs.tavg2d_carma_x.ddf
xdfopen c90F_pI33p7_ocs.tavg2d_carma_x.ddf

set x 1
set y 1
set t 1 24
su1 = aave(suexttau,g)
su2 = aave(suexttau.2,g)
d su1
d su2
printim suexttau.png white


c
su1 = aave(sucmass,g)
su2 = aave(sucmass.2,g)
d su1*5.1e5
d su2*5.1e5
printim sucmass.png white


reinit
xdfopen c90F_pI33p4_ocs.tavg2d_aer_x.ddf
xdfopen c90F_pI33p7_ocs.tavg2d_aer_x.ddf

set x 1
set y 1
set t 1 24
su1 = aave(so2cmass,g)
su2 = aave(so2cmass.2,g)
d su1*5.1e5
d su2*5.1e5
printim so2cmass.png white
