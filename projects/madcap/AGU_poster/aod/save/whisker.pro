; Given five numbers, plot a bar/whisker plot element
; Assumption is that "data" is a five-number array that specifies
; either the y-extent of the data plot (or optionally, the x-extent)
; Inputs:
;  data  - input field
;  x     - offset position
;  dx    - width of bar
;  color - fill color element, optional
;  horizontal - default is vertical, but if set the plot vertically

  pro whisker, data, x, dx, $
   color=color, thick=thick, lcolor=lcolor, $
   horizontal=horizontal, linestyle=linestyle

  if(n_elements(thick) eq 0) then thick = 1 else  thick=thick[0]
  if(n_elements(linestyle) eq 0) then linestyle = 0 else  linestyle=linestyle[0]
  if(n_elements(lcolor) eq 0) then lcolor=0 else lcolor=lcolor[0]

; Check size of data
  if(n_elements(data) ne 5 and n_elements(data) ne 6) then stop

  if(not(keyword_set(horizontal))) then begin
   x0 = x-dx/2.
   x1 = x+dx/2.

   y0 = data[1]
   y1 = data[3]

   z0 = data[0]
   z1 = data[4]

   if(n_elements(color) ne 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=color[0]
   endif

   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], $
    thick=thick, lin=linestyle, color=lcolor

;  plot the whiskers
   plots, [x,x], [z0,y0], thick=thick/2., lin=linestyle, color=lcolor
   plots, [x-dx/4.,x+dx/4.], [z0,z0], thick=thick/2., lin=linestyle, color=lcolor
   plots, [x,x], [z1,y1], thick=thick/2., lin=linestyle, color=lcolor
   plots, [x-dx/4.,x+dx/4.], [z1,z1], thick=thick/2., lin=linestyle, color=lcolor

;  plot the center value
   plots, [x-dx/2.,x+dx/2.], [data[2],data[2]], thick=thick, lin=linestyle, color=lcolor

;  plot symbol for mean value
   if(n_elements(data) eq 6) then begin
    y = data[5]
    plots, x, y, psym=sym(1), symsize=2, color=lcolor
   endif

  endif else begin

   y0 = x-dx/2.
   y1 = x+dx/2.

   x0 = data[1]
   x1 = data[3]

   z0 = data[0]
   z1 = data[4]

   if(n_elements(color) ne 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=color[0]
   endif

   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], thick=thick, lin=linestyle, color=lcolor

;  plot the whiskers
   plots, [z0,x0], [x,x], thick=thick/2., lin=linestyle, color=lcolor
   plots, [z0,z0], [x-dx/4.,x+dx/4.], thick=thick/2., lin=linestyle, color=lcolor
   plots, [z1,x1], [x,x], thick=thick/2., lin=linestyle, color=lcolor
   plots, [z1,z1], [x-dx/4.,x+dx/4.], thick=thick/2., lin=linestyle, color=lcolor

;  plot the center value
   plots, [data[2],data[2]], [x-dx/2.,x+dx/2.], thick=thick, lin=linestyle, color=lcolor

;  plot symbol for mean value
   if(n_elements(data) eq 6) then begin
    y = data[5]
    plots, y, x, psym=sym(1), symsize=2, color=lcolor
   endif


  endelse

  end
