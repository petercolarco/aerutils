  pro read_mon_mean, expid, yearwant, locations, lat, lon, date, $
                     dusmass, sssmass, so4smass, bcsmass, ocsmass, $
                     dusmassStd, sssmassStd, so4smassStd, bcsmassStd, ocsmassStd, $
                     dusm25, dusm25Std, sssm25, sssm25Std, $
                     duaeroce, duaerocestd, ssaeroce, ssaerocestd, $
                     so4emep, so4emepstd, $
                     so4improve, so4improvestd, ssimprove, ssimprovestd, $
                     bcimprove, bcimprovestd, ocimprove, ocimprovestd


; Possibly more than 1 year
  ny = n_elements(yearwant)

  iy = 0
  while(iy lt ny) do begin

   yyyy = yearwant[iy]

;  Read the monthly mean file
   cdfid = ncdf_open('./output/mon_mean/sfcobs_model_mon_mean.'+expid+'.'+yyyy+'.nc')

   if(iy eq 0) then begin

   id = ncdf_varid(cdfid,'location')
   ncdf_varget, cdfid, id, locations
   locations=string(locations)
   nlocs = n_elements(locations)
   id = ncdf_varid(cdfid,'latitude')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'longitude')
   ncdf_varget, cdfid, id, lon

   endif

   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, dateIn

   id = ncdf_varid(cdfid,'dusmass')
   ncdf_varget, cdfid, id, dusmassIn
   id = ncdf_varid(cdfid,'dusmassstd')
   ncdf_varget, cdfid, id, dusmassstdIn
   id = ncdf_varid(cdfid,'sssmass')
   ncdf_varget, cdfid, id, sssmassIn
   id = ncdf_varid(cdfid,'sssmassstd')
   ncdf_varget, cdfid, id, sssmassstdIn
   id = ncdf_varid(cdfid,'ocsmass')
   ncdf_varget, cdfid, id, ocsmassIn
   id = ncdf_varid(cdfid,'ocsmassstd')
   ncdf_varget, cdfid, id, ocsmassstdIn
   id = ncdf_varid(cdfid,'bcsmass')
   ncdf_varget, cdfid, id, bcsmassIn
   id = ncdf_varid(cdfid,'bcsmassstd')
   ncdf_varget, cdfid, id, bcsmassstdIn
   id = ncdf_varid(cdfid,'so4smass')
   ncdf_varget, cdfid, id, so4smassIn
   id = ncdf_varid(cdfid,'so4smassstd')
   ncdf_varget, cdfid, id, so4smassstdIn

;   id = ncdf_varid(cdfid,'dusm25')
;   ncdf_varget, cdfid, id, dusm25In
;   id = ncdf_varid(cdfid,'dusm25std')
;   ncdf_varget, cdfid, id, dusm25stdIn
;   id = ncdf_varid(cdfid,'sssm25')
;   ncdf_varget, cdfid, id, sssm25In
;   id = ncdf_varid(cdfid,'sssm25std')
;   ncdf_varget, cdfid, id, sssm25stdIn

   id = ncdf_varid(cdfid,'du_aeroce')
   ncdf_varget, cdfid, id, duaeroceIn
   id = ncdf_varid(cdfid,'du_aeroce_std')
   ncdf_varget, cdfid, id, duaeroceStdIn
   id = ncdf_varid(cdfid,'ss_aeroce')
   ncdf_varget, cdfid, id, ssaeroceIn
   id = ncdf_varid(cdfid,'ss_aeroce_std')
   ncdf_varget, cdfid, id, ssaeroceStdIn

   id = ncdf_varid(cdfid,'so4_emep')
   ncdf_varget, cdfid, id, so4emepIn
   id = ncdf_varid(cdfid,'so4_emep_std')
   ncdf_varget, cdfid, id, so4emepStdIn

   id = ncdf_varid(cdfid,'ss_imp')
   ncdf_varget, cdfid, id, ssimproveIn
   id = ncdf_varid(cdfid,'ss_imp_std')
   ncdf_varget, cdfid, id, ssimproveStdIn
   id = ncdf_varid(cdfid,'bc_imp')
   ncdf_varget, cdfid, id, bcimproveIn
   id = ncdf_varid(cdfid,'bc_imp_std')
   ncdf_varget, cdfid, id, bcimproveStdIn
   id = ncdf_varid(cdfid,'oc_imp')
   ncdf_varget, cdfid, id, ocimproveIn
   id = ncdf_varid(cdfid,'oc_imp_std')
   ncdf_varget, cdfid, id, ocimproveStdIn
   id = ncdf_varid(cdfid,'so4_imp')
   ncdf_varget, cdfid, id, so4improveIn
   id = ncdf_varid(cdfid,'so4_imp_std')
   ncdf_varget, cdfid, id, so4improveStdIn



   dusmassIn = transpose(dusmassIn)
   sssmassIn = transpose(sssmassIn)
   bcsmassIn = transpose(bcsmassIn)
   ocsmassIn = transpose(ocsmassIn)
   so4smassIn = transpose(so4smassIn)
