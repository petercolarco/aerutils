  site = ['Moscow', 'Fairbanks', 'Seattle','New York','Los Angeles','New Delhi', $
          'Mexico City','Manila','Jakarta','Nairobi']
  lon = [37.62,-147.72,-122.33,-74.00,-118.24,77.10,-99.13,120.98,106.85,36.82]
  lat = [55.76,64.84,47.61,40.71,34.05,28.70,19.43,14.60,-6.21,-1.29]

  openw, lun, 'stn_sampler.csv', /get
  printf, lun, 'name,lon,lat'
  for i = 0, n_elements(site)-1 do begin
   printf, lun, strcompress(site[i],/rem)+','+$
                strcompress(string(lon[i],format='(f8.3)'),/rem)+','+$
                strcompress(string(lat[i],format='(f7.3)'),/rem)
  endfor

  free_lun, lun

end
