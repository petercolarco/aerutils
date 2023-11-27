; Colarco, December 2010
; Given a grads ctl/ddf file return the contents of the
; dset descriptor line

  function parsectl_dset, ctlfile

; Check that it has the right extension; if not, assume it is a template
  len = strlen(ctlfile)
  ext = strlowcase(strmid(ctlfile,len-4,4))
  if(ext ne '.ctl' and ext ne '.ddf') then begin
   return, ctlfile
  endif

; open and read
  ctlfile = get_ctl(ctlfile)
  openr, lun, ctlfile, /get_lun
  dset = ''
  str = 'a'
  while(not(eof(lun)) and dset eq '') do begin
   readf, lun, str
   if(strlen(str) lt 4) then continue
   if(strlowcase(strmid(strcompress(str,/rem),0,4)) ne 'dset') then continue
   tmp = strsplit(str,' ',/extract)
   dset = tmp[1]
  endwhile
  free_lun, lun
  return, dset

end
