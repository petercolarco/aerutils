; Check mass conservation for pinatubo aerosols

; Get the initial mass concentration
  filename = '/misc/prc18/colarco/F25b18/F25b18.inst3d_aer_v.20070101_0000z.nc4'
  nc4readvar, filename, 'so4', su
  nc4readvar, filename, 'delp', delp
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  su  = total(su*delp,3)/9.81  ; kg m-2
  su0 = total(su*area)         ; kg

; Get the budget for sulfate
  expid = 'F25b18'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suem003', suem_
  nc4readvar, filename, 'sudp003', sudp_
  nc4readvar, filename, 'susd003', susd_
  nc4readvar, filename, 'suwt003', suwt_
  nc4readvar, filename, 'susv003', susv_
  nc4readvar, filename, 'supso4g', supg_
  nc4readvar, filename, 'supso4wt', supwt_
  nc4readvar, filename, 'supso4aq', supaq_

  suem = fltarr(12)
  sudp = fltarr(12)
  susd = fltarr(12)
  suwt = fltarr(12)
  susv = fltarr(12)
  supg = fltarr(12)
  supwt = fltarr(12)
  supaq = fltarr(12)

; n days month
  nd = [31,28,31,30,31,30,31,31,30,31,30,31]

; Integrated kg of flux per month
  for i = 0, 11 do begin
   suem[i] = total(area*suem_[*,*,i])*86400.*nd[i]
   sudp[i] = total(area*sudp_[*,*,i])*86400.*nd[i]
   susd[i] = total(area*susd_[*,*,i])*86400.*nd[i]
   suwt[i] = total(area*suwt_[*,*,i])*86400.*nd[i]
   susv[i] = total(area*susv_[*,*,i])*86400.*nd[i]
   supg[i] = total(area*supg_[*,*,i])*86400.*nd[i]
   supwt[i] = total(area*supwt_[*,*,i])*86400.*nd[i]
   supaq[i] = total(area*supaq_[*,*,i])*86400.*nd[i]
  endfor

  prod = suem+supg+supwt+supaq
  loss = sudp+susd+suwt+susv

; Final mass (Dec. 1, 0z)
  filename = '/misc/prc18/colarco/F25b18/F25b18.inst3d_aer_v.20071201_0000z.nc4'
  nc4readvar, filename, 'so4', su
  nc4readvar, filename, 'delp', delp
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  su  = total(su*delp,3)/9.81  ; kg m-2
  su1 = total(su*area)         ; kg

end
