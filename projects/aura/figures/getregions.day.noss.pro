; Colarco
; March 2016
; Gather retrieval information a specified region of latitudes and
; longitudes

; goto, jump
  mm = '07'
  dd = '15'

; July 2007

  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m'+mm+dd+'*vl_rad.geos5_pressure.ext_noss.he5')

  gfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO_noss/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
print, ifile

;   Get the model retrieval
    if(ifile eq 0) then begin
     read_retrieval_ext, files[ifile], lon, lat, $
                         ler388, aod, ssa, $
                         duext, ssext, suext, ocext, bcext, $
                         residue, ai, prs, prso, $
                         rad354, rad388
     nxy = n_elements(lon)
     lon = reform(lon,nxy)
     lat = reform(lat,nxy)
     aod = reform(aod,nxy)
     duext = reform(duext,nxy)
     suext = reform(suext,nxy)
     ssext = reform(ssext,nxy)
     ocext = reform(ocext,nxy)
     bcext = reform(bcext,nxy)
     ai  = reform(ai,nxy)
     ssa = reform(ssa,nxy)
     rad = reform(rad388,nxy)
     ler = reform(ler388,nxy)
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi
     id = ncdf_varid(cdfid,'ai')
     ncdf_varget, cdfid, id, aiomi
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi
     id = ncdf_varid(cdfid,'rad388')
     ncdf_varget, cdfid, id, radomi
     id = ncdf_varid(cdfid,'ref388')
     ncdf_varget, cdfid, id, refomi
     id = ncdf_varid(cdfid,'ler388')
     ncdf_varget, cdfid, id, leromi
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh
     ncdf_close, cdfid
     aodomi = reform(aodomi,nxy)
     aiomi  = reform(aiomi,nxy)
     ssaomi = reform(ssaomi,nxy)
     leromi = reform(leromi,nxy)
     refomi = reform(refomi,nxy)
     radomi = reform(radomi,nxy)
     aert   = reform(aert,nxy)
     aerh   = reform(aerh,nxy)
    endif else begin
     read_retrieval_ext, files[ifile], lon_, lat_, $
                         ler388_, aod_, ssa_, $
                         duext_, ssext_, suext_, ocext_, bcext_, $
                         residue_, ai_, prs_, prso_, $
                         rad354_, rad388_
     nxy_ = n_elements(lon_)
     lon_ = reform(lon_,nxy_)
     lat_ = reform(lat_,nxy_)
     aod_ = reform(aod_,nxy_)
     ai_  = reform(ai_,nxy_)
     ssa_ = reform(ssa_,nxy_)
     duext_ = reform(duext_,nxy_)
     suext_ = reform(suext_,nxy_)
     ssext_ = reform(ssext_,nxy_)
     ocext_ = reform(ocext_,nxy_)
     bcext_ = reform(bcext_,nxy_)
     rad388_ = reform(rad388_,nxy_)
     ler388_ = reform(ler388_,nxy_)
     lon = [lon,lon_]
     lat = [lat,lat_]
     aod = [aod,aod_]
     ai  = [ai,ai_]
     ssa = [ssa,ssa_]
     duext = [duext,duext_]
     suext = [suext,suext_]
     ssext = [ssext,ssext_]
     ocext = [ocext,ocext_]
     bcext = [bcext,bcext_]
     rad   = [rad,rad388_]
     ler   = [ler,ler388_]
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi_
     id = ncdf_varid(cdfid,'ai')
     ncdf_varget, cdfid, id, aiomi_
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi_
     id = ncdf_varid(cdfid,'rad388')
     ncdf_varget, cdfid, id, radomi_
     id = ncdf_varid(cdfid,'ref388')
     ncdf_varget, cdfid, id, refomi_
     id = ncdf_varid(cdfid,'ler388')
     ncdf_varget, cdfid, id, leromi_
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert_
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh_
     ncdf_close, cdfid
     aodomi = [aodomi,reform(aodomi_,nxy_)]
     aiomi  = [aiomi,reform(aiomi_,nxy_)]
     ssaomi = [ssaomi,reform(ssaomi_,nxy_)]
     aert   = [aert,reform(aert_,nxy_)]
     aerh   = [aerh,reform(aerh_,nxy_)]
     refomi = [refomi,reform(refomi_,nxy_)]
     radomi = [radomi,reform(radomi_,nxy_)]
     leromi = [leromi,reform(leromi_,nxy_)]
    endelse
  endfor

; Reduce data set only to points where OMI retrieved
  a = where(aodomi gt 0)
  aodomi = aodomi[a]
  aiomi  = aiomi[a]
  ssaomi = ssaomi[a]
  aert   = aert[a]
  aerh   = aerh[a]
  refomi = refomi[a]
  radomi = radomi[a]
  leromi = leromi[a]
  ler    = ler[a]
  rad    = rad[a]
  ai     = ai[a]
  aod    = aod[a]
  ssa    = ssa[a]
  duext  = duext[a]
  suext  = suext[a]
  ssext  = ssext[a]
  ocext  = ocext[a]
  bcext  = bcext[a]
  lon    = lon[a]
  lat    = lat[a]

  save, file='getregions.noss.2007'+mm+dd+'.sav', /all

end
