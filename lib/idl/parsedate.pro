; Colarco, May 2007
; Parse a YYYYMMDDHH format to return the pieces

  pro parsedate, yyyymmddhh_, yyyy, mm, dd, hh

  yyyymmddhh = string(yyyymmddhh_)
  yyyy = strmid(yyyymmddhh,0,4)
  mm   = strmid(yyyymmddhh,4,2)
  dd   = strmid(yyyymmddhh,6,2)
  hh   = strmid(yyyymmddhh,8,2)

end
