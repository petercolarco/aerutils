  pro read_daily, filename, $
    date, avg, std, num, yyyy=yyyy

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
  readf, lun, str
  ndate = 0
  data = fltarr(4)
  while(not(eof(lun))) do begin
   readf, lun, data
   ndate = ndate+1
  endwhile
  free_lun, lun

; Now get the data for good
  openr, lun, filename_, /get_lun
  str = 'a'
  readf, lun, str
  data = dblarr(4,ndate)
  readf, lun, data
  free_lun, lun
  date_ = long(reform(data[0,*]))
  avg_  = reform(data[1,*])
  std_  = reform(data[2,*])
  num_  = reform(data[3,*])

  if(iy eq 0 and im eq 0) then begin
   date = date_
   avg  = avg_
   std  = std_
   num  = num_
  endif else begin
   date = [date,date_]
   avg  = [avg,avg_]
   std  = [std,std_]
   num  = [num,num_]
  endelse
print, iy, im
   endfor
  endfor

end

