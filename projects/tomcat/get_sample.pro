; Given an "orbit" name sample pblh and return statistics
; optional "taod" is to require AOD > 0.2 and
; optional "tcld" is to require CLDTOT < 0.8
; optional "trnd" is to pick 66% of random points

; Outputs are:
; - full      = histogram of pblh in of full series in 200 m increments
; - fullhr    = mean hourly pblh height
; - fullhrn   = number of obs per hour
; - fullhrhst = quartile etc. histograms


  pro get_sample, orbit, fnoff, nts, full, fullhr, fullhrn, fullhrhst, $
                  fullhrs, fullhrmn, fullhrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, $
                  tcld=tcld, taod=taod, trnd=trnd, $
                  daod=daod, $ ; apply aod threshold to first (day) orbit, not union
                  unionorbit = unionorbit

  print, orbit

; taod
  if(keyword_set(taod) or keyword_set(daod)) then begin
   ddf = orbit+'.ddf'
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   filename= filename[fnoff:fnoff+nts-1]
   nc4readvar, filename, 'totexttau', aot, wantlat=wantlat, wantlon=wantlon
  endif
  if(keyword_set(tcld)) then begin
   ddf = orbit+'.cldtot.ddf'
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   filename= filename[fnoff:fnoff+nts-1]
   nc4readvar, filename, 'cldtot', cld, wantlat=wantlat, wantlon=wantlon
  endif
  ddf = orbit+'.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nday = n_elements(filename)/24
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  a = where(pblh gt 1e14)
  pblh[a] = !values.f_nan
  if(keyword_set(taod) or keyword_set(daod)) then begin
   a = where(aot lt 0.2)
   pblh[a] = !values.f_nan
  endif
  if(keyword_set(tcld)) then begin
   a = where(cld gt 0.8)
   pblh[a] = !values.f_nan
  endif
  if(keyword_set(trnd)) then begin
   a = where(finite(pblh) eq 1)
   nfin = n_elements(a)
   nwan = fix(0.66*nfin)
   spawn, 'ps -A | sum | cut -c1-5', seed
   seed = long(seed[0])
   while(nfin gt nwan) do begin
    r = randomu(seed,1)
    irem = fix(r*nfin)
    irem = min([irem,nfin-1])
print, irem, nfin, r
    pblh[a[irem]] = !values.f_nan
    a = where(finite(pblh) eq 1)
    nfin = n_elements(a)
   endwhile
  endif

; --------------------------------------
; If making union dataset get it here
  if(keyword_set(unionorbit)) then begin
; taod
  if(keyword_set(taod)) then begin
   ddf = unionorbit+'.ddf'
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   filename= filename[fnoff:fnoff+nts-1]
   nc4readvar, filename, 'totexttau', aot_, wantlat=wantlat, wantlon=wantlon
  endif
  if(keyword_set(tcld)) then begin
   ddf = unionorbit+'.cldtot.ddf'
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   filename= filename[fnoff:fnoff+nts-1]
   nc4readvar, filename, 'cldtot', cld_, wantlat=wantlat, wantlon=wantlon
  endif
  ddf = unionorbit+'.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nday = n_elements(filename)/24
  nc4readvar, filename, 'pblh', pblh_, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  a = where(pblh_ gt 1e14)
  pblh_[a] = !values.f_nan
  if(keyword_set(taod)) then begin
   a = where(aot_ lt 0.2)
   pblh_[a] = !values.f_nan
  endif
  if(keyword_set(tcld)) then begin
   a = where(cld_ gt 0.8)
   pblh_[a] = !values.f_nan
  endif
  if(keyword_set(trnd)) then begin
   a = where(finite(pblh_) eq 1)
   nfin = n_elements(a)
   nwan = fix(0.66*nfin)
   spawn, 'ps -A | sum | cut -c1-5', seed
   seed = long(seed[0])
   while(nfin gt nwan) do begin
    r = randomu(seed,1)
    irem = fix(r*nfin)
    irem = min([irem,nfin-1])
    pblh_[a[irem]] = !values.f_nan
    a = where(finite(pblh_) eq 1)
    nfin = n_elements(a)
   endwhile
  endif
; Merge with base
  a = where(finite(pblh_) eq 1)
  pblh[a] = pblh_[a]
  endif
; -----------------------------------------

; Local hour shift
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
  lhr = intarr(nx,ny,24)
  for it = 0, 23 do begin
   for ix = 0, nx-1 do begin
    lhr[ix,*,it] = it+ilhrs[ix]
    if(lhr[ix,0,it] lt 0)  then lhr[ix,*,it] = lhr[ix,*,it]+24
    if(lhr[ix,0,it] gt 23) then lhr[ix,*,it] = lhr[ix,*,it]-24
   endfor
  endfor

  full = histogram(pblh,binsize=200,min=0,max=4000)
  fullhr = reform(pblh,nx*ny*24L,nday)
  fullhr_ = fltarr(24)
  fullhr__ = fltarr(24)
  fullhr___ = fltarr(24)
  fullhr____ = fltarr(24)
  fullhrhst = fltarr(24,7)
  fullhrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   fullhr_[it] = mean(fullhr[a,*],/nan)
   fullhr__[it] = stddev(fullhr[a,*],/nan)
   fullhr___[it] = min(fullhr[a,*],/nan)
   fullhr____[it] = max(fullhr[a,*],/nan)
   inp = reform(fullhr[a,*],n_elements(a)*nday*1L)
   b = where(finite(inp) eq 1)
   if(b[0] ne -1) then begin
    inp = inp[b]
    c = sort(inp)
    inp = inp[c]
    n = n_elements(inp)
    fullhrn[it] = n
;    if(n ge 10) then begin    
    if(n ge 5) then begin    
     fullhrhst[it,0:4] = createboxplotdata(inp)
     fullhrhst[it,0] = inp[long(.1*n)]
     fullhrhst[it,4] = inp[long(.9*n)]
     fullhrhst[it,5] = mean(inp)
     fullhrhst[it,6] = stddev(inp)
    endif
   endif
  endfor
  fullhr = fullhr_
  fullhrs = fullhr__
  fullhrmn = fullhr___
  fullhrmx = fullhr____

end
