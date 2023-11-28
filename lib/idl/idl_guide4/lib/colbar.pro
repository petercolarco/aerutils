PRO colbar, COORDS=coords, LEVS=levs, TITLE=title, UPPER=upper, LOWER=lower, $
            TEXTPOS=textpos, NOLINES=nolines, ALT=alt, NVALS=nvals, FORM=form
;Simple colourbar program using lines, text and polygons
;(C) NCAS 2008

;Check !guide exists
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.
 PRINT, ''
 STOP
ENDIF


;Variable assigment and some basic checks
IF (N_ELEMENTS(coords) NE 4) THEN BEGIN
  PRINT, 'COLBAR ERROR - coords not defined correctly.'
  PRINT, 'COORDS=coords needs 4 elements but received ', STRTRIM(N_ELEMENTS(coords),2)
  STOP
ENDIF

IF (N_ELEMENTS(levs) EQ 0) THEN BEGIN
  PRINT, 'COLBAR ERROR - LEVS=levs must be defined.'
  STOP
ENDIF

x0=FLOAT(coords(0))
y0=FLOAT(coords(1))
x1=FLOAT(coords(2))
y1=FLOAT(coords(3))


IF (N_ELEMENTS(alt) EQ 0) THEN alt=0
IF (N_ELEMENTS(lower) EQ 0) THEN lower=0
IF (N_ELEMENTS(upper) EQ 0) THEN upper=0
IF (N_ELEMENTS(textpos) EQ 0) THEN textpos=0
IF (N_ELEMENTS(nolines) EQ 0) THEN nolines=0
IF (N_ELEMENTS(title) EQ 0) THEN title=''
font=!guide.font
charsize=!guide.charsize

ydiff=y1-y0
xdiff=x1-x0
IF (xdiff LE 0) THEN BEGIN
  PRINT, 'COLBAR ERROR - X1 must be greater than X0.'
  STOP
ENDIF

IF (ydiff LE 0) THEN BEGIN
  PRINT, 'COLBAR ERROR - Y1 must be greater than Y0.'
  STOP
ENDIF

ncontour=N_ELEMENTS(levs)-1
IF (ncontour LE 1) THEN BEGIN
  PRINT, 'COLBAR ERROR - Number of levels must be two or greater.'
  STOP
ENDIF

;Select labels to plot
plotlabels=INTARR(N_ELEMENTS(levs))
IF (N_ELEMENTS(nvals) EQ 0) THEN BEGIN
 plotlabels(*)=1
ENDIF ELSE BEGIN
 ;select a limited number of labels for the colour bar.
 nlevs=N_ELEMENTS(levs)-1
 start=0
 finish=nlevs-1
 IF KEYWORD_SET(lower) THEN start=1
 IF KEYWORD_SET(lower) THEN nlevs=nlevs-1
 IF KEYWORD_SET(upper) THEN finish=finish-1
 IF KEYWORD_SET(upper) THEN nlevs=nlevs-1
 step=FLOAT(nlevs)/(nvals-1)
 plotlabels((FINDGEN(nvals))*step+start)=1
 ;Turn off internal colour bar lines
 nolines=1
ENDELSE

;Some plot definitions
space1=!guide.space1 ;space between colour bar and text.
xpix=!guide.xpix         ;Width of text in pixels
ypix=!guide.ypix         ;Height of text in pixels 


;Horizontal colourbar
;--------------------
IF (xdiff GT ydiff) THEN BEGIN
nticks=ncontour
IF (lower) THEN nticks=nticks-1
IF (upper) THEN nticks=nticks-1

xint = xdiff/ncontour
yint = ydiff
xstart=x0
icol=2

IF (lower) THEN BEGIN
xpts=[x0, x0+xint, x0+xint, x0]
ypts=[y1-yint/2,y1,y1-yint,y1-yint/2]
POLYFILL, xpts, ypts, COLOR=icol, /DEVICE
IF (NOLINES EQ 0) THEN BEGIN
 PLOTS, xpts, ypts, /DEVICE
