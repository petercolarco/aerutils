  pro read_mon_mean, expid, yearwant, locations, lat, lon, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                     aotabsaeronet, aotabsmodel, $
                     aotabsaeronetstd, aotabsmodelstd, $
                     aotmodeldu=aotmodeldu, aotmodelss=aotmodelss, $
                     aotmodelcc=aotmodelcc, aotmodelsu=aotmodelsu, $
                     ndays=ndays, elevation = elevation, $
                     locationwant=locationwant

; If locationwant is provided then only return the values at the
; requested locations


; Possibly more than 1 year
  ny = n_elements(yearwant)

  iy = 0
  while(iy lt ny) do begin

   yyyy = yearwant[iy]

;  Read the monthly mean file
   filename = './output/mon_mean/aeronet_model_mon_mean.'+expid+'.'+yyyy+'.nc'
   cdfid = ncdf_open(filename)

   if(iy eq 0) then begin

   id = ncdf_varid(cdfid,'location')
   ncdf_varget, cdfid, id, locations
   locations=string(locations)
   nlocs = n_elements(locations)
   id = ncdf_varid(cdfid,'latitude')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'longitude')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'elevation')
   ncdf_varget, cdfid, id, elevation

   endif

   id = ncdf_varid(cdfid,'aotaeronet')
   ncdf_varget, cdfid, id, aotaeronetIn
   id = ncdf_varid(cdfid,'aotabsaeronet')
   ncdf_varget, cdfid, id, aotabsaeronetIn
   id = ncdf_varid(cdfid,'angaeronet')
   ncdf_varget, cdfid, id, angaeronetIn
   id = ncdf_varid(cdfid,'aotmodel')
   ncdf_varget, cdfid, id, aotmodelIn
   id = ncdf_varid(cdfid,'aotabsmodel')
   ncdf_varget, cdfid, id, aotabsmodelIn
   id = ncdf_varid(cdfid,'angmodel')
   ncdf_varget, cdfid, id, angmodelIn
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, dateIn
   id = ncdf_varid(cdfid,'ndays')
   ncdf_varget, cdfid, id, ndaysIn

   id = ncdf_varid(cdfid,'aotaeronetstd')
   ncdf_varget, cdfid, id, aotaeronetstdIn
   id = ncdf_varid(cdfid,'aotabsaeronetstd')
   ncdf_varget, cdfid, id, aotabsaeronetstdIn
   id = ncdf_varid(cdfid,'angaeronetstd')
   ncdf_varget, cdfid, id, angaeronetstdIn
   id = ncdf_varid(cdfid,'aotmodelstd')
   ncdf_varget, cdfid, id, aotmodelstdIn
   id = ncdf_varid(cdfid,'aotabsmodelstd')
   ncdf_varget, cdfid, id, aotabsmodelstdIn
   id = ncdf_varid(cdfid,'angmodelstd')
   ncdf_varget, cdfid, id, angmodelstdIn

   ndaysIn      = transpose(ndaysIn)
   aotaeronetIn = transpose(aotaeronetIn)
   aotabsaeronetIn = transpose(aotabsaeronetIn)
   angaeronetIn = transpose(angaeronetIn)
   aotmodelIn   = transpose(aotmodelIn)
   aotabsmodelIn   = transpose(aotabsmodelIn)
   angmodelIn   = transpose(angModelIn)
   aotaeronetstdIn = transpose(aotaeronetstdIn)
   aotabsaeronetstdIn = transpose(aotabsaeronetstdIn)
   angaeronetstdIn = transpose(angaeronetstdIn)
   aotmodelstdIn   = transpose(aotmodelstdIn)
   aotabsmodelstdIn   = transpose(aotabsmodelstdIn)
   angmodelstdIn   = transpose(angModelstdIn)

   id = ncdf_varid(cdfid,'aotmodeldu')
   ncdf_varget, cdfid, id, aotmodelduIn
   id = ncdf_varid(cdfid,'aotmodelss')
   ncdf_varget, cdfid, id, aotmodelssIn
   id = ncdf_varid(cdfid,'aotmodelcc')
   ncdf_varget, cdfid, id, aotmodelccIn
   id = ncdf_varid(cdfid,'aotmodelsu')
   ncdf_varget, cdfid, id, aotmodelsuIn

   aotmodelduIn = transpose(aotmodelduIn)
   aotmodelssIn = transpose(aotmodelssIn)
   aotmodelccIn = transpose(aotmodelccIn)
   aotmodelsuIn = transpose(aotmodelsuIn)
