; Colarco, December 2010
; Based on "readmodel.pro"
; Required inputs:
;  filetemplate = grads style template of filenames
;  site         = AERONET site name
;  lambda       = desired wavelength
;  nymd         = desired YYYYMMDD range (2 element array)
;  nhms         = desired HHMMSS range   (2 element array)
; Given a site location, a filename template, a wantdate range, and
; a desired wavelength, return the model fields.

; Assumption is single site, grads-readable files

  pro readmodel_aeronet, filetemplate, site, nymd, nhms, lambda, varwant, $
                         date, aotOut, tinc=tinc, rc=rc

  rc = 0
!quiet = 1L

; First, expand the dates
  dateexpand, nymd[0], nymd[1], nhms[0], nhms[1], nymde, nhmse, tinc=tinc
  date = nymde*100L + strmid(nhmse,0,2)
  ndates = n_elements(date)   ; number of elements requested to be filled in

; For each date, expand the template and read
; Get the location
  ntcounter = 0
  while(ntcounter lt ndates) do begin
  filename = strtemplate(filetemplate,nymde[ntcounter],nhmse[ntcounter],str=site)
  cdfid=ncdf_open(filename)
   id = ncdf_varid(cdfid, 'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid, 'lat')
   ncdf_varget, cdfid, id, lat
   idlev = ncdf_varid(cdfid, 'lev')
   if(idlev ne -1) then ncdf_varget, cdfid, idlev, lev
   if(idlev eq -1) then lev = 5.5e-7
   nz = n_elements(lev)
   if(lev[0] gt lev[nz-1]) then lev = reverse(lev)

;  Get the time attribute information
   id = ncdf_varid(cdfid, 'time')
   ncdf_varget, cdfid, id, time ; time in minutes since start of file
   ncdf_attget, cdfid, id, 'begin_date', begin_date
   ncdf_attget, cdfid, id, 'begin_time', begin_time
;   ncdf_attget, cdfid, id, 'time_increment', tinc

;  Parse the time to get in the right format
   yyyy = fix(   begin_date/10000L)
   mm   = fix( ( begin_date - 10000L*yyyy)/100L)
   dd   = fix(   begin_date - 10000L*yyyy - 100L*mm)
   hh   = fix(   begin_time/10000L)
   nn   = fix( ( begin_time - hh*10000L)/100L)

;  Parse the attribute value
   date0 =   fix(yyyy)*1000000L $
           + fix(mm)*10000L + fix(dd)*100L + fix(hh)
   julday0 = julday(mm,dd,yyyy,hh,nn)
   julday1 = julday0+time/(24.*60)
   ntime = n_elements(time)
   nymd_ = lonarr(ntime)
   nhms_ = lonarr(ntime)
   for itime = 0, ntime-1 do begin
    caldat, julday1[itime], mm, dd, yyyy, hh, nn
    nymd_[itime] = fix(yyyy)*10000L + fix(mm)*100L + fix(dd)
    nhms_[itime] = fix(hh)*10000L + fix(nn)*100L  
   endfor
   nhms_ = strpad(nhms_,100000L)
;  Retain only those in my date range
   a = where(nymd_ ge nymd[0] and nymd_ le nymd[1])
   nymd_ = nymd_[a]
   nhms_ = nhms_[a]
   nt = n_elements(a)  ; number of times to be retained
  ncdf_close, cdfid
  nc4readvar, filename, varwant, aot0_, rc=rc
  if(rc ne 0) then return
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nv = n_elements(varwant)
  aot0_ = reform(aot0_[a,*],nx,ny,nz,n_elements(a),nv)
; AOT comes back as (nx,ny,nz,nt,nv); rearrange
  aot0_ = transpose(aot0_,[3,0,1,2,4])
  if(ntcounter eq 0) then aot0 = aot0_ else $
                          aot0 = [aot0,aot0_]
  ntcounter = ntcounter + nt

  endwhile

; AOT is now arranged as (nt,nx,ny,nz,nv); rearrange
  aot0 = reform(aot0,ndates,nx,ny,nz,nv)
  aot0 = transpose(aot0,[1,2,3,0,4])
  aot0 = reform(aot0,nx,ny,nz,ndates,nv)
  aot  = reform(aot0)

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

  ilam = interpol(indgen(nz),lev*1.e9,float(lambda))

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

  aotLam = fltarr(nt,nv)
  for ivar = 0, nv-1 do begin
   for it = 0, nt-1 do begin
    m =   alog(aot[ilam0,it,ivar]/aot[ilam1,it,ivar]) $
        / alog(lev[ilam0]/lev[ilam1])
    aotLam[it,ivar] = exp( alog(aot[ilam1,it,ivar]) $
                          + m*alog(float(lambda)/(lev[ilam1]*1.e9)) )
   endfor
  endfor
  aotOut = aotLam


end
