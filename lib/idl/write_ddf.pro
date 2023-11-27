; Colarco, April 2007
; Given a date and some optional parameters create a ddf file suitable for
; templating a file stream

; Forecast option: date passed in is the analysis time

  pro write_ddf, ctlfile, directory, filehead, date0, forecast=forecast, $
                 incstr = incstr, ntime = ntime

; assume some defaults
  if(not(keyword_set(incstr)))   then incstr   = '6'    ; a default time increment (hours)
  if(not(keyword_set(ntime)))    then ntime    = '6000' ; some large # of times
  if(not(keyword_set(forecast))) then forecast = 0
  templatestr = directory+'/Y%y4/M%m2/'+filehead+'%y4%m2%d2.hdf'

; create the initial time in the file
  parsedate, date0, yyyy, mm, dd, hh
  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
  time0str = hh+'z'+dd+mon[fix(mm)-1]+yyyy

; handle the special time variable name if from prs file
  tvar = 'time'
  if(strpos(filehead,'prs') ne -1 and yyyy eq '2006') then tvar = 'TIME:EOSGRID'


  if(forecast) then begin
;  fix the first hour
   hh0 = float(hh)+float(incstr)/2.
   nn0 = strcompress(string(fix( (hh0-fix(hh0))*60.)),/rem)
   if(fix(nn0) lt 10) then nn0 = '0'+nn0
   hh0 = strcompress(string(fix(hh0)),/rem)
   if(fix(hh0) lt 10) then hh0 = '0'+hh0
   templatestr = directory+'/Y'+yyyy+'/M'+mm+'/D'+dd+'/H'+hh+'/'+ $
                  filehead+yyyy+mm+dd+'_'+hh+'z+%y4%m2%d2_%h2%n2z.hdf'
   time0str = hh0+':'+nn0+'z'+dd+mon[fix(mm)-1]+yyyy
   ntime = string(5*24/fix(incstr))
  endif

  openw, lun, ctlfile, /get_lun
  printf, lun, 'dset '+templatestr
  printf, lun, 'options template'
  printf, lun, 'tdef '+tvar+' '+ntime+' linear '+time0str+' '+incstr+'hr'

  free_lun, lun

end
