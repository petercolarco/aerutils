; dateexpand.pro
; Colarco, December 2010

; Given a range of dates as (nymd0,nymd1) and (nhms0,nhms1)
; return nymd and nhms as vector of all dates inclusive in
; that range

; Some control over the dates returned may be obtained as:
;  monthly - expand as if monthly dates are desired: YYYYMM15 is
;            returned, HHMMSS = 120000
;  daily   - expand as if daily dates are desired: HHMMSS = 120000
;  tinc    - if specified, tinc is the time increment to use in
;            minutes

; Default is to expand as if time increment is like some
; number of hours

  pro dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, $
                  monthly=monthly, daily=daily, tinc=tinc, $
                  tdef=tdef, jday=jday

  if(not(keyword_set(monthly))) then monthly = 0

; If not providing a grads style time tempate, then base
; counting off of Julian dates for nymd0/nhms0 and nymd1/nhms1
  if(not(keyword_set(tdef))) then begin
   nymd0_ = string(nymd0,format='(i8)')
   nhms0_ = strpad(string(nhms0,format='(i6)'),100000L)
   nn0    = strmid(nhms0_,0,2)*60L+strmid(nhms0_,2,2)*1L
   julday0 = julday_nymd(nymd0_,nhms0_)

   nymd1_ = string(nymd1,format='(i8)')
   nhms1_ = strpad(string(nhms1,format='(i6)'),100000L)
   nn1    = strmid(nhms1_,0,2)*60L+strmid(nhms1_,2,2)*1L
   julday1 = julday_nymd(nymd1_,nhms1_)
  endif else begin
; Else if using a grads style time template, ignore provided
; dates and return for all times in template
   ga_tdef, tdef, nymd0, nhms0, ninc, tinc
   nymd0_ = string(nymd0,format='(i8)')
   nhms0_ = strpad(string(nhms0,format='(i6)'),100000L)
   nn0    = strmid(nhms0_,0,2)*60L+strmid(nhms0_,2,2)*1L
   julday0 = julday_nymd(nymd0_,nhms0_)
   if(tinc eq 730.5*60L) then monthly = 1
  endelse

; Define time increment based on selection of daily/monthly
  if(keyword_set(daily)) then tinc = 1440
  if(keyword_set(monthly)) then tinc   = 730.5 * 60L

; If time increment is not specified above, then need to pick
; something.  If nhms0 = nhms1 then assume daily, else assume a
; staggered synoptic time is given, and calculate the tinc as from the
; last HHMMSS given, so that, e.g., nhms[1] = 210000 implies a six
; hour time increment centered at 3, 9, 15, 21z.  The exception to
; this is that if nhms[0] = 0 then assume that the time is not
; staggered, e.g., nhms[1] = 210000 implies a three hour time
; increment at 0, 3, 6, 9, 12, 15, 18, 21z.
  if(not(keyword_set(tinc))) then begin
   if(nhms0 eq nhms1) then tinc = 1440.d else $  ; assume day if nothing offered
                           tinc = 2.d*(1440.d - nn1*1.d)
   if(nhms0 eq 0)     then tinc = 1440.d - nn1*1.d
  endif
  tinc = double(tinc)


; Determine the number of time increments to accumulate
  if(not(keyword_set(tdef))) then begin
   ninc = long ( (julday1-julday0)*1440.d/tinc + 1)
  endif


  jday    = julday0
  nymd    = nymd0_
  nhms    = nhms0_

; Special handling for monthly files
  if(monthly) then begin
   iinc = 1
   while(iinc lt ninc) do begin
    caldat, jday[iinc-1], mm, dd, yyyy, hh, nn
    mm = fix(mm) + 1
    if(mm gt 12) then yyyy = fix(yyyy)+1
    if(mm gt 12) then mm = 1
    nymd = [nymd,string(yyyy*10000L+mm*100L+dd,format='(i8)')]
    nhms = [nhms,nhms0_]
    jday = [jday,julday_nymd(nymd[iinc],nhms[iinc])]
    iinc = iinc + 1
   endwhile
  endif else begin
   jday = jday + dindgen(ninc)*(tinc*60.d / 86400.d)
   caldat, jday, mm, dd, yyyy, hh, nn
   nymd = string(yyyy*10000L+mm*100L+dd,format='(i8)')
   nhms = strpad(string(hh*10000L+nn*100L),100000L)
  endelse

  nymd = string(nymd,format='(i8)')
  nhms = strpad(nhms,100000L)

  if(keyword_set(daily)) then nhms[*] = '120000'

  nymd0 = string(nymd[0],format='(i8)')
  nhms0 = strpad(nhms[0],100000L)
  nymd1 = string(nymd[ninc-1],format='(i8)')
  nhms1 = strpad(nhms[ninc-1],100000L)




end
