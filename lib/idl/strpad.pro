; Colarco
; Take a number and compare to some other number
; If input number < comparison number then pad with
; zeroes.
; Return number as a string
; e.g., mm = strpad(1,10) returns mm = '01'
; Assumes numbers are integers/long

  function strpad, input, compn

  n = n_elements(input)
  strout_ = strarr(n)

  input_  = long(input)
  compn_  = long(compn)
  strout_ = strcompress(string(input_),/rem)

; log10 gives number of zeroes to pad
  comporder = fix(alog10(compn_))
  for i = 0, n-1 do begin

   if(input_[i] lt compn_) then begin

    if(input_[i] eq 0) then begin
     for j = 1, comporder do begin
      strout_[i] = '0'+strout_[i]
     endfor
    endif else begin
     inporder = fix(alog10(input_[i]))
     for j = 1, comporder-inporder do begin
      strout_[i] = '0'+strout_[i]
     endfor
    endelse

   endif

  endfor

  if(n eq 1) then return, strout_[0] else return, strout_

  end
