  pro read_data, alt, ssa, ext, oa, bc, no3, so4

  openr, lun, 'ORACLES_20160924.csv', /get

  str = 'a'
  readf, lun, str

  datain_ = fltarr(7)
  readf, lun, datain_
  datain = datain_
  i = 1
  while(not(eof(lun))) do begin
   readf, lun, datain_
   datain = [datain,datain_]
   i = i+1
  endwhile
  free_lun, lun

  datain = reform(datain,7,i)
  alt = reform(datain[0,*])
  ssa = reform(datain[1,*])
  ext = reform(datain[2,*])
  oa  = reform(datain[3,*])
  bc  = reform(datain[4,*])
  nh3 = reform(datain[5,*])
  so4 = reform(datain[6,*])

  a = where(ssa lt 0 or alt gt 5500.)
  if(a[0] ne -1) then ssa[a] = !values.f_nan
  a = where(ext lt 0 or alt gt 5500.)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  a = where(oa lt 0 or alt gt 8000.)
  if(a[0] ne -1) then oa[a] = !values.f_nan
  a = where(bc lt 0 or alt gt 8000.)
  if(a[0] ne -1) then bc[a] = !values.f_nan
  a = where(nh3 lt 0 or alt gt 8000.)
  if(a[0] ne -1) then nh3[a] = !values.f_nan
  a = where(so4 lt 0 or alt gt 8000.)
  if(a[0] ne -1) then so4[a] = !values.f_nan

end
