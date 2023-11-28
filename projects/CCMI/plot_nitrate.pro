; Similar to print_budget_table, from that read of the budget tables
; plot nitrate specific time series

  pro plot_nitrate, expid, yyyy, ny, emis, pno3aq, pno3ht, $
                    loss, lossnh4, lossnh3,  $
                    burden, $
                    draft=draft

  aertype = 'NI'

  print, aertype, expid


  ndaysmon = [31,28,31,30,31,30,31,31,30,31,30,31]
  months = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  ndaysmon_ = intarr(13,ny)
  for iy = 0, ny-1 do begin
   ndaysmon_[0:11,iy] = ndaysmon
   if( fix(yyyy[iy]/4) eq (yyyy[iy]/4.)) then ndaysmon_[1,iy] = 29.
   ndaysmon_[12,iy] = total(ndaysmon_[0:11,iy])
  endfor

; Make a plot, setup for dust now
  set_plot, 'ps'
  device, file='output/plots/print_budget_table.'+expid+'.'+aertype+'.ps', /color, $
   /helvetica, font_size=14, xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0


; Emissions - Interannual
  emisRange = [40,80]
  loadct, 3
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=emisRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual NH3 Emissions'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = emis[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  print, 'Emissions', total(emis[12,*])/ny, format='(a-30,1x,f20.3)'

