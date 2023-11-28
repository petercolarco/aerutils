PRO ex16
d=NCREAD('qbo.nc')
PSOPEN, SPACE2=800
CS, SCALE=1
LEVS, MIN=-40, MAX=15, STEP=5
GSET, XMIN=90.5, XMAX=1169.5, YMIN=1000, YMAX=10, /YLOG
CON, FIELD=d.zonalu, X=d.time, Y=d.pressure, TITLE='Zonal Mean Zonal Wind', $
     CB_TITLE='ms!E-1!N', ZERO_THICK=200

yvals=[1000, 700, 500, 300, 200, 100, 70, 50, 30, 20, 10]
xvals=[90.5, 480.5, 840.5, 1169.5]
xlabels=['01/12/1978:12z', '01/01/1980:12z', '01/01/1981:12z',  '01/12/1981:12z']
AXES, XVALS=xvals, XLABELS=xlabels, XTITLE='Time', $
      YVALS=yvals, YLABELS=yvals, YTITLE='Pressure [hPa]'
PSCLOSE
END
