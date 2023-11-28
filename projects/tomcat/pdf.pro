  wantlat = [7,27]
  wantlon = [-17,37]

  ddf = 'full.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  area = make_array(nx,ny,val=1.)
  aot = aave(aot,area,/nan)
stop
  full = histogram(alog10(aot),binsize=.2,min=-3.,max=1)
  nfull = n_elements(aot)
  fullhr = reform(aot,nx,ny,24,30)
  fullhr = mean(fullhr,dim=4,/nan)
  fullhr = mean(fullhr,dim=1,/nan)
  fullhr = mean(fullhr,dim=1,/nan)
 

; Get ISS1
  ddf = 'iss1.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss1 = histogram(alog10(aot),binsize=.2,min=-3.,max=1,/nan)
  niss1 = n_elements(aot[where(finite(aot) eq 1)])
  iss1hr = reform(aot,nx,ny,24,30)
  iss1hr = mean(iss1hr,dim=4,/nan)
  iss1hr = mean(iss1hr,dim=1,/nan)
  iss1hr = mean(iss1hr,dim=1,/nan)
  aot1 = aot

; Get ISS2
  ddf = 'iss2.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss2 = histogram(alog10(aot),binsize=.2,min=-3.,max=1,/nan)
  niss2 = n_elements(aot[where(finite(aot) eq 1)])
  iss2hr = reform(aot,nx,ny,24,30)
  iss2hr = mean(iss2hr,dim=4,/nan)
  iss2hr = mean(iss2hr,dim=1,/nan)
  iss2hr = mean(iss2hr,dim=1,/nan)
  aot2 = aot

  aot = [aot1,aot2]
  isschr = reform(aot,2*nx,ny,24,30)
  isschr = mean(isschr,dim=4,/nan)
  isschr = mean(isschr,dim=1,/nan)
  isschr = mean(isschr,dim=1,/nan)


  !p.multi=[0,2,1]
  bins = 10^(-3.+findgen(21)/5.)
  plot, bins, float(full)/max(full), /xlog
  oplot, bins, float(iss1)/max(iss1), lin=1
  oplot, bins, float(iss2)/max(iss2), lin=2

  plot, fullhr, yrange=[.3,.9]
  oplot, iss1hr, lin=1
  oplot, iss2hr, lin=2
  oplot, isschr, thick=3

end
