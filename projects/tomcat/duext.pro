; Region
  wantlon = [-17,37]
  wantlat = [7,27]
  aotrange= [0,1]

;  wantlon = [-30,-20]
;  wantlat = [15,20]
;  aotrange= [0,1.5]

  ddf = 'full.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlon=wantlon, wantlat=wantlat, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(aot gt 1e5)
  if(a[0] ne -1) then aot[a] = !values.f_nan
  aotsav = aot
; sort hourly and average
  aotf = reform(aot,nx,ny,24,30)
  aotf = mean(aotf,dim=4,/nan)
  aotf = mean(aotf,dim=1,/nan)
  aotf = mean(aotf,dim=1,/nan)


; Get ISS1
  ddf = 'iss1.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlon=wantlon, wantlat=wantlat
  a = where(aot gt 1e5)
  if(a[0] ne -1) then aot[a] = !values.f_nan
; sort hourly and average
  aot1 = reform(aot,nx,ny,24,30)
  aot1 = mean(aot1,dim=4,/nan)
  aot1 = mean(aot1,dim=1,/nan)
  aot1 = mean(aot1,dim=1,/nan)

; Get ISS2
  ddf = 'iss2.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlon=wantlon, wantlat=wantlat
  a = where(aot gt 1e5)
  if(a[0] ne -1) then aot[a] = !values.f_nan
; sort hourly and average
  aot2 = reform(aot,nx,ny,24,30)
  aot2 = mean(aot2,dim=4,/nan)
  aot2 = mean(aot2,dim=1,/nan)
  aot2 = mean(aot2,dim=1,/nan)

; Now plot the values
  xtickn = [' ',string(indgen(24)+1,format='(i2)'),' ']
  plot, indgen(26), /nodata, $
   xrange=[0,25], xtickn=xtickn, xticks=25, xmin=1, $
   yrange=aotrange
  oplot, indgen(24)+1, aotf, thick=4
  oplot, indgen(24)+1, aot1, lin=1
  oplot, indgen(24)+1, aot2, lin=2
  aa = [aot1,aot2]
  bb = reform(aa,24,2)
  oplot, indgen(24)+1, mean(bb,dim=2,/nan), thick=4, lin=3

end