;  aotmodelsuIn[*] = 0.
  aotmodelIn = aotmodelduIn + aotmodelssIn + aotmodelccIn + aotmodelsuIn

   if(iy eq 0) then begin
    aotaeronet = aotaeronetIn
    aotabsaeronet = aotabsaeronetIn
    angaeronet = angaeronetIn
    aotmodel   = aotmodelIn
    aotabsmodel   = aotabsmodelIn
    angmodel   = angmodelIn
    aotaeronetstd = aotaeronetstdIn
    aotabsaeronetstd = aotabsaeronetstdIn
    angaeronetstd = angaeronetstdIn
    aotmodelstd   = aotmodelstdIn
    aotabsmodelstd   = aotabsmodelstdIn
    angmodelstd   = angmodelstdIn
    aotmodeldu    = aotmodelduIn
    aotmodelss    = aotmodelssIn
    aotmodelcc    = aotmodelccIn
    aotmodelsu    = aotmodelsuIn
    date       = dateIn
    ndays      = ndaysIn
   endif else begin
    aotaeronet = [aotaeronet, aotaeronetIn]
    aotabsaeronet = [aotabsaeronet, aotabsaeronetIn]
    angaeronet = [angaeronet, angaeronetIn]
    aotmodel   = [aotmodel, aotmodelIn]
    aotabsmodel   = [aotabsmodel, aotabsmodelIn]
    angmodel   = [angmodel, angmodelIn]
    aotaeronetstd = [aotaeronetstd, aotaeronetstdIn]
    aotabsaeronetstd = [aotabsaeronetstd, aotabsaeronetstdIn]
    angaeronetstd = [angaeronetstd, angaeronetstdIn]
    aotmodelstd   = [aotmodelstd, aotmodelstdIn]
    aotabsmodelstd   = [aotabsmodelstd, aotabsmodelstdIn]
    angmodelstd   = [angmodelstd, angmodelstdIn]
    aotmodeldu    = [aotmodeldu, aotmodelduIn]
    aotmodelss    = [aotmodelss, aotmodelssIn]
    aotmodelcc    = [aotmodelcc, aotmodelccIn]
    aotmodelsu    = [aotmodelsu, aotmodelsuIn]
    date       = [date, dateIn]
    ndays      = [ndays, ndaysIn]
   endelse

   ncdf_close, cdfid

   iy = iy+1
  endwhile

; Set the missing values to nan
  a = where(aotaeronet lt 0)
  if(a[0] ne -1) then begin
   aotaeronet[a] = !values.f_nan
   angaeronet[a] = !values.f_nan
   aotmodel[a] = !values.f_nan
   angmodel[a] = !values.f_nan
   aotmodeldu[a] = !values.f_nan
   aotmodelss[a] = !values.f_nan
   aotmodelcc[a] = !values.f_nan
   aotmodelsu[a] = !values.f_nan
  endif

  a = where(aotabsaeronet lt 0)
  if(a[0] ne -1) then begin
   aotabsaeronet[a] = !values.f_nan
   aotabsmodel[a] = !values.f_nan
  endif

