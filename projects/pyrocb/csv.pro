; Make a CSV of a trajectory given two end points

  wantlat = [52.43,64.23]
  wantlon = [-125.54,-118.16]
  npts = 100

; get some points
  gr_circ_rte, wantlat[0], wantlon[0], wantlat[1], wantlon[1], npts, $
               bearing, dist, del, latp, lonp, rd

  a = where(lonp gt 180)
  if(a[0] ne -1) then lonp[a] = lonp[a]-360.

; Create a file
  openw, lun, 'calipso.csv', /get
  printf, lun, 'lon,lat,time'
  for i = 0, npts-1 do begin
   str = string(lonp[i],format='(f8.3)')+','+$
         string(latp[i],format='(f6.3)')+','+'2017-08-13T11:00:00'
   printf, lun, str
  endfor
end
