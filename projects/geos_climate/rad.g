foreach yyyy (1855 1865 1875 1885)

reinit
sdfopen /misc/prc18/colarco/S2S1850CO2x4pl/geosgcm_rad/S2S1850CO2x4pl.geosgcm_rad.${yyyy}0601_0000z.nc4
set lon -180 180
set grads off
set gxout shaded
set clevs -24 -21 -18 -15 -12 -9 -6 -3 0 3 6 9
d swtnet-swtnetna
cbarn
printim S2S1850CO2x4pl.swt.${yyyy}06.png white

reinit
sdfopen /misc/prc18/colarco/S2S1850CO2x4pl/geosgcm_rad/S2S1850CO2x4pl.geosgcm_rad.${yyyy}1201_0000z.nc4
set lon -180 180
set grads off
set gxout shaded
set clevs -24 -21 -18 -15 -12 -9 -6 -3 0 3 6 9
d swtnet-swtnetna
cbarn
printim S2S1850CO2x4pl.swt.${yyyy}12.png white

end


reinit
xdfopen S2S1850CO2x4pl.rad.ddf
set x 1
set y 1
set t 1 456
set grads off
all = aave(swtnet-swtnetna,g)
clr = aave(swtnetc-swtnetcna,g)
set vrange -6 -2
d all
d clr
printim swt.png white
