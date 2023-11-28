; Define a sampling box
  maplimit = [0,-120,50,-20]
  latrange = [10,35]
  lonrange = [-100,-40]

; Read a day of coverage for GPM and SS450 @ 550km swath
  filename = '/misc/prc19/colarco/M2R12K/hourly/M2R12K.gpm.nodrag.550km.pm.hourly.20140901.nc4'
  nc4readvar, filename, 'dusmass', gpm, lon=lon, lat=lat
  filename = '/misc/prc19/colarco/M2R12K/hourly/M2R12K.sunsynch_450km_1330crossing.nodrag.550km.pm.hourly.20140901.nc4'
  nc4readvar, filename, 'dusmass', ss450, lon=lon, lat=lat

; Get the grid area
  area, lon, lat, nx, ny, dx, dy, area

; For efficiency, reduce the size of the grids
  b = where(lat ge maplimit[0] and lat le maplimit[2])
  a = where(lon ge maplimit[1] and lon le maplimit[3])
  gpm = gpm[a,*,*]
  gpm = gpm[*,b,*]
  ss450 = ss450[a,*,*]
  ss450 = ss450[*,b,*]

  lon = lon[a]
  lat = lat[b]
  area = area[a,*]
  area = area[*,b]
  nx = n_elements(a)
  ny = n_elements(b)

; Maskout bad values
  a = where(gpm gt 1e14)
  b = where(gpm lt 1e14)
  gpm[a] = !values.f_nan
  gpm[b] = 1.
  a = where(ss450 gt 1e14)
  b = where(ss450 lt 1e14)
  ss450[a] = !values.f_nan
  ss450[b] = 1.

; Make a map of the region
  set_plot, 'ps'
  device, file='hurricane_region.gpm.550km.ps', /color
  map_set, limit=maplimit

; Plot one day of orbits
  loadct, 39
  visit = intarr(nx,ny)
  visit[*,*] = 0
  for it = 0, 23 do begin
   visit[where(gpm[*,*,it] eq 1)] = 1
  endfor
  plotgrid, visit, [1], [176], lon, lat, dx, dy, /map

; Clean up plot
  map_set, limit=maplimit, /noerase
  map_continents, /hires, thick=2
  map_continents, /countries
  x0 = lonrange[0]
  x1 = lonrange[1]
  y0 = latrange[0]
  y1 = latrange[1]
  oplot, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], thick=3
  device, /close

; Find the area sampled by the box
  a = where(lon ge lonrange[0] and lon le lonrange[1])
  b = where(lat ge latrange[0] and lat le latrange[1])
  area_ = area[a,*]
  area_ = area_[*,b]
  visit_ = visit[a,*]
  visit_ = visit_[*,b]

  print, total(area_), total(area_[where(visit_ eq 1)]), $
         total(area_[where(visit_ eq 1)])/total(area_)




; Make a map of the region
  set_plot, 'ps'
  device, file='hurricane_region.ss450.550km.ps', /color
  map_set, limit=maplimit

; Plot one day of orbits
  loadct, 39
  visit = intarr(nx,ny)
  visit[*,*] = 0
  for it = 0, 23 do begin
   visit[where(ss450[*,*,it] eq 1)] = 1
  endfor
  plotgrid, visit, [1], [84], lon, lat, dx, dy, /map

; Clean up plot
  map_set, limit=maplimit, /noerase
  map_continents, /hires, thick=2
  map_continents, /countries
  x0 = lonrange[0]
  x1 = lonrange[1]
  y0 = latrange[0]
  y1 = latrange[1]
  oplot, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], thick=3
  device, /close

; Find the area sampled by the box
  a = where(lon ge lonrange[0] and lon le lonrange[1])
  b = where(lat ge latrange[0] and lat le latrange[1])
  area_ = area[a,*]
  area_ = area_[*,b]
  visit_ = visit[a,*]
  visit_ = visit_[*,b]

  print, total(area_), total(area_[where(visit_ eq 1)]), $
         total(area_[where(visit_ eq 1)])/total(area_)




; Make a map of the region
  set_plot, 'ps'
  device, file='hurricane_region.merge.550km.ps', /color
  map_set, limit=maplimit

; Plot one day of orbits
  loadct, 39
  visit = intarr(nx,ny)
  visit[*,*] = 0
  for it = 0, 23 do begin
   visit[where(ss450[*,*,it] eq 1 or gpm[*,*,it] eq 1)] = 1
  endfor
  plotgrid, visit, [1], [32], lon, lat, dx, dy, /map

; Clean up plot
  map_set, limit=maplimit, /noerase
  map_continents, /hires, thick=2
  map_continents, /countries
  x0 = lonrange[0]
  x1 = lonrange[1]
  y0 = latrange[0]
  y1 = latrange[1]
  oplot, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], thick=3
  device, /close

; Find the area sampled by the box
  a = where(lon ge lonrange[0] and lon le lonrange[1])
  b = where(lat ge latrange[0] and lat le latrange[1])
  area_ = area[a,*]
  area_ = area_[*,b]
  visit_ = visit[a,*]
  visit_ = visit_[*,b]

  print, total(area_), total(area_[where(visit_ eq 1)]), $
         total(area_[where(visit_ eq 1)])/total(area_)

end
