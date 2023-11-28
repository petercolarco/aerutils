PRO ex34
d=NCREAD('rainhist.nc')
PSOPEN, THICK=200, CHARSIZE=150
CS, SCALE=7
GSET, XMIN=1970, XMAX=2008, YMIN=-600, YMAX=300
AXES, XSTEP=5, XTITLE='Year', YSTEP=100,  YTITLE='Rainfall Surplus/Deficit (mm)', /HGRID
HIST, X=d.years, Y=d.rainfall, FILLCOL=6
PSCLOSE
END