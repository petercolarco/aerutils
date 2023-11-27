; Colarco, February 2011
; Given a GrADS style descriptor file, extract the tdef line
; and return the times (and optionally, Julian dates) on the file

  pro ga_times, ctlfile, nymd, nhms, template=template, tdef=tdef, jday=jday, rc=rc

  template = ''
; parse the ctlfile
  openr, lun, ctlfile, /get
  str = 'a'
  while(not(eof(lun))) do begin
   readf, lun, str
   strparts = strtrim(strsplit(str,/extract),2)
   if(strlowcase(strparts[0]) eq 'dset') then begin
    template = strcompress(strmid(str,4,strlen(str)-4),/rem)
   endif
   if(strlowcase(strparts[0]) eq 'tdef') then begin
    tdef = str
    continue
   endif
  endwhile
  free_lun, lun

  if(template eq '') then begin
   print, 'problem: no template found in ga_times; exit'
   stop
  endif

  dateexpand, 1L, 1L, 1L, 1L, nymd, nhms, tdef=tdef, jday=jday

end
