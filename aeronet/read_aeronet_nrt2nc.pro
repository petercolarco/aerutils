; Colarco, August 2011
; Given a site, a wavelength and a range of dates, read and assemble
; the AERONET data

  pro read_aeronet_nrt2nc, site, lambda, yyyymmdd, $
                           aot, dates

; path to NRT nc files
  aeronetpath = '/misc/prc10/AERONET/AOT/AOT/LEV30/NRT_LEV15/'
  nd = n_elements(yyyymmdd)
  nt = 24

  for iday = 0, nd-1 do begin

   aot_use = make_array(nt,val=!values.f_nan)

   cdfid = ncdf_open(aeronetpath + 'aot_nrt.'+yyyymmdd[iday]+'.nc')
   if(iday eq 0 and cdfid lt 0) then begin
    print, 'First file missing; stop'
    stop
   endif

   if(cdfid lt 0) then begin
    print, yyyymmdd+' missing; using fill values'
    time = yyyymmdd[iday]+strpad(indgen(24),10)
   endif else begin
    id = ncdf_varid(cdfid,'time')
    ncdf_varget, cdfid, id, time
    id = ncdf_varid(cdfid,'channels')
    ncdf_varget, cdfid, id, channels
    id = ncdf_varid(cdfid,'location')
    ncdf_varget, cdfid, id, sites
    sites = string(sites)
    id = ncdf_varid(cdfid,'aot_average')
    ncdf_varget, cdfid, id, aot_inp
    ncdf_close, cdfid
    a = where(site eq sites)
    if(a[0] ne -1) then begin
     aot_inp = reform(aot_inp[a[0],*,*])
     a = where(lambda eq channels)
     if(a[0] ne -1) then begin
      aot_use = reform(aot_inp[a[0],*])
     endif else begin
      loglambda = alog(lambda)
      for it = 0, nt-1 do begin
;      Only do polynomial fit for channels 380 - 870
       a = where(aot_inp[*,it] gt -9999. and $
                 channels lt 900 and channels gt 360)
       if(a[0] eq -1) then continue
;      Don't interpolate out of range of wavelengths measure
       if(lambda gt max(channels[a]) or lambda lt min(channels[a])) then continue
       logchannels = alog(channels[a])
       logaot      = alog(aot_inp[a,it])
       if(n_elements(a) eq 2) then begin
        fit            = linfit(logchannels, logaot)
        aot_use[it]    = exp(fit[1]*loglambda + fit[0])
       endif else begin
        fit            = poly_fit(logchannels,logaot,2,status=stat,/double)
        if(stat ne 0) then stop
        aot_use[it]    = exp(fit[2]*loglambda^2.+fit[1]*loglambda+fit[0])
       endelse
      endfor   
     endelse
    endif
   endelse

;  Assemble to output
   if(iday eq 0) then begin
    dates = time
    aot   = aot_use
   endif else begin
    dates = [dates,time]
    aot   = [aot,aot_use]
   endelse
 
  endfor

end
