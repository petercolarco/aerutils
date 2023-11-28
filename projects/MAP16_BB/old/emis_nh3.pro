; Use the PFT mappings and the carbon loss to grid
; NH3
; emissions in kg m-2 s-1

; emission factors (from Table 1 in Darmenov & DaSilva, QFED,
; estimated) g kg-1 of dry matter burned
  etrop  = 0.84
  extrop = 2.72
  egrass = 0.52

; Get the PFT maps
  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_grass.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, fgrass
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_trop.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, ftrop
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_xtrop.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, fxtrop
   ncdf_close, cdfid

; Now get the time series of carbon loss and fractions
  nc4readvar, '/home/colarco/projects/MAP16_BB/clm4.5_closs.nc', 'closs', closs, lon=lon, lat=lat, nymd=nymd
;  nc4readvar, 'clm4.5_closs.nc', 'burn', burn, lon=lon, lat=lat, nymd=nymd

; Get the land fraction from text file
  openr, lun, '/home/colarco/projects/MAP16_BB/land_frac_DE720x360.txt', /get
  lfrac = fltarr(720,360)
  readf, lun, lfrac
  free_lun, lun
  lfrac = reverse(lfrac,2)
  ll = findgen(360)*.5 - 89.75
  a = where(ll ge min(lat) and ll le max(lat))
  lfrac = lfrac[*,a]


; override nymd
  n = indgen(n_elements(nymd))
  nymd = (1980+n/12)*10000L + (n mod 12 + 1)*100L + 1L
  ndays = intarr(n_elements(n))
  yyyy = (1980+n/12)
  mm = (n mod 12 + 1)
  a = where(mm eq 1 or mm eq 3 or mm eq 5 or mm eq 7 or $
            mm eq 8 or mm eq 10 or mm eq 12)
  ndays[a] = 31
  a = where(mm eq 4 or mm eq 6 or mm eq 9 or mm eq 11)
  ndays[a] = 30
  a = where(mm eq 2)
  b = where(yyyy[a]/4 eq yyyy[a]/4.)
  ndays[a] = 28.
  ndays[a[b]] = 29.


; put emisout on global grid
  nyout = 360
  latout = ll
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(n)
  emisout = make_array(nx,nyout,nt,val=0.)
  j0 = where(ll eq min(lat))
  for i = 0, nt-1 do begin
   emisout[*,j0:j0+ny-1,i] =  closs[*,*,i]/.45/1000. $     ; scaling carbon to kg dry matter
;                   * burn[*,*,i]*ndays[i]*86400. $; fraction land burned
                   * lfrac            $           ; land fraction
                   * (  fgrass*egrass $           ; grass fraction
                      + ftrop*etrop   $           ; tropical forest fraction
                      + fxtrop*extrop $           ; extra tropical forest frac
                     ) / 1000.                    ; scale emission factors to kg
  endfor

; units should be kg species m-2 s-1

  

; Dump to netcdf files
  cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/emis_nh3.nc',/clobber)
  idx = ncdf_dimdef(cdfid,'longitude',nx)
  idy = ncdf_dimdef(cdfid,'latitude', nyout)
  idt = ncdf_dimdef(cdfid,'time', nt)
  idv = ncdf_vardef(cdfid,'emis',[idx,idy,idt])
  idlon = ncdf_vardef(cdfid, 'longitude', [idx])
  idlat = ncdf_vardef(cdfid, 'latitude', [idy])
  idtim = ncdf_vardef(cdfid, 'time', [idt], /long)
  ncdf_control,cdfid,/endef
  ncdf_varput, cdfid, idv, emisout
  ncdf_varput, cdfid, idlon, lon
  ncdf_varput, cdfid, idlat, latout
  ncdf_varput, cdfid, idtim, nymd
  ncdf_close, cdfid


end
