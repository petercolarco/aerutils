xdfopen c180R_J10p14p1_aura.tavg2d_aer_x.ctl
xdfopen c180R_J10p17p1dev_aura.tavg2d_aer_x.ctl

set x 1
set y 1

set t 1 36

ni1 = aave(niexttau,g)
ni2 = aave(niexttau.2,g)
d ni1
d ni2
draw title Nitrate AOD
printim niexttau.png white

c
ni1 = aave(nicmass,g)*5.1e5
ni2 = aave(nicmass.2,g)*5.1e5
d ni1
d ni2
draw title Nitrate Column Mass (Tg)
printim nicmass.png white
