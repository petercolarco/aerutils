; Colarco, February 2006
; Read aeronet data from a file
; Specify the desired site, wavelength, and whether you want monthly or
; daily and return AOT and dates at the specified channel.  Optionally, 
; return a bunch of other parameters (e.g., PI, lon, lat, etc.)

; 18-Feb 2008: if yyyy is an array of years, read in all years and stack up.

; 30-Aug 2007: change sense of flags.  By default, will read from
;              daily file.  Select "monthly" to read monthly and
;              select "hourly" to read hourly binned.

  pro read_aeronet2nc, aeronetPath, sitewant, lambdawant, yyyyInp, $
                       aot_, date_, $
                       monthly = monthly, $
                       hourly=hourly, threehourly=threehourly, sixhourly=sixhourly, $
                       pi_name=pi_name, pi_email=pi_email, lon=lon, lat=lat, elev=elev, $
                       naot=naot_, angpair=angpair, angstrom=angstromOut, nang=nangOut
                   

; Open the desired aeronet file
; monthly > 0 for monthly averages
  if(not keyword_set(monthly)) then monthly = 0
  if(not keyword_set(hourly))  then hourly = 0
  if(not keyword_set(threehourly)) then threehourly = 0
  if(not keyword_set(sixhourly)) then sixhourly = 0

  if(monthly and hourly) then begin
   print, 'Select one of monthly or hourly; exit'
   stop
  endif

  if(monthly) then begin
   aeronetfile = aeronetPath+'/aot_monthly.nc'
;   varaot = 'aot_of_weighted_average'
   varaot = 'aot_of_daily_average'
   varnum = 'number_of_observations'
;   varnum = 'number_of_measurements'
  endif else begin
   varnum = 'number_of_aot'
   if(hourly or threehourly or sixhourly) then begin
    aeronetfile = aeronetPath+'/aot_allpts.'+sitewant+'.nc'
;    aeronetfile = aeronetPath+'/aot_allpts.'+sitewant+'.hourly.nc'
    varaot = 'aot_average'
    varang = 'angstrom_parameter_average'
   endif else begin
    aeronetfile = aeronetPath+'/aot_daily.nc'
    varaot = 'aot_daily_average'
    varang = 'angstrom_parameter_daily_average'
   endelse
  endelse

  cdfid = ncdf_open(aeronetfile)
  if(cdfid eq -1) then begin
   print, 'File: '+aeronetFile+' not present or cannot be opened; exit'
   stop
  endif

  id = ncdf_varid(cdfid,'pi')
  ncdf_varget, cdfid, id, pi_name

  nyr = n_elements(yyyyInp)
  for iyr = 0, nyr-1 do begin
  yyyy = yyyyInp[iyr]

; Now get the times
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, date
; Pick up only the year that you want
  datestr = strcompress(string(date),/rem)
  a = where(strmid(datestr,0,4) eq yyyy)
  if(a[0] eq -1) then begin
   print, 'readaeronet: year requested = '+yyyy+' not available; exit'
   stop
  endif
  idate0 = min(a)
  idate1 = max(a)
  ndates = n_elements(date[a])
  date   = date[a]

; Now get the site names out of the file and compare with the desired site
  id = ncdf_varid(cdfid, 'location')
  ncdf_varget, cdfid, id, sites
  sites = string(sites)
  a = where(strlowcase(sites) eq strlowcase(siteWant))
  if(a[0] eq -1) then begin
   print, 'Requested Site: '+sitewant+' not found; exit'
   stop
  endif
  isite = a[0]

; Extinction AOT
; --------------
; Get the number of aot -- will adjust if interpolation fails
  id=ncdf_varid(cdfid,varnum)
  ncdf_varget, cdfid, id, naot, offset=[isite,0,idate0], count=[1,1,ndates]
  naot = reform(naot)

; Get the total extinction AOT, interpolating to lambdawant
; Per Eck et a. 1999, use a second order polynomial in log wavelength
; space (only use 380 nm <= wavelengths <= 870 nm)
  id = ncdf_varid(cdfid,'channels')
  ncdf_varget, cdfid, id, lambda
  lambda = fix(lambda)
  nlambda = n_elements(lambda)
  id = ncdf_varid(cdfid,varaot)
  ncdf_varget, cdfid, id, aot, offset=[isite,0,idate0], count=[1,nlambda,ndates]
  aot = reform(aot)
  aotout = make_array(ndates,val=-9999.)
  loglambdawant = alog(lambdawant)
  for idates = 0, ndates-1 do begin
   a = where(aot[*,idates] gt -9999.)
   if(a[0] eq -1) then continue
