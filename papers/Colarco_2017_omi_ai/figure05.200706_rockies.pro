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
  dai_   = fltarr(nx,2)
  rad_   = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ai_[ix,0]    = mean(ai[a])
   prs_[ix,0]   = mean(prs[a])
   aiomi_[ix,0] = mean(aiomi[a])
   dai_[ix,0]   = mean(aiomi[a]-ai[a])
   rad_[ix,0]   = mean(rad[a])
   ai_[ix,1]    = stddev(ai[a])
   prs_[ix,1]   = stddev(prs[a])
   aiomi_[ix,1] = stddev(aiomi[a])
   dai_[ix,1]   = stddev(aiomi[a]-ai[a])
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

; delta-AI
  loadct, 0
  plot, findgen(2), /nodata, $
   xthick=24, ythick=24, $
   xrange=xrange, yrange=[0,.4], ystyle=1, $
   xtitle='longitude', ytitle='!9D!3AI (OMAERUV-MERRAero)'
  xyouts, -120, .42, 'b) !9D!3AI'
  ler_    = fltarr(nx,2)
  leromi_ = fltarr(nx,2)
  loadct, 62
  xyouts, -118, 0.36, 'Elevation', color=200
  loadct, 57
  xyouts, -118, 0.32, '!9D!3AI', color=200
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ler_[ix,0]    = mean(ler[a])
   leromi_[ix,0] = mean(leromi[a])
   ler_[ix,1]    = stddev(ler[a])
   leromi_[ix,1] = stddev(leromi[a])
  endfor
  if(i eq 0) then begin
   loadct, 57
   fillmeanstd, lonnode, dai_[*,0], dai_[*,1], color=200, fillcolor=50
   oplot, lonnode, dai_[*,0], color=200, thick=18
   loadct, 0
   axis, yaxis=1, yrange=[0,4], /save, ytitle='Elevation [km]', color=0
  endif else begin
   loadct, 0
   axis, yaxis=1, yrange=[0,4], /save, ytitle='Elevation [km]', color=0
   loadct, 62
   fillmeanstd, lonnode, topo_[*,0]/1000., topo_[*,1]/1000., color=200, fillcolor=50
   oplot, lonnode, topo_[*,0]/1000., color=200, thick=18
  endelse



  if(i eq 0) then aimg = tvrd(/true)
  if(i eq 1) then bimg = tvrd(/true)

  endfor

  write_png, 'figure05.'+datewant+'_'+regname+'.png', 0.5*aimg+0.5*bimg

end
