; Colarco
; Get the model on nav track
; Pass in lon, lat of track and return extracted field

  pro get_model_navtrack, url, varwant, varout, $
                          lonf, latf, lev, wanttime=wanttime, template=template

  lon0 = min(lonf)-1.
  lon1 = max(lonf)+1.
  lat0 = min(latf)-1.
  lat1 = max(latf)+1.

  wantlon = [lon0,lon1]
  wantlat = [lat0,lat1]

  ga_getvar, url, varwant, varout_, lon=lon, lat=lat, lev=lev, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, template=template

; Now interpolate the model to the flight tracks
  ix = interpol(indgen(n_elements(lon)),lon,lonf)
  iy = interpol(indgen(n_elements(lat)),lat,latf)
  nz = n_elements(lev)
  nx = n_elements(lonf)
  varout = fltarr(nx,nz)
  a = where(varout_ gt 1e14)
  if(a[0] ne -1) then varout_[a] = !values.f_nan
  for iz = 0, nz-1 do begin
   varout[*,iz] = interpolate(varout_[*,*,iz],ix,iy)
  endfor

end
