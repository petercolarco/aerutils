PRO ex12
d=NCREAD('orca2.nc')
PSOPEN, YPLOTS=2, /PORTRAIT
CS, SCALE=1          
MAP
LEVS, MIN=-2, MAX=30, STEP=2
CON, FIELD=d.sst, X=d.longitude, Y=d.latitude, CB_TITLE='Temperature (Celsius)'	

POS, YPOS=2
MAP, LAND=12, OCEAN=8, /DRAW
GPLOT, X=d.longitude, Y=d.latitude, SYM=1, /NOLINES, SIZE=10
AXES	  
PSCLOSE
END

