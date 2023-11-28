; Colarco, March 2019

; Read the nominal CALIPSO track file
; Write the mask on "d" grid for orbits
; +/- 30 minutes of hours

; Get a "d" grid
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Here is a "nominal" CALIPSO orbit valid in 2009
  trackfiles = '/misc/prc08/calipso/CALIPSO_Orbit_Track_2009.cdf'
  read_calipso_track, trackfiles, tracklon, tracklat, date, mbl=3

; Take CALIPSO date and convert to Julian day
  nymd = long(date)
  jday0 = julday_nymd(nymd,0L)

; Adjust jday to 2016
  jdayf = julday_nymd(20151231L,0L)
  djday = jdayf-jday0[0]
  jday  = jday0+djday

; Go back to day+fraction
  caldat, jday, mm, dd, yyyy, hh, nn, ss
  nymd_ = long(yyyy*10000L+mm*100L+dd)
  date_ = date-nymd+nymd_
  date  = date_

; Now I'm going to loop over my dates to make a mask for
; fraction of day = 0 is 0z; do this hourly
  date0 = double('20160101')
  dates = dblarr(366)
  dates[0] = date0
  for i = 1, 365 do begin
   dates[i] = double(incstrdate(dates[i-1]*100d,24)/100L)
  endfor

; Loop
  for i = 0, 365 do begin
   for j = 0, 23 do begin

print, i, j

    cfrac = dates[i]+j/24.d

    a = where(date ge cfrac-0.5/24.d and date lt cfrac+0.5/24.d)
    lon_  = tracklon[a]
    lat_  = tracklat[a]
    npt_  = n_elements(a)
    npts  = 100L
    lon__ = fltarr((npt_-1)*npts+1L)
    lat__ = fltarr((npt_-1)*npts+1L)
;   Use gr_circ_rte to fill in points in between CALIOP orbit
    for k = 0, npt_-2 do begin
     stlat = lat_[k]
     stlon = lon_[k]
     enlat = lat_[k+1]
     enlon = lon_[k+1]
     gr_circ_rte, stlat, stlon, enlat, enlon, npts+1, bearing, dist, del, latp, lonp, rd
     lon__[k*npts:k*npts+npts] = lonp  ; may be > 180 at this point, will fix next
     lat__[k*npts:k*npts+npts] = latp
    endfor
    lon_ = lon__
    lat_ = lat__
    b    = where(lon_ ge 180.)
    if(b[0] ne -1) then lon_[b] = lon_[b]-360

;   Find points where SZA < 90
    n = n_elements(lon_)
    sza = fltarr(n)
    for k = 0L, n-1 do begin
     szangle, string(dates[i],format='(i8)'), j*10000L, lon_[k], lat_[k], sza_, cossza_
     sza[k] = sza_
    endfor
    a = where(sza lt 90.)
    if(a[0] ne -1) then begin
     lon_ = lon_[a]
     lat_ = lat_[a]
     ix = interpol(indgen(nx),lon,lon_)
     iy = interpol(indgen(ny),lat,lat_)
     mask = make_array(nx,ny,val=1.e15)
     ixy = ix*ny+iy
     mask[ix,iy] = 1.
    endif else begin
     mask = make_array(nx,ny,val=1.e15)
    endelse
    datef = long(dates[i])*100L+j
    write_mask, '/misc/prc18/colarco/mask/', 'mask.calipso.sza', nx, ny, dx, dy, datef, lon, lat, mask, res='d'

   endfor

  endfor

end

