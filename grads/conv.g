xdfopen ../ctl/bR_Fortuna-2_5-b4.tavg2d_aer_x.ctl
xdfopen ../ctl/bR_Fortuna-2_5-b2.tavg2d_aer_x.ctl
set x 1
set y 1
set t 1 12

a = aave(bcsv,g)*1e12
b = aave(bcgsv002,g)*1e12
aa = aave(bcsv.2,g)*1e12
bb = aave(bcgsv002.2,g)*1e12
set vrange 0 .16
set ccolor 1
set cthick 6
d a
set ccolor 3
d b
set ccolor 1
set cstyle 2
d aa
set ccolor 3
set cstyle 2
d bb
draw title BCSV (black), BCGSV (green)
plotpng cv_bc.png

c
a = aave(ocsv,g)*1e12
b = aave(ocgsv002,g)*1e12
aa = aave(ocsv.2,g)*1e12
bb = aave(ocgsv002.2,g)*1e12
set vrange 0 1.8
set ccolor 1
set cthick 6
d a
set ccolor 3
d b
set ccolor 1
set cstyle 2
d aa
set ccolor 3
set cstyle 2
d bb
draw title OCSV (black), OCGSV (green)
plotpng cv_oc.png

c
a = aave(sssv,g)*1e12
b = aave(ssgsv001+ssgsv002+ssgsv003+ssgsv004+ssgsv005,g)*1e12
aa = aave(dusv.2,g)*1e12
bb = aave(dugsv001.2+dugsv002.2+dugsv003.2+dugsv004.2+dugsv005.2,g)*1e12
set vrange 0 50
set ccolor 1
set cthick 6
d a
set ccolor 3
d b
set ccolor 1
set cstyle 2
d aa
set ccolor 3
set cstyle 2
d bb
draw title SSSV (black), SSGSV (green)
plotpng cv_ss.png

c
a = aave(dusv,g)*1e12
b = aave(dugsv001+dugsv002+dugsv003+dugsv004+dugsv005,g)*1e12
aa = aave(dusv.2,g)*1e12
bb = aave(dugsv001.2+dugsv002.2+dugsv003.2+dugsv004.2+dugsv005.2,g)*1e12
set vrange 0 40
set ccolor 1
set cthick 6
d a
set ccolor 3
d b
set ccolor 1
set cstyle 2
d aa
set ccolor 3
set cstyle 2
d bb
draw title DUSV (black), DUGSV (green)
plotpng cv_du.png
