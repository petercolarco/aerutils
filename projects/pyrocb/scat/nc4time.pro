; Colarco, January 2001
; Given a netcdf filename, open the file and return the
; times in the form NYMD NHMS

  pro nc4time, filename, time, nymd, nhms, timeunits=timeunits, cdfid=cdfidIn

  if(keyword_set(cdfidIn)) then cdfid = cdfidIn else cdfid = ncdf_open(filename)

  id = ncdf_varid(cdfid, 'time')
  ncdf_varget, cdfid, id, time
  ncdf_attget, cdfid, id, 'units', timeunits
  timeunits = string(timeunits)

; Parse the time units (assume GEOS-5 style files)
  str = strsplit(timeunits,/extract)

; First field is increment unit; convert to seconds
  case str[0] of
   'month'   : convfac = 1440.*30.
   'days'    : convfac = 1440.
   'hours'   : convfac = 60.
   'minutes' : convfac = 1.
   ELSE      : stop
  endcase

; Get the start time
  months = [' ','jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
  str2  = strsplit(str[2],'-',/extract)
  yyyy_ = strpad(str2[0],1000L)
  mm_   = strpad(str2[1],10L)
  dd_   = strpad(str2[2],10L)
; fix months if bogus
  if(str2[1] lt '01' or str2[1] gt '12') then str2[1] = '01'
  nymd0 = yyyy_ + mm_ + dd_
  daymonyear = dd_+months[fix(mm_)]+yyyy_
  pos = strpos(str[3],':')
  if(pos[0] eq -1) then begin
   offset = time[0]
   if(offset eq 0) then begin
;   number is assumed given as just an hour
    nhms0 = strpad(str[3],10)+'0000'
    hourminute = strpad(str[3],10)
   endif else begin
    mm = strpad(offset*convfac,10)
    nhms0 =  strpad(str[3],10)+mm+'00'
    hourminute = strpad(str[3],10)+':'+mm
   endelse
  endif else begin
   str3 = strsplit(str[3],':',/extract)
   nhms0 = strpad(str3[0],10L)+strpad(str3[1],10L)+strpad(str3[2],10L)
   hourminute = strpad(str3[0],10L)+':'+strpad(str3[1],10L)
  endelse

  nt  = strcompress(string(n_elements(time)),/rem)
  inc = '60'
  if(nt gt 1) then inc = strcompress(string(long((time[1]-time[0])*convfac)),/rem)
  inc = inc+'mn'
  tdef = 'tdef time '+nt+' linear '+hourminute+'z'+daymonyear+' '+inc
  dateexpand, nymd0, nymd0, nhms0, nhms0, nymd, nhms, tdef=tdef
  if(not(keyword_set(cdfidIn))) then ncdf_close, cdfid

end
