; Colarco, January 2016
; Read my gridded retrievals files

  pro read_retrieval, filen, lon, lat, $
                      ler388, aod, ssa, $
                      residue, ai, prs, $
                      rad354, rad388, aerh=aerh, aert=aert, $
                      aodmaskdir=aodmaskdir, aimaskdir=aimaskdir, $
                      maod500 = maod500, mssa500 = mssa500, $
                      maod354 = maod354, mssa354 = mssa354, $
                      maod388 = maod388, mssa388 = mssa388, $
                      aod354 = aod354, ssa354 = ssa354, $
                      aod388 = aod388, ssa388 = ssa388
         


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

    if(keyword_set(maod500)) then begin
     var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT')
     maod_= h5d_read(var_id)
     maod500 = reform(maod_[2,*,*],nxy)
     maod388 = reform(maod_[1,*,*],nxy)
     maod354 = reform(maod_[0,*,*],nxy)
    endif

    if(keyword_set(mssa500)) then begin
     var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA')
     mssa_   = h5d_read(var_id)
     mssa500 = reform(mssa_[2,*,*],nxy)
     mssa388 = reform(mssa_[1,*,*],nxy)
     mssa354 = reform(mssa_[0,*,*],nxy)
    endif

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/FinalAerosolOpticalDepth')
    aod_   = h5d_read(var_id)
    aod    = reform(aod_[2,*,*],nxy)
    aod388 = reform(aod_[1,*,*],nxy)
    aod354 = reform(aod_[0,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/FinalAerosolAbsOpticalDepth')
    ssa_   = h5d_read(var_id)
    ssa    = reform(ssa_[2,*,*],nxy)
    ssa388 = reform(ssa_[1,*,*],nxy)
    ssa354 = reform(ssa_[0,*,*],nxy)

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
  ssa388_ = ssa388
  ssa388_[*] = -1.23e30
  a = where(ssa388 gt .001)
  ssa388_[a] = (aod388[a] - ssa388[a])/aod388[a]
  ssa388 = ssa388_
  ssa354_ = ssa354
  ssa354_[*] = -1.23e30
  a = where(ssa354 gt .001)
  ssa354_[a] = (aod354[a] - ssa354[a])/aod354[a]
  ssa354 = ssa354_

;  if(keyword_set(maod) and keyword_set(mssa)) then mssa = mssa/maod

end
