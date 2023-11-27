; Colarco, June 13, 2007
; Modify March 21, 2008
; When the user requests a wanttime we run it against this script
; that will return a grads-like time.

  function gradsdate, wanttime, hrstr=hrstr

  monstr = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', $
            'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

; Cases:
;  o 1: wanttime has a "-" character in it; assum that it is
;       like what is returned from ga_getvar: YYYY-MM-DD HH:NN Z

  if(strpos(string(wanttime),'-') ne -1) then begin
   split = strsplit(string(wanttime),' -:',/extract)
   yyyy = split[0]
   mon  = monstr[fix(split[1])-1]
   dd   = split[2]
   hh   = split[3]
   nn   = split[4]
   if(strupcase(nn) eq 'Z') then begin
     return, hh+':00z'+dd+mon+yyyy
   endif else begin
     return, hh+':'+nn+'z'+dd+mon+yyyy
   endelse
  endif

; Cases:
;  o 2: wanttime otherwise has characters in it (is a string,
;       not a number, so here we trust the reader has input
;       something reasonable

  if(strcompress(string(long64(wanttime)),/rem) ne $
     strcompress(string(wanttime),/rem) ) then return, wanttime

; Cases:
;  o 3: wanttime is a purely numeric format
;       Unless the number of digits fits one of the formats
;       below we assume we've requested an index (e.g., I
;       want the first time on the file).
;       THIS WILL BREAK IF YOU REALLY WANT A 4 DIGIT INDEX
;       YYYY       - annual 
;       YYYYMM     - monthly
;       YYYYMMDD   - daily
;       YYYYMMDDHH - hourly

   wanttime_ = strcompress(string(wanttime),/rem)
   len = strlen(wanttime_)
   if(keyword_set(hrstr)) then begin
    hrstr_ = hrstr
   endif else begin
    hrstr_ = '12'
   endelse
   case len of
     4:    return, hrstr_+'z15jun'+wanttime_
     6:    begin
           yyyy = strmid(wanttime_,0,4)
           mm   = strmid(wanttime_,4,2)
           return, hrstr_+'z15'+monstr[fix(mm)-1]+yyyy
           end
     8:    begin
           yyyy = strmid(wanttime_,0,4)
           mm   = strmid(wanttime_,4,2)
           dd   = strmid(wanttime_,6,2)
           return, hrstr_+'z'+dd+monstr[fix(mm)-1]+yyyy
           end
    10:    begin
           yyyy = strmid(wanttime_,0,4)
           mm   = strmid(wanttime_,4,2)
           dd   = strmid(wanttime_,6,2)
           hh   = strmid(wanttime_,8,2)
           return, hh+'z'+dd+monstr[fix(mm)-1]+yyyy
           end
    12:    begin
           yyyy = strmid(wanttime_,0,4)
           mm   = strmid(wanttime_,4,2)
           dd   = strmid(wanttime_,6,2)
           hh   = strmid(wanttime_,8,2)
           nn   = strmid(wanttime_,10,2)
           return, hh+':'+nn+'z'+dd+monstr[fix(mm)-1]+yyyy
           end
  else:    begin
           print, 'you gave: '+wanttime_+'; assuming an index'
           return, wanttime_
           end
  endcase

end


