PRO ex17
d=NCREAD('u2.nc')
PSOPEN
CS, SCALE=1
GSET, XMIN=120, XMAX=240, YMIN=0, YMAX=199
LEVS, MIN=-8, MAX=5, STEP=1
CON, FIELD=d.u, X=d.longitude, Y=d.day, TITLE='Zonal wind',CB_TITLE='ms!E-1!N', $
     /NOLINES
     
LEVS, MANUAL=[-1000, 0]
CON, FIELD=d.u, X=d.longitude, Y=d.day, /NOLINELABELS, /NOFILL
AXES, XVALS=[120,150,180,210,240], $
      XLABELS=['120E', '150E','DL','150W', '120W'], $
      YVALS=[12,43,74,102,133,163,194], $
      YLABELS=['Jan 1995','Feb 1995','Mar 1995','Apr 1995', $
               'May 1995','Jun 1995','Jul 1995']
PSCLOSE
END

