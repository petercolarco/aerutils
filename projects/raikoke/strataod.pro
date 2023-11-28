  file = '/misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.tavg3d_aerdiag_v.20200215_0900z.nc4'
  nc4readvar, file, 'suextcoef', suext, lon=lon, lat=lat, lev=lev
  nc4readvar, file, 'brcextcoef', brcext, lon=lon, lat=lat, lev=lev
  nc4readvar, file, 'delp', delp, lon=lon, lat=lat, lev=lev
  nc4readvar, file, 'airdens', rhoa, lon=lon, lat=lat, lev=lev

; Make the edge level pressures
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  p = delp
  p[*,*,*] = 1.
  dz = delp/rhoa/9.81
  for iz = 1, nz-1 do begin
   p[*,*,iz] = p[*,*,iz-1]+delp[*,*,iz]
  endfor

  file = '/misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.geosgcm_surf.20200215_0900z.nc4'
  nc4readvar, file, 'troppb', tropp, lon=lon, lat=lat, lev=lev
  tr = intarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    tr[ix,iy] = max(where(p[ix,iy,*] lt tropp[ix,iy]))
   endfor
  endfor

  aod = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aod[ix,iy] = total((suext[ix,iy,0:tr[ix,iy]]+brcext[ix,iy,0:tr[ix,iy]])*dz[ix,iy,0:tr[ix,iy]])
;    aod[ix,iy] = total((suext[ix,iy,*]+brcext[ix,iy,*])*dz[ix,iy,*])
   endfor
  endfor

end
