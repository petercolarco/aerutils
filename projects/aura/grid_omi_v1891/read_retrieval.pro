; Colarco, January 2016
; Read my gridded retrievals files

  pro read_retrieval, filen, lon, lat, $
                      ler388, aod, ssa, $
                      maod, mssa, $
                      residue, ai, prs, $
                      rad354, rad388, aerh=aerh, aert=aert, $
                      aodmaskdir=aodmaskdir, aimaskdir=aimaskdir

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
    maod    = h5d_read(var_id)
    maod    = reform(maod[1,*,*],nxy)


    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA')
    mssa    = h5d_read(var_id)
    mssa   = reform(mssa[1,*,*],nxy)


    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/FinalAerosolOpticalDepth')
    aod    = h5d_read(var_id)
    aod    = reform(aod[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/FinalAerosolAbsOpticalDepth')
    ssa    = h5d_read(var_id)
    ssa    = reform(ssa[1,*,*],nxy)

    if(keyword_set(aerh)) then begin
     var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/FinalAerosolLayerHeight')
     aerh    = h5d_read(var_id)
     aerh    = reform(aerh,nxy)
    endif
     
    if(keyword_set(aert)) then begin
     var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/AerosolType')
     aert    = h5d_read(var_id)
     aert    = reform(aert,nxy)
    endif
     
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

; Make SSA correct (saved SSA is the AAOD)
  ssa_ = ssa
  ssa_[*] = -1.23e30
  a = where(ssa gt .001)
  ssa_[a] = (aod[a] - ssa[a])/aod[a]
  ssa = ssa_
end
