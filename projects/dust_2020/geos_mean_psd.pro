; Get the monthly mean dust AOD
  filename = '/misc/prc18/colarco/c180R_v202_ceds/tavg2d_aer_x/c180R_v202_ceds.tavg2d_aer_x.monthly.201906.nc4'
  nc4readvar, filename, 'duexttau', aod

; Get the PSD and delp
  filename = '/misc/prc18/colarco/c180R_v202_ceds/inst3d_aer_v/c180R_v202_ceds.inst3d_aer_v.monthly.201906.nc4'
  nc4readvar, filename, 'du0', du, /template
  nc4readvar, filename, 'delp', delp, /template, lon=lon, lat=lat

; Column integrate the PSD
  nx = n_elements(lon)
  ny = n_elements(lat)
  duc = fltarr(nx,ny,5)
  for ibin = 0, 4 do begin
   duc[*,*,ibin] = total(du[*,*,*,ibin]*delp,3)/9.81
  endfor

; Now average by the AOD
  dut = fltarr(5)
  for ibin = 0, 4 do begin
   dut[ibin] = total(duc[*,*,ibin]*aod)/total(aod)
  endfor

  print, dut/max(dut)

end
