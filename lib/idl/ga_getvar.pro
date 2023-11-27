; Colarco, August 2006
; Version 2: June 2007
; Version 3: January 2008

; IDL -> Grads interface
; Pass in a requested input template (see below) and variable name
; Get variable and (optionally) grid values (lat, lon, lev, time) in return
; Optionally, preserve the file of retrieved data in your local directory.
; New, improved, using lats4d!

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
;  save     = if set (and using the lats4d interface) will save a grads readable 
;             netcdf format file results
;  ofile    = if set and /save then this is the exact name of the output file
;  noprint  = only useful at moment with old ga_getvar to return dimension variables
;             like lat, lon, time, lev, when requested var is '' and not print varlist.
;  template = scans list of variables in file and retrieves all variables matching
;             the varwantIn template passed in (e.g., if you ask for "duem" and specify 
;             /template you get on return all the variables beginning with "duem")
;  bin      = old name for "template"
;  sum      = will sum all variables returned

;
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

  pro ga_getvar, inpfile, varwantIn, varval, lon=lon, lat=lat, $
                          lev=lev, wantlev=wantlev, $
                          time=time, wanttime=wanttime, $
                          wantlat=wantlat, wantlon=wantlon, $
                          noprint=noprint, bin=bin, varlist=varlist, $
                          options=options, template=template, sum=sum, $
                          save=save, ofile=ofile, dods5=dods5, rc=rc

  if(keyword_set(noprint)) then noprint = noprint else noprint = 0

  rc = 0

; Make all variable names lower case
  vars = strcompress(strlowcase(varwantin),/rem)

; If what is wanted is the simple listing the variables and nothing else,
; should use the old style ga_getvar interface and return
  if(vars[0] eq '') then begin
     ga_getvar_, inpfile, vars, varval, lon=lon, lat=lat, $
                          lev=lev, wantlev=wantlev, $
                          time=time, wanttime=wanttime, $
                          wantlat=wantlat, wantlon=wantlon, $
                          noprint=noprint, varlist=varlist, dods5=dods5, rc=rc
     if(rc) then print, 'Problem in ga_getvar_!'
     return
  endif

; Check on keyword template/bin
; This keyword, if set, means you want to retrieve the complete list of
; variables in the requested file.  Then you compare the list of variables
; requested against the list of all variables.  For each variable requested,
; we will acquire all variables in the file that begin with the requested
; variable name (e.g., request "duem" gets all variables beginning with "duem")
; and sum them up.
  template_ = 0
  if(keyword_set(bin)) then template_ = bin
  if(keyword_set(template)) then template_ = template
  if(template_) then begin
     vars_ = vars
     nv = n_elements(vars_)
     ga_getvar_, inpfile, '', varval, /template, varlist=varlist, dods5=dods5, $
                              noprint=noprint, rc=rc
     if(rc) then begin
      print, 'Problem in ga_getvar_; exit'
      return
     endif
     for iv = 0, nv-1 do begin
      len=strlen(vars_[iv])
      a = where(strmid(varlist,0,len) eq vars_[iv])
      if(a[0] eq -1) then begin
       print, 'No variables on template; exit'
       rc = 16
       return
      endif
      if(iv eq 0) then vars = varlist[a]
      if(iv ne 0) then vars = [vars,varlist[a]]
     endfor
  endif

; For data gets, let's assume that unless we ask to explicitly save
; the data we want to exercise the "old" interface 
  if(not keyword_set(save)) then begin

   ga_getvar_, inpfile, vars, varval, lon=lon, lat=lat, $
                        lev=lev, wantlev=wantlev, $
                        time=time, wanttime=wanttime, $
                        wantlat=wantlat, wantlon=wantlon, $
                        noprint=noprint, varlist=varlist, dods5=dods5, rc=rc
   if(rc) then print, 'Problem in ga_getvar_!'
   if(rc) then return
  endif else begin

; From here we will use the lats4d interface
; ------------------------------------------
  str_setvar = ' -vars'
  for ivar = 0, n_elements(vars)-1 do begin
   str_setvar = str_setvar+' '+vars[ivar]
  endfor

; Check the inpfile string
; Handling is to extract the last bit after the final "."
; If present, then we assume the file is either XDF or SDF
; openable.  However, if the head of the string is "http://"
; we use the DODS interface
  open_dods = 1
  open_xdf  = 2
  open_sdf  = 3
  opentype = 0
  len = strlen(inpfile)
  split = strsplit(inpfile,'.',/extract)
  n = n_elements(split)
  if(n gt 1) then begin
   if(split[n-1] eq 'ctl' or split[n-1] eq 'ddf') then opentype = open_xdf
  endif
  if((strpos(inpfile,'.nc') ne -1) or (strpos(inpfile,'.hdf') ne -1)) then $
   opentype = open_sdf
  if(strmid(inpfile,0,7) eq 'http://') then opentype = open_dods
