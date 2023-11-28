PRO ex36
d=NCREAD('hurricane_cat.nc')
PSOPEN, THICK=200, CHARSIZE=150
CS, SCALE=11
GSET, XMIN=1850, XMAX=2007, YMIN=0, YMAX=85
col=[13, 2, 4, 6, 9, 8]
HIST, X=d.year+1.5, Y=REVERSE(d.category, 2), /TOWER, FILLCOL=col
AXES, XSTEP=50, XTITLE='Year', YSTEP=10, YTITLE='Number of Storms'
cats=['Category 5', 'Category 4','Category 3','Category 2','Category 1', 'Tropical Storm']
LEGEND, LEGPOS=1, LABELS=cats, COL=col, TYPE=1
PSCLOSE
END 


