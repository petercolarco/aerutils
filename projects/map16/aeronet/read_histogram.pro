  pro read_histogram, expid, yearwant, locations, lat, lon, $
                      taumin, taumax, angmin, angmax, $
                      aotaeronet, angaeronet, aotmodel, angmodel, $
                      absaeronet, absmodel, absmin, absmax, $
                      elevation = elevation


; Possibly more than 1 year
  ny = n_elements(yearwant)

  iy = 0
  while(iy lt ny) do begin

   yyyy = yearwant[iy]

;  Read the monthly mean file
   cdfid = ncdf_open('./output/histogram/aeronet_model_histogram.'+expid+'.'+yyyy+'.nc')

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

   id = ncdf_varid(cdfid,'aotbin_aer')
   ncdf_varget, cdfid, id, aotaeronetIn
   id = ncdf_varid(cdfid,'absbin_aer')
   ncdf_varget, cdfid, id, absaeronetIn
   id = ncdf_varid(cdfid,'angbin_aer')
   ncdf_varget, cdfid, id, angaeronetIn
   id = ncdf_varid(cdfid,'aotbin_mod')
   ncdf_varget, cdfid, id, aotmodelIn
   id = ncdf_varid(cdfid,'absbin_mod')
   ncdf_varget, cdfid, id, absmodelIn
   id = ncdf_varid(cdfid,'angbin_mod')
   ncdf_varget, cdfid, id, angmodelIn
   id = ncdf_varid(cdfid,'taumin')
   ncdf_varget, cdfid, id, taumin
   id = ncdf_varid(cdfid,'taumax')
   ncdf_varget, cdfid, id, taumax
   id = ncdf_varid(cdfid,'absmin')
   ncdf_varget, cdfid, id, absmin
   id = ncdf_varid(cdfid,'absmax')
   ncdf_varget, cdfid, id, absmax
   id = ncdf_varid(cdfid,'angmin')
   ncdf_varget, cdfid, id, angmin
   id = ncdf_varid(cdfid,'angmax')
   ncdf_varget, cdfid, id, angmax

   if(iy eq 0) then begin
    aotaeronet = aotaeronetIn
    absaeronet = absaeronetIn
    angaeronet = angaeronetIn
    aotmodel   = aotmodelIn
    absmodel   = absmodelIn
    angmodel   = angmodelIn
   endif else begin
    aotaeronet = aotaeronet + aotaeronetIn
    absaeronet = absaeronet + absaeronetIn
    angaeronet = angaeronet + angaeronetIn
    aotmodel   = aotmodel + aotmodelIn
    absmodel   = absmodel + absmodelIn
    angmodel   = angmodel + angmodelIn
   endelse

   ncdf_close, cdfid

   iy = iy+1
  endwhile

  end
