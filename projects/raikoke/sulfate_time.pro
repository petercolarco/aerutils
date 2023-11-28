  filetemplate = 'v3.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', so2v3_, lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'v4.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', so2v4_, lon=lon, lat=lat, lev=lev, time=time

  
  filetemplate = 'v5.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', so2v5_, lon=lon, lat=lat, lev=lev, time=time

  
  filetemplate = 'v7.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', so2v7_, lon=lon, lat=lat, lev=lev, time=time
  
; Find the global mean value
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  so2v3 = aave(so2v3_,area)*total(area)*1000./1e12
  so2v4 = aave(so2v4_,area)*total(area)*1000./1e12
  so2v5 = aave(so2v5_,area)*total(area)*1000./1e12
  so2v7 = aave(so2v7_,area)*total(area)*1000./1e12

  set_plot, 'ps'
  device, file='sulfate_time.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  loadct, 39

  nt = n_elements(nymd)
  dd = strmid(nymd,6,2)
  plot, indgen(nt), /nodata, $
   xrange=[-1,nt], yrange=[0,2], $
   ytitle='Sulfate [Tg]', $
   xticks=nt+1, xtickn=[' ',dd,' '], xminor=1, $
   xstyle=9, ystyle=9, thick=3
  oplot, indgen(nt), (so2v3-min(so2v3)), thick=6, lin=2 ; Tg
  oplot, indgen(nt), (so2v4-min(so2v3)), thick=6, lin=2, color=76 ; Tg
  oplot, indgen(nt), (so2v5-min(so2v3)), thick=6, lin=2, color=176 ; Tg
  oplot, indgen(nt), (so2v7-min(so2v3)), thick=6, lin=2, color=254 ; Tg

  device, /close

end