; Special case to handle bad longitude array on dods served files
  inpfile_ = inpfile
  if(keyword_set(dods5)) then opentype = open_dods
  if(keyword_set(dods5)) then begin
   inpfile_ = 'test.ddf'
   openw, lun, inpfile_, /get_lun
   printf, lun, 'dset '+inpfile
   printf, lun, 'xdef lon 540 linear -180 0.6666667'
   free_lun, lun
  endif

  if(opentype eq 0) then begin
   print, "Quitting...I don't know how to open file: ", inpfile
   rc = 1
   return
  endif

; Begin to construct the lats4d call
  tryagain:

  cmd = 'lats4d.sh'
  if(opentype ne open_dods) then inpfile_ = get_ctl(inpfile)
  case opentype of
   open_dods: cmd = cmd + ' -dods'
   open_xdf:  cmd = cmd + ' -ftype xdf'
   open_sdf:  cmd = cmd + ' -hdf -ftype sdf'
  end
  if(noprint eq 0) then cmd = cmd + ' -v'
  cmd = cmd + ' -i '+inpfile_

; Random seed for the output filename (supports multiple instances in one directory)
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)
  file = varWantIn[0]+'.'+rnum
  cmd = cmd + ' -o '+file

; Add the variable wanted
  cmd = cmd + str_setvar

; Now parse out if any bounds are put on the request

; Check on the levels
; -------------------
  if(keyword_set(wantlev)) then begin
   if(wantlev[0] ne -9999.) then begin
    if(n_elements(wantlev) gt 2) then begin
     print, 'wantlev must be 1 or 2 element array; quit'
     rc = 2
     return
    endif
    if(n_elements(wantlev) eq 1) then begin
     str_setlev = ' -levs '+string(wantlev)
    endif else begin
;    Check that the requested levels are in bounds
     wantlev_ = float(wantlev)
     maxw = max(wantlev_,imax)
     minw = min(wantlev_,imin)
     if(maxw gt max(lev)) then wantlev_[imax] = max(lev)
     if(minw lt min(lev)) then wantlev_[imin] = min(lev)
     str_setlev = ' -levs '+string(wantlev_[0])+' '+string(wantlev_[1])
    endelse
    cmd = cmd + str_setlev
   endif
  endif


; Check on the latitudes
; ----------------------
  interplat = 0
  if(keyword_set(wantlat)) then begin
   if(wantlat[0] ne -9999.) then begin
    if(n_elements(wantlat) gt 2) then begin
     print, 'wantlat must be 1 or 2 element array; quit'
     rc = 3
     return
    endif
    if(n_elements(wantlat) eq 1) then begin
;    lats cannot handle writing a single point, so we need to dither
;    about the requested latitude
     wantlat_ = float(wantlat) + .1
     if(wantlat_ gt 90) then begin
      wantlat_ = float(wantlat) - .1
      str_setlat = ' -lat '+string(wantlat_)+ ' '+string(wantlat)
     endif else begin
      str_setlat = ' -lat '+string(wantlat)+ ' '+string(wantlat_)
     endelse
     interplat = 1
    endif else begin
;    Check that the requested lats are in bounds
     wantlat_ = float(wantlat)
     maxw = max(wantlat_,imax)
     minw = min(wantlat_,imin)
     if(maxw gt max(lat)) then wantlat_[imax] = max(lat)
     if(minw lt min(lat)) then wantlat_[imin] = min(lat)
     str_setlat = ' -lat '+string(wantlat_[0])+' '+string(wantlat_[1])
    endelse
    cmd = cmd + str_setlat
   endif
  endif


; Check on the longitudes
; -----------------------
  interplon = 0
  if(keyword_set(wantlon)) then begin
   if(wantlon[0] ne -9999.) then begin
    if(n_elements(wantlon) gt 2) then begin
     print, 'wantlon must be 1 or 2 element array; quit'
     rc = 4
     return
    endif
    if(n_elements(wantlon) eq 1) then begin
;    lats cannot handle writing a single point, so we need to dither
;    about the requested latitude
     wantlon_ = float(wantlon) + .1
     str_setlon = ' -lon '+string(wantlon)+ ' '+string(wantlon_)
     interplon = 1
    endif else begin
;    Check that the requested levels are in bounds
     wantlon_ = float(wantlon)
     maxw = max(wantlon_,imax)
     minw = min(wantlon_,imin)
     if(maxw gt max(lon)) then wantlon_[imax] = max(lon)
     if(minw lt min(lon)) then wantlon_[imin] = min(lon)
     str_setlon = ' -lon '+string(wantlon_[0])+' '+string(wantlon_[1])
    endelse
    cmd = cmd + str_setlon
   endif
  endif

