  pro get_dust, filename, state, county, site, lat, lon, date, dust

  read_spec, filename, 'Iron', state, county, site, lat, lon, param, date, iron, max, maxh
  read_spec, filename, 'Aluminum', state, county, site, lat, lon, param, date, alum, max, maxh
  read_spec, filename, 'Silicon', state, county, site, lat, lon, param, date, sili, max, maxh
  read_spec, filename, 'Calcium', state, county, site, lat, lon, param, date, calc, max, maxh
  read_spec, filename, 'Titanium', state, county, site, lat, lon, param, date, tita, max, maxh

; Dust formula rom malm et al. 1994 (as in Chow et al. 2015
; doi:10.1007/s11869-015-0338-3)
  dust = 2.2*alum+2.49*sili+1.63*calc+1.94*tita+2.42*iron

end
