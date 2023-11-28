xdfopen MOD04_L2_ocn.b.qawt.ddf
xdfopen MOD04_L2_ocn.b.qafl.ddf

set t 1 10
set x 1
set y 1

aotb  = aave(aodtau,g)
aotbn = aave(aodtau*qasum.2,g)/aave(qasum.2,g)

xdfopen MOD04_L2_ocn.c.qawt.ddf
xdfopen MOD04_L2_ocn.c.qafl.ddf
aotc  = aave(aodtau.3,g)
aotcn = aave(aodtau.3*qasum.4,g)/aave(qasum.4,g)

xdfopen MOD04_L2_ocn.d.qawt.ddf
xdfopen MOD04_L2_ocn.d.qafl.ddf
aotd  = aave(aodtau.5,g)
aotdn = aave(aodtau.5*qasum.6,g)/aave(qasum.6,g)

set vrange 0.13 .18
set line 1 1 6
d aotbn
set line 4 1 6
d aotcn
set line 2 1 6
d aotdn

plotpng qawt.png
