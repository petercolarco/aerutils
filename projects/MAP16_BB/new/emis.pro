; Melanie has provided the CLOSS variable from Eunjee run on discover
; here (units are gC/m2/month):
restore, 'clm4.5_DE720_m2gmindep_monthly_burn_closs_1980-2016_ForPete.sav'
; Provides CLOSS on global grid and mlats and mlons of global grid
; This takes out lines below reading closs from file...
closs = reform(closs_all,720,360,444) ; put all months together
mlats = mlats+0.25 ; fix griddings
mlons = mlons+0.25
; And reduce to desired grid like from old files (287 latitudes)
a = where(mlats[0,*] gt -59.3 and mlats[0,*] lt 83.8)
lon = reform(mlons[*,0])
lat = reform(mlats[0,a])
closs = closs[*,a,*]
a = where(finite(closs) ne 1)
closs[a] = !values.f_nan

; Use the PFT mappings and the carbon loss along with the peat carbon
; loss to grid emissions in kg m-2 s-1

; Species
  species = ['bc', 'co', 'co2', 'nh3', 'oc', 'so2']

; Emission factors (from Li, Val Martin, Andreae, et al. ACP 2019)
  egrass  = [0.51,  70, 1647, 0.91, 3.10, 0.51]
  eboreal = [0.50, 124, 1549, 2.82, 10.1, 0.75]
  etemp   = [0.66, 112, 1566, 1.00, 8.90, 0.75]
  etrop   = [0.49, 108, 1613, 1.45, 4.50, 0.78]
;  epeat   = [0.04, 210, 1703, 1.33, 6.02, 0.40] ; No Peat
  eagri   = [0.43,  78, 1421, 1.04, 5.00, 0.81]

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

; See above, I read CLOSS from Melanie file
;; Now get the time series of carbon loss and fractions
;  nc4readvar, '/home/colarco/projects/MAP16_BB/clm4.5_closs.nc', 'closs', closs, lon=lon, lat=lat, nymd=nymd ; vegetation
;  nc4readvar, '/home/colarco/projects/MAP16_BB/clm4.5_closs.nc', 'som_closs', som_closs, lon=lon, lat=lat, nymd=nymd ; peat
;  n = indgen(n_elements(nymd))

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
  n= indgen(444)
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

   emisout = make_array(nx,nyout,nt,val=!values.f_nan)
   j0 = where(ll eq min(lat))
   for i = 0, nt-1 do begin
;   units should be g species m-2 mon-1
    emisout[*,j0:j0+ny-1,i] =  closs[*,*,i]/.45/1000. $     ; scaling g carbon to kg dry matter
                    * lfrac            $           ; land fraction
                    * (  fgrass*egrass[ispec] $    ; grass fraction
                       + ftrop*etrop[ispec]   $    ; tropical forest fraction
                       + ftemp*etemp[ispec]   $    ; temperate forest fraction
                       + fboreal*eboreal[ispec]  $ ; boreal forest fraction
                       + fagri*eagri[ispec] $      ; agricultural frac
                      ) ; stay in g m-2 month-1
;;   Add the peat burning
;    emisout[*,j0:j0+ny-1,i] =  emisout[*,j0:j0+ny-1,i] + som_closs[*,*,i]/.45/1000. $     ; scaling carbon to kg dry matter
;                    * lfrac            $   ; land fraction
;                    * (  epeat[ispec] $    ; peat emission factor
;                      ) ; stay in g m-2 month-1

   endfor

;  Dump to netcdf files
;   cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/emis_'+species[ispec]+'.CatCN_LDASsa45_c10.nc',/clobber)
   cdfid = ncdf_create('./emis_'+species[ispec]+'.CatCN_LDASsa45_c10.nc',/clobber)
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