ENDIF ELSE BEGIN
 xpts=[x0+xint, x0, x0+xint]
 ypts=[y1, y1-yint/2, y1-yint]
 PLOTS, xpts, ypts, /DEVICE 
ENDELSE
xstart=xstart+xint
icol=icol+1
ENDIF


FOR ix=0, nticks-1 DO BEGIN
  plotlabel=plotlabels(ix)
  myx=xstart+ix*xint
  xpts=[myx, myx+xint, myx+xint, myx, myx]
  ypts=[y1,y1, y1-yint,y1-yint,y1]
  POLYFILL, xpts, ypts, COLOR=icol+ix, /DEVICE
  IF (plotlabel EQ 1) THEN BEGIN
   IF ((NOLINES EQ 1) AND (ix EQ 0)) THEN PLOTS, [myx,myx],[y1, y1-yint], /DEVICE
   IF ((NOLINES EQ 1) AND (ix EQ nticks-1)) THEN PLOTS, [myx+xint,myx+xint],[y1, y1-yint], /DEVICE
  ENDIF
  IF (NOLINES EQ 0) THEN BEGIN 
   PLOTS, xpts, ypts, /DEVICE
  ENDIF ELSE BEGIN
   xpts=[myx, myx+xint]
   ypts=[y1,y1]
   xpts2=[myx, myx+xint]
   ypts2=[y1-yint,y1-yint]
   PLOTS, xpts, ypts, /DEVICE
   PLOTS, xpts2, ypts2, /DEVICE 
  ENDELSE
  
  
  mylev=STRTRIM(STRING(levs(ix+icol-2),format=form),2)
  
  IF (ALT EQ 0) THEN BEGIN
    IF (plotlabel EQ 1) THEN BEGIN
     XYOUTS, myx, y0-space1-ypix,mylev , ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
     IF (N_ELEMENTS(nvals) EQ 1) THEN PLOTS, [myx, myx], [y1-yint, y1-yint*7/8], /DEVICE
     IF (N_ELEMENTS(nvals) EQ 1) THEN PLOTS, [myx, myx], [y1, y1-yint*1/8], /DEVICE
    ENDIF
  ENDIF ELSE BEGIN
    IF (ix MOD 2 EQ 0) THEN BEGIN
     IF (plotlabel EQ 1) THEN XYOUTS, myx, y0-space1-ypix, mylev, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
    ENDIF ELSE BEGIN
     IF (plotlabel EQ 1) THEN XYOUTS, myx, y1+space1, mylev, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
    ENDELSE
  ENDELSE  
ENDFOR
myx=xstart+nticks*xint
mylev=STRTRIM(STRING(levs(ix+icol-2),format=form),2)
IF (ALT EQ 0) THEN BEGIN
 XYOUTS, myx, y0-space1-ypix, mylev, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
ENDIF ELSE BEGIN
   IF (ix MOD 2 EQ 0) THEN BEGIN
    XYOUTS, myx, y0-space1-ypix, mylev, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
   ENDIF ELSE BEGIN
    XYOUTS, myx, y1+space1, mylev, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE
   ENDELSE
ENDELSE

IF (upper) THEN BEGIN
xpts=[x1-xint, x1, x1-xint, x1-xint]
ypts=[y1,y1-yint/2.0,y1-yint,y1]
POLYFILL, xpts, ypts, COLOR=icol+nticks, /DEVICE
IF (NOLINES EQ 0) THEN BEGIN
 PLOTS, xpts, ypts, /DEVICE
ENDIF ELSE BEGIN
 xpts=[x1-xint, x1, x1-xint]
 ypts=[y1,y1-yint/2.0,y1-yint]
 PLOTS, xpts, ypts, /DEVICE
ENDELSE
ENDIF

xstart=x0-xint
mystart=0
IF (lower) THEN BEGIN
  mystart=1
ENDIF


;Add the title
XYOUTS, x0+xdiff/2, y0-2*(space1+ypix), title, ALIGNMENT=0.5,  $
          FONT=0, CHARSIZE=charsize, /DEVICE

