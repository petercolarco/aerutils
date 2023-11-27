; Colarco, January 2017

; Read a series of summary text printouts from "print_budget_table"
; and make some sense of relevant variables

  expid = ['c48F','c48R','c48Rreg','c48ctm', $
           'c90F','c90R','c90Rreg','c90ctm', $
           'c180F','c180R','c180Rreg','c180ctm' ] + '_H54p3-acma'

  nexpid = n_elements(expid)

; Vars I want to look at
  iduem = 2
  iduburden = 6
  idulife = 7
  iduwet = 8
  idudry = 11
  iduext = 14

  issem = 17
  issburden = 21
  isslife = 22
  isswet = 23
  issdry = 26
  issext = 29

  ibcburden = 36
  ibclife = 37
  ibcwet = 38
  ibcdry = 41
  ibcext = 44

  iocburden = 51
  ioclife = 52
  iocwet = 53
  iocdry = 56
  iocext = 59

  isuprod = 65
  isuburden = 70
  isulife = 71
  isuwet = 72
  isudry = 75
  isuext = 78

  ivars = [iduem, iduburden, idulife, iduwet, idudry, iduext, $
           issem, issburden, isslife, isswet, issdry, issext, $
                  ibcburden, ibclife, ibcwet, ibcdry, ibcext, $
                  iocburden, ioclife, iocwet, iocdry, iocext, $
           isuprod, isuburden, isulife, isuwet, isudry, isuext ]
  nvars = n_elements(ivars)

  title = ['Dust Emissions [Tg]', 'Dust Burden [Tg]', 'Dust Lifetime [days]', $
           'Dust Wet Removal Frequency [days!E-1!N]', $
           'Dust Dry Removal Frequency [days!E-1!N]', $
           'Dust AOD', $
           'Sea Salt Emissions [Tg]', 'Sea Salt Burden [Tg]', 'Sea Salt Lifetime [days]', $
           'Sea Salt Wet Removal Frequency [days!E-1!N]', $
           'Sea Salt Dry Removal Frequency [days!E-1!N]', $
           'Sea Salt AOD', $
           'BC Burden [Tg]', 'BC Lifetime [days]', $
           'BC Wet Removal Frequency [days!E-1!N]', $
           'BC Dry Removal Frequency [days!E-1!N]', $
           'BC AOD', $
           'POM Burden [Tg]', 'POM Lifetime [days]', $
           'POM Wet Removal Frequency [days!E-1!N]', $
           'POM Dry Removal Frequency [days!E-1!N]', $
           'POM AOD,', $
           'Sulfate Chemical Production [Tg]', 'Sulfate Burden [Tg]', 'Sulfate Lifetime [days]', $
           'Sulfate Wet Removal Frequency [days!E-1!N]', $
           'Sulfate Dry Removal Frequency [days!E-1!N]', $
           'Sulfate AOD']
  filestr = ['duem','duburden','dulife','duwet','dudry', 'duext', $
             'ssem','ssburden','sslife','sswet','ssdry', 'ssext', $
                    'bcburden','bclife','bcwet','bcdry', 'bcext', $
                    'ocburden','oclife','ocwet','ocdry', 'ocext', $
             'suprod','suburden','sulife','suwet','sudry', 'suext']
  formatstr = ['(i4)', '(f5.2)', '(f5.3)', '(f5.3)', '(f5.3)', '(f5.3)', $
               '(i4)', '(f5.2)', '(f5.3)', '(f5.3)', '(f5.3)', '(f5.3)', $
                       '(f5.2)', '(f5.3)', '(f5.3)', '(f5.3)', '(f5.3)', $
                       '(f5.2)', '(f5.3)', '(f5.3)', '(f5.3)', '(f5.3)', $
               '(i3)', '(f5.2)', '(f5.3)', '(f5.3)', '(f5.3)', '(f5.3)' ]

  table = fltarr(nvars,nexpid)

  for i = 0, nexpid-1 do begin
   openr, lun, expid[i]+'.txt', /get
;  count the lines
   j = 0
   while(not(eof(lun))) do begin
    str = 'a'
    readf, lun, str
    j = j+1
   endwhile
   free_lun, lun
   openr, lun, expid[i]+'.txt', /get
   str = strarr(j)
   readf, lun, str
   free_lun, lun
;  parse vars
   for k = 0, nvars-1 do begin
    l = ivars[k]
    len = strlen(str[l])
    m0 = strpos(str[l],' ',/reverse_search)+1
    table[k,i] = float(strmid(str[l],m0,len-m0))
    if(len gt 60) then begin
     str_ = strsplit(str[l],' ',/extract)
     n = n_elements(str_)
     table[k,i] = float(str_[n-2])
    endif
   endfor

  endfor

; Make a grid plot
  for i = 0, nvars-1 do begin

   print, i
   make_summarize_budget_plot, i, nexpid, table, title, filestr, formatstr

  endfor




end
