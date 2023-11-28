xdfopen MERRA2.ddf
xdfopen MERRA2_GMI.ddf
set t 1 24
set lon -59
set lat 2

set vrange 0 0.2

d totexttau
set ccolor 4
d ssexttau
set ccolor 2
d ocexttau+bcexttau+suexttau
set ccolor 8
d duexttau
