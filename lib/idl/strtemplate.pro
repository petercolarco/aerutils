; strtemplate.pro
; Colarco, December 2010
; Given a grads-style filename template, expand to a filename
; given an input string (optional) and date (nymd, nhms)

; assumes 2 digit subsitution tokens (e.g., ch, y4, m2, ...)

  function strtemplate, template, nymd, nhms, str=str

; Fill in any shell variables
  spawn, 'echo '+template, template

; null case - not a template, just return what is given
  if(strpos(template,'%') eq -1) then return, template

; break apart on '%' delimeter
  ftmp  = strsplit(template,'%',/extract)
  nymd_ = string(nymd,format='(i8)')
  nhms_ = strpad(string(nhms,format='(i6)'),100000L)
  yyyy  = strpad(strmid(nymd_,0,4),1000)
  mm    = strpad(strmid(nymd_,4,2),10)
  dd    = strpad(strmid(nymd_,6,2),10)
  hh    = strpad(strmid(nhms_,0,2),10)
  nn    = strpad(strmid(nhms_,2,2),10)
  ss    = strpad(strmid(nhms_,4,2),10)

  for j = 0, n_elements(nymd)-1 do begin
   filename_ = ftmp[0]
   ftmp_     = ftmp
   for i = 1, n_elements(ftmp)-1 do begin
    strtag = strmid(ftmp_[i],0,2)
    strend = strmid(ftmp_[i],2,strlen(ftmp[i])-2)
    case strtag of
     'ch': ftmp_[i] = str +strend
     'y4': ftmp_[i] = yyyy[j]+strend
     'm2': ftmp_[i] = mm[j]  +strend
     'd2': ftmp_[i] = dd[j]  +strend
     'h2': ftmp_[i] = hh[j]  +strend
     'n2': ftmp_[i] = nn[j]  +strend
    endcase
    filename_ = filename_+ftmp_[i]
   endfor
   if(j eq 0) then filename = filename_ else filename = [filename,filename_]
  endfor

  return, filename

end
