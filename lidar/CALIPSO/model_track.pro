; Colarco, Sept. 2008
; Given a lidar ground track of (time, lon, lat) extract the MODEL
; parameters along the track

; Inputs:
;  outfile   = filename of output file
;  trackdate = YYYYMMDD.fracday form (where fracday = 0 for 0Z, = 0.5 for 12z)
;  tracklon  = track longitude on ground
;  tracklat  = track latitude on ground
;  vartable  = filename of variable hash table to read

; Note:
;  GEOS-5 defines longitude -180 to < 180.  Because tracklon may come
;  in as a number > 180 I subtracts 360 from all values greater than
;  180.  Tracklon is preserved, and written into the generated file,
;  as it was provided, for compatibility with the data source.


  pro model_track, outfile, tracklon, tracklat, trackdate, vartable=vartable, $
                   opticstables = opticstables, lambdawant=lambdawant

  if(not(keyword_set(vartable))) then vartable = 'variable_table.txt'

; Setup control for output
  nx = 1
  ny = 1
  nt = n_elements(trackdate)
  set_eta, hyai, hybi
  nz = n_elements(hyai)-1

; pressure hPa = hyai + hybi*surface_pressure

; -----------------------------------------------------------
; Create an output file and fill in basic information
  cdfid = ncdf_create(outfile, /clobber)

;  Dimensions
   idnZ = ncdf_dimdef(cdfid, 'nz', nz)
   idnZp1 = ncdf_dimdef(cdfid, 'nzp1', nz+1)
   idnT = ncdf_dimdef(cdfid, 'nt', nt)

;  Read table of variables to create on file
   read_variable_table, vartable, nv, varoutname, varname, units, scalefac, dimension, $
                                  vloc, ctlfiles, longname

;  Define variables on the output file

;  Header variables
   idHyai = ncdf_vardef(cdfid,'hyai',idnZp1,/float)
   ncdf_attput, cdfid, idHyai, 'long_name', 'hybrid-a coordinate at model layer interface'
   ncdf_attput, cdfid, idHyai, 'units', '1'
   idHybi = ncdf_vardef(cdfid,'hybi',idnZp1,/float)
   ncdf_attput, cdfid, idHybi, 'long_name', 'hybrid-b coordinate at model layer interface'
   ncdf_attput, cdfid, idHybi, 'units', '1'
   idTime = ncdf_vardef(cdfid,'time',idnT,/double)
   ncdf_attput, cdfid, idTime, 'long_name', 'time'
   ncdf_attput, cdfid, idTime, 'units', 'YYYYMMDD.day_fraction'
   idLon  = ncdf_vardef(cdfid,'longitude',idnT,/float)
   ncdf_attput, cdfid, idLon, 'long_name', 'longitude'
   ncdf_attput, cdfid, idLon, 'units', 'degrees'
   idLat  = ncdf_vardef(cdfid,'latitude',idnT,/float)
   ncdf_attput, cdfid, idLat, 'long_name', 'latitude'
   ncdf_attput, cdfid, idLat, 'units', 'degrees'

;  Table variables
   id = lonarr(nv)
   for iv = 0, nv-1 do begin
    if(dimension[iv] ne 'xyz') then begin
     vard = [idnT]
    endif else begin
     if(vloc[iv] eq 'E') then begin 
      vard = [idnZp1,idnT]
     endif else begin
      vard = [idnZ,idnT]
     endelse
    endelse

    id[iv] = ncdf_vardef(cdfid,varoutname[iv], vard, /float)
    ncdf_attput, cdfid, id[iv], 'long_name', longname[iv]
    ncdf_attput, cdfid, id[iv], 'units', units[iv]
   endfor

   ncdf_control, cdfid, /endef

;  Write variables for header
   ncdf_varput, cdfid, idHyai, hyai
   ncdf_varput, cdfid, idHybi, hybi
   ncdf_varput, cdfid, idLon,  tracklon
   ncdf_varput, cdfid, idLat,  tracklat
   ncdf_varput, cdfid, idTime, trackdate

