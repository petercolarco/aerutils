cdfid = ncdf_open('geos_daily_zonal.nc')
id = ncdf_varid(cdfid,'aod')
ncdf_varget, cdfid, id, base
ncdf_close, cdfid

cdfid = ncdf_open('geos_daily_zonal.g2g.nc')
id = ncdf_varid(cdfid,'aod')
ncdf_varget, cdfid, id, g2g
ncdf_close, cdfid

a = where(g2g gt 1e15)
g2g[a] = !values.f_nan

plot, g2g[0,60,*]-base[0,60,*]

end
