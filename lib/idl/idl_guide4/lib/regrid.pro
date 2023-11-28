FUNCTION regrid, orig_fieldin, orig_x1, orig_y1, x2, y2
;Perform bi-linear data regridding on a longitude-latitude grid
;See http://en.wikipedia.org/wiki/Bilinear_interpolation for details on bilinear interpolation.
;
;Over the pole this routine works in degree space.  i.e. if we have a grid 
;with a top row of 88.75 degrees then a new row is created at 91.25 
;degrees with the data points from the row at 88.75 degrees swapped around in longitude. 

;orig_fieldin, orig_x1, orig_y1 are the original field and coordinates.
;x2, y2 are the output field and coordinates.
;(C) NCAS 2008


IF ((N_ELEMENTS(orig_fieldin) EQ 0) OR (N_ELEMENTS(orig_x1) EQ 0)  OR (N_ELEMENTS(orig_y1) EQ 0) $
     OR (N_ELEMENTS(x2) EQ 0) OR (N_ELEMENTS(y2) EQ 0) ) THEN BEGIN
 PRINT, ''
 PRINT, 'REGRID ERROR - fieldin, longs_orig, lats_orig, longs_new, lats_new must '
 PRINT, '               all be supplied'
 PRINT, ''
 STOP
ENDIF 

fieldin=orig_fieldin
x1=orig_x1
y1=orig_y1
fieldout=FLTARR(N_ELEMENTS(x2), N_ELEMENTS(y2))

;Try to wrap data if not 360 degrees of longitude in data.
IF (((MAX(x1)-MIN(x1)) NE 360.0)) THEN BEGIN
 diffx=x1(1)-x1(0)
 same=0
 FOR i=0, N_ELEMENTS(x1)-2 DO BEGIN
  IF ((x1(i+1)-x1(i)) NE diffx) THEN same=same+1
 ENDFOR
 IF (SAME EQ 0) THEN BEGIN
  IF (((MAX(x1)+diffx) - MIN(x1)) EQ 360) THEN BEGIN
   x1=[x1,orig_x1(N_ELEMENTS(x1)-1)+diffx]
   fieldin=[fieldin, fieldin(0,*)]
  ENDIF
 ENDIF ELSE BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - irregular spacing in longitude - cannot wrap this data.
  PRINT, ''
  STOP
 ENDELSE
ENDIF

;Reverse latitudes if going from south pole to north pole
IF (y1(0) GT y1(N_ELEMENTS(y1)-1)) THEN fieldin=REVERSE(fieldin,2)
IF (y1(0) GT y1(N_ELEMENTS(y1)-1)) THEN y1=REVERSE(y1)

;Some basic checks on the fields

s=SIZE(fieldin,/DIMENSIONS)
IF (N_ELEMENTS(s) NE 2) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input grid has ', N_ELEMENTS(s), ' dimensions - only 2 dimensions allowed'
  PRINT, ''
  STOP
