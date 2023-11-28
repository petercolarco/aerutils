; Colarco, Sept. 2008
; Given a lidar ground track of (time, lon, lat) extract the MODEL
; parameters along the track

; Inputs:
;  trackdate = YYYYMMDD.fracday form (where fracday = 0 for 0Z, = 0.5 for 12z)
;  tracklon  = track longitude on ground
;  tracklat  = track latitude on ground
;  modistemplate = GrADS template DDF of data location
;  varlist = a list of variables to extract

; Optional:
;  filetocreate = filename of output file

; Note:
;  the files produced are perhaps larges (100s of MB)
;  I think this code is not suitable for sampling across year boundaries;
;  see the daynum stuff below.

  pro lidartrack_model, trackdate, tracklon, tracklat, $
                        modeltemplate, $
                        varlist, $
                        filetocreate=filetocreate

  if(not(keyword_set(filetocreate))) then $
     filetocreate = 'lidartrack_model.ncdf'

; Setup control for output
  nx = 1
  ny = 1
  nt = n_elements(trackdate)
  ga_getvar, modeltemplate, '', nodata, lon=lon, lat=lat, lev=lev, /noprint
  nz = n_elements(lev)
  set_eta, hyai, hybi, nz=nz
; pressure hPa = hyai + hybi*surface_pressure

  nvars = n_elements(varlist)
  idVar = lonarr(nvars)

; -----------------------------------------------------------
; Create an output file
  cdfid = hdf_sd_start(fileToCreate, /create)

   idx = hdf_sd_create(cdfid, 'hyai', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hyai
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'hybi', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hybi
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'time', [0], /double)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, trackdate
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lon', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, tracklon
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lat', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, tracklat
   hdf_sd_endaccess, idx

   for iv = 0, nvars-1 do begin
    idVar[iv] = hdf_sd_create(cdfid,varlist[iv], [nz,0], /float)
    dim = hdf_sd_dimgetid(idvar[iv],0)
    hdf_sd_dimset, dim, name='z'
    dim = hdf_sd_dimgetid(idvar[iv],1)
    hdf_sd_dimset, dim, name='time'
    hdf_sd_endaccess, idx
   endfor

; Massage the dates to find the appropriate model time to read
  strdate = strcompress(string(long(trackdate)),/rem)
  yyyy = strmid(strdate,0,4)
  mm   = strmid(strdate,4,2)
  dd   = strmid(strdate,6,2)
  yyyym1 = min(yyyy) - 1
; recall that julday likes to set 0.0 time at 12Z of the day
; this conflicts with Judd's definition of 0.0 time as 0Z of
; day, so I subtract 0.5 off of Judd's time ("time") to cast
; it consistently with what julday does.
  jday0 = julday(12,31,yyyym1)
  daynum = julday(mm,dd,yyyy) - jday0 $
     +      ( (trackdate) - long(trackdate) )
  jday = jday0+(daynum-0.5)   ; Julian of the observation

; assign the granularity to the times
; divide day into quarters (dt = 0.25 day)
; recall that .0 is the 12 z time
  fracday = jday-long(jday)

  a = where(fracday ge .375 and fracday lt .625)
  if(a[0] ne -1) then fracday[a] = 0.5

  a = where(fracday ge .625 and fracday lt .875)
  if(a[0] ne -1) then fracday[a] = 0.75

  a = where(fracday ge 0. and fracday lt .125)
  b = where(fracday ge .875)
  if(a[0] ne -1) then fracday[a] = 0.
  if(b[0] ne -1) then fracday[b] = 1.

  a = where(fracday ge .125 and fracday lt .375)
  if(a[0] ne -1) then fracday[a] = 0.25

  jday = float(long(jday))+fracday
  caldat, jday, mon, dd, yyyy, hh, mm, ss
  date = yyyy*1000000L + mon*10000L + dd*100L + hh

  idx = hdf_sd_create(cdfid, 'date', [0], /long)
  dim = hdf_sd_dimgetid(idx,0)
  hdf_sd_dimset, dim, name='time'
  hdf_sd_adddata, idx, date


; -----------------------------------------------------------
; At this point, let's pull out the model variables
; Search by uniq dates
  date = strcompress(string(date),/rem)
  dateu = date[uniq(date)]
  ndate = n_elements(dateu)

  for ivar = 0, nvars-1 do begin

   varout = fltarr(nz,nt)
   for idate = 0, ndate-1 do begin
    a = where(date eq dateu[idate])
print, dateu[idate],' ', varlist[ivar],' ', n_elements(a)
    lon_ = tracklon[a]
    lat_ = tracklat[a]

;   get the variable
;    ga_getvar, modeltemplate, varlist[ivar], varval, lon=lon, lat=lat, lev=lev, wanttime=dateu[idate]
    hdfreadvar, modeltemplate, dateu[idate], varlist[ivar], varval
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)
    for iz = 0, nz-1 do begin
;    Rather than a bilinear interpolation, let's do a nearest neighbor
;     varout[iz,a] = interpolate(varval[*,*,iz],ix,iy)
     varout[iz,a] = interpolate(varval[*,*,iz],long(ix+.5),long(iy+.5))
    endfor
    hdf_sd_adddata, idVar[ivar], varout[*,a], count=[nz,n_elements(a)], $
                 start=[0,min(a)]
   endfor

  endfor
  hdf_sd_end, cdfid


end
