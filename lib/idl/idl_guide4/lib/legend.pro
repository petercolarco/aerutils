PRO legend, LEGPOS=legpos, COL=col,  NOLEGENDBOX=nolegendbox,$
	    LEGCOL=legcol, LEGXOFFSET=legxoffset, LEGYOFFSET=legyoffset, $
	    SIZE=size,  FILLCOL=fillcol,  BORDERSPACE=borderspace, $
	    LABELS=labels, STYLE=style, SYM=sym, TYPE=type, LENGTH=length	      
;Procedure to plot legends.
;(C) NCAS 2008

;Check !guide exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PRINT, ''
 PRINT, 'ERROR - PSOPEN must first be called to initiate a postscript file.
 PRINT, ''
 STOP
ENDIF

;Set defaults.
space1=!guide.space1 ;space between colour bar and text.
xpix=!guide.xpix	 ;Width of text in pixels
ypix=!guide.ypix	 ;Height of text in pixels 
pt=CONVERT_COORD(!P.POSITION(0), !P.POSITION(1), /NORMAL, /TO_DEVICE)
xmin=pt(0)
ymin=pt(1)
pt=CONVERT_COORD(!P.POSITION(2), !P.POSITION(3), /NORMAL, /TO_DEVICE)
xmax=pt(0)
ymax=pt(1)
IF (N_ELEMENTS(borderspace) EQ 0) THEN borderspace=300
legspace=700 ;Space between the axis and the legend.
res=EXECUTE(!guide.textfont)	      
charsize=!guide.charsize
maxwidth=0.0 ;Width of text in pixels.
maxchars=MAX(STRLEN(labels))
IF (N_ELEMENTS(length) EQ 1) THEN linelen=1000.0*length/100.0 ELSE linelen=1000.0
nlines=N_ELEMENTS(labels)
IF (N_ELEMENTS(sym) GE 1) THEN symmult=-1 ELSE symmult=1
IF (N_ELEMENTS(size) EQ 1) THEN symsize=size/100.0 ELSE size=100
IF (N_ELEMENTS(type) EQ 0) THEN type=0 
IF (N_ELEMENTS(col) EQ 0) THEN col=INTARR(N_ELEMENTS(labels))+1

;Set default legend position.
IF (NOT KEYWORD_SET(legpos)) THEN legpos=12

;Y position
IF (WHERE(legpos EQ [3, 7, 11, 15]) GE 0) THEN ylegmin=ymin+legspace
IF (WHERE(legpos EQ [1, 5, 9, 13]) GE 0) THEN ylegmin=ymax-legspace-2*borderspace-nlines*(ypix+space1)
IF (WHERE(legpos EQ [2, 6, 10, 14]) GE 0) THEN ylegmin=(ymax-ymin)/2+ymin-nlines*(ypix+space1)/2
IF (WHERE(legpos EQ [4, 8, 12, 16]) GE 0) THEN ylegmin=ymin-legspace-2*borderspace-nlines*(ypix+space1)
ylegmax=ylegmin+nlines*(ypix+space1)+2*borderspace-space1/2
IF (N_ELEMENTS(legxoffset) EQ 1) THEN ylegmin=ylegmin+legyoffset
IF (N_ELEMENTS(legyoffset) EQ 1) THEN ylegmax=ylegmax+legyoffset


;X position
;Calculate width of text by plotting the text once.
FOR i=0, nlines-1 DO BEGIN
 XYOUTS, 0, 0, labels(i), FONT=0, CHARSIZE=charsize, WIDTH=width, $
	 ALIGNMENT=0.0, COLOR=0, /DEVICE
 IF (width*!d.x_size GT maxwidth) THEN maxwidth=width*!d.x_size
ENDFOR 

IF (WHERE(legpos EQ [1, 2, 3, 4]) GE 0) THEN xlegmin=xmin+legspace
IF (WHERE(legpos EQ [5, 6, 7, 8]) GE 0) THEN xlegmin=(xmax-xmin)/2+xmin-(maxwidth+linelen+2*borderspace+3*space1)/2
IF (WHERE(legpos EQ [9, 10, 11, 12]) GE 0) THEN xlegmin=xmax-(legspace+maxwidth+linelen+2*borderspace+3*space1)
IF (WHERE(legpos EQ [13, 14, 15, 16]) GE 0) THEN xlegmin=xmax+legspace
xlegmax=xlegmin+linelen+2*borderspace+maxwidth+3*space1
IF (N_ELEMENTS(legxoffset) EQ 1) THEN xlegmin=xlegmin+legxoffset
IF (N_ELEMENTS(legyoffset) EQ 1) THEN xlegmax=xlegmax+legxoffset


;Blank the legend box plotting area.
IF (NOT KEYWORD_SET(nolegendbox)) THEN BEGIN
 xbox=[xlegmin, xlegmin, xlegmax, xlegmax, xlegmin]
 ybox=[ylegmin, ylegmax, ylegmax, ylegmin, ylegmin]
 IF (N_ELEMENTS(legcol) NE 1) THEN legcol=0
 GPLOT, X=xbox, Y=ybox, LEGCOL=legcol, /DEVICE
ENDIF

;Plot legend.
FOR i=0, nlines-1 DO BEGIN
 linecol=COL(i)
 IF (type EQ 0) THEN BEGIN
  xpts=[xlegmin,xlegmin+linelen]+borderspace+space1
  ypts=[ylegmin+i*(ypix+space1), ylegmin+i*(ypix+space1)]+borderspace+ypix*0.4
  com='GPLOT, X=xpts, Y=ypts, COL=linecol, /DEVICE'
  IF KEYWORD_SET(style) THEN com=com+', STYLE=STYLE(i)'
  IF KEYWORD_SET(sym) THEN com=com+', SYM=sym(i), SIZE=size'
  res=EXECUTE(com)
 ENDIF ELSE BEGIN
  xpts=[xlegmin, xlegmin, xlegmin+linelen, xlegmin+linelen, xlegmin]+borderspace+space1
  ypts=[ylegmin+(i+0.1)*(ypix+space1), ylegmin+(i+0.7)*(ypix+space1), ylegmin+(i+0.7)*(ypix+space1),$
	ylegmin+(i+0.1)*(ypix+space1), ylegmin+(i+0.1)*(ypix+space1)]+borderspace
  IF (TYPE EQ 1) THEN GPLOT, X=xpts, Y=ypts, FILLCOl=col(i), COL=1, /DEVICE
  IF (TYPE EQ 2) THEN GPLOT, X=xpts, Y=ypts, FILLCOl=col(i), /DEVICE 
 ENDELSE
 GPLOT, X=xlegmin+borderspace+linelen+3*space1, Y=ylegmin+i*(ypix+space1)+borderspace+ypix*0.4, $
	TEXT=labels(i), VALIGN=0.5, ALIGN=0.0, /DEVICE  
ENDFOR 
 


END
