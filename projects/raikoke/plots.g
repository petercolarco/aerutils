set dd  = 24

while ( $dd < 31)

reinit
sdfopen /misc/prc18/colarco/c180R_pI33p9s12_volc/tavg2d_aer_x/c180R_pI33p9s12_volc.tavg2d_aer_x.201906${dd}_0900z.nc4
sdfopen /misc/prc18/colarco/c180R_pI33p9s12_volcv4/tavg2d_aer_x/c180R_pI33p9s12_volcv4.tavg2d_aer_x.201906${dd}_0900z.nc4

f = 1./0.064*6.022e23/2.6867e20

set lon -180 180
set lat 30 90
set mproj nps
set gxout shaded
set clevs 0 0.3 0.7 1 1.3 1.7 2
xycomp so2cmass*f so2cmass.2*f
printim so2cmass.201906${dd}.png white

@ dd = $dd + 1

end
