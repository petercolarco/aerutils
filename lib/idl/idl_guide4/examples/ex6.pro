PRO ex6
d=NCREAD('gdata.nc')
PSOPEN 
CS, SCALE=1
MAP,  LONMIN=-20, LONMAX=40, LATMIN=30, LATMAX=70
LEVS, MIN=-20, MAX=20, STEP=2.5, NDECS=1
CON, FIELD=d.temp(*,*,0), X=d.lon, Y=d.lat, TITLE='Jan 1987', $
     CB_TITLE='Temperature (Celsius)', /BLOCK
PSCLOSE
END