; Turn the trackdate into a julian date
; Recall: trackdate is YYYYMMDD.fraction_of_day_from_0Z
  strdate = strcompress(string(long(trackdate)),/rem)
  yyyy = strmid(strdate,0,4)
  mm   = strmid(strdate,4,2)
  dd   = strmid(strdate,6,2)
  jdayobs = julday(mm,dd,yyyy,0,0,0) $
     +      ( (trackdate) - long(trackdate) )


; -----------------------------------------------------------
; At this point, let's pull out the model variables

  for ivar = 0, nv-1 do begin

   ctlfile = ctlfiles[ivar]

;  get the variable
;  some variables are composed of sums of others
;  This is very inefficient for volume, area, etc. since it wants to
;  read the whole suite of variables multiple times.  Someone could
;  clean this up.   
   case varname[ivar] of
    'du'     : varlist = ['du001','du002','du003','du004','du005']
    'ss'     : varlist = ['ss001','ss002','ss003','ss004','ss005']
    'bc'     : varlist = ['BCphobic','BCphilic']
    'oc'     : varlist = ['OCphobic','OCphilic']
    'ocbbbo' : varlist = ['OCphobicbbbo','OCphilicbbbo']
    'ocbbnb' : varlist = ['OCphobicbbnb','OCphilicbbnb']
    'vol'    : varlist = ['du001','du002','du003','du004','du005', $
                          'ss001','ss002','ss003','ss004','ss005', $
                          'BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'area'   : varlist = ['du001','du002','du003','du004','du005', $
                          'ss001','ss002','ss003','ss004','ss005', $
                          'BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'reff'   : varlist = ['du001','du002','du003','du004','du005', $
                          'ss001','ss002','ss003','ss004','ss005', $
                          'BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'refreal': varlist = ['du001','du002','du003','du004','du005', $
                          'ss001','ss002','ss003','ss004','ss005', $
                          'BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'refimag': varlist = ['du001','du002','du003','du004','du005', $
                          'ss001','ss002','ss003','ss004','ss005', $
                          'BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'vol_fine'    : varlist = ['BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'area_fine'   : varlist = ['BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'reff_fine'   : varlist = ['BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'refreal_fine': varlist = ['BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'refimag_fine': varlist = ['BCphobic','BCphilic','OCphobic','OCphilic','SO4','RH','AIRDENS']
    'vol_coarse'  : varlist = ['du001','du002','du003','du004','du005', $
                               'ss001','ss002','ss003','ss004','ss005', 'RH','AIRDENS']
    'area_coarse' : varlist = ['du001','du002','du003','du004','du005', $
                               'ss001','ss002','ss003','ss004','ss005', 'RH','AIRDENS']
    'reff_coarse' : varlist = ['du001','du002','du003','du004','du005', $
                               'ss001','ss002','ss003','ss004','ss005', 'RH','AIRDENS']
    'refreal_coarse': varlist = ['du001','du002','du003','du004','du005', $
                                 'ss001','ss002','ss003','ss004','ss005', 'RH','AIRDENS']
    'refimag_coarse': varlist = ['du001','du002','du003','du004','du005', $
                                 'ss001','ss002','ss003','ss004','ss005', 'RH','AIRDENS']
    'CFC12'  : varlist = ['CFC12S','CFC12T']
    else     : varlist = varname[ivar]
   endcase

;  If requesting reff or nref check that we passed in optics tables
   if(varname[ivar] eq 'reff' or varname[ivar] eq 'refreal' or varname[ivar] eq 'refimag' or $
      varname[ivar] eq 'reff_fine' or varname[ivar] eq 'refreal_fine' or varname[ivar] eq 'refimag_fine' or $
      varname[ivar] eq 'reff_coarse' or varname[ivar] eq 'refreal_coarse' or varname[ivar] eq 'refimag_coarse' or $
      varname[ivar] eq 'vol' or varname[ivar] eq 'vol_fine' or varname[ivar] eq 'vol_coarse' or $
      varname[ivar] eq 'area' or varname[ivar] eq 'area_fine' or varname[ivar] eq 'area_coarse') then begin
    if(not(keyword_set(opticstables))) then stop ; must pass tables
    if(n_elements(opticstables) ne 5) then stop  ; one for each GOCART species
;   Open and read from optics tables
;   Dust
    tn = -1
    for it = 0, 4 do begin
     if(strpos(opticstables[it],'DU') ne -1) then tn = it
    endfor
    if(tn lt 0) then stop
    cdfidopt = ncdf_open(opticstables[tn])
     idopt = ncdf_varid(cdfidopt,'lambda')
     ncdf_varget, cdfidopt, idopt, lambda__
     idopt = ncdf_varid(cdfidopt,'rEff')
     ncdf_varget, cdfidopt, idopt, reff__
     idopt = ncdf_varid(cdfidopt,'refreal')
     ncdf_varget, cdfidopt, idopt, refreal__
     idopt = ncdf_varid(cdfidopt,'refimag')
     ncdf_varget, cdfidopt, idopt, refimag__
    ncdf_close, cdfidopt
    lammin = abs(float(lambdawant)*1.e-9 - lambda__)
    a = where(lammin eq min(lammin))
    refreal__ = transpose(reform(refreal__[a[0],*,*]))
    refimag__ = transpose(reform(refimag__[a[0],*,*]))
    rhop__ = refreal__
    gf__   = refreal__
    gf__[*,*]  = 1.
    rhop__[*,*] = 2650.
    reff_    = transpose(reff__)
    gf_      = gf__
    rhop_    = rhop__
    refreal_ = refreal__
    refimag_ = refimag__

;   Sea Salt
    tn = -1
    for it = 0, 4 do begin
     if(strpos(opticstables[it],'SS') ne -1) then tn = it
    endfor
    if(tn lt 0) then stop
    cdfidopt = ncdf_open(opticstables[tn])
     idopt = ncdf_varid(cdfidopt,'lambda')
     ncdf_varget, cdfidopt, idopt, lambda__
     idopt = ncdf_varid(cdfidopt,'rEff')
     ncdf_varget, cdfidopt, idopt, reff__
     idopt = ncdf_varid(cdfidopt,'growth_factor')
     ncdf_varget, cdfidopt, idopt, gf__
     idopt = ncdf_varid(cdfidopt,'rhop')
     ncdf_varget, cdfidopt, idopt, rhop__
     idopt = ncdf_varid(cdfidopt,'refreal')
     ncdf_varget, cdfidopt, idopt, refreal__
     idopt = ncdf_varid(cdfidopt,'refimag')
     ncdf_varget, cdfidopt, idopt, refimag__
    ncdf_close, cdfidopt
    lammin = abs(float(lambdawant)*1.e-9 - lambda__)
    a = where(lammin eq min(lammin))
    refreal__ = transpose(reform(refreal__[a[0],*,*]))
    refimag__ = transpose(reform(refimag__[a[0],*,*]))
    reff_    = [reff_,transpose(reff__)]
    gf_      = [gf_,transpose(gf__)]
    rhop_    = [rhop_,transpose(rhop__)]
    refreal_ = [refreal_,refreal__]
    refimag_ = [refimag_,refimag__]

;   Black Carbon
    tn = -1
    for it = 0, 4 do begin
     if(strpos(opticstables[it],'BC') ne -1) then tn = it
    endfor
    if(tn lt 0) then stop
    cdfidopt = ncdf_open(opticstables[tn])
     idopt = ncdf_varid(cdfidopt,'lambda')
     ncdf_varget, cdfidopt, idopt, lambda__
     idopt = ncdf_varid(cdfidopt,'rEff')
     ncdf_varget, cdfidopt, idopt, reff__
     idopt = ncdf_varid(cdfidopt,'growth_factor')
     ncdf_varget, cdfidopt, idopt, gf__
     idopt = ncdf_varid(cdfidopt,'rhop')
     ncdf_varget, cdfidopt, idopt, rhop__
     idopt = ncdf_varid(cdfidopt,'refreal')
     ncdf_varget, cdfidopt, idopt, refreal__
     idopt = ncdf_varid(cdfidopt,'refimag')
     ncdf_varget, cdfidopt, idopt, refimag__
    ncdf_close, cdfidopt
    lammin = abs(float(lambdawant)*1.e-9 - lambda__)
    a = where(lammin eq min(lammin))
    refreal__ = transpose(reform(refreal__[a[0],*,*]))
    refimag__ = transpose(reform(refimag__[a[0],*,*]))
    reff_    = [reff_,transpose(reff__)]
    gf_      = [gf_,transpose(gf__)]
    rhop_    = [rhop_,transpose(rhop__)]
    refreal_ = [refreal_,refreal__]
    refimag_ = [refimag_,refimag__]

;   Organic Carbon
    tn = -1
    for it = 0, 4 do begin
     if(strpos(opticstables[it],'OC') ne -1) then tn = it
    endfor
    if(tn lt 0) then stop
    cdfidopt = ncdf_open(opticstables[tn])
     idopt = ncdf_varid(cdfidopt,'lambda')
     ncdf_varget, cdfidopt, idopt, lambda__
     idopt = ncdf_varid(cdfidopt,'rEff')
     ncdf_varget, cdfidopt, idopt, reff__
     idopt = ncdf_varid(cdfidopt,'growth_factor')
     ncdf_varget, cdfidopt, idopt, gf__
     idopt = ncdf_varid(cdfidopt,'rhop')
     ncdf_varget, cdfidopt, idopt, rhop__
     idopt = ncdf_varid(cdfidopt,'refreal')
     ncdf_varget, cdfidopt, idopt, refreal__
     idopt = ncdf_varid(cdfidopt,'refimag')
     ncdf_varget, cdfidopt, idopt, refimag__
    ncdf_close, cdfidopt
    lammin = abs(float(lambdawant)*1.e-9 - lambda__)
    a = where(lammin eq min(lammin))
    refreal__ = transpose(reform(refreal__[a[0],*,*]))
    refimag__ = transpose(reform(refimag__[a[0],*,*]))
    reff_    = [reff_,transpose(reff__)]
    gf_      = [gf_,transpose(gf__)]
    rhop_    = [rhop_,transpose(rhop__)]
    refreal_ = [refreal_,refreal__]
    refimag_ = [refimag_,refimag__]

;   Sulfate
    tn = -1
    for it = 0, 4 do begin
     if(strpos(opticstables[it],'SU') ne -1) then tn = it
    endfor
    if(tn lt 0) then stop
    cdfidopt = ncdf_open(opticstables[tn])
     idopt = ncdf_varid(cdfidopt,'rh')
     ncdf_varget, cdfidopt, idopt, rh_
     idopt = ncdf_varid(cdfidopt,'lambda')
     ncdf_varget, cdfidopt, idopt, lambda__
     idopt = ncdf_varid(cdfidopt,'rEff')
     ncdf_varget, cdfidopt, idopt, reff__
     idopt = ncdf_varid(cdfidopt,'growth_factor')
     ncdf_varget, cdfidopt, idopt, gf__
     idopt = ncdf_varid(cdfidopt,'rhop')
     ncdf_varget, cdfidopt, idopt, rhop__
     idopt = ncdf_varid(cdfidopt,'refreal')
     ncdf_varget, cdfidopt, idopt, refreal__
     idopt = ncdf_varid(cdfidopt,'refimag')
     ncdf_varget, cdfidopt, idopt, refimag__
    ncdf_close, cdfidopt
    lammin = abs(float(lambdawant)*1.e-9 - lambda__)
    a = where(lammin eq min(lammin))
    refreal__ = transpose(reform(refreal__[a[0],*,*]))
    refimag__ = transpose(reform(refimag__[a[0],*,*]))
    reff_    = [reff_,transpose(reff__)]
    gf_      = [gf_,transpose(gf__)]
    rhop_    = [rhop_,transpose(rhop__)]
    refreal_ = [refreal_,refreal__]
    refimag_ = abs([refimag_,refimag__])
   endif

;  Special case for the CARMA provided sulfate
   template = 0
   if(varname[ivar] eq 'su') then varlist = ['su0']
   if(varname[ivar] eq 'su') then template = 1


;  For a given control file, find the particular dates
;  that bracket the obs
   ga_times, ctlfile, nymd, nhms, jday=jday
   a = where(jday gt min(jdayobs) and jday lt max(jdayobs))
   aa = [min(a)-1,a,max(a)+1]
;  If no times match, possibly a very short data set
;  select nearest time
   if(a[0] eq -1) then b = min(where(jday gt min(jdayobs)))
   if(a[0] eq -1) then aa = [min(b)-1,b]
   if(a[0] eq -1) then a = b
   jday = jday[aa]
   nymd = nymd[aa]
   nhms = nhms[aa]
   ndate = n_elements(aa)-1
   nymd0 = nymd[0:ndate-1]
   nhms0 = nhms[0:ndate-1]
   nymd1 = nymd[1:ndate]
   nhms1 = nhms[1:ndate]
   jday0 = jday[0:ndate-1]
   jday1 = jday[1:ndate]

   if(dimension(ivar) ne 'xyz') then begin
    varout  = fltarr(nt)
    varout0 = fltarr(nt)
    varout1 = fltarr(nt)
    dy      = fltarr(nt)
    dx      = fltarr(nt)
   endif else begin
    if(vloc[ivar] eq 'E') then nnz = nz+1 else nnz = nz
    varout  = fltarr(nnz,nt)
    varout0 = fltarr(nnz,nt)
    varout1 = fltarr(nnz,nt)
    dy      = fltarr(nnz,nt)
    dx      = fltarr(nnz,nt)
   endelse


   for idate = 0, ndate-1 do begin
    a = where(jdayobs ge jday0[idate] and jdayobs lt jday1[idate])
    print, nymd0[idate], ' ', nhms0[idate],' ', varoutname[ivar],' ', n_elements(a),' ', ctlfile
    lon_ = tracklon[a]
    lat_ = tracklat[a]
    b    = where(lon_ ge 180.)
    if(b[0] ne -1) then lon_[b] = lon_[b]-360.

;   Create a wantlon/wantlat to spare the variable reading
    wantlat = [ max([min(lat_-1.),-90.]) , min([max(lat_+1.),90.]) ]
    wantlon = [ max([min(lon_-1.),-180.]), min([max(lon_+1.),180.])]

;   get the variable
    filename = strtemplate(parsectl_dset(ctlfile),nymd0[idate],nhms0[idate])
;   special handling for reff or nref
    sum = 1
   if(varname[ivar] eq 'reff' or varname[ivar] eq 'refreal' or varname[ivar] eq 'refimag' or $
      varname[ivar] eq 'reff_fine' or varname[ivar] eq 'refreal_fine' or varname[ivar] eq 'refimag_fine' or $
      varname[ivar] eq 'reff_coarse' or varname[ivar] eq 'refreal_coarse' or varname[ivar] eq 'refimag_coarse' or $
      varname[ivar] eq 'vol' or varname[ivar] eq 'vol_fine' or varname[ivar] eq 'vol_coarse' or $
      varname[ivar] eq 'area' or varname[ivar] eq 'area_fine' or varname[ivar] eq 'area_coarse') then sum = 0
    nc4readvar, filename, varlist, varval0, lon=lon, lat=lat, lev=lev, $
                                            wantlon=wantlon, wantlat=wantlat, sum=sum, template=template
    filename = strtemplate(parsectl_dset(ctlfile),nymd1[idate],nhms1[idate])
    nc4readvar, filename, varlist, varval1, lon=lon, lat=lat, lev=lev, $
                                            wantlon=wantlon, wantlat=wantlat, sum=sum, template=template
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)

;   Special handling for reff or nref
;   At this point I have all the tracers + RH, so there is an extra
;   dimension on the end of varval0 and varval1 that I need to reduce
;   by integrating to reff and nref
   if(varname[ivar] eq 'reff' or varname[ivar] eq 'refreal' or varname[ivar] eq 'refimag' or $
      varname[ivar] eq 'reff_fine' or varname[ivar] eq 'refreal_fine' or varname[ivar] eq 'refimag_fine' or $
      varname[ivar] eq 'reff_coarse' or varname[ivar] eq 'refreal_coarse' or varname[ivar] eq 'refimag_coarse' or $
      varname[ivar] eq 'vol' or varname[ivar] eq 'vol_fine' or varname[ivar] eq 'vol_coarse' or $
      varname[ivar] eq 'area' or varname[ivar] eq 'area_fine' or varname[ivar] eq 'area_coarse') then begin
    sz  = size(varval0)
    irh = sz[sz[0]]-2  ; relative humidity index
    irhoa = sz[sz[0]]-1  ; air density index
    nx = sz[1]
    ny = sz[2]
    nz = sz[3]
    nb = sz[4]-2       ; remove RH and Air Density
    vwet0 = dblarr(nx,ny,nz)
    vwet1 = dblarr(nx,ny,nz)
    awet0 = dblarr(nx,ny,nz)
    awet1 = dblarr(nx,ny,nz)
    nrefr0 = dblarr(nx,ny,nz)
    nrefr1 = dblarr(nx,ny,nz)
    nrefi0 = dblarr(nx,ny,nz)
    nrefi1 = dblarr(nx,ny,nz)
    rh0 = varval0[*,*,*,irh]
    rh1 = varval1[*,*,*,irh]
    irh0 = interpol(indgen(n_elements(rh_)),rh_,rh0)
    irh1 = interpol(indgen(n_elements(rh_)),rh_,rh1)
    ib0 = 0
    if(strpos(varname[ivar],'_fine') gt 0) then ib0 = 10  ; pick up fine mode in right place in tables
    for ib = 0, nb-1 do begin
        gf0  = interpolate(reform(gf_[ib+ib0,*]),irh0)
        gf1  = interpolate(reform(gf_[ib+ib0,*]),irh1)
        rf0  = interpolate(reform(reff_[ib+ib0,*]),irh0)
        rf1  = interpolate(reform(reff_[ib+ib0,*]),irh1)
        re0  = interpolate(reform(refreal_[ib+ib0,*]),irh0)
        re1  = interpolate(reform(refreal_[ib+ib0,*]),irh1)
        ri0  = interpolate(reform(refimag_[ib+ib0,*]),irh0)
        ri1  = interpolate(reform(refimag_[ib+ib0,*]),irh1)
        rhod = rhop_[ib+ib0,0]  ; dry density
;       Documenting what I'm doing here: for consistency with
;       the optical files I am reading the growth factor assumed in
;       the optics calculations.  This is the ratio of the dry to wet
;       radius.  The ratio of the wet to dry volume is thus gf^3.  The
;       dry volume is found by taking the dry mass and dividing by the
;       dry density.  So: dry volume = tracer_mmr*rhoa/rhod.  The area
;       assumed here is a cross sectional area, which is the volume
;       divided by (4/3 * r).  With out explicitly have "r" we use the
;       per tracer effective radius as an approximation.  The
;       aggregate effective radius is (3/4)*volume/surface area, where
;       the factor of 3/4 is because reff is actually defined integral
;       of (r^3*dn/dlnr*dlnr)/(r^2*dn/dlnr*dlnr) and not precisely
;       volume / area (Levy et al. 2003)
        vwet0 = vwet0 + gf0^3*varval0[*,*,*,ib]*varval0[*,*,*,irhoa]/rhod
        vwet1 = vwet1 + gf1^3*varval1[*,*,*,ib]*varval0[*,*,*,irhoa]/rhod
        awet0 = awet0 + gf0^3*varval0[*,*,*,ib]*varval0[*,*,*,irhoa]/rf0/rhod/(4.d/3.d)
        awet1 = awet1 + gf1^3*varval1[*,*,*,ib]*varval0[*,*,*,irhoa]/rf1/rhod/(4.d/3.d)
        nrefr0 = nrefr0 + gf0^3*varval0[*,*,*,ib]*re0*varval0[*,*,*,irhoa]/rhod
        nrefr1 = nrefr1 + gf1^3*varval1[*,*,*,ib]*re1*varval0[*,*,*,irhoa]/rhod
        nrefi0 = nrefi0 + gf0^3*varval0[*,*,*,ib]*ri0*varval0[*,*,*,irhoa]/rhod
        nrefi1 = nrefi1 + gf1^3*varval1[*,*,*,ib]*ri1*varval0[*,*,*,irhoa]/rhod
    endfor
    if(varname[ivar] eq 'vol' or varname[ivar] eq 'vol_fine' or varname[ivar] eq 'vol_coarse') then begin
      varval0 = vwet0
      varval1 = vwet1
    endif
    if(varname[ivar] eq 'area' or varname[ivar] eq 'area_fine' or varname[ivar] eq 'area_coarse') then begin
      varval0 = awet0
      varval1 = awet1
    endif
    if(varname[ivar] eq 'reff' or varname[ivar] eq 'reff_fine' or varname[ivar] eq 'reff_coarse') then begin
      varval0 = 3.d/4.d*vwet0/awet0
      varval1 = 3.d/4.d*vwet1/awet1
    endif
    if(varname[ivar] eq 'refreal' or varname[ivar] eq 'refreal_fine' or varname[ivar] eq 'refreal_coarse') then begin
      varval0 = nrefr0/vwet0
      varval1 = nrefr1/vwet1
    endif
    if(varname[ivar] eq 'refimag' or varname[ivar] eq 'refimag_fine' or varname[ivar] eq 'refimag_coarse') then begin
      varval0 = nrefi0/vwet0
      varval1 = nrefi1/vwet1
    endif

    endif

;   2D
    if(dimension[ivar] ne 'xyz') then begin
;     varout0[a] = interpolate(varval0[*,*],long(ix+.5),long(iy+.5))
;     varout1[a] = interpolate(varval1[*,*],long(ix+.5),long(iy+.5))
     varout0[a] = interpolate(varval0[*,*],ix,iy)
     varout1[a] = interpolate(varval1[*,*],ix,iy)
;    Assume air density is three-d and we want surface value
     scalefac_  = scalefac[ivar]
     if(scalefac_ lt 0) then begin
      scalefac_  = abs(scalefac_)
      varout0[a] = varout0[a]*airdens0[nz-1,a]
      varout1[a] = varout1[a]*airdens1[nz-1,a]
     endif
     dy[a]      = varout1[a]-varout0[a]
     dx[a]      = jdayobs[a]-jday0[idate]
     delta      = jday1[idate] - jday0[idate]
     varout[a]  = scalefac_ * ( varout0[a] + (dy[a]/delta)*dx[a] )
     ncdf_varput, cdfid, id[ivar], varout[a], count=[n_elements(a)], $
                  offset=[min(a)]
    endif else begin
;   3D
     for iz = 0, nnz-1 do begin
;      varout0[iz,a] = interpolate(varval0[*,*,iz],long(ix+.5),long(iy+.5))
;      varout1[iz,a] = interpolate(varval1[*,*,iz],long(ix+.5),long(iy+.5))
      varout0[iz,a] = interpolate(varval0[*,*,iz],ix,iy)
      varout1[iz,a] = interpolate(varval1[*,*,iz],ix,iy)
     endfor
;    For scaling purposes, save the air density specially
     if(strlowcase(varlist[0]) eq 'airdens') then begin
      airdens0 = varout0
      airdens1 = varout1
     endif
;    Assume air density is three-d
     scalefac_  = scalefac[ivar]
     if(scalefac_ lt 0) then begin
      scalefac_  = abs(scalefac_)
      varout0[*,a] = varout0[*,a]*airdens0[*,a]
      varout1[*,a] = varout1[*,a]*airdens1[*,a]
     endif
     dy[*,a]      = varout1[*,a]-varout0[*,a]
     for iz = 0, nnz-1 do begin
      dx[iz,a]      = jdayobs[a]-jday0[idate]
     endfor
     delta      = jday1[idate] - jday0[idate]
     varout[*,a]  = scalefac_ * ( varout0[*,a] + (dy[*,a]/delta)*dx[*,a] )
     ncdf_varput, cdfid, id[ivar], varout[*,a], count=[nnz,n_elements(a)], $
                  offset=[0,min(a)]
    endelse

   endfor

  endfor

  ncdf_close, cdfid


end
