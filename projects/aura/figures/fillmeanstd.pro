; Colarco, March 2016
; Given a vector of x-coordinates, y-coordinates, and stddev of y 
; construct a filled in polygon that outlines the range of y-stddev to
; y+stddev

  pro fillmeanstd, x, y, ystd, color=color, fillcolor=fillcolor, $
                        thick=thick, linestyle=linestyle, $
                        noave=noave, noclip=noclip

  if(not(keyword_set(color))) then color=0
  if(not(keyword_set(fillcolor))) then fillcolor=0
  if(not(keyword_set(thick))) then thick=6
  if(not(keyword_set(linestyle))) then linestyle=0
  if(not(keyword_set(noclip))) then noclip=0

  nx = n_elements(x)
  
  polyx = fltarr(2*nx+1)
  polyy = fltarr(2*nx+1)

  bmax = fltarr(nx)
  bmin = fltarr(nx)
  bave = fltarr(nx)
  for ix = 0, nx-1 do begin
   a = where(finite(y[ix]) eq 1)
   bmax[ix] = y[ix]+ystd[ix]
   bmin[ix] = y[ix]-ystd[ix]
   bave[ix] = y[ix]
  endfor

  polyy[0:nx-1] = bmax
  for i = 0, nx-1 do begin
   polyy[nx+i] = bmin[nx-1-i]
  endfor
  polyy[2*nx] = bmax[0]
  polyx = [x,reverse(x),x[0]]

  if(fillcolor ge 0) then polyfill, polyx, polyy, color=fillcolor, noclip=noclip
  if(not(keyword_set(noave))) then oplot, x, bave, thick=thick, linestyle=linestyle, color=color, noclip=noclip
  oplot, x, bmax, thick=1, color=color
  oplot, x, bmin, thick=1, color=color

end
