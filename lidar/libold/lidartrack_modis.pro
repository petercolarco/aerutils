; Colarco, Sept. 2008
; Given a lidar ground track of (time, lon, lat) extract the MODIS
; AOT retrievals along the track

; Inputs:
;  trackdate = YYYYMMDD.fracday form (where fracday = 0 for 0Z, = 0.5 for 12z)
;  tracklon  = track longitude on ground
;  tracklat  = track latitude on ground
;  modistemplate = GrADS template DDF of data location

; Optional:
;  filetocreate = filename of output file
;  wantlev = levels (channels) desired to extract from satellite

; Note:
;  the files produced are perhaps larges (100s of MB)
;  I think this code is not suitable for sampling across year boundaries;
;  see the daynum stuff below.

  pro lidartrack_modis, trackdate, tracklon, tracklat, $
                        modistemplate, $
                        filetocreate = filetocreate, $
                        wantlev = wantlev

  if(not(keyword_set(filetocreate))) then filetocreate = 'lidartrack_modis.ncdf'

; Setup control for output
  nx = 1
  ny = 1
  nt = n_elements(trackdate)
  ga_getvar, modistemplate, '', nodata, lon=lon, lat=lat, lev=lev, wantlev=wantlev, /noprint
  nz = n_elements(lev)

; -----------------------------------------------------------
; Create an output file
  cdfid = ncdf_create(fileToCreate, /clobber)
   idZ    = ncdf_dimdef(cdfid,'z',nz)
   idTime = ncdf_dimdef(cdfid,'time',/unlimited)
   idDay  = ncdf_vardef(cdfid,'time', [idTime], /double)
   idDate = ncdf_vardef(cdfid,'date', [idTime], /long)
   idLon  = ncdf_vardef(cdfid,'lon', [idTime], /float)
   idLat  = ncdf_vardef(cdfid,'lat', [idTime], /float)
   idLev  = ncdf_vardef(cdfid,'lev', [idZ], /float)
   idTau  = ncdf_vardef(cdfid,'tau', [idZ,idTime], /float)
  ncdf_control, cdfid, /endef
  ncdf_varput, cdfid, idLev, lev
  ncdf_varput, cdfid, idLon, tracklon
  ncdf_varput, cdfid, idLat, tracklat
  ncdf_varput, cdfid, idDay, trackdate


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

; Date is the sampled data of the dataset (model/satellite)
  id = ncdf_varid(cdfid,'date')
  ncdf_varput, cdfid, id, date

; -----------------------------------------------------------
; At this point, let's pull out the model variables
; Search by uniq dates
  date = strcompress(string(date),/rem)
  dateu = date[uniq(date)]
  ndate = n_elements(dateu)

  id = [idTau]
  var = ['aodtau']
  nvar = n_elements(var)

  for ivar = 0, nvar-1 do begin

   varout = fltarr(nz,nt)
   for idate = 0, ndate-1 do begin
    a = where(date eq dateu[idate])
    print, dateu[idate],' ', var[ivar],' ', n_elements(a)
    lon_ = tracklon[a]
    lat_ = tracklat[a]

;   get the variable
    ga_getvar, modistemplate, var[ivar], varval, $
               lon=lon, lat=lat, lev=lev, wanttime=dateu[idate]
;    hdfreadvar, modistemplate, dateu[idate], var[ivar], varval
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)
    for iz = 0, nz-1 do begin
;    Rather than a bilinear interpolation, let's do a nearest neighbor
;     varout[iz,a] = interpolate(varval[*,*,iz],ix,iy)
     varout[iz,a] = interpolate(varval[*,*,iz],long(ix+.5),long(iy+.5))
    endfor
    ncdf_varput, cdfid, id[ivar], varout[*,a], count=[nz,n_elements(a)], $
                 offset=[0,min(a)]
   endfor

  endfor
  ncdf_close, cdfid


end
