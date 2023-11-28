PRO show_cs
;Procedure to show the colour scales in the cs routine

PSOPEN, /PORTRAIT
n_scales=30

ncols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23]
 
vert=350
space=300
FOR iscale=1, n_scales DO BEGIN
 n=iscale
 CS,SCALE=n
 levs=INDGEN(ncols(n-1)+1)
 barlimits=[5500,29000-((n+1)*(vert))-n*space,20000,29000-n*(vert)-n*space] 
 
 GPLOT, X=500, Y= barlimits(1)+30, TEXT='SCALE='+SCROP(n)+ ' - '+SCROP(ncols(n-1))+' colours', $
        CHARSIZE=70, FONT=3, ALIGN=0.0, /BOLD, /DEVICE

 COLBAR, COORDS=barlimits ,  LEVS=STRARR(N_ELEMENTS(levs))
ENDFOR

PSCLOSE

END

