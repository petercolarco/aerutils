; Use the PFT mappings and the carbon loss along with the peat carbon
; loss to grid emissions in kg m-2 s-1

; Species
  species = ['bc', 'co', 'co2', 'nh3', 'oc', 'so2']

; Emission factors (from GFED tables)
  egrass  = [0.37,  63, 1686, 0.52, 2.62, 0.48]
  eboreal = [0.50, 127, 1489, 2.72, 9.60, 1.10]
  etemp   = [0.50,  88, 1647, 0.84, 9.60, 1.10]
  etrop   = [0.52,  93, 1643, 1.33, 4.71, 0.40]
  epeat   = [0.04, 210, 1703, 1.33, 6.02, 0.40]
  eagri   = [0.75, 102, 1585, 2.17, 2.30, 0.40]

; Get the PFT maps
  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_grass.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, fgrass
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_agri.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, fagri
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_temp.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, ftemp
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_trop.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, ftrop
   ncdf_close, cdfid

  cdfid = ncdf_open('/home/colarco/projects/MAP16_BB/pft_boreal.nc')
   id = ncdf_varid(cdfid,'frac')
   ncdf_varget, cdfid, id, fboreal
   ncdf_close, cdfid

; Now get the time series of carbon loss and fractions
  nc4readvar, '/home/colarco/projects/MAP16_BB/clm4.5_closs.nc', 'closs', closs, lon=lon, lat=lat, nymd=nymd ; vegetation
  nc4readvar, '/home/colarco/projects/MAP16_BB/clm4.5_closs.nc', 'som_closs', som_closs, lon=lon, lat=lat, nymd=nymd ; peat

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
  for ispec = 0, n_elements(species)-1 do begin

print, species[ispec]

   emisout = make_array(nx,nyout,nt,val=0.)
   j0 = where(ll eq min(lat))
   for i = 0, nt-1 do begin
;   units should be kg species m-2 s-1
    emisout[*,j0:j0+ny-1,i] =  closs[*,*,i]/.45/1000. $     ; scaling carbon to kg dry matter
                    * lfrac            $           ; land fraction
                    * (  fgrass*egrass[ispec] $    ; grass fraction
                       + ftrop*etrop[ispec]   $    ; tropical forest fraction
                       + ftemp*etemp[ispec]   $    ; temperate forest fraction
                       + fboreal*eboreal[ispec]  $ ; boreal forest fraction
                       + fagri*eagri[ispec] $      ; agricultural frac
                      ) / 1000.                    ; scale emission factors to kg
;   Add the peat burning
    emisout[*,j0:j0+ny-1,i] =  emisout[*,j0:j0+ny-1,i] + som_closs[*,*,i]/.45/1000. $     ; scaling carbon to kg dry matter
                    * lfrac            $   ; land fraction
                    * (  epeat[ispec] $    ; peat emission factor
                      ) / 1000.            ; scale emission factors to kg

   endfor

;  Dump to netcdf files
   cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/emis_'+species[ispec]+'.nc',/clobber)
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
  endfor


end
