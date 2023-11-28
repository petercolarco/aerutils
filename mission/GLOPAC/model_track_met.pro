; Colarco, Sept. 2008
; Given a lidar ground track of (time, lon, lat) extract the MODEL
; parameters along the track

; Inputs:
;  outfile   = filename of output file
;  trackdate = YYYYMMDD.fracday form (where fracday = 0 for 0Z, = 0.5 for 12z)
;  tracklon  = track longitude on ground
;  tracklat  = track latitude on ground

; Note:
;  the files produced are perhaps larges (100s of MB)
;  I think this code is not suitable for sampling across year boundaries;
;  see the daynum stuff below.

  pro model_track_met, outfile, tracklon, tracklat, trackalt, trackdate, $
                   maxdate=maxdate

; Check for a maxdate beyond which not to try and read
  if(not(keyword_set(maxdate))) then maxdate = 21000101.00d

; Setup control for output
  wantlon=[min(tracklon),max(tracklon)]
  wantlat=[min(tracklat),max(tracklat)]
  nx = 1
  ny = 1
  nt = n_elements(trackdate)
  ga_getvar, 'prsasm.ddf', '', nodata, lon=lon, lat=lat, lev=lev, /noprint
  nz = n_elements(lev)

; Control files
  ctlfiles = ['prsasm.ddf', $
              'sfc.ddf'  $
             ]

; -----------------------------------------------------------
; Create an output file
  cdfid = ncdf_create(outfile, /clobber)

;  Dimensions
   idnZ = ncdf_dimdef(cdfid, 'nz', nz)
   idnT = ncdf_dimdef(cdfid, 'nt', nt)

;  Variables
;  Create an array of variables

;  One-d variables
   varlist1d = ['longitude', $
                'latitude', $
                'time', $
                'pressure', $
                'altitude', $
                'ps', $
                'phis' $
               ]
   vardim1d  = [idnT, $
                idnT, $
                idnT, $
                idnZ, $
                idnT, $
                idnT, $
                idnT]
   varname1d = ['longitude', $
                'latitude', $
                'time', $
                'mid-layer pressure', $
                'aircraft altitude', $
                'surface pressure', $
                'surface geopotential height' $
   ]
   varunit1d = ['degrees', $
                'degrees', $
                'YYYYMMDD.day_fraction', $
                'hPa', $
                'km', $
                'hPa', $
                'm' $
   ]
   varctlf1d = [-1, $
                -1, $
                -1, $
                -1, $
                -1, $
                 0, $
                 0 $
   ]

;  Two-d variables
   varlist2d = ['o3', $
                'qv', $
                'u', $
                'v', $
                't', $
                'h', $
                'epv' $
 ]
   varname2d = ['Ozone mixing ratio', $
                'Water vapor mixing ratio', $
                'Northward wind component', $
                'Eastward wind component', $
                'Air temperature', $
                'Geopotential height', $
                'Ertels potential vorticity' $
]
   varunit2d = ['ppmv', $
                'ppmv', $
                'm s-1', $
                'm s-1', $
                'K', $
                'm', $
                '1' $
]
   varctlf2d = [0, $
                0, $
                0, $
                0, $
                0, $
                0, $
                0 $
]
   varsclf2d = [ 28.97/48.*1.e6, $
                 28.97/18.*1.e6, $
                 1, $
                 1, $
                 1, $
                 1, $
                 1 $
 ]
   


   nvar1d = n_elements(varlist1d)
   nvar2d = n_elements(varlist2d)

  for ivar = 0, nvar1d-1 do begin
   print, ivar, varlist1d[ivar], varname1d[ivar], varunit1d[ivar], format='(i3,1x,a-12,1x,a-80,1x,a-20)'
  endfor
  for ivar = 0, nvar2d-1 do begin
   print, nvar1d+ivar, varlist2d[ivar], varname2d[ivar], varunit2d[ivar], format='(i3,1x,a-12,1x,a-80,1x,a-20)'
  endfor

   id = lonarr(nvar1d+nvar2d+1)

   for j = 0, nvar1d-1 do begin
    if(varlist1d[j] ne 'time') then begin
     id[j] = ncdf_vardef(cdfid, varlist1d[j], [vardim1d[j]], /float)
    endif else begin
     id[j] = ncdf_vardef(cdfid, varlist1d[j], [vardim1d[j]], /double)
    endelse
    ncdf_attput, cdfid, id[j], 'long_name', varname1d[j]
    ncdf_attput, cdfid, id[j], 'units', varunit1d[j]
   endfor

   for j = 0, nvar2d-1 do begin
    i = j+nvar1d
    id[i] = ncdf_vardef(cdfid, varlist2d[j], [idnZ, idnT], /float)
    ncdf_attput, cdfid, id[i], 'long_name', varname2d[j]
    ncdf_attput, cdfid, id[i], 'units', varunit2d[j]
   endfor
   i = nvar1d+nvar2d
   id[i] = ncdf_vardef(cdfid,'AIRDENS', [idnZ, idnT], /float)
   ncdf_attput, cdfid, id[i], 'long_name', 'Air Density]
   ncdf_attput, cdfid, id[i], 'units', 'kg m-3'

   ncdf_control, cdfid, /endef
   ncdf_varput, cdfid, id[0], tracklon
   ncdf_varput, cdfid, id[1], tracklat
   ncdf_varput, cdfid, id[2], trackdate
   ncdf_varput, cdfid, id[3], lev
   ncdf_varput, cdfid, id[4], trackalt

