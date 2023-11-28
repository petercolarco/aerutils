; This compare the monthly mean weighted aot vs. one so constructed from daily obs.

  yyyy = '2000'
; Check my own monthly mean
  aerPath = '/output/colarco/AERONET/AOT_Version2/'

; By default, the monthly read returns the "aot_of_weighted_average"
  read_aeronet2nc, aerPath, 'Abracos_Hill', '550', yyyy, aotm, datem, $
                   /monflag, naot=naotm

; Get the daily aot values
  read_aeronet2nc, aerPath, 'Abracos_Hill', '550', yyyy, aotd, dated, $
                   angstrom=angd, naot=naotd
  read_aeronet2nc, aerPath, 'Abracos_Hill', '870', yyyy, aotd870, dated, $
                   angstrom=angd, naot=naotd
  read_aeronet2nc, aerPath, 'Abracos_Hill', '440', yyyy, aotd440, dated, $
                   angstrom=angd, naot=naotd

  dated = strcompress(string(dated),/rem)


; Compute my own angstrom exponent
  angd_ = make_array(n_elements(aotd440),val=-9999.)
  a = where(aotd440 gt 0.)
  angd_[a] = -alog(aotd440[a]/aotd870[a])/alog(440./870.)


; Now monthly average this
  aotm_ = fltarr(12)
   for imon = 1, 12 do begin
    mm = strcompress(string(imon),/rem)
    if(imon lt 10) then mm = '0'+mm
    a = where(strmid(dated,0,6) eq yyyy+mm and $
              aotd gt 0 )
    ndays = n_elements(a)

;   Only use months with more than 3 days observations in them
    if(ndays le 3) then begin
     aotm_[imon-1] = -9999.
    endif else begin
     aotm_[imon-1] = total(aotd[a]*naotd[a])/total(naotd[a])
    endelse

    print, n_elements(a), total(naotd[a]), naotm[imon-1], aotm_[imon-1], aotm[imon-1]
    


  endfor

end
