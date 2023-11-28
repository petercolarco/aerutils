; Read and parse out one of Santiago's returned OMI files
; This contains his retrievals based on my supplied radiances
; The file contains "rows" 200 - 1400 (so, 1201 rows) of a 
; single OMI orbit, with 60 columns per row.  Arranged by variable.
; There are apparently 27 variables, which are the columns.

; From Santiago:
;For Rows 3 to 62:
;Column  1 - Cross-Track Position Number of each Ground Pixel.
;Column  2 - Longitude at Center of each Ground Pixel.
;Column  3 - Latitude at Center of each Ground Pixel.
;Column  4 - Solar Zenith Angle at Center of each Ground Pixel.
;Column  5 - Viewing Zenith Angle at Center of each Ground Pixel.
;Column  6 - Relative Azimuth Angle at Center of each Ground Pixel.
;Column  7 - Terrain Pressure associated with each Ground Pixel.
;Column  8 - Normalized Radiance at 354.0 nm associated with each
;Ground Pixel.
;Column  9 - Normalized Radiance at 388.0 nm associated with each
;Ground Pixel.
;Column 10 - Ground Pixel Quality Flags associated with each Ground Pixel.
;Column 11 - AIRS CO Value associated with each Ground Pixel.
;Column 12 - Final Aerosol Layer Height associated with each Ground Pixel.
;Column 13 - Lambertian Equivalent Reflectivity at 354.0 nm associated
;with each Ground Pixel.
;Column 14 - Lambertian Equivalent Reflectivity at 388.0 nm associated
;with each Ground Pixel.
;Column 15 - Surface Albedo at 354.0 nm associated with each Ground Pixel.
;Column 16 - Surface Albedo at 388.0 nm associated with each Ground Pixel.
;Column 17 - Final Algorithm Flags associated with each Ground Pixel.
;Column 18 - Final Aerosol Optical Depth at 388.0 nm associated with
;each Ground Pixel.
;Column 19 - Final Aerosol Optical Depth at 500.0 nm associated with
;each Ground Pixel.
;Column 20 - Final Aerosol Single Scattering Albedo at 388.0 nm
;associated with each Ground Pixel.
;Column 21 - Final Aerosol Single Scattering Albedo at 500.0 nm
;associated with each Ground Pixel.
;Column 22 - Aerosol Type associated with each Ground Pixel.
;Column 23 - Uncorrected Aerosol Index associated with each Ground Pixel.
;Column 24 - Corrected Aerosol Index associated with each Ground Pixel.
;Column 25 - Mie-cloud Aerosol Index associated with each Ground Pixel.
;Column 26 - Cloud Fraction associated with each Ground Pixel.
;Column 27 - Cloud Optical Depth associated with each Ground Pixel.


  filed = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'
  file  = file_search(filed,'2007m0*txt')

  for ifile = 0, n_elements(file)-1 do begin

  openr, lun, file[ifile], /get
  print, file[ifile]

; Read first header line
  str = 'a'
  readf, lun, str

; Define output variables
  lon_    = fltarr(60,1201)
  lat_    = fltarr(60,1201)
  aerh_   = fltarr(60,1201)   ; aerosol height retrieved/assumed (?)
  ler354_ = fltarr(60,1201)
  ler388_ = fltarr(60,1201)
  rad354_ = fltarr(60,1201)
  rad388_ = fltarr(60,1201)
  ref354_ = fltarr(60,1201)
  ref388_ = fltarr(60,1201)
  aod388_ = fltarr(60,1201)
  ssa388_ = fltarr(60,1201)
  aert_   = fltarr(60,1201)
  res_    = fltarr(60,1201)
  ai_     = fltarr(60,1201)
  prs_    = fltarr(60,1201)

; Data is in blocks, with each block having a header line
  for i = 0, 1200 do begin
   readf, lun, str
   data = fltarr(27,60)
   readf, lun, data
   lon_[*,i]    = data[1,*]
   lat_[*,i]    = data[2,*]
   aerh_[*,i]   = data[11,*]
   ler354_[*,i] = data[12,*]
   ler388_[*,i] = data[13,*]
   prs_[*,i]    = data[6,*]
   rad354_[*,i] = data[7,*]
   rad388_[*,i] = data[8,*]
   ref354_[*,i] = data[14,*]
   ref388_[*,i] = data[15,*]
   aod388_[*,i] = data[17,*]
   ssa388_[*,i] = data[19,*]
   aert_[*,i]   = data[21,*]
   res_[*,i]    = data[22,*]
   ai_[*,i]     = data[23,*]
  endfor
  free_lun, lun

; Now get the OMI file to determine the mapping to the actual L2 files
; since Santiago only provides me a subset of all rows
  fileh = strmid(file[ifile],strlen(filed),14)
  omidir = '/misc/prc08/colarco/OMAERUV_V1621_DATA/2007/'
  result = file_search(omidir,'*'+fileh+'*he5')
  omif   = result[0]
  file_id = h5f_open(omif)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id

; Now create variables to map retrievals to for output file
  aerh = lon
  aerh[*] = min(data)
  ler354  = aerh
  ler388  = aerh
  rad354  = aerh
  rad388  = aerh
  ref354  = aerh
  ref388  = aerh
  aod388  = aerh
  ssa388  = aerh
  aert    = aerh
  res     = aerh
  ai      = aerh
  prs     = aerh

  aerh[*,199:1399]   = aerh_
  ler354[*,199:1399] = ler354_
  ler388[*,199:1399] = ler388_
  rad354[*,199:1399] = rad354_
  rad388[*,199:1399] = rad388_
  ref354[*,199:1399] = ref354_
  ref388[*,199:1399] = ref388_
  aod388[*,199:1399] = aod388_
  ssa388[*,199:1399] = ssa388_
  aert[*,199:1399]   = aert_
  res[*,199:1399]    = res_
  ai[*,199:1399]     = ai_
  prs[*,199:1399]    = prs_

