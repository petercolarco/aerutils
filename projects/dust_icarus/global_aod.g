xdfopen d5124_m2_jan79.ddf
xdfopen c180F_pI20p1-acma_mie.tavg2d_aer_x.ctl
xdfopen c180F_pI20p1-acma_miet.tavg2d_aer_x.ctl

set x 1
set y 1
set t 1 12
aod  = aave(totexttau,g)
aod2 = aave(totexttau.2,g)
aod3 = aave(totexttau.3,g)
aodd  = aave(duexttau,g)
aodd2 = aave(duexttau.2,g)
aodd3 = aave(duexttau.3,g)

set vrange 0 .25
set line 0 1 12
d aod
set line 1 1 12
d aodd

set line 0 4 12
d aod2
set line 1 4 12
d aodd2

set line 0 6 12
d aod3
set line 1 6 12
d aodd3

printim totexttau.png white
