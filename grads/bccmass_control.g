xdfopen ../ctl/bR_control.tavg2d_aer_x.ctl
c
set grads off
set x 1
set y 1
set t 1 312
set vrange 0 0.6
set cthick 6
define bc = aave(bccmass,g)*5.1e5
d bc
plotpng bccmass_control.png
