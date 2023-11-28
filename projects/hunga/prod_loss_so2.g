xdfopen C90c_HTcntl.aer_monthly.ctl
set x 1
set y 1
set t 1 12
so2 = aave(suem002+supso2,g)*5.1e5*30*86400
so2l = aave((sudp002+suwt002) + (supso4g+supso4aq+supso4wt)*64./96.,g)*5.1e5*30*86400
set vrange 13 15.5
d so2
d so2l
draw title GOCART SO2 production and loss [Tg]
printim prod_loss_so2.gocart.png white

reinit
xdfopen C90c_HTcntl.dac_Nv_monthly.ctl
xdfopen C90c_HTcntl.rk2_Nv_monthly.ctl
xdfopen C90c_HTcntl.dep_Nv_monthly.ctl
set x 1
set y 1
set t 1 12
set z 1
so2g = aave(sum((qqk327.2+qqk328.2)/airdens*delp/9.81*0.062,z=1,z=72)+sum(em_so2*delp/9.81*64./29.,z=1,z=72),g)*5.1e5*30*86400
so2gl = aave(dd_so2.3+wd_so2.3+sum((qqk329.2+qqk330.2+qqk331.2)/airdens*delp/9.81*0.062,z=1,z=72),g)*5.1e5*30*86400
d so2g
d so2gl
draw title GMI SO2 production and loss [Tg]
printim prod_loss_so2.gmi.png white
