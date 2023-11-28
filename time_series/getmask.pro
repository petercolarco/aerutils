pro getmask, res, nx, ny, mask, lon, lat

; Get the mask
  spawn, 'echo ${BASEDIRAER}', basedir
  case res of
     'd' : begin
           nx = 576
           ny = 361
           maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
           maskvar = 'region_mask'
           end
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
     'b' : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
  endcase

; Read the regional mask
  ga_getvar, maskfile, maskvar, mask, lon=lon, lat=lat

; possibly shift the result
  if(min(lon) lt 0) then begin
     lon = lon + 180.
     mask = shift(mask,nx/2,0)
  endif

  a = where(mask gt 100)
  if(a[0] ne -1) then mask[a] = 0
  a = where(mask gt 0)
  if(a[0] ne -1) then mask[a] = 1

end
