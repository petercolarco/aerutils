; Verify that random generated pixel information maps to the right
; place in the files Patricia provides.

  satid = 'gpm'

  filen = '../'+satid+'/'+satid+'.random.200601.txt'
  read_random, filen, lon, lat, $
               vza, sza, vaa, saa, scat, $
               date, time

; Filename for initial GPM time
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB','*'+date[0]+'*')
  cdfid = ncdf_open(filen[0])
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon_
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat_
  id = ncdf_varid(cdfid,'time_ss')
  ncdf_varget, cdfid, id, time_
  id = ncdf_varid(cdfid,'vza_ss')
  ncdf_varget, cdfid, id, vza_
  id = ncdf_varid(cdfid,'sza_ss')
  ncdf_varget, cdfid, id, sza_
  id = ncdf_varid(cdfid,'saa_ss')
  ncdf_varget, cdfid, id, saa_
  id = ncdf_varid(cdfid,'vaa_ss')
  ncdf_varget, cdfid, id, vaa_
  id = ncdf_varid(cdfid,'scatAngle_ss')
  ncdf_varget, cdfid, id, scat_
  ncdf_close, cdfid

end
