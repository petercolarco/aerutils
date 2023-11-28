  expid0 = 'S2S1850nrst'
  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'CO2x4sensSS'
  expid3 = 'CO2x4sensNI'

  set_plot, 'ps'
  device, file='plot_swtnet.ps', /color
  !p.font=0


  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,120], yrange=[-5,0], $
   ytitle='SW Aerosol Forcing [W m!E-2!N]', xtitle='months'


  filetemplate = expid0+'.rad.last10.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnet','swtnetna'], swtnet_, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  swtnet = aave(swtnet_[*,*,*,0]-swtnet_[*,*,*,1], area)
  oplot, indgen(120), swtnet, thick=6

  filetemplate = expid1+'.rad.last10.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnet','swtnetna'], swtnet_, lon=lon, lat=lat
  swtnet = aave(swtnet_[*,*,*,0]-swtnet_[*,*,*,1], area)
  oplot, indgen(120), swtnet, thick=6, color=254

  filetemplate = expid2+'.rad.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnet','swtnetna'], swtnet_, lon=lon, lat=lat
  swtnet = aave(swtnet_[*,*,*,0]-swtnet_[*,*,*,1], area)
  oplot, indgen(120), swtnet, thick=6, color=84


  filetemplate = expid3+'.rad.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnet','swtnetna'], swtnet_, lon=lon, lat=lat
  swtnet = aave(swtnet_[*,*,*,0]-swtnet_[*,*,*,1], area)
  oplot, indgen(120), swtnet, thick=12, color=254, lin=2




  device, /close

end
