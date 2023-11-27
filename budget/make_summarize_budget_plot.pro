;
  pro make_summarize_budget_plot, i, nexpid, table, title, filestr, formatstr

  set_plot, 'ps'
  device, file='summarize_budget.'+filestr[i]+'.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

; Create a color table
  red   = [0,255,214,67]
  green = [0,255,96,147]
  blue  = [0,255,77,195]
  tvlct,red, green, blue

  x = [.15,.35,.55,.75,.95]
  y = [.025,.3,.575,.85]
  nx = n_elements(x)
  ny = n_elements(y)

  color = intarr(nexpid)
  color[*] = 1
;  plot, findgen(10), color=1, /nodata

; color the min and the max in each group of 4
  for j = 0, 2 do begin
   a = where(table[i,j*4:j*4+3] eq max(table[i,j*4:j*4+3]))
   color[j*4+a[0]] = 3
   a = where(table[i,j*4:j*4+3] eq min(table[i,j*4:j*4+3]))
   color[j*4+a[0]] = 2
  endfor

  for j = 0, nexpid-1 do begin
   xind = j mod 4
   yind = 2 - j / 4
   polyfill, [x[xind],x[xind+1],x[xind+1],x[xind],x[xind]], $
             [y[yind],y[yind],y[yind+1],y[yind+1],y[yind]], $
             color=color[j], /normal
   x0 = x[xind] + (x[xind+1]-x[xind])/2.
   y0 = y[yind] + (y[yind+1]-y[yind])/2.
   xyouts, x0, y0-.025, /normal, string(table[i,j],format=formatstr[i]), align=.5
  endfor

; Print the labels
  x0 = x[0]/2.
  xyouts, x0, y[0]+(y[1]-y[0])/2.-0.025, '0.5!E0!N', /normal, align=.5
  xyouts, x0, y[1]+(y[2]-y[1])/2.-0.025, '1!E0!N', /normal, align=.5
  xyouts, x0, y[2]+(y[3]-y[2])/2.-0.025, '2!E0!N', /normal, align=.5

  xyouts, x[0]+(x[1]-x[0])/2., y[3]+.025, 'Free', /normal, align=.5
  xyouts, x[1]+(x[2]-x[1])/2., y[3]+.025, 'Replay', /normal, align=.5
  xyouts, x[2]+(x[3]-x[2])/2., y[3]+.025, 'Replay!DReg!N', /normal, align=.5
  xyouts, x[3]+(x[4]-x[3])/2., y[3]+.025, 'CTM', /normal, align=.5

  xyouts, x[2], y[3]+.095, title[i], /normal, align=.5, chars=1.1

; Draw grid
  for ix = 0, nx-1 do begin
   plots, x[ix], [min(y),max(y)], thick=6, /normal
  endfor
  for iy = 0, ny-1 do begin
   plots, [min(x),max(x)], y[iy], thick=6, /normal
  endfor


  device, /close

end
