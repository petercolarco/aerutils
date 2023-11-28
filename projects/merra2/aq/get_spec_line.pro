  pro get_spec_line, lun, state_, county_, site_, lat_, lon_, param_, date_, mean_, max_, maxh_

  str = 'a'
  readf, lun, str
  str = str_replace(str,'"',' ')
  str = strcompress(str,/rem)
  data = strsplit(str,',',/extract)

  state_  = data[0]
  county_ = data[1]
  site_   = data[2]
  lat_    = float(data[5])
  lon_    = float(data[6])
  param_  = data[8]
  date_   = data[10]
  mean_   = float(data[16])
  max_    = float(data[17])
  maxh_   = float(data[18])

end
