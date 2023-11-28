  date = 'latest'

  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varname  = 'duexttau'
  title = 'GEOS-5 AOT [550 nm] (dust)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, formatstr=formatstr

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varname  = 'suexttau'
  title = 'GEOS-5 AOT [550 nm] (sulfate)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, formatstr=formatstr

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varname  = 'ccexttau'
  title = 'GEOS-5 AOT [550 nm] (carbonaceous)'
  kml_make, filename, date, varname, title=title, levelarray=levelarray, formatstr=formatstr

stop

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varname  = 'totexttau'
  title = 'GEOS-4 AOT [550 nm] (total)'
  kml_make, filename, date, varname, title=title

  filename = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg3d_chm_p.latest'
  varname  = 'co'
  scalefac = 1.e9
  wantlev = [500]
  levelarray = [30, 40, 50, 60, 70, 80, 90, 110, 130, 150, 170]
  title = 'GEOS-4 CO @ 500 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

end
