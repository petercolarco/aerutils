; Colarco, August 2006
; Enhanced ga_getvar with wantlon & wantlat 
; IDL -> Grads interface
; Pass in a requested input template (see below) and variable name
; Get variable and (optionally) grid values in return
; Input template (string):
;  parsed for "http://" then try gradsdods to open
;  parsed to ".ctl" or ".ddf" then try xdfopen to open
;  parsed to ".nc" or ".hdf" then try sdfopen to open
; VarWant (string): name of variable wanted or, if blank, list variable in file
; VarVal: returned variable values

; Optional keyword returns:
;  lon      = return array of longitudes
;  lat      = return array of latitudes
;  lev      = return array of vertical levels
;             nominally, the levels are hPa altitudes
;  time     = return array of times (strings)
;  wantlev  = array of one or two values (either a desired level or two 
;             bounding levels).  In the case that wantlev is specified and lev
;             is requested, the returned values of lev are those levels that
;             fit the requested range
;             if not specified, the default is to read the first level
;  wanttime = array of one or two values (string or longword integer) 
;             specifying either a particular time or a range of times.  
;             Format is one of:  YYYYMM,   YYYYMMDD,   YYYYMMDDHH
;             Also handles grads type time: e.g., 12z05jun2006
;             In the case that wanttime is specified and time is requested, the
;             returned values of time are those that fit the requested range
;             if not specified, the default is to read the first time
;  wantlat  = array of one or two values (either a desired latitude or two
;             bounding latitudes).  In the case that wantlat is specified and lat
;             is requested, the returned values of lat are those lats that
;             fit the requested range  
;  wantlon  = array of one or two values (either a desired longitude or two
;             bounding longitudes).  In the case that wantlon is specified and lon
;             is requested, the returned values of lon are those lons that
;             fit the requested range 
;  noprint  = only useful at moment with old ga_getvar to return dimension variables
;             like lat, lon, time, lev, when requested var is '' and not print varlist.
;  template = scans list of variables in file and retrieves all variables matching
;             the varwantIn template passed in (e.g., if you ask for "duem" and specify 
;             /template you get on return all the variables beginning with "duem")
;  bin      = old name for "template"
;  sum      = will sum all variables returned

; The returned varval is dimensioned (lon,lat,lev,ntimes)
; Set varwant='' to get a list of variables on the file.
; Requires: ga_base.pro, grads.pro, and opengrads-1.9.5
; The procedure is not graceful in the sense that requesting times outside the allowed
; times in the file will cause it to crash.  Also, the request for times and levels
; must be in the order that they are stored in the underlying files.  In other words,
; if the levels in the files are written 992. -> 1. then wantlev[0] > wantlev[1] or
; you get a crash.

; Add special keyword: bin
;  if set, then you can pass a variable like 'duem' and you will get the integral
;  of duem001 ... duemnbin on return

  pro ga_getvar_, inpfile, varwantIn, varval, lon=lon, lat=lat, $
                           lev=lev, wantlev=wantlev, $
                           time=time, wanttime=wanttime, $
                           wantlat=wantlat, wantlon=wantlon, $
                           noprint=noprint, bin=bin, varlist=varshort, $
                           template=template, sum=sum, dods5=dods5, rc=rc


  rc = 0

  if(keyword_set(noprint)) then noprint = noprint else noprint = 0

  verb = 0

; Compile the grads code and start
  COMPILE_OPT      StrictArr
  RESOLVE_ROUTINE, 'ga_base', /either, /compile_full_file, /no_recompile
  RESOLVE_ROUTINE, 'grads'  , /either, /compile_full_file, /no_recompile

; Check the inpfile string
  open_dods = 1  ; deprecated
  open_xdf  = 2
  open_sdf  = 3
  opentype = 0
  if((strpos(inpfile,'.ctl') ne -1) or (strpos(inpfile,'.ddf') ne -1)) then $
   opentype = open_xdf
  if((strpos(inpfile,'.nc4') ne -1) or (strpos(inpfile,'.nc') ne -1) or $
     (strpos(inpfile,'.hdf') ne -1) or (strpos(inpfile,'http:') ne -1)) then $
   opentype = open_sdf

; Special case to handle bad longitude array on dods served files
  if(keyword_set(dods5)) then begin
   inpfile_ = 'test.ddf'
   openw, lun, inpfile_, /get_lun
   printf, lun, 'dset '+inpfile
   printf, lun, 'xdef lon 540 linear -180 0.6666667'
   free_lun, lun
  endif

  if(opentype eq 0) then begin
   print, "Quitting...I don't know how to open file: ", inpfile
   return
  endif

; seed the grads transport file
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)
  transfer = 'idl.'+rnum+'.dat'

