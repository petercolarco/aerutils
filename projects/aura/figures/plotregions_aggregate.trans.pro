; Read the aggregate aerosol files from getregions.pro and make a plot
; that illustrates relevant behavior
; This version takes all the fields and aggregates them to a 1 degree
; resolution in longitude

  datewant = '200707'

  restore, file='getregions.'+datewant+'.sav'

; Region of interest
  lonedge = findgen(21)-25.
  lonnode = -24.5+findgen(20)
  nx = n_elements(lonnode)
;
  latedge = [20,24]
  regname = 'nafrica'

; 
  latedge = [10,20]
  regname = 'dakar'
  xrange = [-25,-5]

; Plot some regional stuff
  for i = 0, 1 do begin

  set_plot, 'z'
  device, set_resolution=[16000,26000], decomp=0, set_pixel_depth=24, $
   set_font='helvetica', set_character_size=[200,200]
  device, set_resolution=[3200,5200], decomp=0, set_pixel_depth=24, $
   set_font='helvetica', set_character_size=[40,40]
  !p.font=1
  !p.multi = [0,2,5]
  !p.background=255
  !p.color=0

; AOD
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,2], $
   xtitle='longitude', ytitle='AOD', $
   title='AOD: MERRAero = red, OMAERUV = blue'
  aod_    = fltarr(nx,2)
  aodomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   aod_[ix,0]    = mean(aod[a])
   aodomi_[ix,0] = mean(aodomi[a])
   aod_[ix,1]    = stddev(aod[a])
   aodomi_[ix,1] = stddev(aodomi[a])
  endfor
  if(i eq 0) then begin
   loadct, 62
   fillmeanstd, lonnode, aod_[*,0], aod_[*,1], color=200, fillcolor=50
   oplot, lonnode, aod_[*,0], color=200, thick=18
   loadct, 57
   fillmeanstd, lonnode, aodomi_[*,0], aodomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, aodomi_[*,0], color=200, thick=18
  endif else begin
   loadct, 57
   fillmeanstd, lonnode, aodomi_[*,0], aodomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, aodomi_[*,0], color=200, thick=18
   loadct, 62
   fillmeanstd, lonnode, aod_[*,0], aod_[*,1], color=200, fillcolor=50
   oplot, lonnode, aod_[*,0], color=200, thick=18
  endelse

; AOD difference
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[-.5,.5], $
   xtitle='longitude', ytitle='AOD Difference', $
   title='OMAERUV - MERRAero AOD Difference'
  aodomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   aodomi_[ix,0]    = mean(aodomi[a] - aod[a])
   aodomi_[ix,1]    = stddev(aodomi[a]-aod[a])
  endfor
  loadct, 57
  fillmeanstd, lonnode, aodomi_[*,0], aodomi_[*,1], color=200, fillcolor=50, thick=18
  

; SSA
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[.7,1], $
   xtitle='longitude', ytitle='SSA', $
   title='SSA: MERRAero = red, OMAERUV = blue'
  ssa_    = fltarr(nx,2)
  ssaomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ssa_[ix,0]    = mean(ssa[a])
   ssaomi_[ix,0] = mean(ssaomi[a])
   ssa_[ix,1]    = stddev(ssa[a])
   ssaomi_[ix,1] = stddev(ssaomi[a])
  endfor
  if(i eq 0) then begin
   loadct, 62
   fillmeanstd, lonnode, ssa_[*,0], ssa_[*,1], color=200, fillcolor=50
   oplot, lonnode, ssa_[*,0], color=200, thick=18
   loadct, 57
   fillmeanstd, lonnode, ssaomi_[*,0], ssaomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, ssaomi_[*,0], color=200, thick=18
  endif else begin
   loadct, 57
   fillmeanstd, lonnode, ssaomi_[*,0], ssaomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, ssaomi_[*,0], color=200, thick=18
   loadct, 62
   fillmeanstd, lonnode, ssa_[*,0], ssa_[*,1], color=200, fillcolor=50
   oplot, lonnode, ssa_[*,0], color=200, thick=18
  endelse

