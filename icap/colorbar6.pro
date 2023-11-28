pro colorbar6,nlevels,labels,colors,x0,x1,y0,units,charsize,charmult,lblcolor
;
;
;print,'colorbar input ',nlevels,labels,colors,x0,x1,y0,units,charsize,charmult,lblcolor

;lblcolor=0
;
; makes labeled horizontal color bar
;
; input:
;
;  nlevels - number of segments in the colorbar
;  labels - numeric values of lower boundaries of the color segments
;  color - values of indicies of colors in color table for each segment
;  x0 - x coordinate of left end of color bar, in normalized units
;  x1 - x corrdinate of right end of color bar, in normalized units
;  y0 - y coordinate of center of color bar, in normalized units
;  units - units (label) of colorbar
;  charsize - usual meaning
;  charmult - usual meaning
;  lblcolor - usual meaning
;

;nlevels = 6
;labels=[-0.0001,1.e-4,-1.e-2,0.1,1.,10.]
;loadct,22
;colors=[20,50,90,120,160,233]
;y0=.2
;x0=.1
;x1=.99

x=fltarr(4)
y=fltarr(4)
xl=fltarr(4)
yl=fltarr(4)

;
;
; determine width of a single color bar segment
;
xwidth = (x1 - x0) / (nlevels)

;
;
; specify thickness of colorbar, and y coordinates
;
;cc ywidth = charsize * 0.06
ywidth = charsize * 0.04
y2=y0 - 0.5 * ywidth
y3=y0 + 0.5 * ywidth
y=[y2,y2,y3,y3]

;cc ylwidth = ywidth / 2.0 * 1.5 * charsize
ylwidth = ywidth / 2.0 * 1.2 * charsize
y2l=y0 - 0.5* ylwidth
y3l=y0 + 0.5* ylwidth
yl=[y2l,y2l,y3l,y3l]

;print,'charsize is ',charsize
;print,'ywidth is ',ywidth
;print,'ylwidth is ',ylwidth
;
;
; make and label each color segment
;

for i = 0,nlevels-1 do begin

;
;
; determine coordinates of segment and fill it
;
x2 = x0 + i * xwidth
x3 = x2 + xwidth
x=[x2,x3,x3,x2]
polyfill,x,y,color=colors(i),/normal
;print,'x is ',x
;
;
; determine appropriate format for label and format it
;
;help, i, labels, nlevels
labstr=strcompress(labels(i),/remove_all)
len = strlen(labstr)
exp = 0
neg = 0
point=0
frac=0
; search for first non-zero value, decimal and last non-zero value
for l = 0,len-1 do begin
;
;
; the number is negative with the sign at position l
;
  if (strmid(labstr,l,1) eq '-') then neg = 1
;
;
; the number is in exponential form with the 'e' at position l
;
  if (strmid(labstr,l,1) eq 'e') then exp = l
  if (strmid(labstr,l,1) eq 'E') then exp = l
;
;
; the number is in decimal form with the decimal at position l
;
  if (strmid(labstr,l,1) eq '.') then point = l
;
;
; the number has a mantissa, ending at position l
;
  if (point ne 0 and strmid(labstr,l,1) ne '0') then frac = l
;
endfor
;
;
; the length of leading numbers excluding the point
;
lead = max([point,1])
dec = frac-point
;
;
; not in decimal or exponential form
;
if (point eq 0 and exp eq 0) then begin
  format='i'+string(len,format='(i2.2)')
;
;
; in exponential form
;
endif else if ( exp ne 0 ) then begin
  format = 'e9.2'
;
;
; in decimal form
;
endif else begin
  format='f'+strcompress(lead+neg+1+dec,/remove_all)+'.'+strcompress(dec,/remove_all)
endelse

label = string(labels(i),format='('+format+')')
;print,label
;print,labels(i)
;print,format
;print,neg,exp,point,lead,dec

;0.00000 40.0000 80.0000 120.000 160.000 200.000 240.000 280.000 320.000 360.000 400.000

;0.
;0.00000
;f2.0
;       0       0       1       1       0
;**
;40.0000
;f2.0
;       0       0       2       1       0



;
;
; old method turned off
;
if ( 1 eq 2 ) then begin
 if labels(i) eq ' ' then begin
   label = labels(i)
 endif else if float(labels(i)) eq 0 then begin
   label = string(labels(i),format='(i1)')
 endif else if labels(i) ge 100.0 then begin
   label = string(labels(i),format='(i4)')
 endif else if labels(i) ge 10.0 then begin
   label = string(labels(i),format='(i3)')
 endif else if labels(i) ge 1.0 then begin
   label = string(labels(i),format='(f3.1)')
 endif else if labels(i) ge 0.1 then begin
   label = string(labels(i),format='(f4.2)')
 endif else if labels(i) ge 0.01 then begin
   label = string(labels(i),format='(f5.3)')
 endif else if labels(i) ge 0.001 then begin
   label = string(labels(i),format='(f6.4)')
 endif else begin
   label = string(labels(i),format='(e8.1)')
 endelse

endif

;if colors(i) gt 210 then begin
;  ccolor = 0
;endif else begin
;  ccolor = 255
;endelse

;
;
; determine size of area to blank before writing label and then blank it
;
lablen = strlen(label)
xlablen = charsize * float(lablen) * .01 / 2. * 1.2
xlablen = charsize * float(lablen) * .01 / 2. * 1.5
x2l = x2 - xlablen
x3l = x2 + xlablen
xl=[x2l,x3l,x3l,x2l]
polyfill,xl,yl,/normal,color=1

;print,'x1 is ',x1
;
;
; determine coordinates for label text and write labels
;
xc = x2
yc = y0 - 0.15/charsize * ywidth
yc = y0 - 0.15 * ywidth
xyouts,xc,yc,label,alignment=0.5,/normal,charsize=charsize*charmult,color=lblcolor
;print,'charmult is ',charmult
endfor
;
;
; determine size of area to blank before writing units and then blank it
;
lablen = strlen(units)
xlablen = charsize * float(lablen) * .01 / 2. * 1.2
xlablen = charsize * float(lablen) * .01 / 2. * 2.0
xc = x0 + (x1 - x0 ) * 0.5
yc = y0 - .12/charsize
x2l = xc - xlablen
x3l = xc + xlablen
xl=[x2l,x3l,x3l,x2l]
y2l=y0 - 2.0* ylwidth
y3l=y0 - 1.0* ylwidth
yl=[y2l,y2l,y3l,y3l]
polyfill,xl,yl,/normal,color=1

;
;
; determine coordinates for colorbar units label and write label
;
xc = x0 + (x1 - x0 ) * 0.5
yc = y0 - .12/charsize
yc = y0 - 1.75* ylwidth
xyouts,xc,yc,units,alignment=0.5,/normal,charsize=charsize*charmult,color=lblcolor

return
end
