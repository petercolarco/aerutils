  expid0 = 'S2S1850nrst'
  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'CO2x4sensSS'
  expid3 = 'CO2x4sensNI'

  set_plot, 'ps'
  device, file='plot_ocn_ts.ps', /color
  !p.font=0


  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,120], yrange=[290,298], $
   ytitle='Sea Surface Temperature [K]', xtitle='months'


  filetemplate = expid0+'.ocn.last10.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ts'], ts, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  a = where(ts gt 1e14)
  ts[a] = !values.f_nan
  ts = aave(ts[*,*,*,0], area, /nan)
  oplot, indgen(120), ts, thick=6
check, ts
  filetemplate = expid1+'.ocn.last10.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ts'], ts, lon=lon, lat=lat
  a = where(ts gt 1e14)
  ts[a] = !values.f_nan
  ts = aave(ts[*,*,*,0], area, /nan)
  oplot, indgen(120), ts, thick=6, color=254

  filetemplate = expid2+'.ocn.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ts'], ts, lon=lon, lat=lat
  a = where(ts gt 1e14)
  ts[a] = !values.f_nan
  ts = aave(ts[*,*,*,0], area, /nan)
  oplot, indgen(120), ts, thick=6, color=84


  filetemplate = expid3+'.ocn.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ts'], ts, lon=lon, lat=lat
  a = where(ts gt 1e14)
  ts[a] = !values.f_nan
  ts = aave(ts[*,*,*,0], area, /nan)
  oplot, indgen(120), ts, thick=12, color=254, lin=2




  device, /close

end
