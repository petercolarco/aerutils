; Do this by month
  nday = [31,28,31,30,31,30,31,31,30,31,30,31]
  mon  = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']

; save the monthly mean values
  med = fltarr(17,12)
  men = fltarr(17,12)


  for it = 0, 11 do begin

  if(it eq 0) then begin
   nt0 = 0
   nt1 = nday[it]-1
  endif else begin
   nt0 = nt1+1
   nt1 = nt0+nday[it]-1
  endelse
  get_stat, 'full.ddf', res0, nt0=nt0, nt1=nt1

  print, nt0, nt1

  endfor


end
