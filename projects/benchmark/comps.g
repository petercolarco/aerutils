xdfopen c180R_J10p12p3.tavg2d_aer_x.ctl
xdfopen c180R_J10p12p3dev_asd.tavg2d_aer_x.ctl

set t 6
set lon -180 180

set gxout shaded
xycomp duexttau duexttau.2
printim duext_J10.png white

c
du = -dusv*1e9
du2 = -dusv.2*1e9
xycomp du du2
printim dusv_J10.png

c
duwt = (duwt001+duwt002+duwt003+duwt004+duwt005)*1e9
duwt2 = (duwt001.2+duwt002.2+duwt003.2+duwt004.2+duwt005.2)*1e9
xycomp duwt duwt2
printim duwt_J10.png
