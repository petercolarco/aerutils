; Read "aeronet_locs.dat" and, given a year, return sites with valid
; data

  pro aeronet_valid, yyyy, location, lon, lat

  read_aeronet_locs, location, lat, lon, ele

  nlocs = n_elements(location)
  valid = make_array(nlocs,val=0)

  aeronetPath = '/misc/prc10/AERONET/LEV30/'
  lambdabase = '550'
  for iloc = 0, nlocs-1 do begin
    read_aeronet2nc, aeronetPath, location[iloc], lambdabase, yyyy, $
                     aeronetAOT, aeronetDate, /monthly
    a = where(aeronetaot gt -9990.)
    if(a[0] ne -1) then valid[iloc] = 1
  endfor

  a = where(valid eq 1)
  location = location[a]
  lat      = lat[a]
  lon      = lon[a]

end
