xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 12
so2 = aave(sudp002+suwt002,g)*5.1e5*30*86400
d so2
draw title GOCART Deposition SO2 [Tg]
printim dp_so2.gocart.png white

reinit
xdfopen C90c_HTcntl.dep_Nv_monthly.ctl
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
set x 1
set y 1
set t 1 12
set z 1
so2g = aave(dd_so2+wd_so2,g)*5.1e5*30*86400
d so2g
* so2w = aave(sum(scav_so2/airdens.2*delp.2/9.81,z=1,z=72),g)*5.1e5*30*86400
draw title GMI Deposition SO2 [Tg]
printim dp_so2.gmi.png white
