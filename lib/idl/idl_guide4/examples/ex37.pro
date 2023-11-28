PRO ex37
d=NCREAD('hurricane_cat.nc')
PSOPEN, THICK=200, CHARSIZE=150, /PORTRAIT
CS, SCALE=11
GSET, YMIN=1850, YMAX=2007, XMIN=0, XMAX=85
col=[13, 2, 4, 6, 9, 8]
HIST, Y=d.year+1.5, X=REVERSE(d.category, 2), /TOWER, FILLCOL=col, WIDTH=80, /HORIZONTAL
AXES, YSTEP=50, YTITLE='Year', XSTEP=10, XTITLE='Number of Storms'
cats=['Category 5', 'Category 4','Category 3','Category 2','Category 1', 'Tropical Storm']
LEGEND, LEGPOS=11, LABELS=cats, COL=col, TYPE=1
PSCLOSE
END 


