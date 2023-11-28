; Fill a csv file with location/time information
  lon = '95.'

; Dates
  yyyy = '2014'
  mm   = '02'
  dd   = '14'
  hh   = strpad(indgen(24),10)
;  lon  = -180.+findgen(24)*15
  lat = -90.+findgen(24)*7.5

  openw, lun, 'csvfile', /get
  printf, lun, 'lon,lat,time'
  nd = n_elements(dd)
  nh = n_elements(hh)
  for id = 0, 23 do begin
;    printf, lun, strcompress(string(lon[id]),/rem)+','+lat+','+yyyy+'-'+mm+'-'+dd+'T'+hh[id]+':00:00'
    printf, lun, lon+','+strcompress(string(lat[id]),/rem)+','+yyyy+'-'+mm+'-'+dd+'T'+hh[id]+':00:00'
  endfor

  free_lun, lun
end
