; Colarco, February 2006
; Read aeroce data from a file
; Specify the desired site, wavelength, and whether you want monthly or
; daily and return value and dates.
; Optionally, return a bunch of other parameters (e.g., PI, lon, lat,
; etc.)

; Optionally, set "clim" to return the climatology and error

  pro read_aeroce2nc, aerocePath, sitewant, varwant, yyyy, $
                      value, date, $
                      stdvalue = stdvalue, nvalue=nvalue, $
                      pi=pi, pi_email=pi_email, lon=lon, lat=lat, elev=elev, rc=rc, $
                      clim=clim
                   

  rc = 0
  do_clim = 0
  if(keyword_set(clim)) then do_clim = clim

; Open the desired file
  aerocefile = aerocePath+'/aeroce_monthly.nc'

  cdfid = ncdf_open(aerocefile[0])
  if(cdfid eq -1) then begin
   print, 'File: '+aeroceFile+' not present or cannot be opened; exit'
   rc = 1
   ncdf_close, cdfid
   return
  endif

; Now get the times
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, date
  datestr = strcompress(string(date),/rem)
; Pick up only the year that you want
  if(not(do_clim)) then begin
   a = where(strmid(datestr,0,4) eq yyyy)
   if(a[0] eq -1) then begin
    print, 'readaeroce: year requested = '+yyyy+' not available; exit'
    rc = 1
    ncdf_close, cdfid
    return
   endif
   idate0 = min(a)
   idate1 = max(a)
   ndates = n_elements(date[a])
   date   = date[a]
  endif else begin
   idate0 = 0
   ndates = n_elements(date)
   idate1 = ndates-1
  endelse

; Now get the site names out of the file and compare with the desired site
  id = ncdf_varid(cdfid, 'location')
  ncdf_varget, cdfid, id, sites
  sites = string(sites)
  a = where(sites eq siteWant)
  if(a[0] eq -1) then begin
   print, 'Requested Site: '+sitewant+' not found; exit'
   rc = 1
   ncdf_close, cdfid
   return
  endif
  isite = a[0]

; Now get the variable wanted
  id = ncdf_varid(cdfid,varwant)
  ncdf_varget, cdfid, id, value, offset=[isite,idate0], count=[1,ndates]
  value = reform(value)
  id = ncdf_varid(cdfid,varwant+'std')
  ncdf_varget, cdfid, id, stdvalue, offset=[isite,idate0], count=[1,ndates]
  stdvalue = reform(stdvalue)

; for daily values the stddev is missing
  nv = n_elements(value)
  nvalue = make_array(nv,val=1)
  a = where(value eq -9999.)
  if(a[0] ne -1) then nvalue[a] = 0

; If doing the climatology then make it
; Assumption is that we have 12 months per year for all years
  if(do_clim) then begin
   ny = ndates/12
   date =reform(date,12,ny)
   value = reform(value,12,ny)
   stdvalue = reform(stdvalue,12,ny)
   value_ = make_array(12,val=-9999.)
   stdvalue_ = make_array(12,val=-9999.)
   for im = 0, 11 do begin
    a = where(value[im,*] ne -9999.)
    n = n_elements(a)
    if(a[0] ne -1) then begin
     value_[im] = mean(value[im,a])
     stdvalue_[im] = sqrt(total(stdvalue[im,a]^2.))/n
    endif
   endfor
   value = value_
   stdvalue = stdvalue_
   date = reform(date[*,0])
  endif


  date = strcompress(string(date),/rem)


  
; close
  ncdf_close, cdfid

end

