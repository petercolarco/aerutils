xdfopen emis_oc.ctl
set x 1
set y 1
set t 1 444
set t 1 72
set t 301 372

oc = aave(emis,g)*30*86400*5.1e5

d oc
draw title OC BB monthly emissions [Tg/mon]
printim emis_oc.2005_2010.png white

