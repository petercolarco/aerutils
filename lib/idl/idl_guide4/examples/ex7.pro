PRO ex7
d=NCREAD('gdata.nc')
PSOPEN, XPLOTS=2, YPLOTS=2
CS, SCALE=1
LEVS, MIN=-32, MAX=32, STEP=4
t1000=d.temp(*,*,0)

MAP
CON, FIELD=t1000, X=d.lon, Y=d.lat, TITLE='Jan 1987', CB_TITLE='Temperature (Celsius)'

POS, XPOS=1, YPOS=2
MAP, /MOLLWEIDE
CON, FIELD=t1000, X=d.lon, Y=d.lat, TITLE='Jan 1987', CB_TITLE='Temperature (Celsius)'

POS, XPOS=2, YPOS=1
MAP, /ROBINSON, LONMIN=0, LONMAX=360
CON, FIELD=t1000, X=d.lon, Y=d.lat, TITLE='Jan 1987', CB_TITLE='Temperature (Celsius)', $
    /CB_UNDER

POS, XPOS=2, YPOS=2
MAP, SATELLITE=[0, 50]
CON, FIELD=t1000, X=d.lon, Y=d.lat, TITLE='Jan 1987', CB_TITLE='Temperature (Celsius)', $
     /CB_RIGHT
PSCLOSE
END

