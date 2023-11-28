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

  pro model_track, outfile, tracklon, tracklat, trackdate, lambda=lambda

  if(not(keyword_set(lambda))) then lambda = '532'

; Setup control for output
  nx = 1
  ny = 1
  nt = n_elements(trackdate)
  ga_getvar, 'inst3_3d_aer_Nv.ddf', '', nodata, lon=lon, lat=lat, lev=lev, /noprint
  nz = n_elements(lev)
  set_eta, hyai, hybi, nz=nz
; pressure hPa = hyai + hybi*surface_pressure

; Control files
  ctlfiles = ['inst3_3d_asd_Np.ddf', $
              'inst3_3d_aer_Nv.ddf', $
              'inst3d_chm_v.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.du.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.bc.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.oc.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.su.ddf', $
              'inst3_3d_ext-'+lambda+'nm_Nv.ss.ddf', $
              'tavg3d_cld_v.ddf', $
              'tavg3d_dyn_v.ddf' $
  ]

; -----------------------------------------------------------
; Create an output file
  cdfid = ncdf_create(outfile, /clobber)

;  Dimensions
   idnZ = ncdf_dimdef(cdfid, 'nz', nz)
   idnZp1 = ncdf_dimdef(cdfid, 'nzp1', nz+1)
   idnT = ncdf_dimdef(cdfid, 'nt', nt)

;  Variables
;  Create an array of variables

;  One-d variables
   varlist1d = ['hyai', $
                'hybi', $
                'longitude', $
                'latitude', $
                'time', $
                'ps', $
                'phis', $
                'pblh', $
                'tropp' ]
   vardim1d  = [idnZp1, $
                idnZp1, $
                idnT, $
                idnT, $
                idnT, $
                idnT, $
                idnT, $
                idnT, $
                idnT]
   varname1d = ['hybrid-a coordinate at model layer interface', $
                'hybrid-b coordinate at model layer interface', $
                'longitude', $
                'latitude', $
                'time', $
                'surface pressure', $
                'surface geopotential height', $
                'planetary boundary layer height', $
                'tropopause pressure']
   varunit1d = ['1', $
                '1', $
                'degrees', $
                'degrees', $
                'YYYYMMDD.day_fraction', $
                'Pa', $
                'm', $
                'm', $
                'Pa']
   varctlf1d = [-1, $
                -1, $
                -1, $
                -1, $
                -1, $
                0, $
                0, $
                0, $
                0]

