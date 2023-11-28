; Plot the annual AOD difference

  ddf1 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.full.totexttau.day.annual.2014.nc4'
  ddf2 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.gpm.nodrag.1100km.totexttau.day.annual.2014.nc4'
  ddf3 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.gpm055.nodrag.1100km.totexttau.day.annual.2014.nc4'
  ddf4 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.gpm050.nodrag.1100km.totexttau.day.annual.2014.nc4'
  ddf5 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.gpm045.nodrag.1100km.totexttau.day.annual.2014.nc4'

  nc4readvar, ddf1, 'totexttau', aod1, lon=lon, lat=lat
  nc4readvar, ddf2, 'totexttau', aod2, lon=lon, lat=lat
  nc4readvar, ddf3, 'totexttau', aod3, lon=lon, lat=lat
  nc4readvar, ddf4, 'totexttau', aod4, lon=lon, lat=lat
  nc4readvar, ddf5, 'totexttau', aod5, lon=lon, lat=lat

  area, lon, lat, nx, ny, dx, dy, area

  a = where(aod2 gt 1000.)
  aod2[a] = !values.f_nan
  a = where(aod3 gt 1000.)
  aod3[a] = !values.f_nan
  a = where(aod4 gt 1000.)
  aod4[a] = !values.f_nan
  a = where(aod5 gt 1000.)
  aod5[a] = !values.f_nan

  aod1t = aave(aod1,area)
  aod2t = aave(aod2,area,/nan)
  aod3t = aave(aod3,area,/nan)
  aod4t = aave(aod4,area,/nan)
  aod5t = aave(aod5,area,/nan)

  aod1w = total(aod1*area,/nan)/1e12
  aod2w = total(aod2*area,/nan)/1e12
  aod3w = total(aod3*area,/nan)/1e12
  aod4w = total(aod4*area,/nan)/1e12
  aod5w = total(aod5*area,/nan)/1e12

  a = where(finite(aod1) eq 1)
  aod1o = total(aod1[a]*area[a])/1e12
  a = where(finite(aod2) eq 1)
  aod2o = total(aod1[a]*area[a])/1e12
  a = where(finite(aod3) eq 1)
  aod3o = total(aod1[a]*area[a])/1e12
  a = where(finite(aod4) eq 1)
  aod4o = total(aod1[a]*area[a])/1e12
  a = where(finite(aod5) eq 1)
  aod5o = total(aod1[a]*area[a])/1e12

  print, aod1t, aod2t, aod3t, aod4t, aod5t, format='(5(f6.4,2x))'
  print, aod1w, aod2w, aod3w, aod4w, aod5w, format='(5(f6.3,2x))'
  print, aod1o, aod2o, aod3o, aod4o, aod5o, format='(5(f6.3,2x))'

end
