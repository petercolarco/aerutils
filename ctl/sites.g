xdfopen bR_Fortuna-2_5-b7.tavg2d_aer_x.ctl
xdfopen b_F25b7-base-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v5.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v6.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v7.tavg2d_carma_x.ctl

set t 1 12
set lon -22
set lat 16
set vrange 0 1.5
set cthick 12
d duexttau
set ccolor 3
d duexttau.2
set ccolor 2
d duexttau.3
set ccolor 7
d duexttau.4
set ccolor 9
d duexttau.5
set ccolor 11
d duexttau.6
draw title Capo Verde DUEXTTAU
plotpng capoverde.png

c
set lon -59
set lat 13
set vrange 0 0.75
set cthick 12
d duexttau
set ccolor 3
d duexttau.2
set ccolor 2
d duexttau.3
set ccolor 7
d duexttau.4
set ccolor 9
d duexttau.5
set ccolor 11
d duexttau.6
draw title Ragged Point DUEXTTAU
plotpng raggedpoint.png

c
set lon -67
set lat 17
set vrange 0 0.75
set cthick 12
d duexttau
set ccolor 3
d duexttau.2
set ccolor 2
d duexttau.3
set ccolor 7
d duexttau.4
set ccolor 9
d duexttau.5
set ccolor 11
d duexttau.6
draw title La Parguera DUEXTTAU
plotpng laparguera.png
