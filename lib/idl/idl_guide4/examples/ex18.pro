PRO ex18
PSOPEN 
CS, SCALE=26
MAP, OCEAN=2, LAND=14, /DRAW

GPLOT, X=-120, Y=8, TEXT='Nino3 region', FONT=7
xpts=[-150, -150, -90, -90, -150]
ypts=[-5, 5, 5, -5, -5]
GPLOT, X=xpts, Y=ypts, FILLCOL=17, THICK=400

GPLOT, X=43, Y=55, TEXT='Moscow', ALIGN=0.0, VALIGN=0.5
GPLOT, X=37, Y=55 , SYM=3, SIZE=200, COL=25

GPLOT, X=103, Y=-30, TEXT='Australia', CHARSIZE=200, ORIENTATION=-90, COL=22

GPLOT, X=3000, Y=19000, TEXT='Text above plot and left justified', FONT=2, $
       ALIGN=0.0, SIZE=150, /BOLD, /ITALIC,  /DEVICE
GPLOT, X=26700, Y=19000, TEXT='Text above plot and right justified', FONT=2, $ 
       ALIGN=1.0, SIZE=150, /DEVICE
AXES
PSCLOSE
END

