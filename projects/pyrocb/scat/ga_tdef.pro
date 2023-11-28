; Colarco, December 2010
; Given a GrADS style "tdef" template return the initial time as
; YYYYMMDD and HHMMSS and the time increment (in minutes)

  pro ga_tdef, tdef, nymd, nhms, ninc, tinc

  result = strarr(3)
  nhms = '-1'

; Parse the tdef and do error checking
  split = strsplit(tdef,/extract)
  if(strlowcase(split[0]) ne 'tdef' or $
     strlowcase(split[1]) ne 'time' or $
     strlowcase(split[3]) ne 'linear') then begin
   print, 'not a time tdef; exit'
   stop
  endif

; Number of time increments on the tdef
  num = split[2]
  ninc = long(num)
  if(ninc ne num) then begin
   print, 'error in number of increments; exit'
   stop
  endif

; split the time for time 0
  timestr = split[4]
  len = strlen(timestr)
; get the year
  yyyy = strmid(timestr,len-4,4)
; get the month
  mon  = strlowcase(strmid(timestr,len-7,3))
  months = [' ','jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
  a = where(mon eq months)
  if(a[0] eq -1) then begin
   print, 'error in months field; exit'
   stop
  endif
  mm = strpad(a,10)
; get the day
  a = strpos(timestr,'z')
  if(a[0] eq -1) then begin
;  no time given, will assume 120000
   dd = strpad(strmid(timestr,0,2),10)
   nhms = '120000'
  endif else begin
   dd = strpad(strmid(timestr,a[0]+1,2),10)
  endelse
; get the time of day
  if(a[0] ne -1) then begin
   hstr = strmid(timestr,0,a[0])
   a = strpos(hstr,':')
   if(a[0] eq -1) then begin
    hh = strpad(hstr,10)
    nn = '00'
   endif else begin
    nn = strpad(strmid(hstr,a[0]+1,2),10)
    hh = strpad(strmid(hstr,0,a[0]),10)
   endelse
   nhms = hh+nn+'00'  ; no seconds for now
  endif
  nymd = yyyy+mm+dd

; now split the time increment
  incstr = split[5]
  len = strlen(incstr)
  unit = strlowcase(strmid(incstr,len-2,2))
  num = long(strmid(incstr,0,len-2))
  mult = -1.
  case unit of
   'mn' : mult = 1.
   'hr' : mult = 1. * 60.
   'dy' : mult = 24. * 60.
   'mo' : mult = 730.5 * 60.
   'yr' : mult = 12. * 730.5 * 60.
  endcase
  if(mult lt 0) then begin
   print, 'error in time increment; exit'
   stop
  endif

  tinc = float(num)*mult

end
