  pro read_argos, filename, lon, lat, time, sza, $
                  ext=ext, h=h, lev=lev, tau=tau

  print, filename, systime()

; Check if reading csv or nc
  fileend = strmid(filename,1,2,/rev)

  if(fileend ne 'nc') then begin
  openr, lun, filename, /get
  str = 'a'
  readf, lun, str
  readf, lun, str
  str_ = strsplit(str,',',/extract)
  lon = str_[0]
  lat = str_[1]
  time = str_[2]
  i = 0
  while(not(eof(lun))) do begin
;  while(i lt 10000) do begin
   readf, lun, str
   str_ = strsplit(str,',',/extract)
   lon = [lon,str_[0]]
   lat = [lat,str_[1]]
   time = [time,str_[2]]
;   print, str_[2]
   i = i + 1
  endwhile
  free_lun, lun


  endif else begin

  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'isotime')
  ncdf_varget, cdfid, id, time
  time = string(time)
  if(keyword_set(ext)) then begin
   id = ncdf_varid(cdfid,'TOTEXTCOEF870')
   ncdf_varget, cdfid, id, ext
   id = ncdf_varid(cdfid,'lev')
   ncdf_varget, cdfid, id, lev
  endif
  if(keyword_set(h)) then begin
   id = ncdf_varid(cdfid,'H')
   ncdf_varget, cdfid, id, h
   id = ncdf_varid(cdfid,'lev')
   ncdf_varget, cdfid, id, lev
  endif
  if(keyword_set(tau)) then begin
   id = ncdf_varid(cdfid,'TOTSTEXTTAU870')
   ncdf_varget, cdfid, id, tau
  endif
  ncdf_close, cdfid

  endelse

  iso_to_nymd, time, nymd, nhms
  szangle, nymd, nhms, lon, lat, sza, cossza

end
