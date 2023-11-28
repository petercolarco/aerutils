  date = '2005061812'

  filename = 'sfc.'+date+'.ddf'
  varname  = 'totexttau'
  title = 'GEOS-4 AOT [550 nm] (total)'
  kml_make, filename, date, varname, title=title

  filename = 'sfc.'+date+'.ddf'
  varname  = 'preacc'
  title = 'GEOS-4 PREACC [mm/day]'
  levelarray = [3,6,9,12,15,18,21,24,27,35,50]
  formatstr = '(i2)'
  kml_make, filename, date, varname, title=title, $
            levelarray=levelarray, formatstr=formatstr

  filename = 'prs.'+date+'.ddf'
  varname  = 'dumass'
  scalefac = 1.e9*.5
  wantlev = [200]
  levelarray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130]
  title = 'GEOS-4 Dust @ 200 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

  filename = 'prs.'+date+'.ddf'
  varname  = 'dumass'
  scalefac = 1.e9*.5
  wantlev = [500]
  levelarray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130]
  title = 'GEOS-4 Dust @ 500 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr


  filename = 'prs.'+date+'.ddf'
  varname  = 'bcmass'
  scalefac = 1.e12
  wantlev = [200]
  levelarray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130]
  title = 'GEOS-4 BC @ 200 hPa [pptm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

  filename = 'prs.'+date+'.ddf'
  varname  = 'bcmass'
  scalefac = 1.e12
  wantlev = [500]
  levelarray = [20, 40, 80, 100, 120, 140, 160, 180, 200, 240, 300]
  title = 'GEOS-4 BC @ 500 hPa [pptm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr



  filename = 'prs.'+date+'.ddf'
  varname  = 'co'
  scalefac = 1.e9
  wantlev = [200]
  levelarray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130]
  title = 'GEOS-4 CO @ 200 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

  filename = 'prs.'+date+'.ddf'
  varname  = 'co'
  scalefac = 1.e9
  wantlev = [500]
  levelarray = [30, 40, 50, 60, 70, 80, 90, 110, 130, 150, 170]
  title = 'GEOS-4 CO @ 500 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

  filename = 'prs.'+date+'.ddf'
  varname  = 'co'
  scalefac = 1.e9
  wantlev = [850]
  levelarray = [30, 50, 70, 90, 110, 130, 150, 170, 190, 210, 230]
  title = 'GEOS-4 CO @ 850 hPa [ppbm]'
  formatstr = '(i3)'
  kml_make, filename, date, varname, wantlev=wantlev, $
            scalefac=scalefac, levelarray=levelarray, $
            title=title, formatstr=formatstr

end

