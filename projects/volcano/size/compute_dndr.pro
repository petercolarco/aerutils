; Colarco, March 2017
; Code to return the zonal mean, vertical effective particle radius
; and level pressure thickness given a DDF file template

  pro compute_dndr, filetemplate, wantlat, itime, dndr_, r_, dr_

  print, 'Reading fields: ', filetemplate
  ga_times, filetemplate, nymd, nhms, template=template
  nymd = nymd[itime]
  nhms = nhms[itime]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'su0', su, /template, lat=lat, lon=lon, lev=lev, $
   wantlat = wantlat+[-5.,5.]
  nc4readvar, filename, 'airdens', rhoa, wantlat = wantlat+[-5.,5.]
  nc4readvar, filename, 'rh', rh, wantlat = wantlat+[-5.,5.]
  nc4readvar, filename, 'suextcoef', suext, wantlat = wantlat+[-5.,5.]
  nc4readvar, filename, 'delp', delp, wantlat = wantlat+[-5.,5.]
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

; And now do the latitudinal average
  su = mean(su,dim=1)
  rhoa = mean(rhoa,dim=1)
  rh = mean(rh,dim=1)
  suext = mean(suext,dim=1)
  delp = mean(delp,dim=1)

; Choose 30 hPa
  iz = 31

; set up size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3

; Compute the effective radius at each grid cell
;  print, 'Processing fields'
;     Compute growth factor for grid point RH
      gf  = sulfate_growthfactor(rh[iz])
      dr_ = dr*gf
      r_  = r*gf
      dndr_ = su[iz,*]/dr_ / (4./3.*!pi*r^3.*rhop)*rhoa[iz]
dndr_ = reform(dndr_)

end
