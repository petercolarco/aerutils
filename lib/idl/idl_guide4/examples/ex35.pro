PRO ex35
d=NCREAD('gprobability.nc')
PSOPEN, THICK=200, CHARSIZE=140
CS, SCALE=1
GSET, XMIN=350, XMAX=1000, YMIN=0.0, YMAX=0.3
AXES, XSTEP=50, YSTEP=0.1, YMINOR=0.025, NDECS=1, $
      XTITLE='Seasonal Total (mm)', YTITLE='Probability'
HIST, X=d.seasonal_total, Y=d.probablity1, WIDTH=150, FILLCOL=1
HIST, X=d.seasonal_total+18, Y=d.probablity2, WIDTH=150, FILLCOL=18
LEGEND, LEGPOS=9, LABELS=['1xCO!I2!N', '2xCO!I2!N'], COL=[1, 18], TYPE=1
PSCLOSE
END
