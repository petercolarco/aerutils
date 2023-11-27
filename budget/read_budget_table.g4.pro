; Note: Scaled to 1979 - 2002 CARMA dust run annual average emissions!!!

  aertype = 'DU'
  expid = 'g4dust_b55r8'
  yyyy = strcompress(string(1979 + indgen(24)),/rem)
  ny = n_elements(yyyy)

  case aertype of
   'BC':   begin
           vars = ['emis','dep','wet','scav','load']
           end
   'OC':   begin
           levelarray = [.01,.02,.05,.1,.2,.5,1]
           formcode = '(f5.2)'
           vars = ['emis','dep','wet','scav','load']
           end
   'DU':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau']
           end
   'SS':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25']
           end
   'SU':   begin
           vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms','emisvolcn', 'emisvolce']
           end
   'CO':   begin
           vars = ['emis','prod','loss','load']
           end
   'CO2':  begin
           vars = ['emis','load']
           end
  endcase


  nvars = n_elements(vars)

; setup the arrays to read
; 12 months + 1 annual average/total = 13
  input = fltarr(13,ny,nvars)

  for iy = 0, ny-1 do begin
   openr, lun, 'output/tables/budget.'+expid+'.'+aertype+'.'+yyyy[iy]+'.txt', /get
   str = 'a'
   data = fltarr(2,13)
   for ivar = 0, nvars-1 do begin
    readf, lun, data
    readf, lun, str
    input[*,iy,ivar] = data[1,*]
   endfor
   free_lun, lun
  endfor

; Scale to carmaDust Simulation dust budget
  carmaEmis = 1678.
  g4Emis = total(input[12,*,0])/ny
  rat = carmaEmis/g4Emis
  print, rat
  input = input*rat


; Make a plot, setup for dust now
  set_plot, 'ps'
  device, file='output/plots/'+expid+'.budget_table.ps', /color, $
   /helvetica, font_size=14, xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0

; Emissions
  loadct, 3
  plot, yyyy, input[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=[1500.,1800.], ystyle=9, ythick=3,ytitle='Emissions [Tg/year]', $
   title = 'Interannual Dust Emissions'
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = input[12,iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[50,200], ystyle=9, ythick=3,ytitle='Emissions [Tg/month]', $
   title = 'Monthly Climatology of Dust Emissions'
  aveinput = total(input,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=160, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor



; Losses
  loadct, 39
  plot, yyyy, input[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=[800.,1800.], ystyle=9, ythick=3,ytitle='Losses [Tg/year]', $
   title = 'Interannual Dust Losses'
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = input[12,iy,ix+1]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0, ny-1 do begin
    x = float(yyyy[iy])-.5
    y = ysave[iy]+input[12,iy,ix+1]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  xyouts, 1979, 1750, 'Sedimentation', color=208, charsize=.75
  xyouts, 1985, 1750, 'Dry Deposition', color=176, charsize=.75
  xyouts, 1991, 1750, 'Wet Deposition', color=84, charsize=.75
  xyouts, 1997, 1750, 'Scavenging', color=48, charsize=.75

  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[75,175], ystyle=9, ythick=3,ytitle='Losses [Tg/month]', $
   title = 'Monthly Climatology of Dust Losses'
  aveinput = total(input,2)/ny
  colors = [208,176,84,48]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix+1]
   ysave[iy] = y
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  for ix = 1, 3 do begin
   for iy = 0,11 do begin
    x = iy+.5
    y = ysave[iy]+aveinput[iy,ix+1]
    polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
    plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
    ysave[iy] = y
   endfor
  endfor
  xyouts, 1, 170, 'Sedimentation', color=208, charsize=.75
  xyouts, 4, 170, 'Dry Deposition', color=176, charsize=.75
  xyouts, 7, 170, 'Wet Deposition', color=84, charsize=.75
  xyouts, 10, 170, 'Scavenging', color=48, charsize=.75


; Burdens
  loadct, 39
  plot, yyyy, input[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=[25,45], ystyle=9, ythick=3,ytitle='Annual Average Burden [Tg]', $
   title = 'Interannual Dust Burden'
  colors = [208,254]
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = input[12,iy,ix+5]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  ix = 1
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = input[12,iy,ix+5]
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  xyouts, 1979, 44, 'Total Dust', color=254, charsize=.75

  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[0,50], ystyle=9, ythick=3,ytitle='Monthly Average Burden [Tg]', $
   title = 'Monthly Climatology of Dust Burden'
  aveinput = total(input,2)/ny
  ix = 0
  ysave = fltarr(ny)
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,ix+5]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor
  ix = 1
  for iy = 0,11 do begin
   x = iy+.5
   y = aveinput[iy,ix+5]
   polyfill, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=colors[ix], noclip=0
   plots, [x,x+1,x+1,x,x],[ysave[iy],ysave[iy],y,y,ysave[iy]], color=0, thick=2, noclip=0
  endfor
  xyouts, 1, 47, 'Total Dust', color=254, charsize=.75




; Lifetime
  loadct, 39
  plot, yyyy, input[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=[7,9], ystyle=9, ythick=3,ytitle='Annual Average Lifetime [days]', $
   title = 'Interannual Dust Lifetime'
  lifetime = reform(input[*,*,5]/(total(input[*,*,1:4],3)/30))
  lifetime[12,*] = lifetime[12,*]*365/30.
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = lifetime[12,iy]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor

  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[0,12], ystyle=9, ythick=3,ytitle='Monthly Average Lifetime [Days]', $
   title = 'Monthly Climatology of Dust Lifetime'
  aveinput = total(lifetime,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,0]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor



; AOT
  loadct, 39
  plot, yyyy, input[12,*,0], /nodata, $
   xrange=[min(yyyy)-1,max(yyyy)+1], xstyle=9, xthick=3, xtitle='year', $
   yrange=[0.03,0.05], ystyle=9, ythick=3,ytitle='Annual Average AOT [550 nm]', $
   title = 'Interannual Dust AOT'
  for iy = 0, ny-1 do begin
   x = float(yyyy[iy])-.5
   y = total(input[0:11,iy,7])/12.
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor


  plot, indgen(14), indgen(14), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xtitle='month', $
   yrange=[0,0.08], ystyle=9, ythick=3,ytitle='AOT [550 nm]', $
   title = 'Monthly Climatology of Dust AOT'
  aveinput = total(input,2)/ny
  for iy = 0, 11 do begin
   x = float(iy)+.5
   y = aveinput[iy,7]
   polyfill, [x,x+1,x+1,x,x],[0,0,y,y,0], color=208, noclip=0
   plots, [x,x+1,x+1,x,x],[0,0,y,y,0], color=0, thick=2, noclip=0
  endfor



  device, /close

end
