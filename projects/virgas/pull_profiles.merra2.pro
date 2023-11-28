; Colarco, May 2016
; Read my VIRGAS sampled curtains, 
; save in latitude range 10 - 25 N,
; interpolate to common height grid,
; and write a text file with all the information

; Get the VIRGAS trajectories
  cdfid = ncdf_open('virgas_1min_v2.nc')
   id = ncdf_varid(cdfid,'date')
   ncdf_varget, cdfid, id, nymdv
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, ssv
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, latv
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lonv
   id = ncdf_varid(cdfid,'alt_m')
   ncdf_varget, cdfid, id, altmv
  ncdf_close, cdfid

; Get the files
  dd = ['20','22','27','29','30']
  so2out = make_array(16,6,val=!values.f_nan)
  for i = 0, 4 do begin
;  Find valid dates in virgas data
   a = where(nymdv eq 20151000L+fix(dd[i]))
   alttmp = altmv[a]/1000.
   cdfid = ncdf_open('GEOS5_virgas2_merra2_201510'+dd[i]+'.nc')
    id = ncdf_varid(cdfid,'time')
    ncdf_varget, cdfid, id, time
    id = ncdf_varid(cdfid,'trjLon')
    ncdf_varget, cdfid, id, lon
    id = ncdf_varid(cdfid,'trjLat')
    ncdf_varget, cdfid, id, lat
    id = ncdf_varid(cdfid,'H')
    ncdf_varget, cdfid, id, h
    h = h/1000.  ; km
    id = ncdf_varid(cdfid,'SO2')
    ncdf_varget, cdfid, id, so2
    so2 = so2/64.*28.*1e12  ; pptv
    id = ncdf_varid(cdfid,'AIRDENS')
    ncdf_varget, cdfid, id, rhoa
   ncdf_close, cdfid

;  Now check that same number of elements in VIRGAS data as in extract
   if(n_elements(alttmp) ne n_elements(time)) then stop

;  Now find height on model profile closest to VIRGAS height
   so2_ = fltarr(n_elements(alttmp))
   for j = 0, n_elements(alttmp)-1 do begin
    b = where(abs(h[*,j]-alttmp[j]) eq min(abs(h[*,j]-alttmp[j])))
    so2_[j] = so2[b[0],j]
   endfor

;  Save the latitude profiles
   a = where(lat ge 10.5 and lat le 25.5 and $
             alttmp ge 10 and alttmp le 25)
   alttmp = alttmp[a]
   so2_   = so2_[a]

;  Create a mean profile in 1 km increments
   for j = 10, 25 do begin
    a = where(alttmp ge j-.5 and alttmp lt j+.5)
    if(a[0] ne -1) then so2out[j-10,i+1] = mean(so2_[a])
   endfor

  endfor

  height = 10+findgen(16)
  so2out[*,0] = height

  openw, lun, 'GEOS5_virgas2_merra2_profiles.txt', /get
  printf, lun, transpose(so2out)
  free_lun, lun


end
