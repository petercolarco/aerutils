PRO ex15
d=NCREAD('stipple.nc')
PSOPEN
CS, SCALE=11, NCOLS=14
MAP, /ROBINSON
LEVS, MIN=-30, MAX=30, STEP=5
CON, FIELD=d.climatology, X=d.longitude, Y=d.latitude, CB_TITLE='Temperature [Celcius]'
STIPPLE, FIELD=d.climatology-d.jan1963, X=d.longitude, Y=d.latitude, MIN=1, MAX=20
PSCLOSE
END
