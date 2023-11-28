; Colarco, February 2006
; Read improve data from a file
; Specify the desired site, wavelength, and whether you want monthly or
; daily and return value and dates.
; Optionally, return a bunch of other parameters (e.g., PI, lon, lat, etc.)

  pro read_improve2nc, improvePath, sitewant, varwant, yyyy, $
                       value, date, $
                       monflag = monflag, stdvalue = stdvalue, nvalue=nvalue, $
                       pi=pi, pi_email=pi_email, lon=lon, lat=lat, elev=elev, rc=rc
                   
  rc = 0

; Open the desired file
; monflag > 0 for monthly averages
; If monthly is desired then I average here on the fly
  if(not keyword_set(monflag)) then monflag = 0

  improvefile = improvePath+'/improve_daily.nc'

  cdfid = ncdf_open(improvefile)
  if(cdfid eq -1) then begin
   print, 'File: '+improveFile+' not present or cannot be opened; exit'
   rc = 1
   ncdf_close, cdfid
   return
  endif

; Now get the times
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, date
; Pick up only the year that you want
  datestr = strcompress(string(date),/rem)
  a = where(strmid(datestr,0,4) eq yyyy)
  if(a[0] eq -1) then begin
   print, 'readimprove: year requested = '+yyyy+' not available; exit'
   rc = 1
   ncdf_close, cdfid
   return
  endif
  idate0 = min(a)
  idate1 = max(a)
  ndates = n_elements(date[a])
  date   = date[a]

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

; for daily values the stddev is missing
  nv = n_elements(value)
  stdvalue = make_array(nv,val=-9999.)
  nvalue = make_array(nv,val=1)
  a = where(value eq -9999.)
  if(a[0] ne -1) then nvalue[a] = 0


  date = strcompress(string(date),/rem)

; If I want monthly
  if(monflag) then begin
   datemon = strcompress(string(yyyy),/rem) $
            +strcompress(string(indgen(12)+1,format='(i2)'))+'15'
   valuemon = fltarr(12)
   stdmon = fltarr(12)
   nvmon = intarr(12)
   for imon = 0, 11 do begin
    a = where(fix(strmid(date,4,2)) eq imon+1)
    b = where(value[a] gt 0.)
    if(b[0] eq -1) then begin
     valuemon[imon] = -9999.
     stdmon[imon] = -9999.
     nvmon[imon] = 0
    endif else begin
     valuemon[imon] = mean(value[a[b]])
     stdmon[imon] = 0.
     if(n_elements(b) ge 2) then stdmon[imon] = stddev(value[a[b]])
     nvmon[imon] = n_elements(b)
    endelse
   endfor
   value = valuemon
   date = datemon
   stdvalue = stdmon
   nvalue = nvmon
  endif

  

; close
  ncdf_close, cdfid

end

