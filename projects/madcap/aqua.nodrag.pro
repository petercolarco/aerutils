  cdfid = ncdf_open('c180R_pI33p7.aqua.nodrag.201601.nc')
   id = ncdf_varid(cdfid,'isotime')
   ncdf_varget, cdfid, id, isotime
   isotime = string(isotime)
   nymd = strmid(isotime,0,4)+strmid(isotime,5,2)+strmid(isotime,8,2)
   hh   = strmid(isotime,11,2)
   mm   = strmid(isotime,14,2)
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau
  ncdf_close, cdfid

; get local time hour
  tt  = hh+mm/60.d
  ttl = tt+lon/15
  ttl[where(ttl ge 24., /null)] = ttl[where(ttl ge 24., /null)]-24.
  ttl[where(ttl lt 0., /null)]  = ttl[where(ttl lt 0.,  /null)]+24.
  map_set, /cont
  map_grid
  plots, lon, lat
  plots, lon, lat, psym=sym(2)
  a = where(lat gt -2 and lat lt 2)
  plots, lon[a], lat[a], psym=sym(1)
  oplot, [-1,1], [0,0]



end
