PRO ex4
d=NCREAD('gdata.nc')
PSOPEN 
CS, SCALE=1
MAP
LEVS, MIN=-32, MAX=32, STEP=4
CON, FIELD=d.temp(*,*,0), X=d.lon, Y=d.lat, TITLE='Jan 1987', /NOFILL
PSCLOSE
END

