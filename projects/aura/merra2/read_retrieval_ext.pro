; Colarco, January 2016
; Read my gridded retrievals files

  pro read_retrieval_ext, filen, lon, lat, $
                      ler388, aod, ssa, $
                      duext, ssext, suext, ocext, bcext, $
                      residue, ai, prs, prso, $
                      rad354, rad388, $
                      aodmaskdir=aodmaskdir, aimaskdir=aimaskdir, $
                      aerhmaskdir=aerhmaskdir

    file_id = h5f_open(filen)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon    = h5d_read(var_id)
    nxy     = n_elements(lon)
    lon    = reform(lon,nxy)

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

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/duext')
    duext   = h5d_read(var_id)
    duext   = reform(duext,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/ssext')
    ssext   = h5d_read(var_id)
    ssext   = reform(ssext,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/suext')
    suext   = h5d_read(var_id)
    suext   = reform(suext,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/ocext')
    ocext   = h5d_read(var_id)
    ocext   = reform(ocext,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/bcext')
    bcext   = h5d_read(var_id)
    bcext   = reform(bcext,nxy)

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
  a = strpos(filen,'vl_rad.geos5_pressure')
  b = strpos(filen,'OMI-Aura')
  filen_ = '/misc/prc08/colarco/OMAERUV_V1731_DATA/2007/'+strmid(filen,b,a-b)+'he5'
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
   duext[a] = min(aodmask)
   ssext[a] = min(aodmask)
   suext[a] = min(aodmask)
   ocext[a] = min(aodmask)
   bcext[a] = min(aodmask)
   ssa[a] = min(aodmask)
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
   duext[a] = min(aodmask)
   ssext[a] = min(aodmask)
   suext[a] = min(aodmask)
   ocext[a] = min(aodmask)
   bcext[a] = min(aodmask)
   ssa[a] = min(aodmask)
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
   duext[a] = min(aimask)
   ssext[a] = min(aimask)
   suext[a] = min(aimask)
   ocext[a] = min(aimask)
   bcext[a] = min(aimask)
   ssa[a] = min(aimask)
   residue[a] = min(aimask)
   ai[a] = min(aimask)
   prs[a] = min(aimask)
   prso[a] = min(aimask)
   rad354[a] = min(aimask)
   rad388[a] = min(aimask)
  endif

end
