; Read the aggregate aerosol files from getregions.pro and make a plot
; that illustrates relevant behavior
; This version takes all the fields and aggregates them to a 1 degree
; resolution in longitude

  datewant = '200706'

  restore, file='getregions.'+datewant+'.sav'

; Region of interest
  latedge = [38,42]
  lonedge = findgen(31)-120.
  lonnode = -119.5+findgen(30)
  nx = n_elements(lonnode)
  regname = 'rockies'

  xrange = [-120,-90]

; Get the topography
  nc4readvar, 'topography.1152x721.nc', 'zs', topo, lon=lont, lat=latt
  area, lon_, lat_, nx_, ny_, dx_, dy_, area_, grid='e', lon2=lont, lat2=latt

; Plot some regional stuff
  for i = 0, 1 do begin

  set_plot, 'z'
  device, set_resolution=[16000,5200], decomp=0, set_pixel_depth=24, $
   set_font='helvetica', set_character_size=[200,200]
;  device, set_resolution=[3200,1040], decomp=0, set_pixel_depth=24, $
;   set_font='helvetica', set_character_size=[40,40]
  !p.font=1
  !p.multi = [0,2,1]
  !p.background=255
  !p.color=0

; AI
  loadct, 0
  plot, findgen(2), /nodata, $
   xthick=24, ythick=24, $
   xrange=xrange, yrange=[-0.5,1.5], $
   xtitle='longitude', ytitle='AI'
  xyouts, -120., 1.6, 'a) AI'
  loadct, 62
  xyouts, -118, 1.3, 'MERRAero', color=200
  loadct, 57
  xyouts, -118, 1.1, 'OMAERUV', color=200
  ai_    = fltarr(nx,2)
  prs_   = fltarr(nx,2)
  topo_  = fltarr(nx,2)
  aiomi_ = fltarr(nx,2)
  rad_   = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ai_[ix,0]    = mean(ai[a])
   prs_[ix,0]   = mean(prs[a])
   aiomi_[ix,0] = mean(aiomi[a])
   rad_[ix,0]   = mean(rad[a])
   ai_[ix,1]    = stddev(ai[a])
   prs_[ix,1]   = stddev(prs[a])
   aiomi_[ix,1] = stddev(aiomi[a])
   rad_[ix,1]   = stddev(rad[a])
   a = where(lont gt lonedge[ix] and lont le lonedge[ix+1] and $
             latt gt latedge[0]  and latt le latedge[1])
   topo_[ix,0]  = mean(topo[a])
   topo_[ix,1]  = stddev(topo[a])
  endfor
  if(i eq 0) then begin
   loadct, 62
   fillmeanstd, lonnode, ai_[*,0], ai_[*,1], color=200, fillcolor=50
   oplot, lonnode, ai_[*,0], color=200, thick=18
   loadct, 57
   fillmeanstd, lonnode, aiomi_[*,0], aiomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, aiomi_[*,0], color=200, thick=18
  endif else begin
   loadct, 57
   fillmeanstd, lonnode, aiomi_[*,0], aiomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, aiomi_[*,0], color=200, thick=18
   loadct, 62
   fillmeanstd, lonnode, ai_[*,0], ai_[*,1], color=200, fillcolor=50
   oplot, lonnode, ai_[*,0], color=200, thick=18
;   loadct, 0
;   axis, yaxis=1, yrange=[0,3500], /save
;   fillmeanstd, lonnode, topo_[*,0], topo_[*,1], color=50, fillcolor=200
;   oplot, lonnode, topo_[*,0], color=50, thick=18
  endelse

; LER
  loadct, 0
  plot, findgen(2), /nodata, $
   xthick=24, ythick=24, $
   xrange=xrange, yrange=[0,.12], $
   xtitle='longitude', ytitle='LER'
  xyouts, -120, .125, 'b) LER!D388!N'
  ler_    = fltarr(nx,2)
  leromi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ler_[ix,0]    = mean(ler[a])
   leromi_[ix,0] = mean(leromi[a])
   ler_[ix,1]    = stddev(ler[a])
   leromi_[ix,1] = stddev(leromi[a])
  endfor
  if(i eq 0) then begin
   loadct, 62
   fillmeanstd, lonnode, ler_[*,0], ler_[*,1], color=200, fillcolor=50
   oplot, lonnode, ler_[*,0], color=200, thick=18
   loadct, 57
   fillmeanstd, lonnode, leromi_[*,0], leromi_[*,1], color=200, fillcolor=50
   oplot, lonnode, leromi_[*,0], color=200, thick=18
  endif else begin
   loadct, 57
   fillmeanstd, lonnode, leromi_[*,0], leromi_[*,1], color=200, fillcolor=50
   oplot, lonnode, leromi_[*,0], color=200, thick=18
   loadct, 62
   fillmeanstd, lonnode, ler_[*,0], ler_[*,1], color=200, fillcolor=50
   oplot, lonnode, ler_[*,0], color=200, thick=18
  endelse



  if(i eq 0) then aimg = tvrd(/true)
  if(i eq 1) then bimg = tvrd(/true)

  endfor

  write_png, 'figure06.'+datewant+'_'+regname+'.png', 0.5*aimg+0.5*bimg
jump:
  set_plot, 'ps'
  device, file='delta_icalc.ps'
  !p.multi=0
  !P.font=0
  a = where(lon gt min(lonedge) and lon lt max(lonedge) and $
            lat gt min(latedge) and lat lt max(latedge))
  rad = rad[a]
  ler = ler[a]
  leromi = leromi[a]
  ai = ai[a]
  aiomi = aiomi[a]
  icalc = rad / (10^(-0.01*ai))
  icalcomi = rad / (10^(-0.01*aiomi))
  plot, icalc-icalcomi, $
   title = '!9D!3iCalc(LER) (MERRAero - OMAERUV)'
  device, /close
  device, file='delta_ler.ps'
  plot, ler-leromi, $
   title = '!9D!3LER (MERRAero - OMAERUV)'
  device, /close
  set_plot, 'x'
  plot, indgen(2), /nodata, $
   xrange=[0,.1], yrange=[0,.1], $
   xtitle='LER', ytitle='iCalc'
  plots, ler, icalc, psym=3
  plots, leromi, icalcomi, psym=3

; Plot the mean AI relative difference as function of pressure
  plot, prs_[*,0], (aiomi_[*,0]-ai_[*,0]), /nodata, $
   xrange=[750,1000], xtitle='Mean Surface Pressure [hPa]', $
   yrange=[0,0.3], ytitle='Mean AI Difference (OMAERUV-MERRAero)', $
   ystyle=9, position=[.1,.1,.9,.9]
  plots, prs_[*,0], (aiomi_[*,0]-ai_[*,0]), psym=sym(1)
  axis, yaxis=1, yrange=[-0.006,0], /save, $
   ytitle='Mean LER Difference (OMAERUV-MERRAero)'
  plots, prs_[*,0], (leromi_[*,0]-ler_[*,0]), psym=sym(2)

end
