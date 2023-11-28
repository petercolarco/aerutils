; Procedure is to draw a square spiral pattern starting from lon0,
; lat0 with a specified delta X (degrees) spacing and a rotation of
; angle degrees counterclockwise.  Also given is the time on station
; (time to fly the pattern in hours.fraction_of_hour) and the option
; to return a uniform time interpolated set of points.

  pro square_spiral, lon0, lat0, deltax, angle, ttime, ntime, $
                     lon, lat, time


;  ttime = 10.
;  ntime = ttime*360.
;  angle = 30.
;  deltax = 1.5   ; degrees
;  lon0   = -43.
;  lat0   = 17.

  lonnodes = deltax*(0.5 + [0.,0.,-1.,-1.,1.,1.,-2.,-2.,2.,2.,-3.,-3.])
  latnodes = deltax*(0.5 + [0.,-1.,-1.,1.,1.,-2.,-2.,2.,2.,-3.,-3.,2.])

; Distance on nodes
  npts = n_elements(lonnodes)
  distnodes = fltarr(npts)
  for ipts = 1, npts-1 do begin
   distnodes[ipts] = distnodes[ipts-1] + sqrt( (lonnodes[ipts]-lonnodes[ipts-1])^2. + $
                                               (latnodes[ipts]-latnodes[ipts-1])^2. )
  endfor
  distnodes = distnodes / max(distnodes)
  timenodes = distnodes*ttime

; Rotation and new node points
  ang = angle
  lon = lon0 + lonnodes*cos(ang*!pi/180.) + latnodes*sin(ang*!pi/180.)
  lat = lat0 - lonnodes*sin(ang*!pi/180.) + latnodes*cos(ang*!pi/180.)

; Time interpolation
  dtime = ttime/ntime
  time  = findgen(ntime)*dtime
  lon   = interpol(lon,timenodes,time)
  lat   = interpol(lat,timenodes,time)

end