; Massage the dates to find the appropriate model time to read
  a = where(trackdate ge maxdate)
  if(a[0] ne -1) then trackdate[a] = maxdate

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
  fracday = jday-long(jday)

; Now create arrays to store the bracketing times for each
; Handle separately the 1d vars (sfc.ddf on 1 hr increment)
; and the 2d vars (all on 6 hr increment)
  fday = fix(fracday*8.+0.5)*0.125d - 0.0625d
  jday1d_0 = long(jday)+fday
  jday1d_1 = long(jday)+fday + 0.125d
  caldat, jday1d_0, mon, dd, yyyy, hh, mm, ss
  date1d_0 = yyyy*1000000L + mon*10000L + dd*100L + hh
  caldat, jday1d_1, mon, dd, yyyy, hh, mm, ss
  date1d_1 = yyyy*1000000L + mon*10000L + dd*100L + hh

  fday = fix(fracday*8.+0.5)*0.125d - 0.0625d
  jday2d_0 = long(jday)+fday
  jday2d_1 = long(jday)+fday+0.125d
  caldat, jday2d_0, mon, dd, yyyy, hh, mm, ss
  date2d_0 = yyyy*1000000L + mon*10000L + dd*100L + hh
  caldat, jday2d_1, mon, dd, yyyy, hh, mm, ss
  date2d_1 = yyyy*1000000L + mon*10000L + dd*100L + hh

; -----------------------------------------------------------
; At this point, let's pull out the model variables
; Search by uniq dates
  date1d_0 = strcompress(string(date1d_0),/rem)
  date1d_1 = strcompress(string(date1d_1),/rem)
  dateu0 = date1d_0[uniq(date1d_0)]
  dateu1 = date1d_1[uniq(date1d_0)]
  ndate = n_elements(dateu0)

; One-d
  for ivar = 5, nvar1d-1 do begin

   ctlfile = ctlfiles[varctlf1d[ivar]]
   varout  = fltarr(nt)
   varout0 = fltarr(nt)
   varout1 = fltarr(nt)
   dy      = fltarr(nt)
   dx      = fltarr(nt)

   for idate = 0, ndate-1 do begin
    a = where(date1d_0 eq dateu0[idate])
    print, gradsdate(dateu0[idate]),' ', varlist1d[ivar],' ', n_elements(a),' ', ctlfile
    lon_ = tracklon[a]
    lat_ = tracklat[a]

;   get the variable
    ga_getvar, ctlfile, varlist1d[ivar], varval0, lon=lon, lat=lat, lev=lev, $
                        wantlon=wantlon, wantlat=wantlat, wanttime=dateu0[idate]
    ga_getvar, ctlfile, varlist1d[ivar], varval1, lon=lon, lat=lat, lev=lev, $
                        wantlon=wantlon, wantlat=wantlat, wanttime=dateu1[idate]
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)
    varout0[a] = interpolate(varval0[*,*],long(ix+.5),long(iy+.5))
    varout1[a] = interpolate(varval1[*,*],long(ix+.5),long(iy+.5))
    dy[a]      = varout1[a]-varout0[a]
    dx[a]      = jday[a]-jday1d_0[a]
    varout[a]  = varout0[a] + (dy[a]/0.125)*dx[a]

    nfin = where(varout gt 1e9 or finite(varout) ne 1)
    if(nfin[0] ne -1) then varout[nfin] = !values.f_nan    
    ncdf_varput, cdfid, id[ivar], varout[a], count=[n_elements(a)], $
                 offset=[min(a)]

   endfor

  endfor
