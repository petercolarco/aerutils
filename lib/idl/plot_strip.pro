; Colarco, March 2006
; Pass in arrays of dates, values and make a strip chart plot of the
; the values

  pro plot_strip, date, val, ymax, title, ytitle, ctlfile, $
      q=q, lon=lon, lat=lat, linestyle=linestyleIn, colors=colorIn, $
      thick=thickIn, $
      colortable = colortableIn, p0lon=p0lon, typefile=typefile, $
      std=std, scolorarray=scolorarray, ymin=ymin, position=position, $
      noerase=noerase, draft=draft

  if(not(keyword_set(draft))) then draft = 0

  !quiet = 1L
  nlin = n_elements(val[0,*])

  color = indgen(nlin)*240/nlin
  lin = make_array(nlin,val=0)
  thick=make_array(nlin,val=9)
  colortable = 0
  if(keyword_set(colorIn)) then color=colorIn
  if(keyword_set(linestyleIn)) then lin=linestyleIn
  if(keyword_set(colortableIn)) then colortable = colortableIn
  if(keyword_set(thickIn)) then thick = thickIn
  if(not(keyword_set(ymin))) then ymin = 0.

  loadct, 0
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

  if(keyword_set(std)) then begin
   for ilin = 0, nlin-1 do begin
    if(scolorarray[ilin] ne 0) then begin
     for it = 0, nt-1 do begin
      if(finite(val[it,ilin]) eq 1) then begin
       x = it
       y = val[it,ilin]
       dy = std[it,ilin]
       polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-dy,-dy,dy,dy,-dy], $
        noclip=0, /fill, color=scolorarray[ilin]
      endif
     endfor
    endif
   endfor
;  And put the tickmarks back on
   plot, [0,nt], [ymin,ymax], /nodata, /noerase, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    position=position , $
    xticks=ntick, xtickv=indgen(ntick+1)*12, xminor=nminor, xtickname=tickname, $
    ytitle=ytitle
  endif

  for ilin = 0, nlin-1 do begin
   loadct, colortable[0]
   if(n_elements(colortable) gt 1) then loadct, colortable[ilin]
   if(keyword_set(typefile)) then begin
    if(typefile[ilin] eq 'OMI') then begin
     axis, yaxis=1, yrange=[1,2], ythick=4,  ystyle=9, ytitle='OMI Aerosol Index'
     oplot, indgen(nt), (val[*,ilin]-1.)*ymax, thick=thick[ilin], lin=lin[ilin], color=color[ilin]
    endif else begin
     oplot, indgen(nt), val[*,ilin], thick=thick[ilin], lin=lin[ilin], color=color[ilin]
    endelse
   endif else begin
     oplot, indgen(nt), val[*,ilin], thick=thick[ilin], lin=lin[ilin], color=color[ilin]
   endelse
   a = where(finite(val[*,ilin]) ne 0 and finite(val[*,0]) ne 0)
   strmon = '0.0'
   if(a[0] ne -1) then strmon = string(total(val[a,ilin])/n_elements(a),format='(f7.3)')
;   xyouts,  .92, .9-ilin*.17, /normal, ctlfile[ilin], color=color[ilin], charsize=.75
;   xyouts,  .92, .815-ilin*.17, /normal, strmon, color=color[ilin], charsize=.75
    statistics, val[a,0], val[a,ilin], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset, rc=rc
   str = string(ctlfile[ilin], mean1, r, bias, skill, $
          format='(1x,a-45,1x,4(f6.3,1x))')
   print, str
   if(draft) then $
    xyouts, .2, ymin+(2-ilin)*0.06*(ymax-ymin), str, color=color[ilin], charsize=.75
  endfor

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
