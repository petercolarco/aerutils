  pro average_aeronet, aerPath, year, location, lambdawant, $
                       ave, std, num, $
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
     readaeronet, aerpath, location, lambdawant, year[iy], $
                  aot_, dateModel, angstrom=aot
    endif else begin
     readaeronet, aerpath, location, lambdawant, year[iy], $
                  aot, dateModel
    endelse
    average_vector, aot, dateModel, dateAve, valout, stdout, nout, $
                    missing=-9999., rc=rc

;   Check that we have a suitable number of points
    nmin = 3
    if(rc or nout lt nmin) then begin
     num[iy*12+im] = 0
     ave[iy*12+im] = -9999.
     std[iy*12+im] = -9999.
    endif else begin
     num[iy*12+im] = nout
     ave[iy*12+im] = valout
     std[iy*12+im] = stdout
    endelse
   endfor
  endfor

end
