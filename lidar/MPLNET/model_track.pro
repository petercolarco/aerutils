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


  pro model_track, outfile, tracklon, tracklat, trackdate, vartable=vartable

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
   case varname[ivar] of
    'du'     : varlist = ['du001','du002','du003','du004','du005']
    'ss'     : varlist = ['ss001','ss002','ss003','ss004','ss005']
    'bc'     : varlist = ['BCphobic','BCphilic']
    'oc'     : varlist = ['OCphobic','OCphilic']
    'ocbbbo' : varlist = ['OCphobicbbbo','OCphilicbbbo']
    'ocbbnb' : varlist = ['OCphobicbbnb','OCphilicbbnb']
    'CFC12'  : varlist = ['CFC12S','CFC12T']
    else     : varlist = varname[ivar]
   endcase



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
    nc4readvar, filename, varlist, varval0, lon=lon, lat=lat, lev=lev, $
                                            wantlon=wantlon, wantlat=wantlat, /sum
    filename = strtemplate(parsectl_dset(ctlfile),nymd1[idate],nhms1[idate])
    nc4readvar, filename, varlist, varval1, lon=lon, lat=lat, lev=lev, $
                                            wantlon=wantlon, wantlat=wantlat, /sum
    ix = interpol(indgen(n_elements(lon)),lon,lon_)
    iy = interpol(indgen(n_elements(lat)),lat,lat_)

;   2D
    if(dimension[ivar] ne 'xyz') then begin
     varout0[a] = interpolate(varval0[*,*],long(ix+.5),long(iy+.5))
     varout1[a] = interpolate(varval1[*,*],long(ix+.5),long(iy+.5))
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
      varout0[iz,a] = interpolate(varval0[*,*,iz],long(ix+.5),long(iy+.5))
      varout1[iz,a] = interpolate(varval1[*,*,iz],long(ix+.5),long(iy+.5))
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
