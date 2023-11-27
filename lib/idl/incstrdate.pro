; Colarco, October 2010
; Function to take as input a date YYYYMMDDHH and increment by some
; number of hours

  function incstrdate, inpdate, inchour

  inpdate = long(inpdate)

; Find the julian date
  yyyy  =  inpdate/1000000L
  mm    = (inpdate - yyyy*1000000L)/10000L
  dd    = (inpdate - yyyy*1000000L - mm*10000L)/100L
  hh    =  inpdate - yyyy*1000000L - mm*10000L - dd*100L
  jday0 = julday(mm,dd,yyyy,hh)

; Increment and return the new date
  jday1 = jday0 + inchour/24.
  caldat,jday1,mm,dd,yyyy,hh
  return, string(yyyy*1000000L+mm*10000L+dd*100L+hh,format='(i10)')

end
