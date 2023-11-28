  filetemplate = 'c90R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', su_90, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c180R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', su_180, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c360R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', su_360, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time

  filetemplate = 'c90R.carma.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suc_90, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c180R.carma.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suc_180, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c360R.carma.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suc_360, wantlat=[60,90], wantlon=[-90,0], $
   lon=lon, lat=lat, lev=lev, time=time

  nt = n_elements(time)
  sum90  = fltarr(nt)
  sum180 = fltarr(nt)
  sum360 = fltarr(nt)
  sucm90  = fltarr(nt)
  sucm180 = fltarr(nt)
  sucm360 = fltarr(nt)
  for i = 0, nt-1 do begin
   sum90[i]  = max(su_90[*,*,i])
   sum180[i] = max(su_180[*,*,i])
   sum360[i] = max(su_360[*,*,i])
   sucm90[i]  = max(suc_90[*,*,i])
   sucm180[i] = max(suc_180[*,*,i])
   sucm360[i] = max(suc_360[*,*,i])
  endfor


  set_plot, 'ps'
  device, file='su_time.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  loadct, 39

  dd = string(22+indgen(nt),format='(i2)')
  plot, indgen(nt), /nodata, $
   xrange=[-1,nt], yrange=[0,1.4], $
   ytitle='Sulfate AOD', $
   xticks=nt+1, xtickn=[' ',dd,' '], xminor=1, $
   xstyle=9, ystyle=9, thick=3

  loadct, 39
  oplot, indgen(nt), sum90, thick=12, color=90
  oplot, indgen(nt), sum180, thick=12, color=32
  oplot, indgen(nt), sum360, thick=12, color=224
  oplot, indgen(nt), sucm90, thick=12, color=90, lin=2
  oplot, indgen(nt), sucm180, thick=12, color=32, lin=2
  oplot, indgen(nt), sucm360, thick=12, color=224, lin=2

  device, /close

end

