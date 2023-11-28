xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 12
so2 = aave(supso2,g)*5.1e5*30*86400
d so2
draw title GOCART SO2 production [Tg]
printim chem_dms.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
xdfopen C90c_HTcntl.rk2_Nv_monthly.ctl
set x 1
set y 1
set t 1 12
set z 1
so2g = aave(sum((qqk327.2+qqk328.2)/airdens*delp/9.81*0.062,z=1,z=72),g)*5.1e5*30*86400
d so2g
draw title GMI DMS SO2 production [Tg]
printim chem_dms.gmi.png white
