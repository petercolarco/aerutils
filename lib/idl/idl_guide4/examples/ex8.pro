PRO ex8
d=NCREAD('gdata.nc')
PSOPEN, TICKLEN=-200, FONT=6, TFONT=6, TCHARSIZE=200, SPACE1=300, $
        CB_WIDTH=75, CB_HEIGHT=200
CS, SCALE=1	
MAP
LEVS, MIN=-32, MAX=32, STEP=4
CON, FIELD=d.temp(*,*,0), X=d.lon, Y=d.lat, TITLE='Jan 1987',CB_TITLE='Temperature (Celsius)'
PSCLOSE
END

