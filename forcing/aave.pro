; Colarco, November 2006
; Colarco, July 2010 -- add exclusion for missing values
; Colarco, June 2012 -- allow for possibly of input having more than
;                       two dimensions.  First two are nx,ny.  If
;                       more than two then return shape of remaining.

  function aave, input, area, nan=nan

  input_ = input
  area_  = area

  if(keyword_set(nan)) then begin
   a = where(finite(input_) eq 0)
   if(a[0] ne -1) then area_[a] = !values.f_nan
   if(nan gt 1) then begin
    a = where(input_ gt nan)
    if(a[0] ne -1) then area_[a] = !values.f_nan
   endif
  endif else begin
   nan = 0
  endelse

; Possibly have more than two dimensional input
  a = size(input_)
  ndim = a[0]
  case ndim of
      1: aave = total(input_*area_,nan=nan)/total(area_,nan=nan)
      2: begin
         if(a[1]*a[2] ne n_elements(area_)) then stop
         area_ = reform(area_,a[1]*a[2])
         a = where(finite(input_) eq 1)
         aave = total(input_*area_,nan=nan)/total(area_,nan=nan)
         end
   else: begin
         if(a[1]*a[2] ne n_elements(area_)) then stop
         area_ = reform(area_,a[1]*a[2])
         nex = 1
         for i = 3, ndim do begin
          nex = nex*a[i]
         endfor
         input_ = reform(input_,[a[1]*a[2],nex])
         arr = make_array(nex,val=0.d)
         for i = 0, nex-1 do begin
          arr[i] = total(input_[*,i]*area_,nan=nan)/total(area_,nan=nan)
         endfor
         aave = reform(arr,a[3:ndim])
         end
  endcase
  return, aave

end
