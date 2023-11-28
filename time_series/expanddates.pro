; Colarco, April 2011
; Given an input nymd and nhms, expand to fill in the intervening
; times
; Works for monthly values right now

  pro expanddates, nymd_i, nhms_i, nymd, nhms

  nymd_ = string(nymd_i,format='(i-8)')
  nhms_ = string(nhms_i,format='(i-6)')

  nymd = long(strmid(nymd_[0],0,6))
  if(n_elements(nymd_) eq 1) then goto, getout
  if(nymd_[0] eq nymd_[1])   then goto, getout

; Increment month/year
  yyyy  = nymd[0]/100L
  mm    = nymd[0]-yyyy*100L
  icnt = 0
  while(nymd[icnt] lt long(strmid(nymd_[1],0,6))) do begin
   mm = mm+1
   if(mm gt 12) then yyyy = yyyy+1
   if(mm gt 12) then mm = 1
   nymd = [nymd,yyyy*100L+mm]
   icnt = icnt+1
  endwhile

getout:
  nymd = string(nymd,format='(i-6)')+'15'
  nhms = make_array(n_elements(nymd),val='120000')



end
