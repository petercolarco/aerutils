; Make a map of the selected stations
  cdfid = ncdf_open('c180R_J10p17p1dev_aura.inst3d_aer_v.aeronet.ext-1020nm.2016.bc.nc')
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnname
  stnname = strcompress(string(stnname),/rem)
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  ncdf_close, cdfid




  set_plot, 'ps'
  device, file='map.ps', /color, font_size=12, $
   xsize=24, ysize=24
  !p.font=0
  map_set, limit=[-40,-30,10,40]
  map_continents, /hires, /countries
  map_continents, /hires, thick=3

  for j = 0, n_elements(stnname) - 1 do begin
   stnWant = stnname[j]
   getaeronetaod, stnWant, 'AOD_340nm', time, aodo
   a = where(finite(aodo[496:735]) eq 1)
   if(n_elements(a) lt 4) then continue
   plots, lon[j], lat[j], psym=sym(1)
   xyouts, lon[j]+.5, lat[j]-.2, stnname[j], charsize=.6
  endfor
  device, /close
  

end
