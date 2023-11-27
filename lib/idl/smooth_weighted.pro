; Colarco
; smooth_weighted
; Running mean average weighted by some weight value (as an optional parameter)

  function smooth_weighted, arrIn, w, weight=weight

  if(w ne fix(w) or w eq 1) then begin
   print, 'need integer w (w > 1); exit'
   stop
  endif

  n = n_elements(arrIn)
  if(not(keyword_set(weight))) then weight = make_array(n,val=1.)

; Create padded array
  arrTmp = [make_array(w,val=arrIn[0]),arrIn,make_array(w,val=arrIn[n-1])]
  wgtTmp = [make_array(w,val=weight[0]),weight,make_array(w,val=weight[n-1])]

; Create output array
  arrOut = arrIn

; Now loop
  for i = 0, n-1 do begin
   k = i+w
   arrTmp_ = arrTmp[k-w/2:k+w/2]
   wgtTmp_ = wgtTmp[k-w/2:k+w/2]
   a = where(finite(arrTmp_) eq 1)
   if(a[0] eq -1) then begin
    arrOut[i] = !values.f_nan
   endif else begin
    arrOut[i] = total(arrTmp_[a]*wgtTmp_[a])/total(wgtTmp_[a])
   endelse
  endfor

  return, arrOut

end



