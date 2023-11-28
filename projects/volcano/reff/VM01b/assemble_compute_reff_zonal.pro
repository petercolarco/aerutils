; Colarco, March 2017
; Use the compute_reff_zonal to get the zonal mean reff profiles from
; all of the control files, and save in an IDL save file

; Get the DDF to scan
  ddflist = file_search("*ddf")
  nf = n_elements(ddflist)

; Hard set some array sizes
  ny = 91
  nz = 72
  nt = 60

; Make the accumulating arrays
  reff  = fltarr(ny,nz,nt,nf)
  suext = fltarr(ny,nz,nt,nf)
  delp  = fltarr(ny,nz,nt,nf)
  p     = fltarr(ny,nz,nt,nf)

  for i = 0, nf -1 do begin
   compute_reff_zonal, ddflist[i], reff_, suext_, delp_, p_
   reff[*,*,*,i]  = reff_
   suext[*,*,*,i] = suext_
   delp[*,*,*,i]  = delp_
   p[*,*,*,i]     = p_
  endfor

  save, /variables, filename = 'compute_reff_zonal.sav'

end
