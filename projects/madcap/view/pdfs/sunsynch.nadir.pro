; Get and read Patricia's files to aggregate PDF of angles

; Let's read only the "nadir" portion of the ground track
  ix = 498

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB','*nc4')

  for ii = 0, n_elements(filen)-1 do begin

  print, filen[ii]
  fileo = strmid(filen[ii],strpos(filen[ii],'ss450-g5nr'))
  fileo = 'ss450/'+strmid(fileo,0,strlen(fileo)-4)+'.txt'

  cdfid = ncdf_open(filen[ii])
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'vaa')
  ncdf_varget, cdfid, id, vaa_, offset=[ix,0,0], count=[1,10,3600]
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_, offset=[ix,0,0], count=[1,10,3600]
  ncdf_close, cdfid

  a = where(sza_ le 80.)

  lon_  = reform(lon_[a])
  lat_  = reform(lat_[a])
  vza_  = reform(vza_[a])
  sza_  = reform(sza_[a])
  vaa_  = reform(vaa_[a])
  saa_  = reform(saa_[a])
  scat_ = reform(scat_[a])

  openw, lun, fileo, /get
  printf, lun, n_elements(a), 81, 91, 361, 361, 181
  printf, lun, lon_
  printf, lun, lat_

  psza = histogram(sza_,min=0.,max=80.,location=lsza)
  pvza = histogram(vza_,min=0.,max=90., location=lvza)
  psaa = histogram(saa_,min=0.,max=360., location=lsaa)
  pvaa = histogram(vaa_,min=0.,max=360., location=lvaa)
  psca = histogram(scat_,min=0.,max=180., location=lsca)

  printf, lun, psza
  printf, lun, pvza
  printf, lun, psaa
  printf, lun, pvaa
  printf, lun, psca

  free_lun, lun

  endfor


end