; If locationwant is provided, return only the desired locations
  if(keyword_set(locationwant)) then begin
   nloc = n_elements(locationwant)
   n = n_elements(date)
   first = 1
   ncnt = 0
   for iloc = 0, nloc-1 do begin
    a = where(locations eq locationwant[iloc])
    if(a[0] eq -1) then print, locationwant[iloc]+' not on file; omitting'
    if(a[0] eq -1) then break
    if(first) then begin
     locations_  = locations[a]
     lat_        = lat[a]
     lon_        = lon[a]
     elevation_  = elevation[a]
     ndays_      = ndays[a]
     aotaeronet_ = aotaeronet[*,a]
     aotabsaeronet_ = aotabsaeronet[*,a]
     angaeronet_ = angaeronet[*,a]
     aotmodel_   = aotmodel[*,a]
     aotabsmodel_   = aotabsmodel[*,a]
     angmodel_   = angmodel[*,a]
     aotaeronetstd_ = aotaeronetstd[*,a]
     aotabsaeronetstd_ = aotabsaeronetstd[*,a]
     angaeronetstd_ = angaeronetstd[*,a]
     aotmodelstd_   = aotmodelstd[*,a]
     aotabsmodelstd_   = aotabsmodelstd[*,a]
     angmodelstd_   = angmodelstd[*,a]
     aotmodeldu_ = aotmodeldu[*,a]
     aotmodelss_ = aotmodelss[*,a]
     aotmodelcc_ = aotmodelcc[*,a]
     aotmodelsu_ = aotmodelsu[*,a]
     ncnt = 1
     first = 0
    endif else begin
     locations_ = [locations_,locations[a]]
     lat_       = [lat_,lat[a]]
     lon_       = [lon_,lon[a]]
     elevation_ = [elevation_,elevation[a]]
     ndays_     = [ndays_,ndays[a]]
     aotaeronet_ = [aotaeronet_,aotaeronet[*,a]]
     aotabsaeronet_ = [aotabsaeronet_,aotabsaeronet[*,a]]
     angaeronet_ = [angaeronet_,angaeronet[*,a]]
     aotmodel_   = [aotmodel_,aotmodel[*,a]]
     aotabsmodel_   = [aotabsmodel_,aotabsmodel[*,a]]
     angmodel_   = [angmodel_,angmodel[*,a]]
     aotaeronetstd_ = [aotaeronetstd_,aotaeronetstd[*,a]]
     aotabsaeronetstd_ = [aotabsaeronetstd_,aotabsaeronetstd[*,a]]
     angaeronetstd_ = [angaeronetstd_,angaeronetstd[*,a]]
     aotmodelstd_   = [aotmodelstd_,aotmodelstd[*,a]]
     aotabsmodelstd_   = [aotabsmodelstd_,aotabsmodelstd[*,a]]
     angmodelstd_   = [angmodelstd_,angmodelstd[*,a]]
     aotmodeldu_ = [aotmodeldu_,aotmodeldu[*,a]]
     aotmodelss_ = [aotmodelss_,aotmodelss[*,a]]
     aotmodelcc_ = [aotmodelcc_,aotmodelcc[*,a]]
     aotmodelsu_ = [aotmodelsu_,aotmodelsu[*,a]]
     ncnt = ncnt+1
    endelse
   endfor

   locations  = locations_
   lat        = lat_
   lon        = lon_
   elevation  = elevation_
   ndays      = ndays_
   aotaeronetstd = reform(aotaeronetstd_,n,ncnt)
   aotabsaeronetstd = reform(aotabsaeronetstd_,n,ncnt)
   angaeronetstd = reform(angaeronetstd_,n,ncnt)
   aotmodelstd   = reform(aotmodelstd_,n,ncnt)
   aotabsmodelstd   = reform(aotabsmodelstd_,n,ncnt)
   angmodelstd   = reform(angmodelstd_,n,ncnt)
   aotaeronet = reform(aotaeronet_,n,ncnt)
   aotabsaeronet = reform(aotabsaeronet_,n,ncnt)
   angaeronet = reform(angaeronet_,n,ncnt)
   aotmodel   = reform(aotmodel_,n,ncnt)
   aotabsmodel   = reform(aotabsmodel_,n,ncnt)
   angmodel   = reform(angmodel_,n,ncnt)
   aotmodeldu = reform(aotmodeldu_,n,ncnt)
   aotmodelss = reform(aotmodelss_,n,ncnt)
   aotmodelcc = reform(aotmodelcc_,n,ncnt)
   aotmodelsu = reform(aotmodelsu_,n,ncnt)


  endif

  end
