xdfopen c48R_pI33p7.tavg2d_aer_x.ctl
xdfopen c48R_pI33p7lite3.tavg2d_aer_x.ctl

set x 1
set y 1
set t 1 12

* monthly mean DU AOD
du1 = aave(duexttau,g)
du2 = aave(duexttau.2,g)
ducm1 = aave(ducmass,g)*5.1e5
ducm2 = aave(ducmass.2,g)*5.1e5
dupm1 = aave(dusmass25,g)*1e9
dupm2 = aave(dusmass25.2,g)*1e9
duang1 = aave(duangstr*duexttau,g)/du1
duang2 = aave(duangstr.2*duexttau.2,g)/du2

* monthly mean SS AOD
ss1 = aave(ssexttau,g)
ss2 = aave(ssexttau.2,g)
sscm1 = aave(sscmass,g)*5.1e5
sscm2 = aave(sscmass.2,g)*5.1e5
sspm1 = aave(sssmass25,g)*1e9
sspm2 = aave(sssmass25.2,g)*1e9
ssang1 = aave(ssangstr*ssexttau,g)/ss1
ssang2 = aave(ssangstr.2*ssexttau.2,g)/ss2

* total angstr
totang1 = aave(totangstr*totexttau,g)/aave(totexttau,g)
totang2 = aave(totangstr.2*totexttau.2,g)/aave(totexttau.2,g)

set grads off
set vrange 0.02 0.04
d du1
d du2
draw title Dust global mean AOD (black=heavy,green=lite) (2016)
printim duext.png white

c
set grads off
d ss1
d ss2
draw title Sea Salt global mean AOD (black=heavy,green=lite) (2016)
printim ssext.png white

c
set grads off
d ducm1
d ducm2
draw title Dust global mean burden [Tg] (black=heavy,green=lite) (2016)
printim ducmass.png white

c
set grads off
set vrange 15 22
d sscm1
d sscm2
draw title Sea Salt global mean burden [Tg] (black=heavy,green=lite) (2016)
printim sscmass.png white


c
set grads off
d dupm1
d dupm2
draw title Dust global mean PM2.5 [ug m-3] (black=heavy,green=lite) (2016)
printim dupm25.png white

c
set grads off
d sspm1
d sspm2
draw title Sea Salt global mean PM2.5 [ug m-3] (black=heavy,green=lite) (2016)
printim sspm25.png white


c
set grads off
set vrange -0.1 -0.085
d duang1
d duang2
draw title Dust global mean Angstrom Parameter (black=heavy,green=lite) (2016)
printim duang.png white

c
set grads off
set vrange 0 0.02
d ssang1
d ssang2
draw title Sea Salt global mean Angstrom Parameter (black=heavy,green=lite) (2016)
printim ssang.png white

c
set grads off
d totang1
d totang2
draw title Total Aerosol global mean Angstrom Parameter (black=heavy,green=lite) (2016)
printim totang.png white
