xdfopen ../ctl/b_Fortuna-2_5-b2.tavg2d_aer_x.ctl
c
set grads off
set x 1
set y 1
set t 1 24
set vrange 0 0.6
set cthick 6
define bc = aave(bccmass,g)*5.1e5
d bc

* green
xdfopen ../ctl/b_F25b2-noconv.tavg2d_aer_x.ctl
define bc = aave(bccmass.2,g)*5.1e5
set ccolor 3
d bc

* red
xdfopen ../ctl/b_F25b2-noheat.tavg2d_aer_x.ctl
define bc = aave(bccmass.3,g)*5.1e5
set ccolor 2
d bc

* blue
xdfopen ../ctl/b_F25b2-emlast.tavg2d_aer_x.ctl
define bc = aave(bccmass.4,g)*5.1e5
set ccolor 4
d bc

* purple
xdfopen ../ctl/b_F25b2-philic.tavg2d_aer_x.ctl
define bc = aave(bccmass.5,g)*5.1e5
set ccolor 9
d bc

* orange
xdfopen ../ctl/b_F25b2-incscav.tavg2d_aer_x.ctl
define bc = aave(bccmass.6,g)*5.1e5
set ccolor 8
d bc

plotpng bccmass.png
