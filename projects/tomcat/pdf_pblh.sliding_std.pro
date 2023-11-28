; Hourly output fields sampled across a sliding two-week window in
; June 2006 for full, iss1 & 2, and dual sampling

  wantlat = [7,27]
  wantlon = [-17,37]

  nt = 14*24
  ns = 16

  fullhra = fltarr(24,ns)
  iss1hra = fltarr(24,ns)
  iss2hra = fltarr(24,ns)
  isschra = fltarr(24,ns)

  full  = fltarr(21,ns)
  iss1  = fltarr(21,ns)
  iss2  = fltarr(21,ns)
  issc  = fltarr(21,ns)

  for ii = 0, ns-1 do begin
print, ii

  ddf = 'full.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[ii*24:ii*24+nt-1]
  nday = nt/24
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  lhrs = (lon/15)   ; every 15 degrees is 1 hour, what is offset?
  ilhrs = lhrs
  a = where(lhrs lt 0)
  ilhrs[a] = fix(lhrs[a]-.5)  ; bunch it as integer hours to offset
  a = where(lhrs ge 0)
  ilhrs[a] = fix(lhrs[a]+.5)
  ilhrs = fix(ilhrs)
; now make a lon x UTC hour array of offsets
  lhr = intarr(nx,24)
  for it = 0, 23 do begin
   for ix = 0, nx-1 do begin
    lhr[ix,it] = it+ilhrs[ix]; + (ii-(ii/24)*24)
    if(lhr[ix,it] lt 0)  then lhr[ix,it] = lhr[ix,it]+24
    if(lhr[ix,it] gt 23) then lhr[ix,it] = lhr[ix,it]-24
   endfor
  endfor
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
;  area = make_array(nx,ny,val=1.)
;  aot = aave(aot,area,/nan)
  full[*,ii] = histogram(aot,binsize=200,min=0,max=4000)
  nfull = n_elements(aot)
stop
  fullhr = reform(aot,nx,ny,24,nday)
  fullhr = mean(fullhr,dim=4,/nan)
  fullhr = mean(fullhr,dim=2,/nan)
  fullhr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   fullhr_[it] = mean(fullhr[a],/nan)
  endfor
  fullhra[*,ii] = fullhr_

; Get ISS1
  ddf = 'iss1.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  filename = filename[0:nt-1]
  filename = filename[ii*24:ii*24+nt-1]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss1[*,ii] = histogram(aot,binsize=200,min=0,max=4000,/nan)
  niss1 = n_elements(aot[where(finite(aot) eq 1)])
  iss1hr = reform(aot,nx,ny,24,nday)
  iss1hr = mean(iss1hr,dim=4,/nan)
  iss1hr = mean(iss1hr,dim=2,/nan)
  iss1hr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   iss1hr_[it] = mean(iss1hr[a],/nan)
  endfor
  iss1hra[*,ii] = iss1hr_
  aot1 = aot

