reinit
xdfopen v3.ddf
xdfopen v4.ddf

set tt = 1

while ($tt < 20)




f = 1./0.064*6.022e23/2.6867e20
set t $tt
set lon 0 360
set lat 30 90
set mproj nps
set gxout shaded
set clevs 0 0.3 0.7 1 1.3 1.7 2
xycomp log10(so2cmass*f) log10(so2cmass.2*f)
printim so2cmass_tropomi.$tt.png white

@ tt = $tt + 1

end
