; GMI version...
; Volcanic H2O profile suitable for TongaMIP experiments
; Guidance is 150 Tg H2O injected over 6 hour period
; from 25 - 30 km altitude in constant VMR, starting on
; 0400 UTC January 15th, 2022 and spread over an area 
; from 22 - 14 S and 178 - 174 W

  h2o = 150.  ; Tg H2O

  lat0 = -22.
  lat1 = -14.
  lon0 = -178.
  lon1 = -174.

  t0 = 4  ; start time UTC hours
  t1 = 10 ; end time UTC hours

  z0 = 25 ; altitude of plume bottom [km]
  z1 = 30 ; altitude of plume top [km]

  dxy = 0.5  ; degrees to discretize the lat/lon distribution
  dz  = 0.5  ; km to discretize the vertical injection

; Create the grids
  nx = (lon1-lon0)/dxy
  ny = (lat1-lat0)/dxy
  lon = findgen(nx)*dxy+lon0+dxy/2.
  lat = findgen(ny)*dxy+lat0+dxy/2.
  nz = (z1-z0)/dz
  z = findgen(nz)*dz+z0+dz/2.

; Following is a constant mass profile
  dt = (t1-t0)*3600. ; seconds to inject over, used to scale flux
  h2oflux_ = fltarr(nx,ny,nz)
  h2oflux_[*] = h2o/dt/(nx*ny*nz)*1.e9 ; kg h2o/s

; Try to work on VMR profile (assume same in all columns)
  h2ocol = h2o/dt/(nx*ny)*1.e9 ; kg h2o/s/col
; Get an atmosphere
  atmosphere, p_, pe_, delp_, z_, ze_, delz_, t_, te_, rhoa_
  rhoa = interpol(rhoa_,z_/1000.,z) ; interpolated density to my locations
  h2oprf = fltarr(nz)
  vmr = 1.d-9        ; fixed number, will normalize
  h2oprf = vmr*rhoa  ; go to absolute mass
; integrate to normalize
  h2oint = total(h2oprf)
  h2oprf = h2ocol/h2oint*h2oprf
  h2oflux = fltarr(nx,ny,nz)
  
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    h2oflux[ix,iy,*] = h2oprf
   endfor
  endfor

; Write to a file
  openw, lun, 'h2o_volcanic_emissions_TongaMIP_exp2.GMI_ht_only.20220115.rc', /get
  printf, lun, '###  LAT (-90,90), LON (-180,180), WATER [kg H2O/s], ELEVATION [m], CLOUD_COLUMN_HEIGHT [m]'
  printf, lun, 'H2O::'
  zm = z*1000. ; altitude in m
  time0 = '040000'
  time1 = '100000'
  for iz = 0, nz-1 do begin
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     printf, lun, lat[iy], lon[ix], h2oflux[ix,iy,iz], zm[iz], zm[iz], $
                  time0, time1, $
                  format='(f7.3,2x,f8.3,2x,e12.4,2x,i5,2x,i5,2x,a6,2x,a6)'
    endfor
   endfor
  endfor
  printf, lun, '::'
  free_lun, lun

end
