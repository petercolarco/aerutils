; Colarco, March 2017
; Code to return the zonal mean, vertical effective particle radius
; and level pressure thickness given a DDF file template

  pro compute_reff_zonal, filetemplate, reff, suext, delp, p

  print, 'Reading fields: ', filetemplate
  ga_times, filetemplate, nymd, nhms, template=template
;  nymd = nymd[0:1]
;  nhms = nhms[0:1]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'su0', su, /template, lat=lat, lon=lon, lev=lev
  nc4readvar, filename, 'airdens', rhoa
  nc4readvar, filename, 'rh', rh
  nc4readvar, filename, 'suextcoef', suext
  nc4readvar, filename, 'delp', delp
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)

; Here I'm going to cheat since I just want zonal fields in the
; stratosphere anyway and do the zonal average now
  su = mean(su,dim=1)
  rhoa = mean(rhoa,dim=1)
  rh = mean(rh,dim=1)
  suext = mean(suext,dim=1)*1e6  ; Mm-1
  delp = mean(delp,dim=1)

; Compose a pressure coordinate for output
  p = make_array(ny,nz,nt)
  p[*,0,*] = 1.
  for iz = 1, nz-1 do begin
   p[*,iz,*] = p[*,iz-1,*] + delp[*,iz-1,*]
  endfor

; set up size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3

; Compute the effective radius at each grid cell
;  print, 'Processing fields'
  reff   = make_array(ny,nz,nt,val=!values.f_nan)
  suexto = make_array(ny,nz,nt,val=!values.f_nan)
  vtot   = make_array(ny,nz,nt,val=!values.f_nan)
  for it = 0, nt-1 do begin
  for iz = 0, nz-1 do begin
   for iy = 0, ny-1 do begin
    if(suext[iy,iz,it] gt 0) then begin
;     Compute growth factor for grid point RH
      gf  = sulfate_growthfactor(rh[iy,iz,it])
      dr_ = dr*gf
      r_  = r*gf
      dndr_ = su[iy,iz,it,*]/dr_ / (4./3.*!pi*r^3.*rhop)*rhoa[iy,iz,it]
      vtot[iy,iz,it] = total(r_^3.*dndr_*dr_)
      reff[iy,iz,it] = total(r_^3.*dndr_*dr_) / total(r_^2.*dndr_*dr_)
    endif
   endfor
  endfor
  endfor

end