; Emissions - Climatology
  emisClimRange=[0,10]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=emisClimRange, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of NH3 Emissions', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(emis,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; Aqueous Production of Nitrate
  pno3aqrange=[-4,1]
  loadct, 3
  plot, yyyy, pno3aq[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=pno3aqrange, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual NIaq Chemical Production'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = pno3aq[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, 'Production (AQ)', total(pno3aq[12,*])/ny, format='(a-30,1x,f20.3)'

; Aqueous Production of Nitrate - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=pno3aqrange, ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of NIaq Chemical Production', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(pno3aq,2)/ny
  loadct, 3
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor



; Heterogeneous Production of Nitrate
  pno3htrange=[20,100]
  loadct, 3
  plot, yyyy, pno3ht[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=pno3htrange, ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual NIht Chemical Production'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = pno3ht[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, 'Production (HT)', total(pno3ht[12,*])/ny, format='(a-30,1x,f20.3)'

; Heterogeneous Production of Nitrate - Climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[0,10], ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of NIht Chemical Production', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(pno3ht,2)/ny
  loadct, 3
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; Losses - interannual
  lossRange = [0,100]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lossrange, ystyle=9, ythick=3,ytitle='Losses [Tg/year]', $
   title = 'Interannual Nitrate Losses'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = loss[12,iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+loss[12,iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossRange)-min(lossRange))+min(lossRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75


; Losses - climatology
  lossClimRange = [0,10]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lossClimRange, ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of Nitrate Losses', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(loss,2)/ny
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossClimRange)-min(lossClimRange))+min(lossClimRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75

  print, 'Losses', total(loss[12,*,*])/ny, format='(a-30,1x,f20.3)'
  print, '-Dry', total(loss[12,*,0:1])/ny, format='(a-30,1x,f20.3)'
  print, '-Wet', total(loss[12,*,2:3])/ny, format='(a-30,1x,f20.3)'




; Ammonium Losses - interannual
  lossRange = [0,50]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lossrange, ystyle=9, ythick=3,ytitle='Losses [Tg/year]', $
   title = 'Interannual NH4a Losses'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lossnh4[12,iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+lossnh4[12,iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossRange)-min(lossRange))+min(lossRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75


; Losses - climatology
  lossClimRange = [0,5]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lossClimRange, ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of NH4a Losses', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(lossnh4,2)/ny
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossClimRange)-min(lossClimRange))+min(lossClimRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75




; Ammonia Losses - interannual
  lossRange = [0,50]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lossrange, ystyle=9, ythick=3,ytitle='Losses [Tg/year]', $
   title = 'Interannual NH3g Losses'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lossnh3[12,iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+lossnh3[12,iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossRange)-min(lossRange))+min(lossRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75


; Losses - climatology
  lossClimRange = [0,5]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lossClimRange, ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of NH3g Losses', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(lossnh3,2)/ny
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  xc = x0 + .55*dx
  xd = x0 + .8*dx
  y0 = .95*(max(lossClimRange)-min(lossClimRange))+min(lossClimRange)
  xyouts, xa, y0, 'Sedimentation', color=208, charsize=.75
  xyouts, xb, y0, 'Dry Deposition', color=176, charsize=.75
  xyouts, xc, y0, 'Wet Deposition', color=84, charsize=.75
  xyouts, xd, y0, 'Scavenging', color=48, charsize=.75



; Burdens
  burdenRange=[0,1]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=burdenRange, ystyle=9, ythick=3,ytitle='Annual Average Burden [Tg]', $
   title = 'Interannual Nitrate Burden'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  colors = [208,254]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = burden[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
pm25 = 0
  if(pm25) then begin
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = burden25[12,iy]
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[1], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  endif
  x0 = min(yyyy)-1
  x1 = max(yyyy)+1
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  y0 = .95*(max(burdenRange)-min(burdenRange))+min(burdenRange)
  xyouts, xa, y0, 'Total Nitrate', color=208, charsize=.75
  if(pm25) then xyouts, xb, y0, 'PM2.5', color=254, charsize=.75

  print, 'Burden', total(burden[12,*])/ny, format='(a-30,1x,f20.3)'

; Burden - climatology
  burdenclimrange = [0,2]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=burdenClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Burden [Tg]', $
   title = 'Monthly Climatology of Nitrate Burden', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  ix = 0
  ysave = fltarr(12)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = total(burden[iy,*])/ny
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  if(pm25) then begin
  for iy = 0,11 do begin
   x = iy+.5
   y = total(burden25[iy,*])/ny
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[1], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  endif
  x0 = 0
  x1 = 13
  dx = x1-x0
  xa = x0 + .05*dx
  xb = x0 + .3*dx
  y0 = .95*(max(burdenClimRange)-min(burdenClimRange))+min(burdenClimRange)
  xyouts, xa, y0, 'Total Nitrate', color=208, charsize=.75
  if(pm25) then xyouts, xb, y0, 'PM2.5', color=254, charsize=.75




; Lifetime
  lifetimerange = [0,12]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=lifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Lifetime [days]', $
   title = 'Interannual Nitrate Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden/(total(loss,3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, 'Lifetime [days]', total(lifetime[12,*])/ny, format='(a-30,1x,f20.3)'

; Lifetime - climatology
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=lifetimeRange, ystyle=9, ythick=3,ytitle='Monthly Average Lifetime [Days]', $
   title = 'Monthly Climatology of Nitrate Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


; Wet Lifetime
  wetlifetimerange = [0,20]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=wetLifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Wet Lifetime [days]', $
   title = 'Nitrate Wet Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,2:3],3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, '-Wet Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,2]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -Large Scale Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,3]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -Scavenging Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'

; Wet Lifetime - climatology
  wetlifetimeclimrange = [0,20]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=wetLifetimeClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Wet Lifetime [Days]', $
   title = 'Monthly Climatology of Nitrate Wet Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,2:3],3)/ndaysmon_))
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

; Dry Lifetime
  drylifetimerange = [0,20]
  loadct, 39
  plot, yyyy, emis[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=dryLifetimeRange, ystyle=9, ythick=3,ytitle='Annual Average Dry Lifetime [days]', $
   title = 'Nitrate Dry Lifetime'
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,0:1],3)/ndaysmon_))
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  print, '-Dry Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,0]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -Settling Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'
  lifetime = reform(burden[*,*]/(loss[*,*,1]/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  print, ' -DryDep Removal [1/days]', 1./(total(lifetime[12,*])/ny), format='(a-30,1x,f20.3)'

; Dry Lifetime - climatology
  drylifetimeclimrange = [0,20]
  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=dryLifetimeClimRange, ystyle=9, ythick=3,ytitle='Monthly Average Dry Lifetime [Days]', $
   title = 'Monthly Climatology of Nitrate Dry Lifetime', $
   xticks=13, xtickname=months
  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75
  lifetime = reform(burden[*,*]/(total(loss[*,*,0:1],3)/ndaysmon_))
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  device, /close

end
