  date = 'sep2007'

  filename = 'http://opendap:9090/dods/GEOS-4/AeroChem/assim_met/chem_diag.sfc'
  varname  = 'ccexttau'
  title = 'GEOS-4 AOT [550 nm] (carbonaceous)'
  kml_make, filename, date, varname, title=title, $
   wanttime=['12z1sep2007','12z6sep2007']

end