;  Two-d variables
   varlist2d = ['RH', $
                'du', $
                'bc', $
                'oc', $
                'ss', $
                'so4', $
                'so2', $
                'delp', $
                'totext', $
                'totssa', $
                'totext2back', $
                'duext', $
                'dussa', $
                'duext2back', $
                'bcext', $
                'bcssa', $
                'bcext2back', $
                'ocext', $
                'ocssa', $
                'ocext2back', $
                'suext', $
                'sussa', $
                'suext2back', $
                'ssext', $
                'ssssa', $
                'ssext2back', $
                'CLOUD', $
                'TAUCLI', $
                'TAUCLW', $
                'T', $
                'U', $
                'V', $
                'HGHT', $
                'CO', $
                'CObbbo', $
                'CObbnb', $
                'COffru', $
                'COffas', $
                'COffeu', $
                'COffna', $
                'CFC12' $
 ]
   varname2d = ['Relative_Humidity_after_moist_processes', $
                'dust mass concentration', $
                'black carbon mass concentration', $
                'organic carbon mass concentration', $
                'sea salt mass concentration', $
                'sulfate aerosol mass concentration', $
                'SO2 mixing ratio', $
                'pressure thickness of vertical level', $
                'total aerosol extinction ['+lambda+' nm]', $
                'total aerosol single scatter albedo ['+lambda+' nm]', $
                'total aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'dust aerosol extinction ['+lambda+' nm]', $
                'dust aerosol single scatter albedo ['+lambda+' nm]', $
                'dust aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'black carbon aerosol extinction ['+lambda+' nm]', $
                'black carbon aerosol single scatter albedo ['+lambda+' nm]', $
                'black carbon aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'organic carbon aerosol extinction ['+lambda+' nm]', $
                'organic carbon aerosol single scatter albedo ['+lambda+' nm]', $
                'organic carbon aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'sulfate aerosol extinction ['+lambda+' nm]', $
                'sulfate aerosol single scatter albedo ['+lambda+' nm]', $
                'sulfate aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'sea salt aerosol extinction ['+lambda+' nm]', $
                'sea salt aerosol single scatter albedo ['+lambda+' nm]', $
                'sea salt aerosol extinction-to-backscatter ratio ['+lambda+' nm]', $
                'cloud_area_fraction', $
                'optical_thickness_for_ice_clouds', $
                'optical_thickness_for_liquid_clouds', $
                'air_temperature', $
                'eastward_wind', $
                'northward_wind', $
                'layer midpoint geopotential height', $
                'CO mixing ratio', $
                'CO (boreal biomass burning emissions) mixing ratio', $
                'CO (non-boreal biomass burning emissions) mixing ratio', $
                'CO (Northern Asia anthropogenic emissions) mixing ratio', $
                'CO (Southern Asia anthropogenic emissions) mixing ratio', $
                'CO (European anthropogenic emissions) mixing ratio', $
                'CO (North American anthropogenic emissions) mixing ratio', $
                'CFC-12 mixing ratio' $
]
   varunit2d = ['1', $
                'micrograms m-3', $
                'micrograms m-3', $
                'micrograms m-3', $
                'micrograms m-3', $
                'micrograms m-3', $
                'ppbv', $
                'Pa', $
                'km-1', $
                '1', $
                'sr-1', $
                'km-1', $
                '1', $
                'sr-1', $
                'km-1', $
                '1', $
                'sr-1', $
                'km-1', $
                '1', $
                'sr-1', $
                'km-1', $
                '1', $
                'sr-1', $
                'km-1', $
                '1', $
                'sr-1', $
                '1', $
                '1', $
                '1', $
                '1', $
                'K', $
                'm s-1', $
                'm s-1', $
                'm', $
                'ppbv', $
                'ppbv', $
                'ppbv', $
                'ppbv', $
                'ppbv', $
                'ppbv', $
                'ppbv', $
                'pptv' $
]
   varctlf2d = [1, $
                1, $
                1, $
                1, $
                1, $
                1, $
                1, $
                1, $
                3, $
                3, $
                3, $
                4, $
                4, $
                4, $
                5, $
                5, $
                5, $
                6, $
                6, $
                6, $
                7, $
                7, $
                7, $
                8, $
                8, $
                8, $
                9, $
                9, $
                9, $
                10, $
                10, $
                10, $
                10, $
                2, $
                2, $
                2, $
                2, $
                2, $
                2, $
                2, $
                2 $
]
   varsclf2d = [ 1., $
                -1, $
                -1, $
                -1, $
                -1, $
                -1, $
                 28./64.*1.e9, $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1., $
                 1.e9, $
                 1.e9, $
                 1.e9, $
                 1.e9, $
                 1.e9, $
                 1.e9, $
                 1.e9, $
                 1.e12 $
 ]
   


   nvar1d = n_elements(varlist1d)
   nvar2d = n_elements(varlist2d)
; override for now
   nvar1d = nvar1d-2
   nvar2d = 26

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
   ncdf_attput, cdfid, id[i], 'long_name', 'Air Density'
   ncdf_attput, cdfid, id[i], 'units', 'kg m-3'

   ncdf_control, cdfid, /endef
   ncdf_varput, cdfid, id[0], hyai
   ncdf_varput, cdfid, id[1], hybi
   ncdf_varput, cdfid, id[2], tracklon
   ncdf_varput, cdfid, id[3], tracklat
   ncdf_varput, cdfid, id[4], trackdate


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
  fracday = jday-long(jday)