; Now let's dump this to a netcdf file
  len = strpos(file[ifile],'.txt')
  ofile = strmid(file[ifile],0,len)+'.nc4'
  cdfid = ncdf_create(ofile,/clobber)
   idNx = ncdf_dimdef(cdfid,'nx',n_elements(ai[*,0]))
   idNy = ncdf_dimdef(cdfid,'ny',n_elements(ai[0,*]))

   idLon = ncdf_vardef(cdfid,'lon',[idNx,idNy])
    ncdf_attput, cdfid, idLon, 'long_name', 'longitude'
    ncdf_attput, cdfid, idLon, 'fill_value', 1.e15

   idLat = ncdf_vardef(cdfid,'lat',[idNx,idNy])
    ncdf_attput, cdfid, idLat, 'long_name', 'latitude'
    ncdf_attput, cdfid, idLat, 'fill_value', 1.e15

   idAerh = ncdf_vardef(cdfid,'aerh',[idNx,idNy])
    ncdf_attput, cdfid, idAerh, 'long_name', 'aerosol height from retrieval'
    ncdf_attput, cdfid, idAerh, 'fill_value', 1.e15

   idLER354 = ncdf_vardef(cdfid,'ler354',[idNx,idNy])
    ncdf_attput, cdfid, idLER354, 'long_name', 'LER @ 354 nm'
    ncdf_attput, cdfid, idLER354, 'fill_value', 1.e15

   idLER388 = ncdf_vardef(cdfid,'ler388',[idNx,idNy])
    ncdf_attput, cdfid, idLER388, 'long_name', 'LER @ 388 nm'
    ncdf_attput, cdfid, idLER388, 'fill_value', 1.e15

   idRAD354 = ncdf_vardef(cdfid,'rad354',[idNx,idNy])
    ncdf_attput, cdfid, idRAD354, 'long_name', 'normalized radiance @ 354 nm'
    ncdf_attput, cdfid, idRAD354, 'fill_value', 1.e15

   idRAD388 = ncdf_vardef(cdfid,'rad388',[idNx,idNy])
    ncdf_attput, cdfid, idRAD388, 'long_name', 'normalized radiance @ 388 nm'
    ncdf_attput, cdfid, idRAD388, 'fill_value', 1.e15

   idREF354 = ncdf_vardef(cdfid,'ref354',[idNx,idNy])
    ncdf_attput, cdfid, idREF354, 'long_name', 'Surface Albedo @ 354 nm'
    ncdf_attput, cdfid, idREF354, 'fill_value', 1.e15

   idREF388 = ncdf_vardef(cdfid,'ref388',[idNx,idNy])
    ncdf_attput, cdfid, idREF388, 'long_name', 'Surface Albedo @ 388 nm'
    ncdf_attput, cdfid, idREF388, 'fill_value', 1.e15

   idAOD388 = ncdf_vardef(cdfid,'aod388',[idNx,idNy])
    ncdf_attput, cdfid, idAOD388, 'long_name', 'aod @ 388 nm'
    ncdf_attput, cdfid, idAOD388, 'fill_value', 1.e15

   idSSA388 = ncdf_vardef(cdfid,'ssa388',[idNx,idNy])
    ncdf_attput, cdfid, idSSA388, 'long_name', 'ssa @ 388 nm'
    ncdf_attput, cdfid, idSSA388, 'fill_value', 1.e15

   idAert = ncdf_vardef(cdfid,'aert',[idNx,idNy])
    ncdf_attput, cdfid, idAert, 'long_name', 'aerosol type from retrieval'
    ncdf_attput, cdfid, idAert, 'fill_value', 1.e15

   idRes = ncdf_vardef(cdfid,'residue',[idNx,idNy])
    ncdf_attput, cdfid, idRes, 'long_name', 'residue (i.e., uncorrected AI)'
    ncdf_attput, cdfid, idRes, 'fill_value', 1.e15

   idAI = ncdf_vardef(cdfid,'ai',[idNx,idNy])
    ncdf_attput, cdfid, idAI, 'long_name', 'aerosol index (i.e., corrected AI)'
    ncdf_attput, cdfid, idAI, 'fill_value', 1.e15

   idPrs = ncdf_vardef(cdfid,'pressure',[idNx,idNy])
    ncdf_attput, cdfid, idPrs, 'long_name', 'surface pressure [hPa]'
    ncdf_attput, cdfid, idPrs, 'fill_value', 1.e15

   ncdf_control, cdfid, /endef

   ncdf_varput, cdfid, idLon, lon
   ncdf_varput, cdfid, idLat, lat
   ncdf_varput, cdfid, idAerh, aerh
   ncdf_varput, cdfid, idLER354, ler354
   ncdf_varput, cdfid, idLER388, ler388
   ncdf_varput, cdfid, idRAD354, rad354
   ncdf_varput, cdfid, idRAD388, rad388
   ncdf_varput, cdfid, idREF354, ref354
   ncdf_varput, cdfid, idREF388, ref388
   ncdf_varput, cdfid, idAOD388, aod388
   ncdf_varput, cdfid, idSSA388, ssa388
   ncdf_varput, cdfid, idAert, aert
   ncdf_varput, cdfid, idRes, res
   ncdf_varput, cdfid, idAI, ai
   ncdf_varput, cdfid, idPrs, prs

   ncdf_close, cdfid

  endfor

end

