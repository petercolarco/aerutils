PRO ex19
d=NCREAD('vapour.nc')
PSOPEN 
CS, IDL=33, NCOLS=9
MAP
LEVS, MANUAL=['1E6', '5E6', '1E7', '5E7', '1E8', '5E8', '1E9', '5E9', '1E10', '5E10'], /EXACT      
CON, FIELD=d.vapour, X=d.longitude, Y=d.latitude, TITLE='Total Emissions - January',$
     CB_TITLE='H!I2!NO vapour(g)', /NOLINES
PSCLOSE
END

