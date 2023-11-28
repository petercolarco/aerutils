; Colarco, August 2006
; Modified version of the original readmodelaeronet.pro
; Now uses the ga_getvar
; Read in the model AERONET extractions, returning the requested wavelength
; aot and date information at the location desired.
; If the keyword "angstrom" is present it will return the 470-870 angstrom
; Note that this is not exactly equivalent to the AERONET Angstrom parameter!
; Specify lambdawant in nm

  pro readmodelaeronet_ga, exppath, expid, timewant, location, lambdawant, aotOut, date, $
                        angstrom=angstrom

; Create a temporary control file for analysis
  dset = 'dset '+exppath+expid+'/tau/'+expid+'.tau2d.'+location+'.%y4.nc'
  y0 = long(strmid(wanttime[0],0,4))
  y1 = y0
  if(n_elements(wanttime) eq 2) then y1 = long(strmid(wanttime[1],0,4))
  ny = (y1-y0)+1
  tdef = 'tdef time '+string(ny*1464L)+' linear 0z01jan'+ $
          strcompress(string(y0),/rem) + ' 6hr'
  spawn, 'echo '+dset+' > tmp.ctl'
  spawn, 'echo options template >> tmp.ctl'
  spawn, 'echo '+tdef+' >> tmp.ctl'

; Get the data file information
  ga_getvar, 'tmp.ctl', '', varout, lon=lon, lat=lat, $
   lev=lev, wanttime=wanttime, time=time, /noprint
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(time)

; Here are the variables to read from the model file
  modelvars = ['du001', 'du002', 'du003', 'du004', 'du005', $
               'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
               'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'SO4']
  nvars = n_elements(modelvars)

  aot0 = fltarr(nx,ny,nz,nt,nvars)
  for ivar = 0, nvars-1 do begin
    ga_getvar, 'tmp.ctl', modelvars[ivar], aottemp, wanttime=wanttime
    aot0[*,*,*,*,ivar] = aottemp
  endfor

  aot = reform(aot0)


; For the wavelength, use an angstrom parameter estimate to interpolate
  ilam = interpol(indgen(nz),lev*1.e9,float(lambdawant))
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
                          + m*alog(float(lambdawant)/(lev[ilam0]*1.e9)) )
   endfor
  endfor
  aotOut = aotLam


; Compute the AERONET Angstrom parameter
  if(keyword_set(angstrom)) then begin
   aot870 = fltarr(nt)
   aot470 = fltarr(nt)
;  870
   ilam = interpol(indgen(nz),lev*1.e9,float('870'))
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
                          + m*alog(float('870')/(lev[ilam0]*1.e9)) )
    endfor
   endfor
   aot870 = total(aotlam,2)

;  470
   ilam = interpol(indgen(nz),lev*1.e9,float('470'))
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
                          + m*alog(float('470')/(lev[ilam0]*1.e9)) )
    endfor
   endfor
   aot470 = total(aotlam,2)

   angstrom = -alog(aot470/aot870) / alog(470./870.)

  endif

; recast the dates as wanted
  date = lonarr(nt)
  for it = 0, nt-1 do begin
   str = strsplit(time[it],' -', /extract)
   date[it] = long(str[0]+str[1]+str[2]+str[3])
  endfor


end

