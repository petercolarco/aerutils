xdfopen MOD04_L2_ocn.b.qawt.num.ddf
xdfopen MOD04_L2_ocn.b.qafl.ddf

set t 1 10
set x 1
set y 1

aotb  = aave(aodtau,g)
aotbn = aave(aodtau*num.2,g)/aave(num.2,g)

xdfopen MOD04_L2_ocn.c.qawt.num.ddf
xdfopen MOD04_L2_ocn.c.qafl.ddf
aotc  = aave(aodtau.3,g)
aotcn = aave(aodtau.3*num.4,g)/aave(num.4,g)

xdfopen MOD04_L2_ocn.d.qawt.num.ddf
xdfopen MOD04_L2_ocn.d.qafl.ddf
aotd  = aave(aodtau.5,g)
aotdn = aave(aodtau.5*num.6,g)/aave(num.6,g)

set vrange 0.13 .18
set line 1 1 6
d aotbn
set line 4 1 6
d aotcn
set line 2 1 6
d aotdn

plotpng num.png
