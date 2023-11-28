; Volcanic SO2 profile suitable for TongaMIP experiments
; Guidance is 0.5 Tg SO2 injected over 6 hour period
; from 30 - 35 km altitude in constant VMR, starting on
; 0400 UTC January 15th, 2022 and spread over an area 
; from 22 - 14 S and 178 - 174 W

  so2 = 0.5  ; Tg SO2

  lat0 = -22.
  lat1 = -14.
  lon0 = -178.
  lon1 = -174.

  t0 = 4  ; start time UTC hours
  t1 = 10 ; end time UTC hours

  z0 = 30 ; altitude of plume bottom [km]
  z1 = 35 ; altitude of plume top [km]

  dxy = 0.5  ; degrees to discretize the lat/lon distribution
  dz  = 0.5 ; km to discretize the vertical injection

; Create the grids
  nx = (lon1-lon0)/dxy
  ny = (lat1-lat0)/dxy
  lon = findgen(nx)*dxy+lon0+dxy/2.
  lat = findgen(ny)*dxy+lat0+dxy/2.
  nz = (z1-z0)/dz
  z = findgen(nz)*dz+z0+dz/2.

; Following is a constant mass profile
  dt = (t1-t0)*3600. ; seconds to inject over, used to scale flux
  so2flux_ = fltarr(nx,ny,nz)
  so2flux_[*] = so2/dt/(nx*ny*nz)*1.e9 ; kg so2/s

; Try to work on VMR profile (assume same in all columns)
  so2col = so2/dt/(nx*ny)*1.e9 ; kg so2/s/col
; Get an atmosphere
  atmosphere, p_, pe_, delp_, z_, ze_, delz_, t_, te_, rhoa_
  rhoa = interpol(rhoa_,z_/1000.,z) ; interpolated density to my locations
  so2prf = fltarr(nz)
  vmr = 1.d-9        ; fixed number, will normalize
  so2prf = vmr*rhoa  ; go to absolute mass
; integrate to normalize
  so2int = total(so2prf)
  so2prf = so2col/so2int*so2prf
  so2flux = fltarr(nx,ny,nz)
  
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    so2flux[ix,iy,*] = so2prf
   endfor
  endfor

; Write to a file
  openw, lun, 'so2_volcanic_emissions_TongaMIP_exp4.20220115.rc', /get
  printf, lun, '###  LAT (-90,90), LON (-180,180), SULFUR [kg S/s], ELEVATION [m], CLOUD_COLUMN_HEIGHT [m]'
  printf, lun, '### If elevation=cloud_column_height, emit in layer of elevation'
  printf, lun, '### else, emit in top 1/3 of cloud_column_height'
  printf, lun, 'volcano::'
  zm = z*1000. ; altitude in m
  sflux = so2flux/2.
  time0 = '040000'
  time1 = '100000'
  for iz = 0, nz-1 do begin
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     printf, lun, lat[iy], lon[ix], sflux[ix,iy,iz], zm[iz], zm[iz], $
                  time0, time1, $
                  format='(f7.3,2x,f8.3,2x,e12.4,2x,i5,2x,i5,2x,a6,2x,a6)'
    endfor
   endfor
  endfor
  printf, lun, '::'
  free_lun, lun

end