;  if lambdawant is a node the select, else interpolate
   a = where(lambdawant eq lambda)
   if(a[0] ne -1) then begin
    if(aot[a,idates] gt -9999.) then begin
     aotout[idates] = aot[a,idates]
     continue
    endif
   endif
;  Only do polynomial fit for channels 380 - 870
   a = where(aot[*,idates] gt -9999. and $
             lambda lt 900 and lambda gt 360)
;  Don't interpolate out of range of wavelengths measure
   if(lambdawant gt max(lambda[a]) or lambdawant lt min(lambda[a])) then continue
   loglambda = alog(lambda[a])
   logaot    = alog(aot[a,idates])
   if(n_elements(a) eq 2) then begin
    fit            = linfit(loglambda, logaot)
    aotout[idates] = exp(fit[1]*loglambdawant + fit[0])
   endif else begin
    fit            = poly_fit(loglambda,logaot,2,status=stat,/double)
    if(stat ne 0) then stop
    aotout[idates] = exp(fit[2]*loglambdawant^2.+fit[1]*loglambdawant+fit[0])
   endelse
  endfor   
  aot = aotout

; For any times which somehow fail the interpolation test we want to
; exclude those from naot
  a = where(aot lt 0 and naot gt 0)
  if(a[0] ne -1) then naot[a] = -9999L

; If available, get the Angstrom Exponent pair
  if(not monthly) then begin
   angwant = 0
   angpair = 1
   if(keyword_set(angpair)) then angwant = 1
   id = ncdf_varid(cdfid,varang)
   ncdf_varget, cdfid, id, angstrom, offset=[isite,angpair-1,idate0], count=[1,1,ndates]
   angstrom = reform(angstrom)
  endif

  if(iyr eq 0) then begin
   aot_ = aot
   date_ = date
   naot_ = naot
   if(not monthly) then if(angwant) then angstromout = angstrom 
  endif else begin
   aot_ = [aot_,aot]
   date_ = [date_,date]
   naot_ = [naot_,naot]
   if(not monthly) then if(angwant) then angstromout = [angstromOut,angstrom]
  endelse


  endfor   ; loop over years 
   


; close
  ncdf_close, cdfid

; Finally, as a hack, if selected "threehourly" I will bin results accordingly
  if(threehourly) then begin
    n = n_elements(date_)
    date__ = date_[1:n-2:3]  ; every third date
    n = n_elements(date__)
    aot__  = make_array(n,val=-9999.)
    naot__ = make_array(n,val=-9999L)
    if(angwant) then angstromout__ = aot__
    for m = 0, n-1 do begin
     c = indgen(3)+3*m
     a = where(naot_[c] gt 0)
     if(a[0] ne -1) then begin
      naot__[m] = total(naot_[c[a]])
      aot__[m]  = total(aot_[c[a]]*naot_[c[a]]) / naot__[m]
      if(angwant) then $
      angstromout__[m] = total(aot_[c[a]]*naot_[c[a]]*angstromout[c[a]]) $
                  / total(aot_[c[a]]*naot_[c[a]])
     endif
    endfor
    date_ = date__
    aot_  = aot__
    naot_ = naot__
    if(angwant) then angstromout = angstromout__

  endif

  if(sixhourly) then begin
    n = n_elements(date_)
    date__ = date_[1:n-5:6]  ; every sixth date
    n = n_elements(date__)
    aot__  = make_array(n,val=-9999.)
    naot__ = make_array(n,val=-9999L)
    if(angwant) then angstromout__ = aot__
    for m = 0, n-1 do begin
     c = indgen(6)+6*m
     a = where(naot_[c] gt 0)
     if(a[0] ne -1) then begin
      naot__[m] = total(naot_[c[a]])
      aot__[m]  = total(aot_[c[a]]*naot_[c[a]]) / naot__[m]
      if(angwant) then $
      angstromout__[m] = total(aot_[c[a]]*naot_[c[a]]*angstromout[c[a]]) $
                  / total(aot_[c[a]]*naot_[c[a]])
     endif
    endfor
    date_ = date__
    aot_  = aot__
    naot_ = naot__
    if(angwant) then angstromout = angstromout__

  endif

end

