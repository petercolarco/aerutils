PRO ex28
d=NCREAD('gdata.nc')
zonalt=TOTAL(d.temp,1)/N_ELEMENTS(d.lon)
zonalu=TOTAL(d.u,1)/N_ELEMENTS(d.lon)
PSOPEN, THICK=200, CHARSIZE=150
CS, SCALE=28
GSET, XMIN=-90, XMAX=90, YMIN=-30, YMAX=30, $
      TITLE='Zonal Mean Temperature and Zonal Mean Zonal Wind'
GPLOT, X=d.lat, Y=zonalt(*,0), COL=4
AXES, YSTEP=10, YTITLE='Temperature (Celsius)', /ONLYLEFT     
AXES, XSTEP=30, XTITLE='Latitude', /NOLEFT, /NORIGHT  
   
GSET, XMIN=-90, XMAX=90, YMIN=-15, YMAX=15
GPLOT, X=d.lat, Y=zonalu(*,0), COL=7
AXES, STEP=5, YTITLE='Zonal Wind ms!E-1!N', /ONLYRIGHT  
LEGEND, LEGPOS=9, COL=[7, 4], LABELS=['Zonal Wind', 'Temperature']
PSCLOSE
END