; Now try to open the inpfile
  rc = 0
  case opentype of
   open_xdf:  begin
              grads,  verb=verb, rc=rc, transfer=transfer
              inpfile_ = get_ctl(inpfile)
              fh = ga_open(inpfile_,/xdf, rc=rc)
              end
   open_sdf:  begin
              grads,  verb=verb, rc=rc, transfer=transfer
              fh = ga_open(inpfile,/sdf, rc=rc)
              end
  end
  if(rc ne 0) then begin
   print, 'Problem opening file; quitting'
   goto, returnout
  endif

; Now, first find the limits of the file
; --------------------------------------
  nx = fh.nx
  ny = fh.ny
  nz = fh.nz
  nt = fh.nt
  ga, 'set x 1', rc=rc
  ga, 'set y 1', rc=rc
  ga, 'set z 1 '+string(nz), rc=rc
  lev = ga_expr('lev',rc=rc)
  ga, 'set x 1 '+string(nx), rc=rc
  ga, 'set y 1', rc=rc
  ga, 'set z 1', rc=rc
  lon = ga_expr('lon',rc=rc)
  ga, 'set x 1', rc=rc
  ga, 'set y 1 '+string(ny), rc=rc
  ga, 'set z 1', rc=rc
  lat = ga_expr('lat',rc=rc)

; Return of some time information
  ga, 'set t 1 ', rc=rc
  t0 = ga_gett()
  ga, 'set t 1 '+string(nt), rc=rc
  time = strarr(nt)
  for it = 1L, nt do begin
   time[it-1] = ga_time(it)
  endfor

; Check on the levels
; -------------------
  if(keyword_set(wantlev)) then begin
   str_setlev = 'set z 1 '+string(nz)
   if(wantlev[0] ne -9999.) then begin
    ga, 'set x 1', rc=rc
    ga, 'set y 1', rc=rc
    if(n_elements(wantlev) gt 2) then begin
     print, 'wantlev must be 1 or 2 element array; quit'
     goto, returnout
    endif
    if(n_elements(wantlev) eq 1) then begin
     str_setlev = 'set lev '+string(wantlev)
    endif else begin
;    Check that the requested levels are in bounds
     wantlev_ = float(wantlev)
     maxw = max(wantlev_,imax)
     minw = min(wantlev_,imin)
     if(maxw gt max(lev)) then wantlev_[imax] = max(lev)
     if(minw lt min(lev)) then wantlev_[imin] = min(lev)
     str_setlev = 'set lev '+string(wantlev_[0])+' '+string(wantlev_[1])
    endelse
    ga, str_setlev, rc=rc
    lev = ga_expr('lev',rc=rc)
   endif
  endif


; Check on the latitudes
; ----------------------
  if(keyword_set(wantlat)) then begin
   str_setlat = 'set y 1 '+string(ny)
   if(wantlat[0] ne -9999.) then begin
    ga, 'set x 1', rc=rc
    ga, 'set z 1', rc=rc
    if(n_elements(wantlat) gt 2) then begin
     print, 'wantlat must be 1 or 2 element array; quit'
     goto, returnout
    endif
    if(n_elements(wantlat) eq 1) then begin
     str_setlat = 'set lat '+string(wantlat)
    endif else begin
;    Check that the requested lats are in bounds
     wantlat_ = float(wantlat)
     maxw = max(wantlat_,imax)
     minw = min(wantlat_,imin)
     if(maxw gt max(lat)) then wantlat_[imax] = max(lat)
     if(minw lt min(lat)) then wantlat_[imin] = min(lat)
     str_setlat = 'set lat '+string(wantlat_[0])+' '+string(wantlat_[1])
    endelse
    ga, str_setlat, rc=rc
    lat = ga_expr('lat',rc=rc)
   endif
  endif


; Check on the longitudes
; -----------------------
  if(keyword_set(wantlon)) then begin
   str_setlon = 'set x 1 '+string(nx)
   if(wantlon[0] ne -9999.) then begin
    ga, 'set y 1', rc=rc
    ga, 'set z 1', rc=rc
    if(n_elements(wantlon) gt 2) then begin
     print, 'wantlon must be 1 or 2 element array; quit'
     goto, returnout
    endif
    if(n_elements(wantlon) eq 1) then begin
     str_setlon = 'set lon '+string(wantlon)
    endif else begin
;    Check that the requested levels are in bounds
     wantlon_ = float(wantlon)
     maxw = max(wantlon_,imax)
     minw = min(wantlon_,imin)
;     if(maxw gt max(lon)) then wantlon_[imax] = max(lon)
;     if(minw lt min(lon)) then wantlon_[imin] = min(lon)
     str_setlon = 'set lon '+string(wantlon_[0])+' '+string(wantlon_[1])
    endelse
    ga, str_setlon, rc=rc
    lon = ga_expr('lon',rc=rc)
   endif
  endif

