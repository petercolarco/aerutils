PRO ex26
d=NCREAD('dailyt.nc')
PSOPEN, THICK=200, CHARSIZE=150
CS, SCALE=28
GSET, XMIN=1, XMAX=365, YMIN=-30, YMAX=40, TITLE='Daily temperature'
xvals=[1,31,59,90,120,151,181,212,243,273,304,334]
months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
cities=['Beijing', 'Mumbai', 'Moscow', 'Sydney', 'Winnipeg', 'Brasilia']
cols=INDGEN(6)+2
GPLOT, X=d.day, Y=d.temp, /LEGEND, LEGPOS=7, COL=cols, LABELS=cities
AXES, XVALS=xvals, XLABELS=months, XTITLE='Month', YSTEP=10, YTITLE='Degrees Celsius'   
PSCLOSE
END


