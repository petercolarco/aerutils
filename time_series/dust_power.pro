; Colarco, November 2007
; Read in the monthly mean 10-m wind speeds from the model and average over
; dust source regions.
goto, jump
; Get the highres results
  ga_getvar, 't003_c32.chem_diag.sfc.ctl', 'u10m', u10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  ga_getvar, 't003_c32.chem_diag.sfc.ctl', 'v10m', v10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  w10m = sqrt(u10m^2. + v10m^2.)
; Get the dust source
  ga_getvar, '../data/c/gocart.dust_source.v2a.x288_y181.hdf', 'du_src', dusrc, $
    lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
; and make the spatial average
  nt = n_elements(time)
  dut3 = fltarr(nt)
  for it = 0, nt-1 do begin
   dut3[it] = aave(w10m[*,*,it]^3.*dusrc,area)
  endfor



; Get the t006 results
  ga_getvar, 't006_b32.chem_diag.sfc.ctl', 'u10m', u10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  ga_getvar, 't006_b32.chem_diag.sfc.ctl', 'v10m', v10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  w10m = sqrt(u10m^2. + v10m^2.)
; Get the dust source
  ga_getvar, '../data/b/gocart.dust_source.v2a.x144_y91.hdf', 'du_src', dusrc, $
    lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
; and make the spatial average
  nt = n_elements(time)
  dut6 = fltarr(nt)
  for it = 0, nt-1 do begin
   dut6[it] = aave(w10m[*,*,it]^3.*dusrc,area)
  endfor



; Get the t005 results
  ga_getvar, 't005_b32.chem_diag.sfc.ctl', 'u10m', u10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  ga_getvar, 't005_b32.chem_diag.sfc.ctl', 'v10m', v10m, $
    lon=lon, lat=lat, time=time, wanttime=['200001','200612']
  w10m = sqrt(u10m^2. + v10m^2.)
; Get the dust source
  ga_getvar, '../data/b/gocart.dust_source.v2a.x144_y91.hdf', 'du_src', dusrc, $
    lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
; and make the spatial average
  nt = n_elements(time)
  dut5 = fltarr(nt)
  for it = 0, nt-1 do begin
   dut5[it] = aave(w10m[*,*,it]^3.*dusrc,area)
  endfor
jump:
; Plot
  set_plot, 'ps'
  device, file='dust_power.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  ntick = 7
  nminor = 4
  tickname=replicate(' ', ntick+1)
  tickname_=replicate(' ', ntick+1)
  for it = 0, ntick-1 do begin
   tickname_[it] = strcompress(string(2000+it),/rem)
  endfor

  loadct, 0
  plot, indgen(nt+1), /nodata, $
   xthick=3, xstyle=9, ythick=3, yrange=[0,0.2], ystyle=8, xrange=[0,nt], $
   xticks=ntick, xminor=nminor, xtickname=tickname, $
   xtitle='Year', ytitle='"Dust Power" [m!E3!N s!E-3!N]'
  for itick = 0, ntick-1 do begin
   xyouts, itick*12, -0.075*0.2, tickname_[itick], align=0
  endfor

  oplot, indgen(nt), dut3, thick=6
  oplot, indgen(nt), dut5, thick=6, lin=2
  oplot, indgen(nt), dut6, thick=6, color=160

  device, /close

end