jump:
; Two-d
; Search by uniq dates
  date2d_0 = strcompress(string(date2d_0),/rem)+'30'
  date2d_1 = strcompress(string(date2d_1),/rem)+'30'
  dateu0 = date2d_0[uniq(date2d_0)]
  dateu1 = date2d_1[uniq(date2d_0)]
  ndate = n_elements(dateu0)
  gotairdens = 0
  for ivar = 0,nvar2d-1 do begin

   varout  = fltarr(nz,nt)
   varout0 = fltarr(nz,nt)
   varout1 = fltarr(nz,nt)
   dy      = fltarr(nz,nt)
   dx      = fltarr(nz,nt)

   ctlfile = ctlfiles[varctlf2d[ivar]]
   scalefac = varsclf2d[ivar]
   if(scalefac eq -1 and not(gotairdens)) then begin
    airdens = fltarr(nz,nt)
    airdens0 = fltarr(nz,nt)
    airdens1 = fltarr(nz,nt)
   endif

   for idate = 0, ndate-1 do begin
    a = where(date2d_0 eq dateu0[idate])
    print, gradsdate(dateu0[idate]),' ', varlist2d[ivar],' ', n_elements(a),' ', ctlfile
    lon_ = tracklon[a]
    lat_ = tracklat[a]

;   get the variable
;   some variables are composed of sums of others
    case varlist2d[ivar] of
     'cfc12'  : varlist = ['cfc12strat','cfc12trop']
     else     : varlist = [varlist2d[ivar]]
    endcase

    nv = n_elements(varlist)
    iv = 0
    ga_getvar, ctlfile, varlist[iv], varval0, lon=lon, lat=lat, $
               wantlon=wantlon, wantlat=wantlat, wanttime = dateu0[idate]
    if(nv gt 1) then begin
     for iv = 1, nv-1 do begin
      ga_getvar, ctlfile, varlist[iv], varval_, lon=lon, lat=lat, $
                 wantlon=wantlon, wantlat=wantlat, wanttime = dateu0[idate]
      varval0 = varval0+varval_
     endfor
    endif
    iv = 0
    ga_getvar, ctlfile, varlist[iv], varval1, lon=lon, lat=lat, $
               wantlon=wantlon, wantlat=wantlat, wanttime = dateu1[idate]
    if(nv gt 1) then begin
     for iv = 1, nv-1 do begin
      ga_getvar, ctlfile, varlist[iv], varval_, lon=lon, lat=lat, $
                 wantlon=wantlon, wantlat=wantlat, wanttime = dateu1[idate]
      varval1 = varval1+varval_
     endfor
    endif

    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)
    for iz = 0, nz-1 do begin
     varout0[iz,a] = interpolate(varval0[*,*,iz],long(ix+.5),long(iy+.5))
     varout1[iz,a] = interpolate(varval1[*,*,iz],long(ix+.5),long(iy+.5))
    endfor
    dy[*,a]      = varout1[*,a]-varout0[*,a]
    for iz = 0, nz-1 do begin
     dx[iz,a]      = jday[a]-jday1d_0[a]
    endfor
    varout[*,a]  = varout0[*,a] + (dy[*,a]/0.25)*dx[*,a]

;   Multiply by a scale factor.  If scale factor = -1 then use air density
    if(scalefac ne -1) then begin
     varout[*,a] = varout[*,a]*scalefac
    endif else begin
     if(not(gotairdens)) then begin
;     get the air density
      ga_getvar, ctlfiles[0], 'airdens', airdens0_, lon=lon, lat=lat, $
                 wantlon=wantlon, wantlat=wantlat, wanttime=dateu0[idate]
      ga_getvar, ctlfiles[0], 'airdens', airdens1_, lon=lon, lat=lat, $
                 wantlon=wantlon, wantlat=wantlat, wanttime=dateu1[idate]
      ix = interpol(indgen(n_elements(lon)),lon,lon_)
      iy = interpol(indgen(n_elements(lat)),lat,lat_)
      for iz = 0, nz-1 do begin
       airdens0[iz,a] = interpolate(airdens0_[*,*,iz],long(ix+.5),long(iy+.5))
       airdens1[iz,a] = interpolate(airdens1_[*,*,iz],long(ix+.5),long(iy+.5))
      endfor
      dy[*,a]      = airdens1[*,a]-airdens0[*,a]
      airdens[*,a] = airdens0[*,a] + (dy[*,a]/0.25)*dx[*,a]
      nfin = where(airdens gt 1e9 or finite(airdens) ne 1)
      if(nfin[0] ne -1) then airdens[nfin] = !values.f_nan    
      ncdf_varput, cdfid, id[nvar1d+nvar2d], airdens[*,a], count=[nz,n_elements(a)], $
                   offset=[0,min(a)]
      if(idate eq ndate-1) then gotairdens = 1
     endif
     varout[*,a] = varout[*,a]*airdens[*,a]*1.e9
    endelse



    nfin = where(varout gt 1e9 or finite(varout) ne 1)
    if(nfin[0] ne -1) then varout[nfin] = !values.f_nan    
    ncdf_varput, cdfid, id[nvar1d+ivar], varout[*,a], count=[nz,n_elements(a)], $
                 offset=[0,min(a)]
   endfor
check, varout
  endfor

  ncdf_close, cdfid


end
