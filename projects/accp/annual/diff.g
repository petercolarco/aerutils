sdfopen /misc/prc19/colarco/M2R12K/annual/M2R12K.full.totexttau.day.annual.2014.nc4
sdfopen /misc/prc19/colarco/M2R12K/annual/M2R12K.gpm045.nodrag.1100km.totexttau.day.annual.2014.nc4
sdfopen /misc/prc19/colarco/M2R12K/annual/M2R12K.gpm050.nodrag.1100km.totexttau.day.annual.2014.nc4
sdfopen /misc/prc19/colarco/M2R12K/annual/M2R12K.gpm055.nodrag.1100km.totexttau.day.annual.2014.nc4
sdfopen /misc/prc19/colarco/M2R12K/annual/M2R12K.gpm.nodrag.1100km.totexttau.day.annual.2014.nc4

set gxout shaded
set grads off
set lon -180 180
xycomp totexttau.2 totexttau
printim gpm045.png white

c
xycomp totexttau.3 totexttau
printim gpm050.png white

c
xycomp totexttau.4 totexttau
printim gpm055.png white

c
xycomp totexttau.5 totexttau
printim gpm.png white