; SSA difference
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[-.2,.2], $
   xtitle='longitude', ytitle='SSA Difference', $
   title='OMAERUV - MERRAero SSA difference'
  ssaomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ssaomi_[ix,0]    = mean(ssaomi[a] - ssa[a])
   ssaomi_[ix,1]    = stddev(ssaomi[a]-ssa[a])
  endfor
  loadct, 57
  fillmeanstd, lonnode, ssaomi_[*,0], ssaomi_[*,1], color=200, fillcolor=50, thick=18

; AI
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,5], $
   xtitle='longitude', ytitle='AI', $
   title='AI: MERRAero = red, OMAERUV = blue'
  ai_    = fltarr(nx,2)
  aiomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ai_[ix,0]    = mean(ai[a])
   aiomi_[ix,0] = mean(aiomi[a])
   ai_[ix,1]    = stddev(ai[a])
   aiomi_[ix,1] = stddev(aiomi[a])
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
  endelse

; LER
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='LER', $
   title='LER388: MERRAero = red, OMAERUV = blue'
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

; AERH
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,4], $
   xtitle='longitude', ytitle='Aerosol Height [km]', $
   title='OMAERUV aerosol retrieval height'
  aerh_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   aerh_[ix,0]    = mean(aerh[a])
   aerh_[ix,1]    = stddev(aerh[a])
  endfor
  loadct, 57
  fillmeanstd, lonnode, aerh_[*,0], aerh_[*,1], color=200, fillcolor=50, thick=18

; AERT
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,3.2], ystyle=1, $
   yticks=3, ytickv=[0,1,2,3], ytickn=[' ','1','2','3'], $
   xtitle='longitude', ytitle='Aerosol Type Flag', $
   title='OMAERUV aerosol type flag'
  loadct, 39
  a = where(lon gt min(lonedge) and lon le max(lonedge) and $
            lat gt min(latedge) and lat le max(latedge))
  plots, lon[a], aert[a], psym=sym(1), color=84, symsize=.5
  x = min(xrange)+.02*(max(xrange)-min(xrange))
  n = n_elements(where(aert[a] eq 1))
  xyouts, x, .6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 2))
  xyouts, x, 1.6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 3))
  xyouts, x, 2.6, 'n = '+string(n)

; REF
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Surface Reflectance @ 388', $
   title='OMAERUV Surface Reflectance @ 388 nm'
  refomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   refomi_[ix,0]    = mean(refomi[a])
   refomi_[ix,1]    = stddev(refomi[a])
  endfor
  loadct, 57
  fillmeanstd, lonnode, refomi_[*,0], refomi_[*,1], color=200, fillcolor=50, thick=18

; RAD
  loadct, 0
  plot, findgen(2), /nodata, $
   thick=18, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Radiance @ 388', $
   title='Radiance @ 388 nm: MERRAero = red, OMAERUV = blue'
  rad_    = fltarr(nx,2)
  radomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   rad_[ix,0]    = mean(rad[a])
   radomi_[ix,0] = mean(radomi[a])
   rad_[ix,1]    = stddev(rad[a])
   radomi_[ix,1] = stddev(radomi[a])
  endfor
  if(i eq 0) then begin
   loadct, 62
   fillmeanstd, lonnode, rad_[*,0], rad_[*,1], color=200, fillcolor=50
   oplot, lonnode, rad_[*,0], color=200, thick=18
   loadct, 57
   fillmeanstd, lonnode, radomi_[*,0], radomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, radomi_[*,0], color=200, thick=18
  endif else begin
   loadct, 57
   fillmeanstd, lonnode, radomi_[*,0], radomi_[*,1], color=200, fillcolor=50
   oplot, lonnode, radomi_[*,0], color=200, thick=18
   loadct, 62
   fillmeanstd, lonnode, rad_[*,0], rad_[*,1], color=200, fillcolor=50
   oplot, lonnode, rad_[*,0], color=200, thick=18
  endelse

  if(i eq 0) then aimg = tvrd(/true)
  if(i eq 1) then bimg = tvrd(/true)

  endfor

  write_png, 'plotregions_aggregate.'+datewant+'_'+regname+'.png', 0.5*aimg+0.5*bimg


end
