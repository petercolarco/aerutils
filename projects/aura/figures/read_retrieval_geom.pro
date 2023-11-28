; Colarco, January 2016
; Read my gridded retrievals files

  pro read_retrieval_geom, filen, lon, lat, $
                      ler388, aod, ssa, $
                      residue, ai, prs, prso, $
                      rad354, rad388, $
                      trans, spher, sca, $
                      aodmaskdir=aodmaskdir, aimaskdir=aimaskdir, $
                      aerhmaskdir=aerhmaskdir

    file_id = h5f_open(filen)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon    = h5d_read(var_id)
    nxy     = n_elements(lon)
    lon    = reform(lon,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Radiance388Calc')
    i388c   = h5d_read(var_id)
    i388c   = reform(i388c,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Transmissivity')
    trans   = h5d_read(var_id)
    trans   = reform(trans,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SphericalAlbedo')
    spher   = h5d_read(var_id)
    spher   = reform(spher,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat    = h5d_read(var_id)
    lat    = reform(lat,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    ai    = h5d_read(var_id)
    ai    = reform(ai,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Reflectivity')
    refl     = h5d_read(var_id)
    ler388   = reform(refl[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT')
    aod    = h5d_read(var_id)
    aod    = reform(aod[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/ViewingZenithAngle')
    vza    = h5d_read(var_id)
    vza    = reform(vza,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/SolarZenithAngle')
    sza    = h5d_read(var_id)
    sza    = reform(sza,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/RelativeAzimuthAngle')
    raa    = h5d_read(var_id)
    raa    = reform(raa,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA')
    ssa    = h5d_read(var_id)
    ssa    = reform(ssa[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Residue')
    residue = h5d_read(var_id)
    residue = reform(residue,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
    rad_    = h5d_read(var_id)
    rad388  = reform(rad_[1,*,*],nxy)
    rad354  = reform(rad_[0,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs    = h5d_read(var_id)
    prs    = reform(prs,nxy)

  h5f_close, file_id

; Get the OMI Pressure
  a = strpos(filen,'geos5_pressure')
  filen_ = strmid(filen,0,a)+'he5'
  file_id = h5f_open(filen_)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prso    = h5d_read(var_id)
    prso    = reform(prso,nxy)

  h5f_close, file_id

; Make SSA correct (saved SSA is the scattering AOD
  ssa_ = ssa
  ssa_[*] = -1.23e30
  a = where(ssa gt .001)
  ssa_[a] = ssa[a]/aod[a]
  ssa = ssa_

; If requested a mask then read AOD value from maskfile and mask all
; returns to that
  if(keyword_set(aodmaskdir)) then begin
   filem = aodmaskdir+strmid(filen,strpos(filen,'2007m'),21)+'_OMAERUVx_Outputs.nc4'
   cdfid = ncdf_open(filem)
   id = ncdf_varid(cdfid,'aod388')
   ncdf_varget, cdfid, id, aodmask
   ncdf_close, cdfid
   aodmask = reform(aodmask,nxy)
   a = where(aodmask lt -1.e30)
   ler388[a] = min(aodmask)
   aod[a] = min(aodmask)
   ssa[a] = min(aodmask)
   trans[a] = min(aodmask)
   spher[a] = min(aodmask)
   i388c[a] = min(aodmask)
   sza[a] = min(aodmask)
   vza[a] = min(aodmask)
   raa[a] = min(aodmask)
   residue[a] = min(aodmask)
   ai[a] = min(aodmask)
   prs[a] = min(aodmask)
   prso[a] = min(aodmask)
   rad354[a] = min(aodmask)
   rad388[a] = min(aodmask)
  endif

; If requested a mask then read AOD value from maskfile and mask all
; returns to that, retaining also only points where aerh gt 0
  if(keyword_set(aerhmaskdir)) then begin
   filem = aerhmaskdir+strmid(filen,strpos(filen,'2007m'),21)+'_OMAERUVx_Outputs.nc4'
   cdfid = ncdf_open(filem)
   id = ncdf_varid(cdfid,'aod388')
   ncdf_varget, cdfid, id, aodmask
   id = ncdf_varid(cdfid,'aerh')
   ncdf_varget, cdfid, id, aerhmask
   ncdf_close, cdfid
   aodmask = reform(aodmask,nxy)
   aerhmask = reform(aerhmask,nxy)
   a = where(aodmask lt -1.e30 or aerhmask le 0)
   ler388[a] = min(aodmask)
   aod[a] = min(aodmask)
   ssa[a] = min(aodmask)
   trans[a] = min(aodmask)
   spher[a] = min(aodmask)
   i388c[a] = min(aodmask)
   sza[a] = min(aodmask)
   vza[a] = min(aodmask)
   raa[a] = min(aodmask)
   residue[a] = min(aodmask)
   ai[a] = min(aodmask)
   prs[a] = min(aodmask)
   prso[a] = min(aodmask)
   rad354[a] = min(aodmask)
   rad388[a] = min(aodmask)
  endif

; If requested a mask then read AI value from maskfile and mask all
; returns to that
  if(keyword_set(aimaskdir)) then begin
   filem = aimaskdir+strmid(filen,strpos(filen,'2007m'),21)+'_OMAERUVx_Outputs.nc4'
   cdfid = ncdf_open(filem)
   id = ncdf_varid(cdfid,'ai')
   ncdf_varget, cdfid, id, aimask
   ncdf_close, cdfid
   aimask = reform(aimask,nxy)
   a = where(aimask lt -1.e30)
   ler388[a] = min(aimask)
   aod[a] = min(aimask)
   ssa[a] = min(aimask)
   trans[a] = min(aimask)
   spher[a] = min(aimask)
   i388c[a] = min(aimask)
   sza[a] = min(aimask)
   vza[a] = min(aimask)
   raa[a] = min(aimask)
   residue[a] = min(aimask)
   ai[a] = min(aimask)
   prs[a] = min(aimask)
   prso[a] = min(aimask)
   rad354[a] = min(aimask)
   rad388[a] = min(aimask)
  endif

; scattering angle
  mu0 = sza
  mu  = sza
  ra  = sza
  sca = sza
  mu0[a] = cos(sza[a]/360.*2.*!pi)
  mu[a]  = cos(vza[a]/360.*2.*!pi)
  ra[a]  = cos(raa[a]/360.*2.*!pi)
  sca[a] = 360./2./!pi*acos(-mu0[a]*mu[a]+ra[a]*sqrt((1.-mu0[a])*(1.-mu[a])))

end
