  cdfid = ncdf_open('/share/colarco/GAAS/src/Components/missions/A-CCP/c1440_NR.hr.gpm.nodrag.20060605_0000z.nc')
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat
  ncdf_close, cdfid


  map_set, /cont, limit=[0,40,20,55]
  plots, lon[*,0,0], lat[*,0,0], psym=3
  plots, lon[*,9,0], lat[*,9,0], psym=3
  plots, lon[*,0,10], lat[*,0,10], psym=3, color=120
  plots, lon[*,9,10], lat[*,9,10], psym=3, color=120


end
