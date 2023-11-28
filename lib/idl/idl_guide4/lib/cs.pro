PRO CS, SCALE=scale, COLS=cols, MIN=min, MAX=max, NCOLS=ncols, IDL=idl,VCS=vcs, $
        FILE=file, OUTFILE=outfile, DRAW=draw, WHITE=white, REV=rev
;Procedure to select colour scales.
;(C) NCAS 2008

;Check !guide exists.
DEFSYSV, '!guide', exists=exists
IF ((exists EQ 0)) THEN BEGIN
 PSOPEN
 PSCLOSE, /NOVIEW
ENDIF


;Load selected colour scale if requested.
IF (N_ELEMENTS(scale) NE 0) THEN BEGIN
 IF ((scale LT 1) OR (scale GT 30)) THEN BEGIN
  PRINT, ''
  PRINT, 'CS ERROR - scale not in range 1-30'
  PRINT, ''
  STOP
 ENDIF
 csfile=GETENV('GUIDE_LIB')+'/colour_scales/cs'+SCROP(scale)+'.txt'
 rgb=INTARR(256,3)
 OPENR, lun, csfile, /GET_LUN
 READF, lun, rgb
 FREE_LUN, lun

 plot_cscale=reform(rgb, 3, N_ELEMENTS(rgb)/3)
 IF (N_ELEMENTS(NCOLS) EQ 0) THEN BEGIN
  ;Load uninterpolated colours.
  TVLCT, plot_cscale(0,*), plot_cscale(1,*), plot_cscale(2,*)
 ENDIF ELSE BEGIN
  ;Interpolate to get 254 colours with white and black at the start as normal.
  scalecols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23]
  scols=scalecols(scale-1)
  step=(scols-1)/253.0
  x1=FINDGEN(scols)
  x2=FINDGEN(254)*step
  red=REFORM(plot_cscale(0, 2:scols+1))
  green=REFORM(plot_cscale(1, 2:scols+1))
  blue=REFORM(plot_cscale(2, 2:scols+1))
  
  ;Interpolate colours.
  red2=[255, 0, INTERPOL(red, x1, x2)]
  green2=[255, 0, INTERPOL(green, x1, x2)]
  blue2=[255, 0, INTERPOL(blue, x1, x2)]
  
  ;step through to get new colour scale.
  IF (N_ELEMENTS(min) EQ 0) THEN min=2
  IF (MIN LT 2) THEN MIN=2
  IF (N_ELEMENTS(max) EQ 0) THEN max=255
  IF (max GT 255) THEN max=254
  IF (ncols GT 254) THEN ncols=254
 
  red3=INTARR(256)+255
  red3(1)=0
  green3=red3
  blue3=red3
  step=(max-min)/FLOAT(ncols-1)
  FOR ix=0, ncols-1 DO BEGIN
   icol=min+ix*step
   red3(ix+2)=red2(icol)
   green3(ix+2)=green2(icol)
   blue3(ix+2)=blue2(icol)
  ENDFOR
  TVLCT, red3, green3, blue3
 ENDELSE
ENDIF


;Choose colours by number.
IF (N_ELEMENTS(cols) NE 0) THEN BEGIN
 rgbnames=STRARR(749,4)
 rgbname=''
 csfile=GETENV('GUIDE_LIB')+'/colour_scales/colournames.txt' 
 OPENR, lun, csfile, /GET_LUN
 FOR i=0, 548 DO BEGIN
  READF,lun, rgbname
  split=STRSPLIT(rgbname, /EXTRACT)
  rgbnames(i,*)=split
 ENDFOR
 FREE_LUN, lun

 red=INTARR(255)
 red(0)=255
 green=red
 blue=red
 FOR i=0, N_ELEMENTS(cols)-1 DO BEGIN
  IF (cols(i) GT 549) THEN BEGIN
   PRINT, ''
   PRINT, 'CS ERROR - requested colour ', cols(i), ' out of range 1-549.'
   PRINT, ''
   STOP
  ENDIF
  red(i+2)=rgbnames(cols(i)-1,1)
  green(i+2)=rgbnames(cols(i)-1,2)
  blue(i+2)=rgbnames(cols(i)-1,3)
 ENDFOR
 ;Change all remaining colours to white.
 red(N_ELEMENTS(cols)+2:254)=255
 green(N_ELEMENTS(cols)+2:254)=255
 blue(N_ELEMENTS(cols)+2:254)=255 
 TVLCT, red, green, blue
ENDIF


