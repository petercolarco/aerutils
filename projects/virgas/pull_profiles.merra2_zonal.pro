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
   cdfid = ncdf_open('/misc/prc13/MERRA2/inst3_3d_aer_Nv/MERRA2_400.inst3_3d_aer_Nv.201510'+dd[i]+'.nc4')
    id = ncdf_varid(cdfid,'lon')
    ncdf_varget, cdfid, id, lon
    id = ncdf_varid(cdfid,'lat')
    ncdf_varget, cdfid, id, lat
    id = ncdf_varid(cdfid,'SO2')
    ncdf_varget, cdfid, id, so2
    so2 = so2/64.*28.*1e12  ; pptv
    so2 = mean(so2,dim=1) ; zonal mean
    so2 = so2[*,*,6]      ; 18z
   ncdf_close, cdfid
   cdfid = ncdf_open('/misc/prc13/MERRA2/inst3_3d_asm_Nv/MERRA2_400.inst3_3d_asm_Nv.201510'+dd[i]+'.nc4')
    id = ncdf_varid(cdfid,'H')
    ncdf_varget, cdfid, id, h
    h = h/1000.           ; km
    h = mean(h,dim=1)     ; zonal mean
    h = h[*,*,6]          ; 18z
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

  openw, lun, 'GEOS5_virgas2_profiles.merra2_zonal.txt', /get
  printf, lun, transpose(so2out)
  free_lun, lun


end
