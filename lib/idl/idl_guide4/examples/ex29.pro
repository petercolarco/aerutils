PRO ex29
d=NCREAD('amo.nc')
PSOPEN, THICK=300, CHARSIZE=150
CS,SCALE=28
GSET, XMIN=1870, XMAX=2000, YMIN=-0.3, YMAX=0.3, TITLE='AMO Index'
GPLOT, X=d.year, Y=d.index, BELOW=4, ABOVE=2
AXES, XSTEP=10, YSTEP=0.1, NDECS=1
PSCLOSE
END
