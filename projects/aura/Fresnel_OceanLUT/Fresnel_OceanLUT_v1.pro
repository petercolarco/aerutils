; Colarco, Nov. 12, 2015
; This will read the Fresnel_OceanLUT_v1.he4 (converted to nc) file
; that Santiago provides.  Dimensions are (nwave,nsza,nvza,naa) =
; (2,16,16,16)

; Source of this is from research OMI code

  cdfid = ncdf_open('Fresnel_OceanLUT_v1.nc')
  id = ncdf_varid(cdfid,'OceanLER_ai')
  ncdf_varget, cdfid, id, ler
  ncdf_close, cdfid

; Dump this to a flat binary file
  openw, lun, 'Fresnel_OceanLUT_v1.bin', /get, /F77_UNFORMATTED
  for iw = 0, 15 do begin
   for iz = 0, 15 do begin
    for iy = 0, 15 do begin
     for ix = 0, 1 do begin
      writeu, lun, ler[ix,iy,iz,iw]
     endfor
    endfor
   endfor
  endfor
  free_lun, lun


end
