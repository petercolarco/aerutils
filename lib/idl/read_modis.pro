; Colarco, December 2013
; Read in MODIS data and return an array of the land and ocean aot
; (550 nm) merged
; Supports reading multiple dates as one

; Default behavior is to read from the 3 hourly gridded "old" style
; Also possible to read hourly and NNR files

; Also supports reading model sampled values

  pro read_modis, aot, lon, lat, yyyy, mm, dd, hh, $
                  satid=satid, old=old, res=res, varwant=varwant, $
                  model=model, hourly=hourly, $
                  climatology = climatology, season = season, $
                  ctlmodelocean = ctlmodelocean, ctlmodelland=ctlmodelland

  if(not(keyword_set(res))) then res = 'd'
  if(not(keyword_set(old))) then old = 0
  if(not(keyword_set(satid))) then satid = 'MOD04'
  if(not(keyword_set(duscale))) then duscale = 1.
  if(not(keyword_set(climatology))) then climatology = 0
  if(not(keyword_set(season))) then seasonal = 0 else seasonal = 1

; Read satellite data
  if(not(keyword_set(model))) then begin

   spawn, 'echo $MODISDIR', modisdir, /sh
   if(not(old)) then begin
;   Use new NNR retrievals

    modispath = modisdir[0] + 'MODIS/NNR/051/Level3/'+satid+'/'+res+'/Y'+yyyy+'/M'+mm+'/'
    if(keyword_set(hourly)) then $
     modispath = modisdir[0] + 'MODIS/NNR/051/Level3/'+satid+'/'+res+'/hourly/Y'+yyyy+'/M'+mm+'/'
    if(climatology or seasonal) then $
     modispath = modisdir[0] + 'MODIS/NNR/051/Level3/'+satid+'/'+res+'/clim/'
    ocn = 'nnr_001.'+satid+'_L3a.ocean.'
    lnd = 'nnr_001.'+satid+'_L3a.land.'
    if(keyword_set(varwant)) then var = varwant else var = 'tau_'
   endif else begin
    modispath = modisdir[0] + 'Level3/'+satid+'/'+res+'/GRITAS/Y'+ $
                               yyyy+'/M'+mm+'/'
    if(keyword_set(hourly)) then $
     modispath = modisdir[0] + 'Level3/'+satid+'/hourly/'+res+'/GRITAS/Y'+ $
                                yyyy+'/M'+mm+'/'
    if(climatology or seasonal) then $
     modispath = modisdir[0] + 'Level3/'+satid+'/'+res+'/GRITAS/clim/'
    if(keyword_set(varwant)) then var = varwant else var = 'aodtau'
    ocn = satid+'_L2_ocn.aero_tc8_051.qawt.'
    lnd = satid+'_L2_lnd.aero_tc8_051.qawt3.'
    if(keyword_set(hourly)) then begin
     ocn = satid+'_L2_ocn.aero_tc8_051.qast_qawt.'
     lnd = satid+'_L2_lnd.aero_tc8_051.qast3_qawt.'
     var = 'aot'
    endif
    wantlev = 550.
   endelse

;  If dd and hh not given, then we will return the monthly average file
   if(n_elements(dd) eq 0) then begin
    file = modispath+ocn+yyyy+mm+'.nc4'
    if(climatology) then file = modispath+ocn+'clim'+mm+'.nc4'
    if(seasonal)    then file = modispath+ocn+'clim.'+season+'.nc4'
    nc4readvar, file, var, aoto, lon=lon, lat=lat, time=time, wantlev=wantlev, rc=rc
    file = modispath+lnd+yyyy+mm+'.nc4'
    if(climatology) then file = modispath+lnd+'clim'+mm+'.nc4'
    if(seasonal)    then file = modispath+lnd+'clim.'+season+'.nc4'
    nc4readvar, file, var, aotl, lon=lon, lat=lat, time=time, wantlev=wantlev
   endif else begin
    print, 'do not support finer than monthly for now'
    stop
   endelse

  endif else begin

;  Doing model, must supply ctl file locations
   if(not(keyword_set(ctlmodelocean)) or not(keyword_set(ctlmodelland))) then begin
    print, 'model output requested; must supply control files'
    stop
   endif
   var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
   if(keyword_set(varwant)) then var = varwant
   nymd = yyyy+mm
   wanttime = [min(nymd),max(nymd)]
   nc4readvar, ctlmodelocean, var, aoto, lon=lon, lat=lat, time=time, $
               wantnymd=wanttime
   nc4readvar, ctlmodelland, var, aotl, lon=lon, lat=lat, time=time, $
               wantnymd=wanttime
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
