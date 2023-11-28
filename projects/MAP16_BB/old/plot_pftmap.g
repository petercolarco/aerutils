xdfopen pft_trop.ctl
set lon -180 180
set gxout grfill
d frac
draw title Tropical Forest Fraction
cbarn
printim pft_trop.png white

reinit
xdfopen pft_xtrop.ctl
set lon -180 180
set gxout grfill
d frac
draw title Extra-Tropical Forest Fraction
cbarn
printim pft_xtrop.png white

reinit
xdfopen pft_grass.ctl
set lon -180 180
set gxout grfill
d frac
draw title Grassland Fraction
cbarn
printim pft_grass.png white
