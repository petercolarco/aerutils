xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 36
so2 = aave(dmscmass,g)*5.1e5
d so2
draw title GOCART DMS Load [Tg]
printim dms_load.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
set x 1
set y 1
set t 1 36
set z 1
so2g = aave(sum(dms*delp/9.81*62./29.,z=1,z=72),g)*5.1e5
d so2g
draw title GMI DMS Load [Tg]
printim dms_load.gmi.png white
