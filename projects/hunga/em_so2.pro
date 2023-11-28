  filename = 'GMI_HTeruption.tavg24_3d_dac_Nv.20220115.nc4'
  filename = 'GMI_HTerup12hr.tavg24_3d_dac_Nv.20220115.nc4'
  nc4readvar, filename, 'em_so2', em_so2, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
; Above two lines use my own IDL reader...

  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = 0.5
  dy = 0.5
  area, lon, lat, nx, ny, dx, dy, area
; Above function is my own IDL code to get the grid box areas

; Reform
  em_so2 = reform(em_so2,1L*nx*ny,72) ; mol mol-1
  delp = reform(delp,1L*nx*ny,72)
; Below line I am finding the grid cells that have a high altitude
; emission, i.e., where the volcano is
  a = where(em_so2[*,30] gt 1.e-16)
  area = reform(area,1L*nx*ny)

; Vertical integral
  em_so2 = em_so2*64./29.  ; mol mol-1 -> kg kg-1
  em_tot = total(em_so2*delp/9.81,2) ; kg m-l2 s-1

; Print the total emissions for the Hunga grid boxes and scale to Tg
  print, total(em_tot[a]*area[a]*86400./1e9)  ; seconds in day


end
