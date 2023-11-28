  sattrack = 'neg5deg.txt'
  read_lidartrack_modis, time, date, lon, lat, lev, tau, $
                       sattrack=sattrack
  iz = 5
  tau = reform(tau[iz,*])

  for dd = 14, 31 do begin
  a = where(date eq 2007070018L+100L*dd)
  map_set, /cont, title=dd
  plots, lon[a], lat[a]
  loadct, 39
  b = where(finite(tau[a]) eq 1)
  if(b[0] ne -1) then $
   plots, lon[a[b]], lat[a[b]], psym=4, color=80

  wait, 1
  endfor

end
