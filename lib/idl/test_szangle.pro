  nymd = 19710605L
  nhms = 120000L

  lat2 = 1.
  lon2 = 1.
  area, lon, lat, nx, ny, dx, dy, area, grid='b', lon2=lon2, lat2=lat2

; Loop over a day
  tcosz = fltarr(nx,ny)
  tday  = fltarr(nx,ny)
  for ihr = 0, 23 do begin
   nhms = ihr*10000L
   szangle, nymd, nhms, lon2, lat2, sza, cossza
   contour, sza
   tcosz = tcosz + cossza
   a = where(cossza gt 0.)
   tday[a] = tday[a]+3600.
  endfor

  szangle, nymd, 120000L, lon2, lat2, sza, cossza

; oh_clim is the daily mean value of OH, which is assumed zero at
; night and some value larger than the daily mean during the day
; Purpose here is to derive a scaling to find the value "now"
; dependent on whether it is day or night
; In this example we use 3600 seconds as the time step size.
; So 86400./3600. is the number of time steps in a day (= 24)
; This scaling redistributes the OH across the day so that the daily
; mean value is oh_clim.  It works!
  oh_clim = 1000.
  xoh     = fltarr(nx*ny*1L,24)
  acossza = fltarr(nx*ny*1L,24)
  for ihr = 0, 23 do begin
   nhms = ihr*10000L
   szangle, nymd, nhms, lon2, lat2, sza, cossza
   a = where(cossza gt 0.)
   acossza[a,ihr] = cossza[a]
   xoh[a,ihr]  = oh_clim*(86400./3600.)*cossza[a]/tcosz[a]
  endfor
  xoh = reform(xoh,nx,ny,24)
  acossza = reform(acossza,nx,ny,24)


end
