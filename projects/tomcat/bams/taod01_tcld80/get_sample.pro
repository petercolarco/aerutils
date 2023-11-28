; Given an "orbit" name sample pblh and return statistics
; optional "taod" is to require AOD > 0.2 and
; optional "tcld" is to require CLDTOT < 0.8
; optional "trnd" is to pick 66% of random points

; Outputs are:
; - full      = histogram of pblh in of full series in 200 m increments
; - fullhr    = mean hourly pblh height
; - fullhrn   = number of obs per hour
; - fullhrhst = quartile etc. histograms


  pro get_sample, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                  fullhrs, fullhrmn, fullhrmx, $
                  tcld=tcld, taod=taod, trnd=trnd, $
                  daod=daod, $ ; apply aod threshold to first (day) orbit, not union
                  unionorbit = unionorbit, $
                  forcenew=forcenew

;  print, orbit, filetag

; See if the histogram file exists
  if(not(keyword_set(forcenew))) then begin
   histfile = orbit+'.'+filetag
   if(keyword_set(tcld)) then histfile = histfile+'.tcld'
   if(keyword_set(taod)) then histfile = histfile+'.taod'
   histfile = histfile+'.hist.sav'
   if(file_search(histfile) ne '') then begin
    restore, histfile
    print, 'histfile found: ', histfile
    goto, getout
   endif
  endif

; taod
  if(keyword_set(taod) or keyword_set(daod)) then begin
;   ddf = orbit+'.ddf'
;   ga_times, ddf, nymd, nhms, template=template
;   filename=strtemplate(template,nymd,nhms)
;   filename= filename[fnoff:fnoff+nts-1:24]
;   nc4readvar, filename, 'totexttau', aot, wantlat=wantlat, wantlon=wantlon
   if(strmid(orbit,0,9) eq 'tomcatall') then begin
    tail = strmid(orbit,10,100)+'.'+filetag
    restore_tomcatall, tail, varout, nday, lon, lat
   endif else begin
    restore, orbit+'.'+filetag+'.sav'
   endelse
   aot = varout
  endif
  if(keyword_set(tcld)) then begin
;   ddf = orbit+'.cldtot.ddf'
;   ga_times, ddf, nymd, nhms, template=template
;   filename=strtemplate(template,nymd,nhms)
;   filename= filename[fnoff:fnoff+nts-1:24]
;   nc4readvar, filename, 'cldtot', cld, wantlat=wantlat, wantlon=wantlon
   if(strmid(orbit,0,9) eq 'tomcatall') then begin
    tail = strmid(orbit,10,100)+'.cldtot'+'.'+filetag
    restore_tomcatall, tail, varout, nday, lon, lat
   endif else begin
    restore, orbit+'.cldtot.'+filetag+'.sav'
   endelse
   cld = varout
  endif
;  ddf = orbit+'.pm25.ddf'
;  ga_times, ddf, nymd, nhms, template=template
;  filename=strtemplate(template,nymd,nhms)
;  filename= filename[fnoff:fnoff+nts-1:24]
;  nday = n_elements(filename)
;  nc4readvar, filename, 'pm25', pm25, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
;  a = where(pm25 gt 1e14)
;  pm25[a] = !values.f_nan
; make pm25 ug m-3
  if(strmid(orbit,0,9) eq 'tomcatall') then begin
   tail = strmid(orbit,10,100)+'.pm25'+'.'+filetag
   restore_tomcatall, tail, varout, nday, lon, lat
  endif else begin
   restore, orbit+'.pm25.'+filetag+'.sav'
   nday = n_elements(filename)
  endelse
  pm25 = 1.e9*varout
  if(keyword_set(taod) or keyword_set(daod)) then begin
   a = where(aot lt 0.1)
   pm25[a] = !values.f_nan
  endif
  if(keyword_set(tcld)) then begin
   a = where(cld gt 0.8)
   pm25[a] = !values.f_nan
  endif
; This seems...not efficient
  if(keyword_set(trnd)) then begin
   a = where(finite(pm25) eq 1)
   nfin = n_elements(a)
   nwan = long(0.66*nfin)
   spawn, 'ps -A | sum | cut -c1-5', seed
   seed = long(seed[0])
   while(nfin gt nwan) do begin
    r = randomu(seed,1)
    irem = long(r*nfin)
    irem = min([irem,nfin-1])
;print, irem, nfin, r
    pm25[a[irem]] = !values.f_nan
    a = where(finite(pm25) eq 1)
    nfin = n_elements(a)
   endwhile
  endif

; --------------------------------------
; If making union dataset get it here
  if(keyword_set(unionorbit)) then begin
; taod
  if(keyword_set(taod)) then begin
;   ddf = unionorbit+'.ddf'
;   ga_times, ddf, nymd, nhms, template=template
;   filename=strtemplate(template,nymd,nhms)
;   filename= filename[fnoff:fnoff+nts-1:24]
;   nc4readvar, filename, 'totexttau', aot_, wantlat=wantlat, wantlon=wantlon
   restore, unionorbit+'.'+filetag+'.sav'
   aot_ = varout
  endif
  if(keyword_set(tcld)) then begin
;   ddf = unionorbit+'.cldtot.ddf'
;   ga_times, ddf, nymd, nhms, template=template
;   filename=strtemplate(template,nymd,nhms)
;   filename= filename[fnoff:fnoff+nts-1:24]
;   nc4readvar, filename, 'cldtot', cld_, wantlat=wantlat, wantlon=wantlon
   restore, unionorbit+'.cldtot.'+filetag+'.sav'
   cld_ = varout
  endif
;  ddf = unionorbit+'.pm25.ddf'
;  ga_times, ddf, nymd, nhms, template=template
;  filename=strtemplate(template,nymd,nhms)
;  filename= filename[fnoff:fnoff+nts-1:24]
;  nday = n_elements(filename)
;  nc4readvar, filename, 'pm25', pm25_, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
;  a = where(pm25_ gt 1e14)
;  pm25_[a] = !values.f_nan
; make pm25 ug m-3
  restore, unionorbit+'.pm25.'+filetag+'.sav'
  pm25_ = 1.e9*varout
  if(keyword_set(taod)) then begin
   a = where(aot_ lt 0.1)
   pm25_[a] = !values.f_nan
  endif
  if(keyword_set(tcld)) then begin
   a = where(cld_ gt 0.8)
   pm25_[a] = !values.f_nan
  endif
  if(keyword_set(trnd)) then begin
   a = where(finite(pm25_) eq 1)
   nfin = n_elements(a)
   nwan = fix(0.66*nfin)
   spawn, 'ps -A | sum | cut -c1-5', seed
   seed = long(seed[0])
   while(nfin gt nwan) do begin
    r = randomu(seed,1)
    irem = fix(r*nfin)
    irem = min([irem,nfin-1])
    pm25_[a[irem]] = !values.f_nan
    a = where(finite(pm25_) eq 1)
    nfin = n_elements(a)
   endwhile
  endif
; Merge with base
  a = where(finite(pm25_) eq 1)
  pm25[a] = pm25_[a]
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

  binsize=2.
  binmax =40.

  full = histogram(pm25,binsize=binsize,min=0,max=binmax)
  fullhr = reform(pm25,nx*ny*24L,nday)
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

getout:

end
