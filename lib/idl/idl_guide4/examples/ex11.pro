PRO ex11
d=NCREAD('lc1.nc')
PSOPEN 
CS, SCALE=1, NCOLS=19
MAP, LONMIN=0, LONMAX=110, LATMIN=20, LATMAX=75, /SECTOR
LEVS, MIN=-20, MAX=20, STEP=2, /EXACT
CON, FIELD=d.temp, X=d.longitude, Y=d.latitude, COL=INDGEN(21)+2, /NOFILL, /NOMAP

LEVS, MANUAL=['-1.0', '-0.8', '-0.6', '-0.4', '-0.2', '0.2', '0.4', '0.6', '0.8', '1.0']
CON, FIELD=d.mslp, X=d.longitude, Y=d.latitude, NEGATIVE_STYLE=2, /NOFILL, /NOMAP
PSCLOSE
END