; Get ISS2
  ddf = 'iss2.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  filename = filename[0:nt-1]
  filename = filename[ii*24:ii*24+nt-1]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss2[*,ii] = histogram(aot,binsize=200,min=0,max=4000,/nan)
  niss2 = n_elements(aot[where(finite(aot) eq 1)])
  iss2hr = reform(aot,nx,ny,24,nday)
  iss2hr = mean(iss2hr,dim=4,/nan)
  iss2hr = mean(iss2hr,dim=2,/nan)
  iss2hr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   iss2hr_[it] = mean(iss2hr[a],/nan)
  endfor
  iss2hra[*,ii] = iss2hr_
  aot2 = aot

  aot = fltarr(nx,ny,24,nday,2)
  aot[*,*,*,*,0] = aot1
  aot[*,*,*,*,1] = aot2
  issc[*,ii] = histogram(aot,binsize=200,min=0,max=4000,/nan)
  aot = mean(aot,dim=5,/nan)
  aot = mean(aot,dim=4,/nan)
  aot = mean(aot,dim=2,/nan)
  isschr_ = fltarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   isschr_[it] = mean(aot[a],/nan)
  endfor
  isschra[*,ii] = isschr_

  endfor

  for ii = 0, ns-1 do begin
   full[*,ii] = full[*,ii]/max(full[*,ii])
   iss1[*,ii] = iss1[*,ii]/max(iss1[*,ii])
   iss2[*,ii] = iss2[*,ii]/max(iss2[*,ii])
   issc[*,ii] = issc[*,ii]/max(issc[*,ii])
  endfor

  set_plot, 'ps'
  device, file='pdf_pblh.sliding.01.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,2,1]
  bins = findgen(21)*200
  loadct, 0
  plot, bins, bins, thick=6, /nodata, yrange=[0,1], $
   xtitle='PBL Height [m]', ytitle='Relative Frequency'
  loadct, 0
  polymaxmin, bins, full, fillcolor=240
  oplot, bins, mean(full,dim=2,/nan), thick=4
  loadct, 62
  oplot, bins, mean(iss1,dim=2,/nan), thick=4, color=240
  loadct, 65
  oplot, bins, mean(iss2,dim=2,/nan), thick=4, color=120
  loadct, 49
  oplot, bins, mean(issc,dim=2,/nan), thick=4, color=240

  loadct, 0  
  plot, indgen(24), yrange=[0,3000], thick=6, /nodata, $
   xtitle='Local Hour', ytitle='PBL Height [m]'
  loadct, 0
  polymaxmin, indgen(24), fullhra, fillcolor=240
  oplot, indgen(24), mean(fullhra,dim=2,/nan), thick=4
  loadct, 62
  oplot, indgen(24), mean(iss1hra,dim=2,/nan), thick=4, color=240
  loadct, 65
  oplot, indgen(24), mean(iss2hra,dim=2,/nan), thick=4, color=120
  loadct, 49
  oplot, indgen(24), mean(isschra,dim=2,/nan), thick=4, color=240

  device, /close

  set_plot, 'ps'
  device, file='pdf_pblh.sliding.02.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,2,1]
  bins = findgen(21)*200
  loadct, 39
  plot, bins, bins, thick=6, /nodata, yrange=[0,1], $
   xtitle='PBL Height [m]', ytitle='Relative Frequency'
  loadct, 62
  polymaxmin, bins, iss1, fillcolor=240
  oplot, bins, mean(iss1,dim=2,/nan), thick=4, color=240

  loadct, 0  
  plot, indgen(24), yrange=[0,3000], thick=6, /nodata, $
   xtitle='Local Hour', ytitle='PBL Height [m]'
  loadct, 62
  polymaxmin, indgen(24), iss1hra, fillcolor=240
  oplot, indgen(24), mean(iss1hra,dim=2,/nan), thick=4, color=240

  device, /close

  set_plot, 'ps'
  device, file='pdf_pblh.sliding.03.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,2,1]
  bins = findgen(21)*200
  loadct, 39
  plot, bins, bins, thick=6, /nodata, yrange=[0,1], $
   xtitle='PBL Height [m]', ytitle='Relative Frequency'
  loadct, 65
  polymaxmin, bins, iss2, fillcolor=120
  oplot, bins, mean(iss2,dim=2,/nan), thick=4, color=120

  loadct, 0  
  plot, indgen(24), yrange=[0,3000], thick=6, /nodata, $
   xtitle='Local Hour', ytitle='PBL Height [m]'
  loadct, 65
  polymaxmin, indgen(24), iss2hra, fillcolor=120
  oplot, indgen(24), mean(iss2hra,dim=2,/nan), thick=4, color=120

  device, /close

  set_plot, 'ps'
  device, file='pdf_pblh.sliding.04.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,2,1]
  bins = findgen(21)*200
  loadct, 39
  plot, bins, bins, thick=6, /nodata, yrange=[0,1], $
   xtitle='PBL Height [m]', ytitle='Relative Frequency'
  loadct, 49
  polymaxmin, bins, issc, fillcolor=240
  oplot, bins, mean(issc,dim=2,/nan), thick=4, color=240

  loadct, 0  
  plot, indgen(24), yrange=[0,3000], thick=6, /nodata, $
   xtitle='Local Hour', ytitle='PBL Height [m]'
  loadct, 49
  polymaxmin, indgen(24), isschra, fillcolor=240
  oplot, indgen(24), mean(isschra,dim=2,/nan), thick=4, color=240

  device, /close
end
