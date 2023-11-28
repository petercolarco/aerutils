; Colarco, July 2010
; Read the MODIS data and make some plots illustrating trends and
; behavior of AOT over IGP

; Latitude/Longitude bounding box
  wantlon    = [65.,95.]
  wantlat    = [10.,35.]

; Dataset
  ctlfile    = ['MYD04_L2_051.mm.qawt3.lnd.d.ctl']
  typefile   = ['MODIS']
  resolution = ['d']

; Times
  wanttime   = ['200301','200912']

; Get the times on the files (assumes all have same nt)
  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=wanttime,/noprint
  nt = n_elements(time)

  ictl = 0
  case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', $
                      'bcphobic', 'so4']
               wantlev=5.5e-7
               template = 1
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', $
                      'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
  endcase

  spawn, 'echo ${BASEDIRAER}', basedir
  area, longr, latgr, nx, ny, dx, dy, area, grid=resolution[ictl]

  case resolution[ictl] of
     'd' : begin
           maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
           maskvar = 'region_mask'
           end
     'c' : begin
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
     'b' : begin
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
  endcase

; Read the regional mask
  ga_getvar, maskfile, maskvar, mask, lon=lon, lat=lat, $
             wantlon=wantlon, wantlat=wantlat
  a = where(mask gt 100)
  if(a[0] ne -1) then mask[a] = 0

; Reduce area array to region covered by wantlon/wantlat
  a = where(longr ge wantlon[0] and longr le wantlon[1])
  b = where(latgr ge wantlat[0] and latgr le wantlat[1])
  area = area[a,*]
  area = area[*,b]

; Override NX,NY
  nx = n_elements(lon)
  ny = n_elements(lat)

; Now read the data
  nvars = n_elements(var)
  inp = fltarr(nx,ny,nt)
  date = strarr(nt)
  q = fltarr(nx,ny)
  print, ctlfile[ictl]
  for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wantlon=wantlon, wantlat=wantlat, $
       wanttime=wanttime, wantlev=wantlev, template=template
      inp = inp + varout
  endfor
; Discard missing values
  a = where(inp gt 1e14)
  if(a[0] ne -1) then inp[a] = !values.f_nan

; Mask out
  a = where(mask eq 0)
  inp_ = reform(inp,nx*ny,nt)
  if(a[0] ne -1) then inp_[a,*] = !values.f_nan
  inp = reform(inp_,nx,ny,nt)


;--- do area average ---
  regave = fltarr(nt)
  for it = 0, nt-1 do begin
   regave[it] = aave(inp[*,*,it],area,/nan)
  endfor

  date = strmid(time,0,4)+strmid(time,5,2)

end


