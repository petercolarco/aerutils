PRO ex25    
d=NCREAD('fieldsite.nc')
PSOPEN, THICK=200, CHARSIZE=140
CS, SCALE=1
GSET, XMIN=7, XMAX=25, YMIN=-5, YMAX=15, TITLE='Reading field site temperatures'
labels=['Minimum', 'Maximum']
GPLOT, X=d.day, Y=d.temperature, /LEGEND, LEGPOS=9, SYM=[2, 3], $
       COL=[3, 18], LABELS=labels              
xvals=INDGEN(10)*2+7
xlabels=SCROP(xvals)+' Feb'
AXES, XVALS=xvals, XLABELS=xlabels, YSTEP=5, YTITLE='Temp [Deg C]', MINOR=1
PSCLOSE
END

