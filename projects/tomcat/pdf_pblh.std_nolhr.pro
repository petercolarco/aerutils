  wantlat = [7,27]
  wantlon = [-17,37]

  ddf = 'full.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[0:719]
  nday = n_elements(filename)/24
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  full = histogram(aot,binsize=200,min=0,max=4000)
  nfull = n_elements(aot)
  fullhr = reform(aot,nx,ny,24L,nday)
  fullhr_ = fltarr(24)
  fullhr__ = fltarr(24)
  for it = 0, 23 do begin
   fullhr_[it] = mean(fullhr[*,*,it,*],/nan)
   fullhr__[it] = stddev(fullhr[*,*,it,*],/nan)
  endfor
  fullhr = fullhr_
  fullhrs = fullhr__

; Get ISS1
  ddf = 'iss1.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[0:719]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss1 = histogram(aot,binsize=200,min=0,max=4000,/nan)
  niss1 = n_elements(aot[where(finite(aot) eq 1)])
  iss1hr = reform(aot,nx,ny,24L,nday)
  iss1hr_ = fltarr(24)
  iss1hr__ = fltarr(24)
  for it = 0, 23 do begin
   iss1hr_[it] = mean(iss1hr[*,*,it,*],/nan)
   iss1hr__[it] = stddev(iss1hr[*,*,it,*],/nan)
  endfor
  iss1hr = iss1hr_
  iss1hrs = iss1hr__
  aot1 = aot

; Get ISS2
  ddf = 'iss2.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[0:719]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss2 = histogram(aot,binsize=200,min=0,max=4000,/nan)
  niss2 = n_elements(aot[where(finite(aot) eq 1)])
  iss2hr = reform(aot,nx,ny,24L,nday)
  iss2hr_ = fltarr(24)
  iss2hr__ = fltarr(24)
  for it = 0, 23 do begin
   iss2hr_[it] = mean(iss2hr[*,*,it,*],/nan)
   iss2hr__[it] = stddev(iss2hr[*,*,it,*],/nan)
  endfor
  iss2hr = iss2hr_
  iss2hrs = iss2hr__
  aot2 = aot

  aot = fltarr(nx,ny,24,nday,2)
  aot[*,*,*,*,0] = aot1
  aot[*,*,*,*,1] = aot2
  aot = reform(aot,nx,ny,24L,nday,2)
  issc = histogram(aot,binsize=200,min=0,max=4000,/nan)
  isschr_ = fltarr(24)
  isschr__ = fltarr(24)
  for it = 0, 23 do begin
   isschr_[it] = mean(aot[*,*,it,*,*],/nan)
   isschr__[it] = stddev(aot[*,*,it,*,*],/nan)
  endfor
  isschr = isschr_
  isschrs = isschr__


  set_plot, 'ps'
  device, file='pdf_pblh.std_nolhr.ps', /color, /helvetica, font_size=24, $
   xoff=.5, yoff=.5, xsize=36, ysize=12
  !p.font=0
  !p.multi=[0,3,1]
  bins = findgen(21)*200
  loadct, 39
  plot, bins, float(full)/max(full), thick=6, $
   xtitle='PBL Height [m]', ytitle='Relative Frequency'
  oplot, bins, float(iss1)/max(iss1), thick=4, color=254
  oplot, bins, float(iss2)/max(iss2), thick=4, color=208
  oplot, bins, float(issc)/max(issc), thick=6, color=84

  plot, fullhr, yrange=[0,3000], thick=6, $
   xtitle='UTC Hour', ytitle='PBL Height [m]'
  plots, indgen(24), iss1hr, thick=4, color=254
  plots, indgen(24), iss2hr, thick=4, color=208
  plots, indgen(24), isschr, thick=6, color=84, lin=2

  plot, fullhr, yrange=[-400,400], thick=6, /nodata, $
   xtitle='UTC Hour', ytitle='stddev PBL Height [m] (difference from full)'
  plots, [0,25], [0,0], lin=2
  plots, indgen(24), iss1hrs-fullhrs, thick=4, color=254
  plots, indgen(24), iss2hrs-fullhrs, thick=4, color=208
  plots, indgen(24), isschrs-fullhrs, thick=6, color=84

  device, /close

end