ENDIF
IF (s(0) NE N_ELEMENTS(x1)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input field and input x dimension incorrect'
  PRINT, 'Input field has ',s(0),' columns and x dimension is ', N_ELEMENTS(x1)
  STOP
ENDIF
IF (s(1) NE N_ELEMENTS(y1)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Input field and input y dimension incorrect'
  PRINT, 'Input field has ',s(1),' rows and y dimension is ', N_ELEMENTS(y1)
  STOP
ENDIF


s=SIZE(fieldout,/DIMENSIONS)
IF (N_ELEMENTS(s) EQ 1) THEN BEGIN
 IF (N_ELEMENTS(s) NE N_ELEMENTS(x2)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Output field and output x dimension incorrect'
  PRINT, 'Field has ',N_ELEMENTS(s),' elements and output x dimension is ', N_ELEMENTS(x2)
  STOP
 ENDIF
 IF (N_ELEMENTS(s) NE N_ELEMENTS(y2)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Output field and output y dimension incorrect'
  PRINT, 'Field has ',N_ELEMENTS(s),' elements and output y dimension is ', N_ELEMENTS(y2)
  STOP
 ENDIF 
ENDIF ELSE BEGIN
 IF (s(0) NE N_ELEMENTS(x2)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Output field and output x dimension incorrect'
  PRINT, 'Field has ',s(0),' columns and x dimension is ', N_ELEMENTS(x2)
  STOP
 ENDIF
 IF (s(1) NE N_ELEMENTS(y2)) THEN BEGIN
  PRINT, ''
  PRINT, 'REGRID ERROR - Output field and output y dimension incorrect'
  PRINT, 'Field has ',s(1),' rows and y dimension is ', N_ELEMENTS(y2)
  STOP
 ENDIF
ENDELSE

;Stop if outside limits of longitude.
;Try to adjust for longitude wrapping if outside of limits.
FOR ix=0,N_ELEMENTS(x2)-1 DO BEGIN
 IF ((x2(ix) LT  MIN(x1)) OR (x2(ix) GT MIN(x1))) THEN BEGIN
  IF (x2(ix) LT  MIN(x1)) THEN BEGIN
     x2(ix)=x2(ix)+360.0
     IF ((x2(ix) LT  MIN(x1)) OR (x2(ix) GT  MAX(x1))) THEN BEGIN
       PRINT, 'Requested regrid longitude ', x2(ix)-360.0,' is less than the minimum longitude'
       PRINT, 'Fix input grid or requested regrid values'
       PRINT, 'Longitudes are ', x1
       STOP
     ENDIF
  ENDIF
  IF (x2(ix) GE  MAX(x1)) THEN BEGIN
     x2(ix)=x2(ix)-360.0
     IF ((x2(ix) LT  MIN(x1))  OR (x2(ix) GT  MAX(x1))) THEN BEGIN
       PRINT, 'Requested regrid longitude ', x2(ix)+360.0,' is greater than the maximum longitude'
       PRINT, 'Fix input grid or requested regrid values'
       PRINT, 'Longitudes are ', x1
       STOP
     ENDIF
  ENDIF  
 ENDIF
ENDFOR

;Stop if outside limits of latitude - i.e. past the pole
FOR iy=0,N_ELEMENTS(y2)-1 DO BEGIN
  IF ((y2(iy) LT  -90.0) OR (y2(iy) GT 90.0)) THEN BEGIN
    PRINT, 'Requested regrid latitude ', y2(iy), ' past the pole'
    STOP
  ENDIF
ENDFOR


;Add an extra row at the top and bottom to cope with poles
;Rotate data around and calcluate the extra latitude points
extrarow1=SHIFT(fieldin(*,0), ROUND(N_ELEMENTS(x1)/2.0))
extrarow2=SHIFT(fieldin(*,N_ELEMENTS(y1)-1), ROUND(N_ELEMENTS(x1)/2.0))
fieldin=[[extrarow1],[fieldin],[extrarow2]]
y1=[-90.0-(ABS(-90.0-MIN(y1))),y1,90.0+ABS(90.0-y1(N_ELEMENTS(y1)-1))]

;Now we're ready to do the bi-linear interpolation
xpts=N_ELEMENTS(x2)
ypts=N_ELEMENTS(y2)


;Circles over the input grid to get the new grid values
FOR ix=0,xpts-1 DO BEGIN
 FOR iy=0,ypts-1 DO BEGIN

 myxpos=SIZE(WHERE(x2(ix) GE x1), /N_ELEMENTS)-1
 myypos=SIZE(WHERE(y2(iy) GE y1), /N_ELEMENTS)-1

  IF (y2(iy) NE 90.0) THEN BEGIN
   alpha=(x2(ix)-x1(myxpos))/(x1(myxpos+1)-(x1(myxpos))) 	
   newval1=fieldin(myxpos,myypos)-(fieldin(myxpos,myypos)-fieldin(myxpos+1,myypos))*alpha
   newval2=fieldin(myxpos,myypos+1)-(fieldin(myxpos,myypos+1)-fieldin(myxpos+1,myypos+1))*alpha
   alpha2=(y2(iy)-y1(myypos))/(y1(myypos+1)-(y1(myypos)))
   newval3=newval1-(newval1-newval2)*alpha2
  ENDIF ELSE BEGIN
   newval3=fieldin(0,N_ELEMENTS(y1)-1)
  ENDELSE
  
  fieldout(ix,iy)=newval3
 
 ENDFOR
ENDFOR

;Return just a float if a single point.  Returning an array when a float is expected
;can cause unexpected array problems.
IF (N_ELEMENTS(fieldout) EQ 1) THEN fieldout=fieldout(0)

RETURN, fieldout

END


