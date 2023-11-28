; Colarco, August 2006
; Provide the arrays of data and dates and average them based on matching
; the dateave criteria.  That is, if dateave = '200009' then I want to
; average all dates beginning with '200009' (Sept. 2000 average)
; Return the mean and stddev value and the number of points

; Dates are expected in YYYYMMDDHH format

  pro average_vector, valIn, dateIn, dateAve, valOut, stdOut, nOut, $
      missing=missingval, rc=rc

  rc = 0

  missing = 0
  if(keyword_set(missingval)) then missing = 1

  date = strcompress(string(dateIn),/rem)
  dateAve = strcompress(string(dateAve),/rem)

  len = strlen(dateAve)
  if(missing) then begin
   a = where(strmid(date,0,len) eq dateAve and valIn ne missingVal)
  endif else begin
   a = where(strmid(date,0,len) eq dateAve)
  endelse
 
  if(a[0] eq -1) then begin
   nout = 0
   valout = !values.f_nan
   stdout = !values.f_nan
   rc = 1
   return
  endif

  nOut = n_elements(a)
  valOut = total(valIn[a])/nOut
  stdOut = 0.
  if(nOut ge 3) then stdOut = stddev(valIn[a])

  return

end
