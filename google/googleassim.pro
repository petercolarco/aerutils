  date = '20080417_00z'

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/ARCTAS/0.5_deg/assim/tavg2d_aer_x
  varname  = 'duexttau'
  title = 'GEOS-5 AOT [550 nm] (dust)'
  levelarray = [.002,.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]/10.
  formatstr = '(f4.2)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, $
            formatstr=formatstr, wanttime=['2008041700','2008042300']
stop
  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/ARCTAS/0.5_deg/assim/tavg2d_aer_x
  varname  = 'suexttau'
  title = 'GEOS-5 AOT [550 nm] (sulfate)'
  levelarray = [.002,.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, $
            formatstr=formatstr, wanttime=['2008041700','2008042300']

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/ARCTAS/0.5_deg/assim/tavg2d_aer_x
  varname  = 'ccexttau'
  title = 'GEOS-5 AOT [550 nm] (carbonaceous)'
  levelarray = [.002,.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, $
            formatstr=formatstr, wanttime=['2008041700','2008042300']

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/ARCTAS/0.5_deg/assim/tavg2d_aer_x
  varname  = 'totexttau'
  title = 'GEOS-5 AOT [550 nm] (total)'
  levelarray = [.002,.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, $
            formatstr=formatstr, wanttime=['2008041700','2008042300']

end