; Check on the time
; -----------------
; Because the time variable is uncertain to the user without having already
; scanned the DDF file I allow the user to ask for either the date as a wanttime
; or the time index.  Here's how...
  if(keyword_set(wanttime)) then begin    ; if not, get all times, could take a while
   if(wanttime[0] ne -9999.) then begin   ; reset wanttime, like asking for all times
    if(n_elements(wanttime) gt 3) then begin
     print, 'wanttime must be 1, 2, or 3 element array; quit'
     rc = 5
     return
    endif

;   If the length of the wanttime variables is less than 4 let's assume you're asking
;   for a time index
    case n_elements(wanttime) of
     1: begin
        if(strlen(strcompress(string(wanttime),/rem)) lt 4) then begin
         ga_getvar_, inpfile, '', varval, time=time, /noprint, rc=rc
         nt = n_elements(time)
         if(fix(strcompress(string(wanttime),/rem)) gt nt) then begin
          print, 'Requested time index too large'
          print, 'nt = ', string(nt)
          print, 'you asked for '+strcompress(string(wanttime),/rem)
          print, 'exiting'
          rc = 6
          return
         endif else begin
          str_settime = ' -time '+gradsdate(time[fix(wanttime)-1])
         endelse
        endif else begin
         str_settime = ' -time '+gradsdate(wanttime)
        endelse
        end
     2: begin
        if(strlen(strcompress(string(wanttime[0]),/rem)) lt 4 and $
           strlen(strcompress(string(wanttime[1]),/rem)) lt 4) then begin
         ga_getvar_, inpfile, '', varval, time=time, /noprint, rc=rc
         nt = n_elements(time)
         if(fix(strcompress(string(wanttime[0]),/rem)) gt nt or $
            fix(strcompress(string(wanttime[1]),/rem)) gt nt ) then begin
          print, 'Requested time index too large'
          print, 'nt = ', string(nt)
          print, 'you asked for '+strcompress(string(wanttime),/rem)
          print, 'exiting'
          rc = 6
          return
         endif else begin
          str_settime = ' -time '+gradsdate(time[fix(wanttime[0])-1])+' '+$
                                  gradsdate(time[fix(wanttime[1])-1])
         endelse
        endif else begin
          str_settime = ' -time '+gradsdate(wanttime[0])+' '+gradsdate(wanttime[1])
        endelse
        if(n_elements(wanttime) eq 3) then str_settime = str_settime+' '+string(wanttime[2])
        end
    endcase
    cmd = cmd + str_settime
   endif
  endif   
  

; Any optional calls?
; -------------------
  if(keyword_set(options)) then begin
   cmd = cmd + ' ' + options
  endif

; Redirect the output
  cmd = cmd + ' >& error.log'

; Spawn the lats4d call
  print, 'Issuing lats4d call: '
  print, cmd
  spawn, cmd, /sh

; Check the error.log to see if the file was read correctly
  cmd = 'grep "error creating" error.log; echo $status'
  spawn, cmd, ier, /sh
  if(n_elements(ier) gt 1) then begin
   rc = 1
   cmd = '\rm -f '+file+'.nc'
   spawn, cmd, /sh
   print, 'Cannot open file ', inpfile_
   return
  endif
  cmd = '\rm -f error.log'
  spawn, cmd, /sh


; Open and read the generated file
; tack on the the obligatory '.nc' to the file
  file = file+'.nc'
  ga_getvar_read, file, vars, lon, lat, lev, time, time0, varval, sum=sum

; Create an output time array based on the time fragment from the nc file
; a bit flaky in that lats4d does not always base the time0 off the time
; I think that the template shows.
  nt = n_elements(time)
  timeout = strarr(nt)
  timeout[0] = string(time0)
  if(nt gt 1) then timeout[1:nt-1] = time[1:nt-1]
  time = timeout


; Before return, in case we requested only one lon/lat let's reduce data
; to be the nearest neighbor to that point/slice
  if(interplon eq 1) then begin
   rix = interpol(indgen(n_elements(lon)),lon,wantlon[0])
   dix = rix - fix(rix)
   if(dix le .5) then ix = fix(rix)
   if(dix gt .5) then ix = fix(rix+1)
   lon = lon[ix]
   varval = varval[ix,*,*,*,*]
  endif
  if(interplat eq 1) then begin
   riy = interpol(indgen(n_elements(lat)),lat,wantlat[0])
   diy = riy - fix(riy)
   if(diy le .5) then iy = fix(riy)
   if(diy gt .5) then iy = fix(riy+1)
   lat = lat[iy]
   varval = varval[*,iy,*,*,*]
  endif


; clean up
  if(keyword_set(save)) then begin
   if(keyword_set(ofile)) then begin
    cmd = '\mv -f '+file + ' '+ofile
    spawn, cmd, /sh
   endif
  endif else begin
   cmd = 'rm -f '+file
   spawn, cmd, /sh
  endelse


  print, cmd
 
  endelse

end

