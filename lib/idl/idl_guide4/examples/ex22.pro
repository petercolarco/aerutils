PRO ex22
d=NCREAD('epflux.nc')
PSOPEN
CS, SCALE=6, NCOLS=10
LEVS, MIN=-2, MAX=2, STEP=0.5, NDECS=1
GSET, XMIN=0, XMAX=90, YMIN=1000, YMAX=0, TITLE='EP Flux and Zonal Wind Anomalies'
CON, X=d.latitude, Y=d.plev, FIELD=d.u, ZERO_STYLE=2, /NOCOLBAR 

VECT, X=d.latitude, Y=d.plev, U=d.epfu, V=d.epfv, $
      MAG=['1E14', '1E19'], LENGTH=[100, 200], MUNITS=['m!E2!Ns!E-2!N', 'ms!E-2!NPa']
AXES, XSTEP=15, YSTEP=-200, YMINOR=-50, XTITLE='Latitude (N)', YTITLE='Pressure (hPa)'
PSCLOSE
END
