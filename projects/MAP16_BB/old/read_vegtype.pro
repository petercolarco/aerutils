; Colarco, July 2018
; Read the vegetation fraction definitions for 0.5 x 0.5 grid (same as
; for Catchments)
; I take the PFT fractions per grid and map them to the three Andreae
; & Merlet vegetation type (tropical forest, extratropical forest, and
; grass)
; From Fanwei and file is here:
; /discover/nobackup/fzeng/bcs/Icarus-NL/Icarus-NL_Reynolds/DE_00720x00360_PE_0720x0360/clsm/CLM_veg_typs_fracs
;Column 1 is tile index;
;Columns 3-6 are the vegetation types;
;Columns 7-10 are the corresponding fractions.
;[See /discover/nobackup/fzeng/bcs/Icarus-NL/Icarus-NL_Reynolds/DE_00720x00360_PE_0720x0360/clsm/README for this information.]
;
;Here is the description of the 19 pfts we will use for the updated CLM4.5 Catchment-CN (same as that used for CLM4 Catchment-CN). 
;
;PFT     Description
; 0     bare
; 1     needleleaf evergreen temperate tree
; 2     needleleaf evergreen boreal tree
; 3     needleleaf deciduous boreal tree
; 4     broadleaf evergreen tropical tree
; 5     broadleaf evergreen temperate tree
; 6     broadleaf deciduous tropical tree
; 7     broadleaf deciduous temperate tree
; 8     broadleaf deciduous boreal tree
; 9     broadleaf evergreen temperate shrub
; 10     broadleaf deciduous temperate shrub [moisture + deciduous]
; 11     broadleaf deciduous temperate shrub [moisture stress only]
; 12     broadleaf deciduous boreal shrub
; 13     arctic c3 grass
; 14     cool c3 grass [moisture + deciduous]
; 15     cool c3 grass [moisture stress only]
; 16     warm c4 grass [moisture + deciduous]
; 17     warm c4 grass [moisture stress only]
; 18     crop          [moisture + deciduous]
; 19     crop          [moisture stress only]

  pro read_vegtype, ntile, ftrop, fxtrop, fgrass

;  read_cdef, ntile, lnmax, lnmin, ltmax, ltmin

; classify PFT to A&M type
  ctrop   = [4, 6]
  cxtrop  = [1, 2, 3, 5, 7, 8]
  cgrass  = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]

  openr, lun, '/home/colarco/projects/MAP16_BB/CLM_veg_typs_fracs', /get_lun
  data_ = fltarr(14)
  icnt = 0L
  while(not(eof(lun))) do begin
   icnt = icnt+1
   readf, lun, data_
   if(icnt eq 1) then data = data_ else data = [data,data_]
  endwhile
  data = transpose(reform(data,14,icnt))

; At this point need to assign fractions per grid
  ntile = data[*,0]
  ftrop  = make_array(n_elements(ntile),val=0.)
  fxtrop = make_array(n_elements(ntile),val=0.)
  fgrass  = make_array(n_elements(ntile),val=0.)

; Now assign
  for i = 0L, icnt-1 do begin
   for j = 2,5 do begin
    a = where(fix(data[i,j]) eq ctrop)
    if(a[0] ne -1) then ftrop[i]= ftrop[i]+data[i,j+4]/100.
    a = where(fix(data[i,j]) eq cxtrop)
    if(a[0] ne -1) then fxtrop[i]= fxtrop[i]+data[i,j+4]/100.
    a = where(fix(data[i,j]) eq cgrass)
    if(a[0] ne -1) then fgrass[i]= fgrass[i]+data[i,j+4]/100.
   endfor
  endfor
; one grid where fgrass > 0
  a = where(fgrass gt 1.)
  if(a[0] ne -1) then fgrass[a] = 1.
  a = where(ftrop gt 1.)
  if(a[0] ne -1) then ftrop[a] = 1.
  a = where(fxtrop gt 1.)
  if(a[0] ne -1) then fxtrop[a] = 1.



end
