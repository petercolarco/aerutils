PRO ex20
d=NCREAD('gwinds.nc')
PSOPEN
CS, SCALE=1
MAP, LONMIN=10, LONMAX=120, LATMIN=-30, LATMAX=30, /DRAW
VECT, U=d.u(*,*,3), V=d.v(*,*,3), X=d.longitude, Y=d.latitude, $
      LENGTH=200, MAG=10, MUNITS='ms!E-1!N'
AXES, STEP=10
PSCLOSE
END

