; Colarco, February 2006
; Updated, September 2010 for newer format files *and* for reading 
; from tavg2d_aer_x/tavg2d_carma_x style files

; Assumption is single site, grads-readable files on the year

; Read in the model AERONET extractions one variable at a time, returning the 
; requested wavelength aot and date information at the location desired.

; The date will be long integer format YYYYMMDDHH

; This code interpolates the location to the AERONET locations from the database

  pro readmodel, exppath, expid, year, location, lambdawant, varwant, aotOut, date

!quiet = 1L

;  modellocation = strlowcase(location)
  modellocation = location

  filename=exppath+expid+'.'+modellocation+'.'+year+'.nc4'

; Here are the variables to read from the model file
  modelvars = varwant
  nvars = n_elements(modelvars)

; open the model file
  cdfid = ncdf_open(filename)

;  Get the time
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, time

;  Get the time attribute information
   ncdf_attget, cdfid, id, 'begin_date', begin_date
   ncdf_attget, cdfid, id, 'begin_time', begin_time
   ncdf_attget, cdfid, id, 'time_increment', tinc

;  Parse the time to get in the right format
   yyyy = fix(   begin_date/10000L)
   mm   = fix( ( begin_date - 10000L*yyyy)/100L)
   dd   = fix(   begin_date - 10000L*yyyy - 100L*mm)
   hh   = fix(   begin_time/10000L)
   nn   = fix( ( begin_time - hh*10000L)/100L)

;  Parse the attribute value
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

;  Get the location
   id = ncdf_varid(cdfid, 'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid, 'lat')
   ncdf_varget, cdfid, id, lat
   idlev = ncdf_varid(cdfid, 'lev')
   if(idlev ne -1) then ncdf_varget, cdfid, idlev, lev
   if(idlev eq -1) then lev = 5.5e-7

   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)
   nt = n_elements(time)
   aot0 = fltarr(nx,ny,nz,nt,nvars)
   for ivar = 0, nvars-1 do begin
    id = ncdf_varid(cdfid,modelvars[ivar])
    if(id eq -1) then id = ncdf_varid(cdfid,strupcase(modelvars[ivar]))
    aottemp = make_array(nx,ny,nz,nt,val=1.e-16)
    if(id ne -1) then begin
     ncdf_varget, cdfid, id, aottemp
    endif
    aot0[*,*,*,*,ivar] = aottemp
   endfor
  ncdf_close, cdfid

  aot = reform(aot0)

; If no levels are on the file, assume that there is only one
; wavelength and return that value
  if(idlev eq -1) then begin
   aotOut = aot
   return
  endif

; For the wavelength, use an angstrom parameter estimate to interpolate
; Recall: ilam0 is the longer of the channels and ilam1 is the shorter
; The slope is thus m = ( alog(tau[ilam0])-alog(tau[ilam1]) )
;                      /( alog(lambda[ilam0])-alog(lambda[ilam1]))

  ilam = interpol(indgen(nz),lev*1.e9,float(lambdawant))

  if(lev[0] gt lev[nz-1]) then begin ; because the levels are in reverse order
   ilam0 = fix(ilam+1.)
   ilam1 = fix(ilam)
   if(ilam lt 0) then ilam1 = 0
   if(ilam lt 0) then ilam0 = 1
   if(ilam gt nz) then ilam1 = nz-2
   if(ilam gt nz) then ilam0 = nz-1
  endif else begin
   ilam0 = fix(ilam)
   ilam1 = fix(ilam+1)
   if(ilam lt 0) then ilam0 = 0
   if(ilam lt 0) then ilam1 = 1
   if(ilam gt nz) then ilam0 = nz-2
   if(ilam gt nz) then ilam1 = nz-1
  endelse

  aotLam = fltarr(nt,nvars)
  for ivar = 0, nvars-1 do begin
   for it = 0, nt-1 do begin
    m =   alog(aot[ilam0,it,ivar]/aot[ilam1,it,ivar]) $
        / alog(lev[ilam0]/lev[ilam1])
    aotLam[it,ivar] = exp( alog(aot[ilam1,it,ivar]) $
                          + m*alog(float(lambdawant)/(lev[ilam1]*1.e9)) )
   endfor
  endfor
  aotOut = aotLam


end
