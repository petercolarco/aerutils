reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
xdfopen C90c_HTcntl.rk2_Nv_monthly.ctl
xdfopen C90c_HTcntl.rj2_Nv_monthly.ctl
set x 1
set y 1
set t 1 12
set z 1
so2g = aave(sum((qqk332.2+qqk333.2+qqj075.3+qqj076.3)/airdens*delp/9.81*0.062,z=1,z=72),g)*5.1e5*30*86400
d so2g
draw title GMI SO2 Production (OCS, hv) Through Chemistry [Tg]
printim chem_prod_so2.gmi.png white