;Load an IDL or VCS colour scale.
IF ((N_ELEMENTS(idl) NE 0) OR KEYWORD_SET(VCS)) THEN BEGIN
 IF (N_ELEMENTS(idl) NE 0) THEN BEGIN
  IF ((idl LT 0) OR (idl GT 40)) THEN BEGIN
   PRINT, ''
   PRINT, 'CS ERROR - idl not in range 0-40'
   PRINT, ''
   STOP
  ENDIF
  csfile=GETENV('GUIDE_LIB')+'/colour_scales/idl'+SCROP(idl)+'.txt'
 ENDIF
 IF KEYWORD_SET(VCS) THEN csfile=GETENV('GUIDE_LIB')+'/colour_scales/vcs.txt'
 
 rgb=INTARR(256,3)
 OPENR, lun, csfile, /GET_LUN
 READF, lun, rgb
 FREE_LUN, lun
 plot_cscale=reform(rgb, 3, N_ELEMENTS(rgb)/3)
 IF (N_ELEMENTS(min) EQ 0) THEN min=2
 IF (MIN LT 2) THEN MIN=2
 IF (N_ELEMENTS(max) EQ 0) THEN max=255
 IF (max GT 255) THEN max=254
 IF (N_ELEMENTS(ncols) EQ 0) THEN ncols=254
 IF (ncols GT 254) THEN ncols=254
 
 red=INTARR(256)+255
 red(1)=0
 green=red
 blue=red
 step=(max-min)/FLOAT(ncols-1)
 FOR ix=0, ncols-1 DO BEGIN
  icol=min+ix*step
  red(ix+2)=plot_cscale(0,icol)
  green(ix+2)=plot_cscale(1,icol)
  blue(ix+2)=plot_cscale(2,icol)
 ENDFOR
 TVLCT, red, green, blue
ENDIF


;Output scale to a file.
IF (N_ELEMENTS(outfile) NE 0) THEN BEGIN
 TVLCT, red, green, blue, /GET
 OPENW, lun, outfile, /GET_LUN
 FOR j=0, 255 DO BEGIN
  PRINTF, lun, red(j), green(j), blue(j)
 ENDFOR
 FREE_LUN,lun
ENDIF


;Reading in scale from a file.
IF (N_ELEMENTS(file) NE 0) THEN BEGIN
 PRINT, 'reading colour scale data'
 red=INTARR(256)
 green=INTARR(256)
 blue=INTARR(256)
 OPENR, lun, file, /GET_LUN
 FOR j=0, 255 DO BEGIN
  READF, lun, val1, val2, val3
  red(j)=val1
  green(j)=val2
  blue(j)=val3
  PRINT, j, red(j), green(j), blue(j)
 ENDFOR
 FREE_LUN, lun
 TVLCT, red, green, blue
ENDIF


;Reverse colours if requested.
IF (N_ELEMENTS(REV) EQ 1) THEN BEGIN
 scols=254
 scalecols=[18, 16, 15, 12, 8, 3, 8, 8, 3, 16, 12, 18, 12, 18, 14, 10, 12, 8, 8, 10, 12, 14, 11, 10, 7, 28, 35, 9, 15, 23]
 IF (N_ELEMENTS(SCALE) NE 0) THEN scols=scalecols(scale-1)
 IF (N_ELEMENTS(ncols) NE 0) THEN scols=ncols
 IF (rev NE 1) THEN scols=rev
 TVLCT, red, green, blue, /GET ;Get current colour scale.
 r=[red(0:1),reverse(red(2:scols+1))]
 g=[green(0:1),reverse(green(2:scols+1))]
 b=[blue(0:1),reverse(blue(2:scols+1))]
 IF (scols LT 254) THEN BEGIN
  r=[r, red(scols+2:255)]
  g=[g, green(scols+2:255)]
  b=[b, blue(scols+2:255)]
 ENDIF
 TVLCT, r, g, b 
ENDIF


;Setting selected colours to white
IF (N_ELEMENTS(white) NE 0) THEN BEGIN
 TVLCT, r, g, b, /GET ;Get current colour scale.
 FOR icol=0, N_ELEMENTS(white)-1 DO BEGIN
  r(white(icol))=255
  g(white(icol))=255
  b(white(icol))=255
 ENDFOR
 TVLCT, r, g, b
ENDIF


;Drawing a colour scale.
IF KEYWORD_SET(draw) THEN BEGIN
 TVLCT, r, g, b, /GET ;Get correct colour scale.
 PSOPEN ;This overwrites the colour scale with scale=1.
 TVLCT, r, g, b ;Reload colour scale.
 size=1200
 offset=1000
 thresh=50  
 TVLCT, r, g, b, /GET
 FOR ix=0, 15 DO BEGIN
  FOR iy=0, 15 DO BEGIN
   xpts=[ix, ix, ix+1, ix+1, ix]*size+offset
   ypts=[iy, iy+1, iy+1, iy, iy]*size+offset
   POLYFILL, xpts, ypts, COLOR=((15-iy)*16)+ix, /DEVICE
   textcol=0
   col=((15-iy)*16)+ix
   IF (LONG(r(col))+LONG(g(col))+LONG(b(col)) GT 350) THEN textcol=1
   XYOUTS, ix*size+size/2+offset, iy*size+size/2.6+offset, SCROP(col), $
          ALIGN=0.5, CHARSIZE=1.5, CHARTHICK=5, COLOR=textcol, /DEVICE
  ENDFOR
 ENDFOR

 PSCLOSE
ENDIF


END