; Now create arrays to store the bracketing times for each
; Handle separately the 1d vars (tavg2d_met_x on 3 hr increment)
; and the 2d vars (all on 6 hr increment)
; old way
;  fday = fix(fracday*8. + 0.5)*0.125d - 0.0625d
;  jday1d_0 = long(jday)+fday
;  jday1d_1 = long(jday)+fday + 0.125d
;  caldat, jday1d_0, mon, dd, yyyy, hh, mm, ss
;  date1d_0 = yyyy*1000000L + mon*10000L + dd*100L + hh
;  caldat, jday1d_1, mon, dd, yyyy, hh, mm, ss
;  date1d_1 = yyyy*1000000L + mon*10000L + dd*100L + hh

  dy1d = 0.125d
  fday = fix(fracday*8. + 0.5)*dy1d
  jday1d_0 = long(jday)+fday
  jday1d_1 = long(jday)+fday+dy1d
  caldat, jday1d_0, mon, dd, yyyy, hh, mm, ss
  date1d_0 = yyyy*1000000L + mon*10000L + dd*100L + hh
  caldat, jday1d_1, mon, dd, yyyy, hh, mm, ss
  date1d_1 = yyyy*1000000L + mon*10000L + dd*100L + hh

  dy2d = 0.25d
  fday = fix(fracday*4. + 0.5)*dy2d - dy2d/2.d
  jday2d_0 = long(jday)+fday
  jday2d_1 = long(jday)+fday+dy2d
  caldat, jday2d_0, mon, dd, yyyy, hh, mm, ss
  date2d_0 = yyyy*1000000L + mon*10000L + dd*100L + hh
  caldat, jday2d_1, mon, dd, yyyy, hh, mm, ss
  date2d_1 = yyyy*1000000L + mon*10000L + dd*100L + hh

; -----------------------------------------------------------
; At this point, let's pull out the model variables
; Search by uniq dates
;  date1d_0 = strcompress(string(date1d_0),/rem)+'30'
;  date1d_1 = strcompress(string(date1d_1),/rem)+'30'
  dateu0 = date1d_0[uniq(date1d_0)]
  dateu1 = date1d_1[uniq(date1d_0)]
  ndate = n_elements(dateu0)

; One-d
  for ivar = 5, nvar1d-1 do begin

   scalefac = 1.
   if(varlist1d[ivar] eq 'phis') then scalefac = 1./9.8
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
    ga_getvar, ctlfile, varlist1d[ivar], varval0, lon=lon, lat=lat, lev=lev, wanttime=dateu0[idate]
    ga_getvar, ctlfile, varlist1d[ivar], varval1, lon=lon, lat=lat, lev=lev, wanttime=dateu1[idate]
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)
    varout0[a] = interpolate(varval0[*,*],long(ix+.5),long(iy+.5))
    varout1[a] = interpolate(varval1[*,*],long(ix+.5),long(iy+.5))
    dy[a]      = varout1[a]-varout0[a]
    dx[a]      = jday[a]-jday1d_0[a]
    varout[a]  = varout0[a] + (dy[a]/dy1d)*dx[a] 
    varout[a]  = varout[a] * scalefac
    
    ncdf_varput, cdfid, id[ivar], varout[a], count=[n_elements(a)], $
                 offset=[min(a)]

   endfor

  endfor

; Two-d
; Search by uniq dates
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
     'du'     : varlist = ['du001','du002','du003','du004','du005']
     'ss'     : varlist = ['ss001','ss002','ss003','ss004','ss005']
;    f-d up naming
     'so4'    : varlist = ['s04']
     'so2'    : varlist = ['s02']
