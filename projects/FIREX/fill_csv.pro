; Given a set of aircraft way point create a higher resolution CSV
; file suitable for the trj/ext_sampler.py algorithms

  datestr_ = '2019-08-04T'

; Way points provided by flight plan
  pts = [-116.08,44.21,0, $
         -116.06,44.37,0, $
         -116.06,44.48,0, $
         -116.11,44.71,0, $
         -116.28,47.2,0, $
         -115.38,47.5,0, $
         -117.79,48.2,0, $
         -118.74,47.9,0, $
         -122.63,46.36,0, $
         -122.27,42.85,0, $
         -123.11,42.55,0, $
         -116.19,43.55,0, $
         -116.22,43.56,0]
  npts = n_elements(pts)/3
  pts = reform(pts,3,npts)
  lon0 = reform(pts[0,*])
  lat0 = reform(pts[1,*])

; Now use a great circle route to get in between points
  for i = 0, npts-2 do begin
   stlat = lat0[i]
   stlon = lon0[i]
   enlat = lat0[i+1]
   enlon = lon0[i+1]
   n = 100
   gr_circ_rte,stlat,stlon,enlat,enlon,n,bearing,dist,del,latp,lonp,rd
   if(i eq 0) then begin
    lon = lonp
    lat = latp
   endif else begin
    lon = [lon,lonp[1:n-1]]
    lat = [lat,latp[1:n-1]]
   endelse
  endfor
  lon[where(lon gt 180, /null)] = lon[where(lon gt 180, /null)]-360.
  n = n_elements(lon)
; fudge up some times
  hh = '00'
  mm = '00'
  ss = '00'
  datestr = datestr_+hh+':'+mm+':'+ss
  for i = 0, n-1 do begin
   ss = strpad(fix(ss)+1,10)
   if(fix(ss) ge 60) then begin
    ss = strpad(fix(ss)-60,10)
    mm = strpad(fix(mm)+1,10)
    if(fix(mm) ge 60) then begin
     mm = strpad(fix(mm)-60,10)
     hh = strpad(fix(hh)+1,10)
    endif
   endif
;   datestr = [datestr,datestr_+hh+':'+mm+':'+ss]
   datestr = [datestr,datestr_+'00:00:00']
  endfor

  dataout = strcompress(string(lon),/rem)+','+$
            strcompress(string(lat),/rem)+','+$
            datestr

  openw, lun, '20190804.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n-1 do begin
   printf, lun, dataout[j]
  endfor
  free_lun, lun


end