;   dusm25In = transpose(dusm25In)
;   sssm25In = transpose(sssm25In)

   so4emepIn = transpose(so4emepIn)

   duaeroceIn = transpose(duaeroceIn)
   ssaeroceIn = transpose(ssaeroceIn)

   so4improveIn = transpose(so4improveIn)
   ocimproveIn = transpose(ocimproveIn)
   bcimproveIn = transpose(bcimproveIn)
   ssimproveIn = transpose(ssimproveIn)

   dusmassStdIn = transpose(dusmassStdIn)
   sssmassStdIn = transpose(sssmassStdIn)
   bcsmassStdIn = transpose(bcsmassStdIn)
   ocsmassStdIn = transpose(ocsmassStdIn)
   so4smassStdIn = transpose(so4smassStdIn)
;   dusm25StdIn = transpose(dusm25StdIn)
;   sssm25StdIn = transpose(sssm25StdIn)

   so4emepStdIn = transpose(so4emepStdIn)

   duaeroceStdIn = transpose(duaeroceStdIn)
   ssaeroceStdIn = transpose(ssaeroceStdIn)

   so4improveStdIn = transpose(so4improveStdIn)
   ocimproveStdIn = transpose(ocimproveStdIn)
   bcimproveStdIn = transpose(bcimproveStdIn)
   ssimproveStdIn = transpose(ssimproveStdIn)

   if(iy eq 0) then begin
    dusmass = dusmassIn
    sssmass = sssmassIn
    bcsmass = bcsmassIn
    ocsmass = ocsmassIn
    so4smass = so4smassIn
;    dusm25 = dusm25In
;    sssm25 = sssm25In

    duaeroce = duaeroceIn
    ssaeroce = ssaeroceIn

    so4emep = so4emepIn

    so4improve = so4improveIn
    bcimprove = bcimproveIn
    ocimprove = ocimproveIn
    ssimprove = ssimproveIn

    dusmassStd = dusmassStdIn
    sssmassStd = sssmassStdIn
    bcsmassStd = bcsmassStdIn
    ocsmassStd = ocsmassStdIn
    so4smassStd = so4smassStdIn
;    dusm25Std = dusm25StdIn
;    sssm25Std = sssm25StdIn

    duaeroceStd = duaeroceStdIn
    ssaeroceStd = ssaeroceStdIn

    so4emepStd = so4emepStdIn

    so4improveStd = so4improveStdIn
    bcimproveStd = bcimproveStdIn
    ocimproveStd = ocimproveStdIn
    ssimproveStd = ssimproveStdIn

    date       = dateIn
   endif else begin
    dusmass = [dusmass,dusmassIn]
    sssmass = [sssmass,sssmassIn]
    bcsmass = [bcsmass,bcsmassIn]
    ocsmass = [ocsmass,ocsmassIn]
    so4smass = [so4smass,so4smassIn]
;    dusm25 = [dusm25,dusm25In]
;    sssm25 = [sssm25,sssm25In]

    duaeroce = [duaeroce, duaeroceIn]
    ssaeroce = [ssaeroce, ssaeroceIn]

    so4emep = [so4emep,so4emepIn]

    so4improve = [so4improve,so4improveIn]
    ocimprove = [ocimprove,ocimproveIn]
    bcimprove = [bcimprove,bcimproveIn]
    ssimprove = [ssimprove,ssimproveIn]

    dusmassStd = [dusmassStd,dusmassStdIn]
    sssmassStd = [sssmassStd,sssmassStdIn]
    bcsmassStd = [bcsmassStd,bcsmassStdIn]
    ocsmassStd = [ocsmassStd,ocsmassStdIn]
    so4smassStd = [so4smassStd,so4smassStdIn]
;    dusm25Std = [dusm25Std,dusm25StdIn]
;    sssm25Std = [sssm25Std,sssm25StdIn]

    duaeroceStd = [duaeroceStd, duaeroceStdIn]
    ssaeroceStd = [ssaeroceStd, ssaeroceStdIn]

    so4emepStd = [so4emepStd,so4emepStdIn]

    so4improveStd = [so4improveStd,so4improveStdIn]
    ocimproveStd = [ocimproveStd,ocimproveStdIn]
    bcimproveStd = [bcimproveStd,bcimproveStdIn]
    ssimproveStd = [ssimproveStd,ssimproveStdIn]


    date       = [date, dateIn]
   endelse

   ncdf_close, cdfid

   iy = iy+1
  endwhile

; Set the missing values to nan
  a = where(duaeroce lt 0)
  if(a[0] ne -1) then begin
   duaeroce[a] = !values.f_nan
   duaerocestd[a] = !values.f_nan
  endif
  a = where(ssaeroce lt 0)
  if(a[0] ne -1) then begin
   ssaeroce[a] = !values.f_nan
   ssaerocestd[a] = !values.f_nan
  endif

  a = where(so4emep lt 0)
  if(a[0] ne -1) then begin
   so4emep[a] = !values.f_nan
   so4emepstd[a] = !values.f_nan
  endif

  a = where(ocimprove lt 0)
  if(a[0] ne -1) then begin
   ocimprove[a] = !values.f_nan
   ocimprovestd[a] = !values.f_nan
  endif
  a = where(bcimprove lt 0)
  if(a[0] ne -1) then begin
   bcimprove[a] = !values.f_nan
   bcimprovestd[a] = !values.f_nan
  endif
  a = where(ssimprove lt 0)
  if(a[0] ne -1) then begin
   ssimprove[a] = !values.f_nan
   ssimprovestd[a] = !values.f_nan
  endif
  a = where(so4improve lt 0)
  if(a[0] ne -1) then begin
   so4improve[a] = !values.f_nan
   so4improvestd[a] = !values.f_nan
  endif



  end
