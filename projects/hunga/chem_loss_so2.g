xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 12
set vrange 0 10
so2 = aave(supso4g,g)*5.1e5*30*86400*64/96.
d so2
so2 = aave(supso4aq,g)*5.1e5*30*86400*64/96.
d so2
so2 = aave(supso4wt,g)*5.1e5*30*86400*64/96.
d so2

draw title GOCART SO2 Loss Through Chemistry [Tg]
printim chem_loss_so2.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
xdfopen C90c_HTcntl.rk2_Nv_monthly.ctl
set x 1
set y 1
set t 1 12
set z 1
set vrange 0 10
so2g = aave(sum((qqk329.2+qqk330.2+qqk331.2)/airdens*delp/9.81*0.062,z=1,z=72),g)*5.1e5*30*86400
d so2g
draw title GMI SO2 Loss Through Chemistry [Tg]
printim chem_loss_so2.gmi.png white
