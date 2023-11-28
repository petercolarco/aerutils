; Colarco, May 2016
; Read 18z for each flight day, 
; save in latitude range 10 - 25 N,
; interpolate to common height grid,
; and write a text file with all the information

; Get the files
  dd = ['20','22','27','29','30']
  so2out = fltarr(16,6)
  for i = 0, 4 do begin
   print, i
   cdfid = ncdf_open('http://opendap.nccs.nasa.gov:80/dods/GEOS-5/fp/0.25_deg/assim/inst3_3d_aer_Nv')
    id = ncdf_varid(cdfid,'lon')
    ncdf_varget, cdfid, id, lon
    id = ncdf_varid(cdfid,'lat')
    ncdf_varget, cdfid, id, lat
    id = ncdf_varid(cdfid,'time')
    ncdf_varget, cdfid, id, time
    jtime = julday(1,1,1,0)+time
    caldat, jtime, m, d, y, h
    a = where(m eq 10 and y eq 2015 and d eq fix(dd[i]) and h eq 18)
    id = ncdf_varid(cdfid,'so2')
    ncdf_varget, cdfid, id, so2, offset=[0,0,0,a[0]], count=[576,361,72,1]
    so2 = so2/64.*28.*1e12  ; pptv
    so2 = mean(so2,dim=1) ; zonal mean
   ncdf_close, cdfid
   cdfid = ncdf_open('http://opendap.nccs.nasa.gov:80/dods/GEOS-5/fp/0.25_deg/assim/inst3_3d_asm_Nv')
    id = ncdf_varid(cdfid,'time')
    ncdf_varget, cdfid, id, time
    jtime = julday(1,1,1,0)+time
    caldat, jtime, m, d, y, h
    a = where(m eq 10 and y eq 2015 and d eq fix(dd[i]) and h eq 18)
    id = ncdf_varid(cdfid,'h')
    ncdf_varget, cdfid, id, h, offset=[0,0,0,a[0]], count=[576,361,72,1]
    h = h/1000.           ; km
    h = mean(h,dim=1)     ; zonal mean
   ncdf_close, cdfid

;  Save the latitude profiles
   a = where(lat ge 10 and lat le 25)
   h = mean(h[a,*],dim=1)
   so2 = mean(so2[a,*],dim=1)
;  Create a mean profile in 1 km increments
   for j = 10, 25 do begin
    iz = interpol(indgen(n_elements(h)),h,j)
    so2out[j-11,i+1] = interpolate(so2,iz)
   endfor

  endfor

  height = 10+findgen(16)
  so2out[*,0] = height

  openw, lun, 'GEOS5_virgas2_profiles.assim_zonal.txt', /get
  printf, lun, transpose(so2out)
  free_lun, lun


end
