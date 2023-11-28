  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  ga_getvar, 'MYD04_L2_051.mm.qafl.ocn.b.ctl', 'num', num, $
   wanttime=[1,84], lon=lon, lat=lat
  num = reform(num)
  a = where(num ge 1e15)
  if(a[0] ne -1) then num[a] = !values.f_nan
  qafl = fltarr(84)
  for i = 0, 83 do begin
   qafl[i] = aave(num[*,*,i],area,/nan)
  endfor

  ga_getvar, 'MYD04_L2_051.mm.noqafl.ocn.b.ctl', 'num', num, $
   wanttime=[1,84], lon=lon, lat=lat
  num = reform(num)
  a = where(num ge 1e15)
  if(a[0] ne -1) then num[a] = !values.f_nan
  noqafl = fltarr(84)
  for i = 0, 83 do begin
   noqafl[i] = aave(num[*,*,i],area,/nan)
  endfor

  ga_getvar, 'MYD04_L2_051.mm.qafl3.ocn.b.ctl', 'num', num, $
   wanttime=[1,84], lon=lon, lat=lat
  num = reform(num)
  a = where(num ge 1e15)
  if(a[0] ne -1) then num[a] = !values.f_nan
  qafl3 = fltarr(84)
  for i = 0, 83 do begin
   qafl3[i] = aave(num[*,*,i],area,/nan)
  endfor

  set_plot, 'ps'
  device, file='num.ps', font_size=14, /helvetica, /color
  !p.font=0
  loadct, 39

  plot, indgen(100), /nodata, $
    xrange=[0,84], yrange=[0,150], xstyle=9, ystyle=9, $
    xtitle='month', ytitle='num'
  oplot, indgen(84), qafl, thick=6, color=78
  oplot, indgen(84), noqafl, thick=6, color=208, lin=2
  oplot, indgen(84), qafl3, thick=6, color=254
  device, /close

end
