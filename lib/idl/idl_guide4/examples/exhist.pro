PRO EXHIST
PSOPEN
GSET, XMIN=0, XMAX=10, YMIN=0, YMAX=10
CS, SCALE=1
ypts=[5, 2, 3, 8, 1, 4, 9, 6, 2, 7]
xpts=INDGEN(10)+0.5
HIST, X=xpts, Y=ypts, FILLCOL=INDGEN(10)+2, WIDTH=200
HIST, X=xpts, Y=ypts/1.3, FILLCOL=INDGEN(10)+4
AXES, STEP=1
PSCLOSE
END