; Check on the time
; -----------------
  if(keyword_set(wanttime)) then begin
   str_settime = 'set t 1'
   if(wanttime[0] ne -9999.) then begin
    if(n_elements(wanttime) gt 2) then begin
     print, 'wanttime must be 1 or 2 element array; quit'
     goto, returnout
    endif
    if(n_elements(wanttime) eq 1) then begin
     wanttime = gradsdate(wanttime)
     nt = 1
     time = ga_date(wanttime)
     t0 = ga_gett()
     str_settime = 'set t '+string(t0)
     t1 = t0
    endif else begin
     wanttime[0] = gradsdate(wanttime[0])
     wanttime[1] = gradsdate(wanttime[1])
     time0 = ga_date(wanttime[0])
     t0 = ga_gett()
     time1 = ga_date(wanttime[1])
     t1 = ga_gett()
     str_settime = 'set t '+string(t0)+' '+string(t1)
    endelse
    nt = fix(t1)-fix(t0)+1
    time = strarr(nt)
    for it = 0, nt-1 do begin
     time[it] = ga_time(t0+it)
    endfor
   endif
  endif

; Did I just want a variable list?
; --------------------------------
  vars = strsplit(fh.vars_long,'$$$', /extract)
  nvar = n_elements(vars)
  varshort = strarr(nvar)
  for ivar = 0, nvar-1 do begin
   varsplit = strsplit(vars[ivar],/extract)
   varshort[ivar] = varsplit[0]
  endfor
  varshort = strcompress(strlowcase(varshort),/rem)
  if(varwantIn[0] eq '') then begin
   if(noprint eq 0) then begin
    for i = 0, fh.nvars-1 do begin
     print, vars[i]
    endfor
   endif
   goto, returnout
  endif


; Now set up to get the requested variables
; -----------------------------------------
  ga, 'set z 1 '+string(nz), rc=rc
  ga, 'set x 1 '+string(nx), rc=rc
  ga, 'set y 1 '+string(ny), rc=rc

  if(keyword_set(wantlev)) then ga, str_setlev, rc=rc
  if(keyword_set(wantlon)) then ga, str_setlon, rc=rc
  if(keyword_set(wantlat)) then ga, str_setlat, rc=rc
  if(keyword_set(wanttime)) then ga, str_settime, rc=rc


; Get the requested variable from the file
; Last chance -- is the variable in the list?
  varwant = strcompress(strlowcase(varWantIn),/rem)
  nvarwant = n_elements(varwant)
  varwantuse = varwant

; Logic is: if variable name is an exact match to something in variable
; list then we assume all requested variables should match something in
; list exactly.  If none do, we assume they may all be templated.  At the
; end, if we pass through, varwantuse is what is used.

  allPass = 1
  for iv = 0, nvarwant-1 do begin
   a = where(varwant[iv] eq varshort)
   if(a[0] eq -1) then allPass = 0
   rc = 8
  endfor

; If failed above, then we test on templating
  if(allPass ne 1) then begin
   rc = 0
   for iv = 0, nvarwant-1 do begin

;   Check on keyword template/bin
;   This keyword, if set, means you want to retrieve the complete list of
;   variables in the requested file.  Then you compare the list of variables
;   requested against the list of all variables.  For each variable requested,
;   we will acquire all variables in the file that begin with the requested
;   variable name (e.g., request "duem" gets all variables beginning with "duem")
;   and sum them up.
    template_ = 0
    if(keyword_set(bin)) then template_ = bin
    if(keyword_set(template)) then template_ = template
    if(template_) then begin
      vars_ = varwant[iv]
      len=strlen(vars_)
      a = where(strmid(varshort,0,len) eq vars_)
      if(a[0] eq -1) then begin
       print, 'No variables on template; exit'
       rc = 16
       goto, returnout
      endif
      if(iv eq 0) then varwantUse = varshort[a]
      if(iv ne 0) then varwantUse = [varwantUse,varshort[a]]
      allPass = 1
    endif
   endfor
  endif

  if(allPass ne 1) then begin
   print, varwantIn+' not in list of variables in file; exiting'
   varval = fltarr(nx,ny,nz,nt)
   rc = 32
   goto, returnout
  endif

  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  varval = fltarr(nx,ny,nz,nt)
  for i = 0, n_elements(varwantuse)-1 do begin

  for it = 0, nt-1 do begin
   ga, 'set t '+string(fix(t0)+it)
   for iz = 0, nz-1 do begin
    ga, 'set lev '+string(lev[iz])
    varval[*,*,iz,it] = varval[*,*,iz,it] + ga_expr(varwantuse[i],rc=rc)
   endfor
  endfor
 endfor

returnout:
  ga_end
  cmd = 'rm -f '+transfer
  spawn, cmd, /sh
  return

end

