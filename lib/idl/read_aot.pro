; Colarco, February 2011
; Simple program to read MODIS AOD and aggregate land/ocean to single
; value returned (550 nm AOD)
; Supports reading multiple dates as one

  pro read_aot,    aot, lon, lat, yyyy, mm, dd, hh, $
                   satid=satid, old=old, res=res, varwant=varwant, $
                   fineaot=fineaot, hourly=hourly, $
                   model=model, ctlmodelocean = ctlmodelocean, ctlmodelland=ctlmodelland

  if(not(keyword_set(res))) then res = 'e'
  if(not(keyword_set(old))) then old = 0
  if(not(keyword_set(satid))) then satid = 'MOD04'
  fmod = ''

  hrstr = ''
  if(keyword_set(hourly)) then hrstr = '/hourly'

; If what is requested is the satellite data
  if(not(keyword_set(model))) then begin

;  If not asking for MISR
   if(satid ne 'MISR') then begin

    spawn, 'echo $MODISDIR', modisdir, /sh
    if(not(old)) then begin
;    Use new NNR retrievals
     modispath = modisdir[0] + 'MODIS/NNR/'+satid+'/'+res+hrstr+'/Y'+yyyy+'/M'+mm+'/'
     ocn = 'nnr_001.'+satid+'_l3a.ocean.'
     lnd = 'nnr_001.'+satid+'_l3a.land.'
     if(keyword_set(varwant)) then var = varwant else var = 'tau_'
    endif else begin
     modispath = modisdir[0] + 'MODIS/Level3/'+satid+'/'+res+'/GRITAS/'+$
                                hrstr+'/Y'+ $
                                yyyy+'/M'+mm+'/'
     if(keyword_set(varwant)) then var = varwant else var = 'aodtau'
     ocn  = satid+'_L2_ocn.aero_tc8_051.qawt.'
     lnd  = satid+'_L2_lnd.aero_tc8_051.qawt3.'
     fmod = satid+'_L2_ocn.aero_tc8_051.qafl.'
     wantlev = 550.
    endelse

;   If dd and hh not given, then we will return the monthly average file
    if(n_elements(dd) eq 0) then begin
     file = modispath+ocn+yyyy+mm+'.nc4'
     nc4readvar, file, var, aoto, lon=lon, lat=lat, time=time, wantlev=wantlev
     file = modispath+lnd+yyyy+mm+'.nc4'
     nc4readvar, file, var, aotl, lon=lon, lat=lat, time=time, wantlev=wantlev
     if(fmod ne '' and keyword_set(fineaot)) then begin
      file = modispath+fmod+yyyy+mm+'.nc4'
      nc4readvar, file, 'finerat', finerat, lon=lon, lat=lat, time=time
     endif
    endif else begin
     print, 'do not support finer than monthly for now'
     stop
    endelse

   endif else begin
;   MISR
    spawn, 'echo $MODISDIR', modisdir, /sh
    misrpath = modisdir[0]+'MISR/Level3/'+res+'/GRITAS/'+hrstr+'/Y'+ $
                            yyyy+'/M'+mm+'/MISR_L2.aero_tc8_F12_0022.noqawt.'
    var = 'aodtau'
    wantlev = 558.
    file = misrpath+yyyy+mm+'.nc4'
    nc4readvar, file, var, aoto, lon=lon, lat=lat, time=time, wantlev=wantlev
    aotl = aoto
   endelse

  endif else begin

;  Doing model, must supply ctl file locations
   if(not(keyword_set(ctlmodelocean)) or not(keyword_set(ctlmodelland))) then begin
    print, 'model output requested; must supply control files'
    stop
   endif
   var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
   nymd = yyyy+mm
   wanttime = [min(nymd),max(nymd)]
;  Special handling if MISR
   if(satid eq 'MISR') then begin
    nc4readvar, ctlmodelocean, var, aoto, lon=lon, lat=lat, time=time, $
                wantnymd=wanttime
    aotl = aoto
   endif else begin  
    nc4readvar, ctlmodelocean, var, aoto, lon=lon, lat=lat, time=time, $
                wantnymd=wanttime
    nc4readvar, ctlmodelland, var, aotl, lon=lon, lat=lat, time=time, $
                wantnymd=wanttime
   endelse
  endelse

; Now average results together
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)
  nv = n_elements(var)

  a = where(aoto gt 100.)
  aoto[a] = !values.f_nan
  a = where(aotl gt 100.)
  aotl[a] = !values.f_nan

  if(fmod ne '' and keyword_set(fineaot)) then begin
   a = where(finerat gt 100)
   if(a[0] ne -1) then finerat[a] = !values.f_nan
   fineaot = reform(finerat*aoto,nx,ny,nt,nv)
  endif

  aot = fltarr(nx*ny*1L,nt,nv)
  aoto = reform(aoto,nx*ny*1L,nt,nv)
  aotl = reform(aotl,nx*ny*1L,nt,nv)
  for iv = 0, nv-1 do begin
  for it = 0, nt-1 do begin
   for i = 0L, nx*ny-1 do begin
    aot[i,it,iv] = mean([aoto[i,it,iv],aotl[i,it,iv]],/nan)
   endfor
  endfor
  endfor
  aot = reform(aot,nx,ny,nt,nv)

end
