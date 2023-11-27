; Colarco, April 2011
; Pass in arrays of x and y (multiple y dimensions permitted) and make
; a filled in plot

  pro plot_comp_aot, date, val, ymax, title, ytitle, ctlfile, $
      q=q, lon=lon, lat=lat, colors=colors, thick=thick, $
      colortable = colortable, p0lon=p0lon, typefile=typefile, $
      ymin=ymin, position=position, $
      noerase=noerase, draft=draft, $
      sattrace=sattrace

  if(not(keyword_set(draft))) then draft = 0

  !quiet = 1L
  nlin = n_elements(val[0,*])

  color = indgen(nlin)*240/nlin
  if(not(keyword_set(colors))) then colors=indgen(nlin)*240/nlin
  if(not(keyword_set(colortable))) then colortable = 39
  if(not(keyword_set(thick))) then thick = make_array(nlin,val=9)
  if(not(keyword_set(ymin))) then ymin = 0.

  loadct, colortable
  if(not(keyword_set(position))) then position = [.1,.1,.95,.9]
  if(not(keyword_set(noerase))) then noerase = 0
   
  nt = n_elements(date)

; Assume the time is in YYYYMM.  I want a tick mark every 3 months.
  ntick = nt/12
  nminor = 4

; I want the tickmark name to be the year
  tickname=replicate(' ', ntick+1)
  date_ = strcompress(string(date),/rem)
  plot, [0,nt], [ymin,ymax], /nodata, noerase=noerase, $
   thick=4, xstyle=9, ystyle=9, color=0, $
   position=position , $
   xticks=ntick, xtickv=indgen(ntick+1)*12, xminor=nminor, xtickname=tickname, $
   ytitle=ytitle
  x = position[0]
  y = position[3]+.03*(position[3]-position[1])
  xyouts, x, y, title, /normal
  for it = 0, nt-1, 12 do begin
   xyouts, it, ymin-0.06*(ymax-ymin), strmid(date_[it],0,4), align=0
  endfor

  loadct, colortable
  for ilin = nlin-1, 0, -1 do begin

   xx = indgen(nt)
   val_ = make_array(nt,2,val=0.)
   if(ilin gt 0) then val_[*,1] = total(val[*,0:ilin],2) else val_[*,1] = val[*,0]
   a = where(finite(val_[*,1]) eq 1)
   if(a[0] ne -1) then val_ = val_[a,*]
   if(a[0] ne -1) then xx   = xx[a]
   polymaxmin, xx, val_, fillcolor=colors[ilin], /noave

  endfor

; And put the tickmarks back on
  plot, [0,nt], [ymin,ymax], /nodata, /noerase, $
   thick=4, xstyle=9, ystyle=9, color=0, $
   position=position , $
   xticks=ntick, xtickv=indgen(ntick+1)*12, xminor=nminor, xtickname=tickname, $
   ytitle=ytitle
  if(keyword_set(sattrace)) then oplot, indgen(nt), sattrace, thick=9, color=0

  if(keyword_set(q)) then begin

   loadct, 0
   dxplot = position[2]-position[0]
   dyplot = position[3]-position[1]
   x0 = position[0]+.65*dxplot
   x1 = position[0]+.95*dxplot
   y0 = position[1]+.65*dyplot
   y1 = position[1]+.95*dyplot
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
