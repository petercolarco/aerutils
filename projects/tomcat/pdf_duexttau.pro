  wantlat = [7,27]
  wantlon = [-17,37]

  ddf = 'full.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  lhrs = (lon/15)
  ilhrs = lhrs
  a = where(lhrs lt 0)
  ilhrs[a] = fix(lhrs[a]-.5)
  a = where(lhrs ge 0)
  ilhrs[a] = fix(lhrs[a]+.5)
  ilhrs = fix(ilhrs)
  lhr = intarr(nx,24)
  for it = 0, 23 do begin
   for ix = 0, nx-1 do begin
    lhr[ix,it] = it+ilhrs[ix]
    if(lhr[ix,it] lt 0)  then lhr[ix,it] = lhr[ix,it]+24
    if(lhr[ix,it] gt 23) then lhr[ix,it] = lhr[ix,it]-24
   endfor
  endfor
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
;  area = make_array(nx,ny,val=1.)
;  aot = aave(aot,area,/nan)
  full = histogram(alog10(aot),binsize=.2,min=-3.,max=1)
  nfull = n_elements(aot)
  fullhr = reform(aot,nx,ny,24,30)
  fullhr = mean(fullhr,dim=4,/nan)
  fullhr = mean(fullhr,dim=2,/nan)
  fullhr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   fullhr_[it] = mean(fullhr[a],/nan)
  endfor
  fullhr = fullhr_

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
  iss1hr = mean(iss1hr,dim=2,/nan)
  iss1hr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   iss1hr_[it] = mean(iss1hr[a],/nan)
  endfor
  iss1hr = iss1hr_
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
  iss2hr = mean(iss2hr,dim=2,/nan)
  iss2hr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   iss2hr_[it] = mean(iss2hr[a],/nan)
  endfor
  iss2hr = iss2hr_
  aot2 = aot

  aot = fltarr(nx,ny,720,2)
  aot[*,*,*,0] = aot1
  aot[*,*,*,1] = aot2
  aot = reform(aot,nx,ny,24,30,2)
  issc = histogram(alog10(aot),binsize=.2,min=-3.,max=1,/nan)
  aot = mean(aot,dim=4,/nan)
  aot = mean(aot,dim=2,/nan)
  aot = reform(aot,nx*24,2)
  isschr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   isschr_[it] = mean(aot[a,*],/nan)
  endfor
  isschr = isschr_


  set_plot, 'ps'
  device, file='pdf_duexttau.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,2,1]
  bins = 10^(-3.+findgen(21)/5.)
  loadct, 39
  plot, bins, float(full)/max(full), /xlog, thick=6, $
   xtitle='Dust AOD', ytitle='Relative Frequency'
  oplot, bins, float(iss1)/max(iss1), thick=4, color=254
  oplot, bins, float(iss2)/max(iss2), thick=4, color=208
  oplot, bins, float(issc)/max(issc), thick=6, color=84

  plot, fullhr, yrange=[.3,.9], thick=6, $
   xtitle='Local Hour', ytitle='Dust AOD'
  oplot, iss1hr, thick=4, color=254
  oplot, iss2hr, thick=4, color=208
  oplot, isschr, thick=6, color=84

  device, /close

end
