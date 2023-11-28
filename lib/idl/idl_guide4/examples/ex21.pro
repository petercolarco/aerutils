PRO ex21
d=NCREAD('gwinds.nc')
PSOPEN, XPLOTS=2
CS, SCALE=1
MAP, /NH, /DRAW
VECT, U=d.u(*,*,14), V=d.v(*,*,14), X=d.longitude, Y=d.latitude, $
      MAG=10, MUNITS='ms!E-1!N'
AXES, STEP=30

POS, XPOS=2
MAP, /NH, /DRAW
VECT, U=d.u(*,*,14), V=d.v(*,*,14), X=d.longitude, Y=d.latitude, $
      MAG=10, MUNITS='ms!E-1!N', PTS=40
AXES, STEP=30
PSCLOSE
END


