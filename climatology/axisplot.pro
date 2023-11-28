  pro axisplot, value_, lon_, lat_, lin

  a = where(lon_ ge 260 and lon_ le 342.5)
  lon = lon_[a]
  value = value_[a,*]
  a = where(lat_ ge 8 and lat_ le 20)
  lat = lat_[a]
  value = value[*,a]

; interpolate the latitude to higher resolution
  lati = interpol(lat,1000)

  nx = n_elements(lon)
  ny = n_elements(lati)
  plume = fltarr(nx)
  for ix = 0, nx-1 do begin
   valx = interpol(reform(value[ix,*]),1000,/quadratic)
   maxv = max(valx,/nan)
   plume[ix] = lati(where(valx eq maxv))
  endfor

  plots, lon, plume, linestyle=lin, thick=6

end
