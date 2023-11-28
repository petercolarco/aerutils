PRO ex3
d=NCREAD('gdata.nc')
PSOPEN 
CS, SCALE=4
MAP, /NH
LEVS, MIN=15150, MAX=16650, STEP=150
CON, FIELD=d.ht(*,*,6), X=d.lon, Y=d.lat, CB_TITLE='Height (m)', $
     TITLE='Jan 1987 - 100mb Geopotential Height'
PSCLOSE
END

