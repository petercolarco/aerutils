; Colarco, March 2006
; Pass in arrays of dates, values and make a strip chart plot of the
; the values

  pro plot_scatter, date, val, ymax, plotfile, title, ytitle, ctlfile, $
      q=q, lon=lon, lat=lat, colors=colorIn, $
      colortable = colortableIn, p0lon=p0lon, typefile=typefile, $
      std=std, scolorarray=scolorarray

  color = [120,120,120]
  colortable = 0
  if(keyword_set(colorIn)) then color=colorIn
  if(keyword_set(linestyleIn)) then lin=linestyleIn
  if(keyword_set(colortableIn)) then colortable = colortableIn

  loadct, colortable

; Sort out the data
  sizearr = size(val)
  nx = sizearr[1]
  ny = sizearr[2]
  if(ny lt 2) then begin
   print, 'Expected an array (nx,ny) where ny > 2; you gave ny = ', ny
   print, 'exiting'
   stop
  endif

; Make the plot
  plot, [0,ymax], [0,ymax], /nodata, $
   xstyle=8, xthick=6, $
   ystyle=8, ythick=6, $
   xtitle='MOD04', ytitle='Model', title=title

; Plot a one-to-one line
  oplot, [0,5], [0,5]
  oplot, [0,5], [0,2.5], lin=2, thick=3
  oplot, [0,2.5], [0,5], lin=2, thick=3

  x = reform(val[*,0])
  y = reform(val[*,1:ny-1])
  for iy = 0, ny-2 do begin
   for ix = 0, nx-1 do begin
    if(finite(x[ix])) then begin
     usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=color[iy]
     plots, x[ix], y[ix,iy], psym=8
     usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=0
     plots, x[ix], y[ix,iy], psym=8
    endif
   endfor

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(x) eq 1)
    n = n_elements(a)
    statistics, x[a], y[a,iy], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
    if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, $
      linestyle=1, noclip=0, color=color[iy], thick=3
     n = strcompress(string(n, format='(i2)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
     xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.4
     xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.4
     xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.4
     xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.4
     xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.4
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.4
    endif
   endif

  endfor


  if(keyword_set(q)) then begin

   loadct, 0
   dxplot = !x.region[1]-!x.region[0]
   dyplot = !y.region[1]-!y.region[0]
   x0 = !x.region[0]+.65*dxplot
   x1 = !x.region[0]+.95*dxplot
   y0 = !y.region[0]+.15*dyplot
   y1 = !y.region[0]+.45*dyplot
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=255, /fill, /normal
   if(keyword_set(p0lon)) then begin
    map_set, 0, p0lon, 0, /noerase, position=[x0,y0,x1,y1]
   endif else begin
    map_set, /noerase, position=[x0,y0,x1,y1]
   endelse
   area, lon, lat, nx, ny, dxx, dyy, area
   plotgrid, q, [.1], [160], lon, lat, dxx, dyy
   map_continents, thick=.5
  endif


end
