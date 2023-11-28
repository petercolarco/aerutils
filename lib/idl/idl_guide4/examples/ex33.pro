PRO ex33
d=NCREAD('errorplot.nc') 
PSOPEN, THICK=200, CHARSIZE=150
CS, SCALE=27
GSET, XMIN=1900, XMAX=2010, YMIN=-3, YMAX=2
AXES, XSTEP=20, YSTEP=0.5, NDECS=1, /HGRID, GCOL=34, $
      YTITLE='Temperature Anomaly [deg.C]', XTITLE='Year'
GPLOT, X=d.years, Y=d.temp_anom, SYM=2, SIZE=150
FOR ix=0, N_ELEMENTS(d.years)-1 DO BEGIN
 EBAR, X=d.years(ix), Y=d.temp_anom(ix), ERROR_Y=d.errors(ix)
ENDFOR
PSCLOSE
END
