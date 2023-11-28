  filetemplate = 'c90R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2_90, wantlat=[60,90], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c180R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2_180, wantlat=[60,90], $
   lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'c360R.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2_360, wantlat=[60,90], $
   lon=lon, lat=lat, lev=lev, time=time

  nt = n_elements(time)
  so2m90  = fltarr(nt)
  so2m180 = fltarr(nt)
  so2m360 = fltarr(nt)
  for i = 0, nt-1 do begin
   so2m90[i]  = max(so2_90[*,*,i])
   so2m180[i] = max(so2_180[*,*,i])
   so2m360[i] = max(so2_360[*,*,i])
  endfor

  so2m90  = so2m90/0.064*6.022e23/2.687e20
  so2m180 = so2m180/0.064*6.022e23/2.687e20
  so2m360 = so2m360/0.064*6.022e23/2.687e20

  set_plot, 'ps'
  device, file='so2_time.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  loadct, 39

  dd = string(22+indgen(nt),format='(i2)')
  plot, indgen(nt), /nodata, $
   xrange=[-1,nt], yrange=[0,250], $
   ytitle='SO!D2!N [DU]', $
   xticks=nt+1, xtickn=[' ',dd,' '], xminor=1, $
   xstyle=9, ystyle=9, thick=3

  loadct, 39
  oplot, indgen(nt), so2m90, thick=12, color=90
  oplot, indgen(nt), so2m180, thick=12, color=32
  oplot, indgen(nt), so2m360, thick=12, color=224

; OMI peak SO2
  omi = [241,162,119,55,37,36,37,135,57,68]
  plots, indgen(nt),omi, psym=sym(4), symsize=2

  device, /close

end

