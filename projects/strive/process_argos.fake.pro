  function convert_time, time
  time_ = strsplit(time,' ',/extract)
  date  = time_[0]
  date_ = strsplit(date,'/',/extract)
  jday = julday(fix(date_[0]),fix(date_[1]),2022)-120
  caldat, jday,m,d,yyyy
  mm = string(m,format='(i02)')
  dd = string(d,format='(i02)')
  yyyy =   date_[2]
  yyyy = '2022'
  hour = time_[1]
  return, yyyy+'-'+mm+'-'+dd+'T'+hour+':00'
  end

  openr, lun, 'Argos lat long of limb sensor boresight.csv', /get
  str = 'a'
  readf, lun, str
  str_ = strsplit(str,',',/extract)
  time = convert_time(str_[0])
  lat1 = str_[1]
  lon1 = str_[2]
  lat2 = str_[3]
  lon2 = str_[4]
  lat3 = str_[5]
  lon3 = str_[6]
  lat4 = str_[7]
  lon4 = str_[8]
  lat5 = str_[9]
  lon5 = str_[10]
  lat6 = str_[11]
  lon6 = str_[12]
  lat7 = str_[13]
  lon7 = str_[14]
  lat8 = str_[15]
  lon8 = str_[16]

; Export
  openw, lun1, 'argos1.fake.csv', /get
  openw, lun2, 'argos2.fake.csv', /get
  openw, lun3, 'argos3.fake.csv', /get
  openw, lun4, 'argos4.fake.csv', /get
  openw, lun5, 'argos5.fake.csv', /get
  openw, lun6, 'argos6.fake.csv', /get
  openw, lun7, 'argos7.fake.csv', /get
  openw, lun8, 'argos8.fake.csv', /get

  printf, lun1, 'lon,lat,time'
  printf, lun2, 'lon,lat,time'
  printf, lun3, 'lon,lat,time'
  printf, lun4, 'lon,lat,time'
  printf, lun5, 'lon,lat,time'
  printf, lun6, 'lon,lat,time'
  printf, lun7, 'lon,lat,time'
  printf, lun8, 'lon,lat,time'

  printf, lun1, lon1,',',lat1,',',time
  printf, lun2, lon2,',',lat2,',',time
  printf, lun3, lon3,',',lat3,',',time
  printf, lun4, lon4,',',lat4,',',time
  printf, lun5, lon5,',',lat5,',',time
  printf, lun6, lon6,',',lat6,',',time
  printf, lun7, lon7,',',lat7,',',time
  printf, lun8, lon8,',',lat8,',',time

  while(not(eof(lun))) do begin
  str = 'a'
  readf, lun, str
  str_ = strsplit(str,',',/extract)
  time = convert_time(str_[0])

  lat1 = str_[1]
  lon1 = str_[2]
  lat2 = str_[3]
  lon2 = str_[4]
  lat3 = str_[5]
  lon3 = str_[6]
  lat4 = str_[7]
  lon4 = str_[8]
  lat5 = str_[9]
  lon5 = str_[10]
  lat6 = str_[11]
  lon6 = str_[12]
  lat7 = str_[13]
  lon7 = str_[14]
  lat8 = str_[15]
  lon8 = str_[16]
  printf, lun1, lon1,',',lat1,',',time
  printf, lun2, lon2,',',lat2,',',time
  printf, lun3, lon3,',',lat3,',',time
  printf, lun4, lon4,',',lat4,',',time
  printf, lun5, lon5,',',lat5,',',time
  printf, lun6, lon6,',',lat6,',',time
  printf, lun7, lon7,',',lat7,',',time
  printf, lun8, lon8,',',lat8,',',time
  endwhile


  free_lun, lun1
  free_lun, lun2
  free_lun, lun3
  free_lun, lun4
  free_lun, lun5
  free_lun, lun6
  free_lun, lun7
  free_lun, lun8



  

  free_lun, lun

end
