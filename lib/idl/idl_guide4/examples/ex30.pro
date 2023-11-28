PRO ex30
d=NCREAD('gdata.nc')
zonalu=TOTAL(d.temp,1)/N_ELEMENTS(d.lon)
profiles=TRANSPOSE([zonalu(12, *), zonalu(36, *), zonalu(60, *)])
labels=['60S', 'Equator', '60N']

PSOPEN, THICK=200, CHARSIZE=150 
CS, SCALE=28
GSET, XMIN=-90, XMAX=90, YMIN=1000, YMAX=0.3, /YLOG, $
      TITLE='Zonal Mean Zonal Wind (ms!E-1!N)'
GPLOT, X=profiles, Y=d.p, /LEGEND, LEGPOS=9, COL=[2, 3, 4], LABELS=labels

AXES, XSTEP=30, XTITLE='Latitude', YTITLE='Pressure (mb)', /NORIGHT, $
      YVALS=['1000', '300', '100', '30', '10', '3', '1', '0.3']
ylabels=[0, 10, 20, 30, 40, 50, 56]
yvals=PCON(ylabels, /TO_MB)
AXES, /ONLYRIGHT, YVALS=yvals, YLABELS=ylabels, YTITLE='Height (km)'
PSCLOSE
END

