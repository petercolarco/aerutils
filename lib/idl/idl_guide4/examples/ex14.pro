PRO ex14
d=NCREAD('gdata.nc')
zonalu=TOTAL(d.u,1)/N_ELEMENTS(d.lon)
PSOPEN
CS, COLS=[464]
LEVS, MANUAL=[-200, 0], /EXACT
GSET, XMIN=-90, XMAX=90, YMIN=1000, YMAX=0.3, /YLOG
CON, FIELD=zonalu, X=d.lat, Y=d.p, TITLE='Jan 1987 - Zonal Mean Zonal Wind', $
     CB_TITLE='ms!E-1!N', /NOLINES, /NOCOLBAR
     
LEVS, MIN=-100, MAX=35, STEP=5
CON, FIELD=zonalu, X=d.lat, Y=d.p, NEGATIVE_STYLE=2, ZERO_THICK=200, $
     /NOFILL
AXES, XSTEP=30, XTITLE='Latitude', YVALS=['1000', '300', '100', '30', '10', '3', '1', '0.3'], $
      YTITLE='Pressure (mb)', /NORIGHT
ylabels=[0, 10, 20, 30, 40, 50, 56]
yvals=PCON(ylabels, /TO_MB)
AXES, /ONLYRIGHT, YVALS=yvals, YLABELS=ylabels, YTITLE='Height (km)'
PSCLOSE
END