;Reset the position
!P.POSITION = 0

ENDIF


;Vertical colourbar
;------------------
IF (ydiff GT xdiff) THEN BEGIN
nticks=ncontour
IF (upper) THEN nticks=nticks-1
IF (lower) THEN nticks=nticks-1

yint = ydiff/ncontour
xint = xdiff
ystart=y0
icol=2

IF (lower) THEN BEGIN
xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
ypts=[y0,y0+yint,y0+yint,y0]
POLYFILL, xpts, ypts, COLOR=icol, /DEVICE
IF (NOLINES EQ 0) THEN BEGIN
 PLOTS, xpts, ypts, /DEVICE
ENDIF ELSE BEGIN
 xpts=[x0, x0+xint/2, x0+xint]
 ypts=[y0+yint,y0,y0+yint]
 PLOTS, xpts, ypts, /DEVICE
ENDELSE
ystart=ystart+yint
icol=icol+1
ENDIF

myalign=1.0
myx=x0-xint*0.25
IF TEXTPOS then myalign=0.0
IF TEXTPOS THEN myx=x0+xint*1.25
FOR iy=0, nticks-1 DO BEGIN
 plotlabel=plotlabels(iy)
 myy=ystart+iy*yint
 xpts=[x0, x0, x0+xint, x0+xint, x0]
 ypts=[myy,myy+yint, myy+yint, myy, myy]
 POLYFILL, xpts, ypts, COLOR=icol+iy, /DEVICE  
 IF (plotlabel EQ 1) THEN BEGIN
  IF ((NOLINES EQ 1) AND (iy EQ 0)) THEN PLOTS, [x0, x0+xint], [myy,myy], /DEVICE
  IF ((NOLINES EQ 1) AND (iy EQ nticks-1)) THEN PLOTS, [x0, x0+xint], [myy+yint,myy+yint], /DEVICE
  IF (N_ELEMENTS(nvals) EQ 1) THEN PLOTS, [x0, x0+xint*1/8], [myy,myy], /DEVICE
  IF (N_ELEMENTS(nvals) EQ 1) THEN PLOTS, [x0+xint*7/8, x0+xint], [myy,myy], /DEVICE
 ENDIF
 IF (NOLINES EQ 0) THEN BEGIN
  PLOTS, xpts, ypts, /DEVICE 
 ENDIF ELSE BEGIN
  xpts=[x0, x0]
  ypts=[myy,myy+yint]
  xpts2=[x0+xint, x0+xint]
  ypts2=[myy,myy+yint]    
  PLOTS, xpts, ypts, /DEVICE 
  PLOTS, xpts2, ypts2, /DEVICE 
 ENDELSE
 myy=ystart+iy*yint
 mylev=STRTRIM(STRING(levs(iy+icol-2), format=form),2)
 IF (plotlabel EQ 1) THEN XYOUTS, myx, myy-ypix/2.0, mylev, ALIGNMENT=myalign, FONT=0, CHARSIZE=charsize, /DEVICE
ENDFOR
myy=ystart+nticks*yint
mylev=STRTRIM(STRING(levs(iy+icol-2),format=form),2)
XYOUTS, myx, myy-ypix/2.0, mylev, ALIGNMENT=myalign, FONT=0, CHARSIZE=charsize, /DEVICE


IF (upper) THEN BEGIN
xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
ypts=[y1,y1-yint,y1-yint,y1]
POLYFILL, xpts, ypts, COLOR=icol+nticks, /DEVICE
IF (NOLINES EQ 0) THEN BEGIN
 PLOTS, xpts, ypts, /DEVICE
ENDIF ELSE BEGIN
 xpts=[x0, x0+xint/2, x0+xint]
 ypts=[y1-yint,y1,y1-yint]
 PLOTS, xpts, ypts, /DEVICE
ENDELSE
ENDIF

;Add the title
XYOUTS, x0+xint/2, y0-2*(space1+ypix), title, ALIGNMENT=0.5, FONT=0, CHARSIZE=charsize, /DEVICE


!P.POSITION = 0

ENDIF

END


