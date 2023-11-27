; Colarco, Oct. 2007
; Given a vector of x-coordinates and a 2-d array of y-coordinates,
; construct a filled in polygon that outlines the max and min of the
; the y-values at each x.
;  e.g.
;   x = 0, 1, 2, ... 11  (months)
;   y = [nmonth,nyears]
; if sdev present then plot the standard deviations

  pro polymaxmin, x, y, color=color, fillcolor=fillcolor, edgecolor=edgecolor, $
                        thick=thick, linestyle=linestyle, $
                        noave=noave, sdev=sdev, noclip=noclip

  if(not(keyword_set(color))) then color=0
  if(not(keyword_set(fillcolor))) then fillcolor=0
  if(not(keyword_set(edgecolor))) then edgecolor=-1
  if(not(keyword_set(thick))) then thick=6
  if(not(keyword_set(linestyle))) then linestyle=0
  if(not(keyword_set(noclip))) then noclip=0

  nx = n_elements(x)
  a = size(y)
  if(a[0] ne 2) then begin
   print, 'y must be 2-d array'
   stop
  endif
  if(a[1] ne nx) then begin
   print, 'first dimension of y must be same length as x vector'
   stop
  endif
  
  polyx = fltarr(2*nx+1)
  polyy = fltarr(2*nx+1)

  bmax = fltarr(nx)
  bmin = fltarr(nx)
  bave = fltarr(nx)
  for ix = 0, nx-1 do begin
   a = where(finite(y[ix,*]) eq 1)
   bmax[ix] = max(y[ix,a])
   bmin[ix] = min(y[ix,a])
   bave[ix] = mean(y[ix,a])
  endfor

  polyy[0:nx-1] = bmax
  for i = 0, nx-1 do begin
   polyy[nx+i] = bmin[nx-1-i]
  endfor
  polyy[2*nx] = bmax[0]
  polyx = [x,reverse(x),x[0]]

  if(fillcolor ge 0) then polyfill, polyx, polyy, color=fillcolor, noclip=noclip
  if(not(keyword_set(noave))) then oplot, x, bave, thick=thick, linestyle=linestyle, color=color, noclip=noclip
  if(not(keyword_set(noave))) then oplot, x, bmin, thick=thick/3, linestyle=linestyle, color=color, noclip=noclip
  if(not(keyword_set(noave))) then oplot, x, bmax, thick=thick/3, linestyle=linestyle, color=color, noclip=noclip

  if(keyword_set(sdev)) then begin
   dx = x[1]-x[0]
   for ix = 0, nx-1 do begin
    plots, x[ix]+[-1,1,0,0,-1,1]*0.25*dx, $
           bave[ix]+[-1,-1,-1,1,1,1]*sdev[ix], color=color, noclip=noclip
   endfor
  endif

; Plot an edge color on the top and bottom (aesthetics!)
  if(edgecolor ne -1) then begin
   oplot, x, bmin, thick=thick/3, linestyle=linestyle, color=edgecolor, noclip=noclip
   oplot, x, bmax, thick=thick/3, linestyle=linestyle, color=edgecolor, noclip=noclip
  endif
end