;
     'bc'     : varlist = ['BCphobic','BCphilic']
     'oc'     : varlist = ['OCphobic','OCphilic']
     'ocbbbo' : varlist = ['OCphobicbbbo','OCphilicbbbo']
     'ocbbnb' : varlist = ['OCphobicbbnb','OCphilicbbnb']
     'CFC12'  : varlist = ['CFC12S','CFC12T']
     'totext' : varlist = ['extinction']
     'totssa' : varlist = ['ssa']
     'totext2back' : varlist = ['ext2back']
     'duext'  : varlist = ['extinction']
     'dussa'  : varlist = ['ssa']
     'duext2back' : varlist = ['ext2back']
     'bcext'  : varlist = ['extinction']
     'bcssa'  : varlist = ['ssa']
     'bcext2back' : varlist = ['ext2back']
     'ocext'  : varlist = ['extinction']
     'ocssa'  : varlist = ['ssa']
     'ocext2back' : varlist = ['ext2back']
     'suext'  : varlist = ['extinction']
     'sussa'  : varlist = ['ssa']
     'suext2back' : varlist = ['ext2back']
     'ssext'  : varlist = ['extinction']
     'ssssa'  : varlist = ['ssa']
     'ssext2back' : varlist = ['ext2back']
     else     : varlist = [varlist2d[ivar]]
    endcase

    nv = n_elements(varlist)
    iv = 0

    nymd = strmid(strcompress(string(dateu0[idate]),/rem),0,8)
    nhms = strmid(strcompress(string(dateu0[idate]),/rem),8,2)+'0000'
    filename = strtemplate(parsectl_dset(ctlfile),nymd,nhms)
    nc4readvar, filename, varlist[iv], varval0
    if(nv gt 1) then begin
     for iv = 1, nv-1 do begin
      nc4readvar, filename, varlist[iv], varval_
      varval0 = varval0+varval_
     endfor
    endif
    iv = 0
    nymd = strmid(strcompress(string(dateu1[idate]),/rem),0,8)
    nhms = strmid(strcompress(string(dateu1[idate]),/rem),8,2)+'0000'
    filename = strtemplate(parsectl_dset(ctlfile),nymd,nhms)
    nc4readvar, filename, varlist[iv], varval1
    if(nv gt 1) then begin
     for iv = 1, nv-1 do begin
      nc4readvar, filename, varlist[iv], varval_
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
     dx[iz,a]      = jday[a]-jday2d_0[a]
    endfor
    varout[*,a]  = varout0[*,a] + (dy[*,a]/dy2d)*dx[*,a]

;   Multiply by a scale factor.  If scale factor = -1 then use air density
    if(scalefac ne -1) then begin
     varout[*,a] = varout[*,a]*scalefac
    endif else begin
     if(not(gotairdens)) then begin
;     get the air density
      nymd = strmid(strcompress(string(dateu0[idate]),/rem),0,8)
      nhms = strmid(strcompress(string(dateu0[idate]),/rem),8,2)+'0000'
      filename = strtemplate(parsectl_dset(ctlfiles[1]),nymd,nhms)
      nc4readvar, filename, 'airdens', airdens0_
      nymd = strmid(strcompress(string(dateu1[idate]),/rem),0,8)
      nhms = strmid(strcompress(string(dateu1[idate]),/rem),8,2)+'0000'
      filename = strtemplate(parsectl_dset(ctlfiles[1]),nymd,nhms)
      nc4readvar, filename, 'airdens', airdens1_
      ix = interpol(indgen(n_elements(lon)),lon,lon_)
      iy = interpol(indgen(n_elements(lat)),lat,lat_)
      for iz = 0, nz-1 do begin
       airdens0[iz,a] = interpolate(airdens0_[*,*,iz],long(ix+.5),long(iy+.5))
       airdens1[iz,a] = interpolate(airdens1_[*,*,iz],long(ix+.5),long(iy+.5))
      endfor
      dy[*,a]      = airdens1[*,a]-airdens0[*,a]
      airdens[*,a] = airdens0[*,a] + (dy[*,a]/dy2d)*dx[*,a]
      ncdf_varput, cdfid, id[nvar1d+nvar2d], airdens[*,a], count=[nz,n_elements(a)], $
                   offset=[0,min(a)]
      if(idate eq ndate-1) then gotairdens = 1
     endif
     varout[*,a] = varout[*,a]*airdens[*,a]*1.e9
    endelse



    ncdf_varput, cdfid, id[nvar1d+ivar], varout[*,a], count=[nz,n_elements(a)], $
                 offset=[0,min(a)]
   endfor
check, varout
  endfor

  ncdf_close, cdfid


end
