; Plot the component AOT over the Arctic for 4 years of MERRA-2

  ytitle='POM Deposition [Tg mon-1]'
  filen = 'plot_ocdep.ps'
  var = ['ocdp001','ocdp002', $
         'ocsd001','ocsd002', $
         'ocwt001','ocwt002', $
         'ocsv001','ocsv002']

  yrange=[0,4]

; Series 1
  filename = 'merra2.d5124_m2_jan79.tavg1_2d_aer_Nx.ddf'
  nc4readvar, filename, var, tau, lon=lon, lat=lat, /sum, $
              wantnymd=['19810115','19811215']
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau1981 = fltarr(12)
  a = where(lat gt 60)
  for it = 0, 11 do begin
   tau1981[it] = total(tau[*,a,it]*area[*,a])*86400*30/1e9
  endfor

; Series 2
  filename = 'merra2.d5124_m2_jan91.tavg1_2d_aer_Nx.ddf'
  nc4readvar, filename, var, tau, lon=lon, lat=lat, /sum, $
              wantnymd=['19940115','19941215']
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau1994 = fltarr(12)
  a = where(lat gt 60)
  for it = 0, 11 do begin
   tau1994[it] = total(tau[*,a,it]*area[*,a])*86400*30/1e9
  endfor

; Series 3
  filename = 'merra2.d5124_m2_jan00.tavg1_2d_aer_Nx.ddf'
  nc4readvar, filename, var, tau, lon=lon, lat=lat, /sum, $
              wantnymd=['20020115','20021215']
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau2002 = fltarr(12)
  a = where(lat gt 60)
  for it = 0, 11 do begin
   tau2002[it] = total(tau[*,a,it]*area[*,a])*86400*30/1e9
  endfor

; Series 4
  filename = 'merra2.d5124_m2_jan10.tavg1_2d_aer_Nx.ddf'
  nc4readvar, filename, var, tau, lon=lon, lat=lat, /sum, $
              wantnymd=['20110115','20111215']
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau2011 = fltarr(12)
  a = where(lat gt 60)
  for it = 0, 11 do begin
   tau2011[it] = total(tau[*,a,it]*area[*,a])*86400*30/1e9
  endfor


; Plot AOT
  set_plot, 'ps'
  device, file=filen, /helvetica, font_size=14, /color, $
   xsize=16, ysize=10, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39
  x = indgen(12)+1
  plot, x, tau1981, /nodata, $
   thick=6, xstyle=9, ystyle=9, $
   xrange=[0,13], xticks=13, xtitle = 'Month', $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=yrange, ytitle=ytitle, $
   title='MERRA2 (average north of 60N)'
  oplot, x, tau1981, thick=6, color=254
  oplot, x, tau1994, thick=6, color=176
  oplot, x, tau2002, thick=6, color=208
  oplot, x, tau2011, thick=6, color=74
  ymax = max(yrange)
  plots, [1,2], .95*ymax, thick=6, color=254
  plots, [1,2], .9*ymax, thick=6, color=176
  plots, [1,2], .85*ymax, thick=6, color=208
  plots, [1,2], .8*ymax, thick=6, color=74
  xyouts, 2.4, .93*ymax, '1981', charsize=.75
  xyouts, 2.4, .88*ymax, '1994', charsize=.75
  xyouts, 2.4, .83*ymax, '2002', charsize=.75
  xyouts, 2.4, .78*ymax, '2011', charsize=.75
  device, /close

end
