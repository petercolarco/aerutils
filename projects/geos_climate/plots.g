xdfopen S2S1850CO2x4pl.ddf
set gxout shaded
set t 246
set grads off
xycomp sscmass*1e6 sscmass(t=6)*1e6
printim sscmass.187006_185006.png white

reinit
xdfopen S2S1850CO2x4pl.surf.ddf
set gxout shaded
set t 246
set grads off
xycomp sqrt(u10m*u10m+v10m*v10m) sqrt(u10m(t=6)*u10m(t=6)+v10m(t=6)*v10m(t=6))
printim uv10m.187006_185006.png white
