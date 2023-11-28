sdfopen /misc/prc11/colarco/bR_Fortuna-2_5-b1/tavg2d_aer_x/Y2008/M07/bR_Fortuna-2_5-b1.tavg2d_aer_x.monthly.200807.nc4
sdfopen /misc/prc15/colarco/bR_Fortuna-2-4-b7/tavg2d_aer_x/Y2008/M07/bR_Fortuna-2-4-b7.tavg2d_aer_x.monthly.200807.nc4
sdfopen /misc/prc11/colarco/bR_25b1_test/tavg2d_aer_x/Y2008/M07/bR_25b1_test.tavg2d_aer_x.monthly.200807.nc4

set lon -180 180
set gxout grfill
xycomp duexttau duexttau.2
plotpng duexttau.24_25.png


xycomp duexttau.3 duexttau.2
plotpng duexttau.24_25oldwet.png

xycomp 1.5*ssexttau ssexttau.2
plotpng ssexttau.24_25.png


xycomp 1.5*ssexttau.3 ssexttau.2
plotpng ssexttau.24_25nosst.png
