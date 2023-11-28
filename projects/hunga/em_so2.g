xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 36
so2 = aave(suem002,g)*5.1e5*30*86400
d so2
draw title GOCART Emissions SO2 [Tg]
printim em_so2.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
set x 1
set y 1
set t 1 36
set z 1
so2g = aave(sum(em_so2*delp/9.81*64./29.*30*86400,z=1,z=72),g)*5.1e5
d so2g
draw title GMI Emissions SO2 [Tg]
printim em_so2.gmi.png white
