xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 36
so2 = aave(so2cmass,g)*5.1e5
d so2
draw title GOCART SO2 [Tg]
printim so2_load.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
set x 1
set y 1
set t 1 36
set z 1
so2g = aave(sum(so2*delp/9.81*64./29.,z=1,z=72),g)*5.1e5
d so2g
draw title GMI SO2 [Tg]
printim so2_load.gmi.png white
