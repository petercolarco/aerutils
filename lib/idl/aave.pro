; Colarco, November 2006
; Colarco, July 2010 -- add exclusion for missing values
; Colarco, June 2012 -- allow for possibly of input having more than
;                       two dimensions.  First two are nx,ny.  If
;                       more than two then return shape of remaining.
; Colarco, May 2016  -- change sense of above to check on shape of
;                       input area array

  function aave, input, area, nan=nan

  input_ = input
  area_  = area

;  if(keyword_set(nan)) then begin
;   a = where(finite(input_) eq 0)
;   if(a[0] ne -1) then area_[a] = !values.f_nan
;   if(nan gt 1) then begin
;    a = where(input_ gt nan)
;    if(a[0] ne -1) then area_[a] = !values.f_nan
;   endif
;  endif else begin
;   nan = 0
;  endelse

; Check that however arranged, number of elements in area
; matches somehow the first elements in the input
  a = size(area_)
  if(a[0] eq 1) then begin    ; one dimensional area
   if(a[1] ne n_elements(input_[*,0])) then stop
   a = size(input_)
   ndim = a[0]
  endif else begin            ; two dimensional area
   a = size(input_)
   if(a[1]*a[2]*1L ne n_elements(area_)) then stop
   area_ = reform(area_,a[1]*a[2])
   ndim = a[0]
   nex = 1L
   for i = 3, ndim do begin
    nex = nex*a[i]
   endfor
   input_ = reform(input_,[a[1]*a[2]*1L,nex])
  endelse

; Check sizes again
  a = size(input_)
  ndim = a[0]
  if(ndim eq 1) then aave = total(input_*area_,nan=nan)/total(area_,nan=nan)
  if(ndim gt 1) then begin
   nex = 1
   for i = 2, ndim do begin
    nex = nex*a[i]
   endfor
   arr = make_array(nex,val=0.d)
   for i = 0, nex-1 do begin
    area_ = area
    if(keyword_set(nan)) then begin
     b = where(finite(input_[*,i]) ne 1)
     if(b[0] ne -1) then area_[b] = !values.f_nan
    endif
    arr[i] = total(input_[*,i]*area_,nan=nan)/total(area_,nan=nan)
   endfor
   aave = reform(arr,a[2:ndim])
  endif
  return, aave

end
