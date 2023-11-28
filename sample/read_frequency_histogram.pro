; Colarco, December 2009
; Modify to and assemble monthly files

  pro read_frequency_histogram, filename, $
    date, histnorm, num, histmin, histmax, nbin, $
    yyyy = yyyy

; Years
  if(not(keyword_set(yyyy))) then $
   yyyy = ['2000','2001','2002','2003','2004','2005','2006','2007','2008','2009']
; Months
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  ny = n_elements(yyyy)
  nm = n_elements(mm)

  tdate = 0L
  for iy = 0, ny-1 do begin
   for im = 0, nm-1 do begin
    filename_ = filename+yyyy[iy]+mm[im]+'.txt'

; Open and count
  openr, lun, filename_, /get_lun
  str = 'a'
  data = fltarr(3)
  readf, lun, str
  readf, lun, data
  histmin = data[0]
  histmax = data[1]
  nbin    = data[2]
  ndate = 0
  data = fltarr(nbin+1)
  while(not(eof(lun))) do begin
   readf, lun, data
   ndate = ndate+1
  endwhile
  free_lun, lun

; Now get the data for good
  tdate = tdate+long(ndate)
  openr, lun, filename_, /get_lun
  str = 'a'
  data = dblarr(3)
  readf, lun, str
  readf, lun, data
  data = dblarr(nbin+2,ndate)
  readf, lun, data
  free_lun, lun

  date_ = long(reform(data[0,*]))
  histnorm_ = data[1:nbin,*]
  num_ = reform(data[nbin+1,*])

  if(iy eq 0 and im eq 0) then begin
   date = date_
   histnorm = reform(histnorm_,nbin*ndate)
   num = num_
  endif else begin
   date = [date,date_]
   histnorm = [histnorm,reform(histnorm_,nbin*ndate)]
   num = [num,num_]
  endelse

   endfor
  endfor

  histnorm = reform(histnorm,nbin,tdate)

end

