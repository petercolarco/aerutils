  date = 'latest'

  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'

  filename = 'arctas.ddf'
  varname  = 'duexttau'
  title = 'GEOS-5 AOT [550 nm] (dust)'
  kml_make, filename, date, varname, title=title, ntimes=240, levelarray=levelarray, formatstr=formatstr


end
