; Colarco, May 2016
; Read my VIRGAS sampled curtains, 
; save in latitude range 10 - 25 N,
; interpolate to common height grid,
; and write a text file with all the information

; Get the files
  dd = ['20','22','27','29']
  so2out = fltarr(16,5)
  for i = 0, 3 do begin
   cdfid = ncdf_open('GEOS5_virgas2_merra2_201510'+dd[i]+'.nc')
    id = ncdf_varid(cdfid,'time')
    ncdf_varget, cdfid, id, time
    id = ncdf_varid(cdfid,'trjLon')
    ncdf_varget, cdfid, id, lon
    id = ncdf_varid(cdfid,'trjLat')
    ncdf_varget, cdfid, id, lat
    id = ncdf_varid(cdfid,'H')
    ncdf_varget, cdfid, id, h
    h = h /1000.  ; km
    id = ncdf_varid(cdfid,'SO2')
    ncdf_varget, cdfid, id, so2
    so2 = so2*1e12  ; pptv
    id = ncdf_varid(cdfid,'AIRDENS')
    ncdf_varget, cdfid, id, rhoa
   ncdf_close, cdfid
;  Save the latitude profiles
   a = where(lat ge 10.5 and lat le 25.5 and $
             h ge 10 and h le 25)
   h = h[a]
   lat = lat[a]
   lon = lon[a]
   time = time[a]
   so2 = so2[a]
   rhoa = rhoa[a]
;  Create a mean profile in 1 km increments
   for j = 10, 25 do begin
    a = where(h ge j-.5 and h lt j+.5)
    so2out[j-11,i+1] = mean(so2[a])
   endfor

  endfor

  height = 10+findgen(16)
  so2out[*,0] = height

  openw, lun, 'GEOS5_virgas2_merra2_profiles.txt', /get
  printf, lun, transpose(so2out)
  free_lun, lun


end
