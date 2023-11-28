; Get and read Patricia's files to aggregate PDF of angles

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB','*nc4')

  for ii = 0, n_elements(filen)-1 do begin

  fileo = strmid(filen[ii],strpos(filen[ii],'ss450-g5nr'))
  fileo = 'ss450/'+strmid(fileo,0,strlen(fileo)-4)+'.txt'

  cdfid = ncdf_open(filen[ii])
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

  nx = n_elements(lon_)
  jj = 0
  for ix = 0, nx-1 do begin

   a = where(sza_[*,ix] le 80.)
   if(n_elements(a) eq 10) then begin
    if(jj eq 0) then begin
     lon  = lon_[ix]
     lat  = lat_[ix]
     vza  = vza_[*,ix]
     sza  = sza_[*,ix]
     vaa  = vaa_[*,ix]
     saa  = saa_[*,ix]
     scat = scat_[*,ix]
     jj = 1
    endif else begin
     lon  = [lon,lon_[ix]]
     lat  = [lat,lat_[ix]]
     vza  = [vza,vza_[*,ix]]
     sza  = [sza,sza_[*,ix]]
     vaa  = [vaa,vaa_[*,ix]]
     saa  = [saa,saa_[*,ix]]
     scat = [scat,scat_[*,ix]]
    endelse
   endif
  endfor

  print, fileo, n_elements(lon)
  openw, lun, fileo, /get
  printf, lun, n_elements(lon), 81, 91, 361, 361, 181
  printf, lun, lon
  printf, lun, lat

  psza = histogram(sza,min=0.,max=80.,location=lsza)
  pvza = histogram(vza,min=0.,max=90., location=lvza)
  psaa = histogram(saa,min=0.,max=360., location=lsaa)
  pvaa = histogram(vaa,min=0.,max=360., location=lvaa)
  psca = histogram(scat,min=0.,max=180., location=lsca)

  printf, lun, psza
  printf, lun, pvza
  printf, lun, psaa
  printf, lun, pvaa
  printf, lun, psca

  free_lun, lun

  endfor


end
