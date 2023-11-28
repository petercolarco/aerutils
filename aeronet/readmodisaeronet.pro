; Colarco, February 2006
; Read in the MODIS AERONET extractions, returning the requested wavelength
; aot and date information at the location desired.

; The date will be long integer format YYYYMMDDHH

; This code interpolates the location to the AERONET locations from the database

  pro readmodisaeronet, exppath, expid, year, location, lambdawant, aotOut, date

;  modellocation = strlowcase(location)
  modellocation = location
; Here are the variables to read from the model file
  modelvars = ['AODTAU']
  nvars = n_elements(modelvars)

  filename=exppath+expid+'.tau2d.'+modellocation+'.'+year+'.nc'

  print, filename
; open the model file
  cdfid = hdf_sd_start(filename)
   idx = hdf_sd_nametoindex(cdfid,'time')
   id = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, time
;  Here we want to get the attribute information for the time dimension
;  because it tells us where
   idf = hdf_sd_attrfind(id,'units')
   hdf_sd_attrinfo, id, idf, data=minutes_since
;  Parse the attribute value
   minutes_since = strmid(minutes_since,14)
   str_part = strsplit(minutes_since,'-: ',/extract)
   yyyy = str_part[0]
   mm   = str_part[1]
   dd   = str_part[2]
   hh   = str_part[3]
   date0 =   fix(yyyy)*1000000L $
           + fix(mm)*10000L + fix(dd)*100L + fix(hh)
   julday0 = julday(mm,dd,yyyy,hh)
   julday1 = julday0+time/(24.*60)
   ntime = n_elements(time)
   date = lonarr(ntime)
   for itime = 0, ntime-1 do begin
    caldat, julday1[itime], mm, dd, yyyy, hh
    date[itime] =   fix(yyyy)*1000000L $
                  + fix(mm)*10000L + fix(dd)*100L + fix(hh)
   endfor
   idx = hdf_sd_nametoindex(cdfid,'lon')
   id = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, lon
   idx = hdf_sd_nametoindex(cdfid,'lat')
   id = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, lat
   idx = hdf_sd_nametoindex(cdfid,'lev')
   id = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, lev
   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)
   nt = n_elements(time)
   aot0 = fltarr(nx,ny,nz,nt,nvars)
   aottemp = fltarr(nx,ny,nz,nt)
   for ivar = 0, nvars-1 do begin
    idx = hdf_sd_nametoindex(cdfid,modelvars[ivar])
    id = hdf_sd_select(cdfid,idx)
    hdf_sd_getdata, id, aottemp
    aot0[*,*,*,*,ivar] = aottemp
   endfor
  hdf_sd_end, cdfid

  aot = reform(aot0)

; For the wavelength, use an angstrom parameter estimate to interpolate
  ilam = interpol(indgen(nz),lev,float(lambdawant))
  ilam0 = fix(ilam+1.)
  ilam1 = fix(ilam) ;; because the levels are in reverse order
  if(ilam0 gt (nz-1)) then begin
   ilam0 = nz-1
   ilam1 = ilam1-1
  endif
  aotLam = fltarr(nt,nvars)
  for ivar = 0, nvars-1 do begin
   for it = 0, nt-1 do begin
    m =   alog(aot[ilam0,it,ivar]/aot[ilam1,it,ivar]) $
        / alog(lev[ilam0]/lev[ilam1])
    aotLam[it,ivar] = exp( alog(aot[ilam0,it,ivar]) $
                          + m*alog(float(lambdawant)/(lev[ilam0])) )
   endfor
  endfor
  aotOut = aotLam

; Compute the AERONET Angstrom parameter
  if(keyword_set(angstrom)) then begin
   aot870 = fltarr(nt)
   aot470 = fltarr(nt)
;  870 -- use 660 instead because of MODIS land
   ilam = interpol(indgen(nz),lev,float('660'))
   ilam0 = fix(ilam+1.)
   ilam1 = fix(ilam) ;; because the levels are in reverse order
   if(ilam0 gt (nz-1)) then begin
    ilam0 = nz-1
    ilam1 = ilam1-1
   endif
   aotLam = fltarr(nt,nvars)
   for ivar = 0, nvars-1 do begin
    for it = 0, nt-1 do begin
     m =   alog(aot[ilam0,it,ivar]/aot[ilam1,it,ivar]) $
         / alog(lev[ilam0]/lev[ilam1])
     aotLam[it,ivar] = exp( alog(aot[ilam0,it,ivar]) $
                          + m*alog(float('660')/(lev[ilam0])) )
    endfor
   endfor
   aot870 = total(aotlam,2)

;  470
   ilam = interpol(indgen(nz),lev,float('470'))
   ilam0 = fix(ilam+1.)
   ilam1 = fix(ilam) ;; because the levels are in reverse order
   if(ilam0 gt (nz-1)) then begin
    ilam0 = nz-1
    ilam1 = ilam1-1
   endif
   aotLam = fltarr(nt,nvars)
   for ivar = 0, nvars-1 do begin
    for it = 0, nt-1 do begin
     m =   alog(aot[ilam0,it,ivar]/aot[ilam1,it,ivar]) $
         / alog(lev[ilam0]/lev[ilam1])
     aotLam[it,ivar] = exp( alog(aot[ilam0,it,ivar]) $
                          + m*alog(float('470')/(lev[ilam0])) )
    endfor
   endfor
   aot470 = total(aotlam,2)

   angstrom = -alog(aot470/aot870) / alog(470./870.)

  endif

end
