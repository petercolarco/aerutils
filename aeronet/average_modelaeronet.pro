  pro average_modelaeronet, exppath, expid, year, location, lambdawant, $
                            ave, std, num, $
                            sample=sample, $
                            angstrom=angstrom

  ny = n_elements(year)
  ave = fltarr(ny*12)
  std = fltarr(ny*12)
  num = intarr(ny*12)

  for iy = 0, ny-1 do begin
   for im = 0, 11 do begin
    dateAve = long(year[iy])*100L + (im+1)
    if(keyword_set(angstrom)) then begin
     aot = 1.
     readmodelaeronet, exppath, expid, year[iy], location, lambdawant, $
                       aotModel, dateModel, angstrom=aot
    endif else begin
     readmodelaeronet, exppath, expid, year[iy], location, lambdawant, $
                       aotModel, dateModel
     aot = total(aotModel,2)
    endelse

;   If keyword sample is set then we're going to average only days in the
;   model that had AERONET observations
    if(keyword_set(sample)) then begin
     aerPath = '/output/colarco/AERONET/AOT_Version2/'
     readaeronet, aerpath, location, lambdawant, year[iy], $
                  aotAeronet, dateAeronet
     a = where(aotAeronet lt 0)  ; flag out missing values
;    now set missing days from AERONET to missing in model
     if(a[0] ne -1) then begin
      datemodel = strcompress(string(datemodel),/rem)
      dateaeronet = strcompress(string(dateaeronet),/rem)
      for j = 0, n_elements(a)-1 do begin
       b = where(strmid(dateModel,0,8) eq dateAeronet[a[j]])
       dateModel[b] = '19710605'
      endfor
     endif
    endif

    average_vector, aot, dateModel, dateAve, valout, stdout, nout, rc=rc

    nmin = 12
    if(rc or nout lt nmin) then begin
     num[iy*12+im] = 0
     ave[iy*12+im] = !values.f_nan
     std[iy*12+im] = !values.f_nan
    endif else begin
     num[iy*12+im] = nout
     ave[iy*12+im] = valout
     std[iy*12+im] = stdout
    endelse

   endfor
  endfor

end
