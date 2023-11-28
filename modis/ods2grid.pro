; Colarco, Sept. 2008
; Procedure is to take MOD04/MYD04 ODS files and grid to a requested
; model resolution.  Various keywords control grid resolution, orientation,
; and quality weighting. Operate on one ODS file at a time, but allow for
; possibility to read in bracketing files to get the data in other days.

; Arguments:
;  datestart    - YYYYMMDD of first date to act on
;  dateend      - YYYYMMDD of last date to act on
;  satellite    - satellite ID ("MOD04" or "MYD04" for now)

; Keywords:
;  odsdir       - location of ODS files (else /output/MODIS/Level3/$satellite/ODS)
;  outdir       - location for gridded output
;  resolution   - spatial resolution (a,b,c,d,e, default is "b")
;  ntday        - number of grid times per day (default is 4; ie., every 6 hrs)
;  noundef      - if set, do not produce an "undef" file of the first time
;  geos4        - if set, use GEOS4 lons (0 - 360), else GEOS5 (-180 - 180)
;  qatype       - one of "qawt", "qawt3", or "noqawt" (default is "qawt")
;                 "noqaqwt" - all retrievals are weighted equally in aggregate
;                 "qawt3"   - retain only the qawt = 3 retrievals
;                 "qawt"    - weight according to qawt (this is like
;                             Level 3)
;  method       - one of ocean, land, deep (for deep blue)

  pro ods2grid, satellite, datestart, dateend, $
      collection = collection, $
      odsdir = odsdir, odsver = odsver, outdir = outdir, $
      resolution = resolution, ntday = ntday, $
      noundef = noundef, geos4=geos4, h4zip=h4zip, shave=shave, regrid=regrid, $
      qatype = qatype, $
      synopticoffset=synopticoffset, $
      method=method

; Check the keywords
  spawn, 'echo $MODISDIR', headDIR
  if(not(keyword_set(geos4))) then geos4 = 0
  if(not(keyword_set(noundef))) then noundef = 0
  if(not(keyword_set(ntday))) then ntday = 4
  if(not(keyword_set(resolution))) then resolution = 'b'
  if(not(keyword_set(odsdir))) then odsdir = headDir+'/MODIS/Level3/'+satellite+'/ODS/'
  if(not(keyword_set(outdir))) then $
   outdir = headDir+'/MODIS/Level3/'+satellite+'/'+resolution+'/GRITAS/'
  if(not(keyword_set(qatype))) then qatype = 'qawt'
  if(not(keyword_set(deepblue))) then deepblue = 0
  if(not(keyword_set(odsver))) then odsver = 'aero_005'
; Synoptic offset from 0Z in minutes of base time for day
  if(not(keyword_set(synopticoffset))) then synopticoffset = 0
; Special name of ODS files
  if(not(keyword_set(method))) then method = 'ocean'
; Collection
  if(not(keyword_set(collection))) then collection = '051'

; Set up for qatype
  case qatype of
   'noqawt': begin
             qawtstr = 'noqawt'
             qaflstr = 'noqafl'
             qathresh = 0
             end
   'qawt3':  begin
             qawtstr = 'qawt3'
             qaflstr = 'qafl3'
             qathresh = 2  ; only choose points > 2 qawt
             end
   'qawt':   begin
             qawtstr = 'qawt'
             qaflstr = 'qafl'
             qathresh = 0
             end
  endcase

; Set up case for resolutions
  case resolution of
   'a': begin
        nx = 72
        ny = 46
        end
   'b': begin
        nx = 144
        ny = 91
        end
   'c': begin
        nx = 288
        ny = 181
        end
   'd': begin
        nx = 576
        ny = 361
        end
   'e': begin
        nx = 1152
        ny = 721
        end
  endcase

; Initial
  saveOcn = 0
  saveLnd = 0
  saveBlu = 0

; Min tau (for now, can select a threshold of the minimum tau to
; consider in aggregating; here I assume tau is valid at 550 nm
; and values below the threshold are treated as missing)
  mintau = 0.0

; ----------------------------------------------------------------
; Create the output grid
  dy = 180.d/(ny-1)
  dx = 360.d/nx
  lonOut = -180.d + dindgen(nx)*dx
  latOut =  -90.d + dindgen(ny)*dy

  date = datestart
  while(long(date) le long(dateend)) do begin

  Print, 'Begin: ', date

; Create the filename to read
  yyyy = stringit(long(date)/10000L)
  mm   = stringit((long(date) - (long(yyyy)*10000L))/100L)
  if(long(mm) lt 10) then mm = '0'+mm
  dd   = stringit(long(date)-(long(yyyy)*10000L + long(mm)*100L))
  if(long(dd) lt 10) then dd = '0'+dd
  odsfile = odsdir + 'Y'+yyyy+'/M'+mm+'/'+satellite+'_L2_'+collection+'.'+odsver+'.'+method+'.'+yyyy+mm+dd+'.ods'

; If any of the variables are not saved then read the file again
  if((saveOcn eq 0) or (saveLnd eq 0) or (saveBlu eq 0)) then begin
  odsread, odsfile, fail, $
               levOcn, latOcn, lonOcn, timeOcn, aotOcn, $
               levfOcn, latfOcn, lonfOcn, timefOcn, aotfOcn, $
               levqOcn, latqOcn, lonqOcn, timeqOcn, aotqOcn, $
               satid = satellite, method=method

; for noqawt give all points equal qawt
  if(qatype eq 'noqawt') then begin
   aotqOcn[where(aotqOcn gt 0)] = 1.
  endif

  endif

; If any have been saved, then revert
; Catches case of land saved, ocean not, or vice versa
  if(saveocn) then begin
    aotOcn = aotOcns
    lonOcn = lonOcns
    latOcn = latOcns
    levOcn = levOcns
    timeOcn = timeOcns

    aotfOcn = aotfOcns
    lonfOcn = lonfOcns
    latfOcn = latfOcns
    levfOcn = levfOcns
    timefOcn = timefOcns

    aotqOcn = aotqOcns
    lonqOcn = lonqOcns
    latqOcn = latqOcns
    levqOcn = levqOcns
    timeqOcn = timeqOcns
  endif

; What is the next date?
  caldat, julday(mm,dd,yyyy)+1, mm_, dd_, yyyy_
  date_ = yyyy_*10000L+mm_*100L+dd_
  yyyy_ = stringit(yyyy_)
  mm_   = stringit(mm_)
  if(long(mm_) lt 10) then mm_ = '0'+mm_
  dd_   = stringit(dd_)
  if(long(dd_) lt 10) then dd_ = '0'+dd_
  odsfile_ = odsdir + 'Y'+yyyy_+'/M'+mm_+'/'+satellite+'_L2_'+collection+'.'+odsver+'.'+method+'.'+yyyy_+mm_+dd_+'.ods'
  odsread, odsfile_, fail_, $
               levOcn_, latOcn_, lonOcn_, timeOcn_, aotOcn_, $
               levfOcn_, latfOcn_, lonfOcn_, timefOcn_, aotfOcn_, $
               levqOcn_, latqOcn_, lonqOcn_, timeqOcn_, aotqOcn_, $
               satid = satellite, method=method

;  for noqawt give all points equal qawt
   if(qatype eq 'noqawt') then begin
    aotqOcn[where(aotqOcn gt 0)] = 1.
   endif

;  If no file found...
   if(fail and fail_) then goto, cycle

;  Now assemble to work on:
   if(not fail_) then begin
    rc_ = 1
    rc  = 0
    if(not fail) then rc = 1
    rcsave = rc
    if(saveOcn) then rc = 1
    stitch, rc, rc_, levOcn, levOcn_, levOcn, rcstitch
    if(rcstitch eq 0) then goto, cycle
    stitch, rc, rc_, latOcn, latOcn_, latOcn, rcstitch
    stitch, rc, rc_, lonOcn, lonOcn_, lonOcn, rcstitch
    stitch, rc, rc_, timeOcn, timeOcn_+1440., timeOcn, rcstitch
    stitch, rc, rc_, aotOcn, aotOcn_, aotOcn, rcstitch

    stitch, rc, rc_, levfOcn, levfOcn_, levfOcn, rcstitch
    stitch, rc, rc_, latfOcn, latfOcn_, latfOcn, rcstitch
    stitch, rc, rc_, lonfOcn, lonfOcn_, lonfOcn, rcstitch
    stitch, rc, rc_, timefOcn, timefOcn_+1440., timefOcn, rcstitch
    stitch, rc, rc_, aotfOcn, aotfOcn_, aotfOcn, rcstitch

    stitch, rc, rc_, levqOcn, levqOcn_, levqOcn, rcstitch
    stitch, rc, rc_, latqOcn, latqOcn_, latqOcn, rcstitch
    stitch, rc, rc_, lonqOcn, lonqOcn_, lonqOcn, rcstitch
    stitch, rc, rc_, timeqOcn, timeqOcn_+1440., timeqOcn, rcstitch
    stitch, rc, rc_, aotqOcn, aotqOcn_, aotqOcn, rcstitch

    rc = rcsave
   endif

; Variables to be gridded for output and reform, swapping order of levels
; ocean has 7 AOT channels
; land has 3 AOT channels
; deep blue has 4 AOT channels
  olevOcn = levOcn[uniq(levOcn,sort(levOcn))]
  nlamOcn = n_elements(olevOcn)
  npts = n_elements(aotqOcn)
  aotOcn = reform(aotOcn,nlamOcn,npts)
  levOcn = reform(levOcn,nlamOcn,npts)
  olevOcn = reverse(oLevOcn)
  aotOcn = reverse(aotOcn,1)
  levOcn = reverse(levOcn,1)
  case method of
   'ocean' : i550o = 5
   'land'  : i550o = 1
   'deep'  : i550o = 1
  endcase

; At this point I think that the lon/lat are equivalently dimensioned and
; ordered for the aotOcn as for the aotfOcn, aotqOcn.

  modAOTOcn = make_array(nx,ny,nlamOcn,ntday,val=1.e15)    ; average AOT
  modNumOcn = make_array(nx,ny,1,ntday,val=1.e15)          ; Number of points making up average
  modStdOcn = make_array(nx,ny,1,ntday,val=1.e15)          ; Standard deviation about average
  modqaOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; QA flag
  modfnOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; fine mode AOT fraction (550)
  modmnOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; Minimum AOT value (550) (nonzero QA)
  modmxOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; Maxmimum AOT value (550) (nonzero QA)

;  Loop over time and subset input fields
   dt = (24*60) / ntday
   for it = 0, ntday-1 do begin
    modAOTOcn_ = fltarr(nx,ny,nlamOcn)    ; average AOT
    modNumOcn_ = intarr(nx,ny)            ; Number of points making up average
    modStdOcn_ = fltarr(nx,ny)            ; Standard deviation about average
    modqaOcn_  = fltarr(nx,ny)
    modfnOcn_  = fltarr(nx,ny)
    modmnOcn_  = fltarr(nx,ny)
    modmxOcn_  = fltarr(nx,ny)
    modmnOcn_[*,*] =  9999.
    modmxOcn_[*,*] = -9999.

    minsyn = it*dt + synopticoffset
;   Here I need to select then the points I want to operate on for this
;   synoptic time

;   Aggregate the averages
    a = where(timeqOcn ge minsyn-dt/2 and timeqOcn lt minsyn+dt/2 and aotqOcn gt qathresh)
    if(a[0] ne -1) then begin
     aotOcn__ = aotOcn[*,a]
     aotqOcn__ = aotqOcn[a]
     aotfOcn__ = aotfOcn[a]
     lonfOcn__ = lonfOcn[a]
     latfOcn__ = latfOcn[a]

     ix = interpol(indgen(nx),lonOut,lonfOcn__)
     iy = interpol(indgen(ny),latOut,latfOcn__)
     ix = fix(ix+0.5)
     iy = fix(iy+0.5)
     b = where(ix ge nx)
     if(b[0] ne -1) then ix[b] = 0
     npts = n_elements(ix)
     for ipts = 0L, npts-1L do begin
      modAotOcn_[ix[ipts],iy[ipts],*] = modAotOcn_[ix[ipts],iy[ipts],*] $
       + aotOcn__[*,ipts]*aotqOcn__[ipts]

      modfnOcn_[ix[ipts],iy[ipts]] = modfnOcn_[ix[ipts],iy[ipts]] $
       + aotfOcn__[ipts]*aotOcn__[i550o,ipts]*aotqOcn__[ipts]

      modNumOcn_[ix[ipts],iy[ipts]] = modNumOcn_[ix[ipts],iy[ipts]] + 1

      modqaOcn_[ix[ipts],iy[ipts]] = modqaOcn_[ix[ipts],iy[ipts]] + aotqOcn__[ipts]

      if(aotOcn__[i550o,ipts] lt modmnOcn_[ix[ipts],iy[ipts]]) then $
        modmnOcn_[ix[ipts],iy[ipts]] = aotOcn__[i550o,ipts]
      if(aotOcn__[i550o,ipts] gt modmxOcn_[ix[ipts],iy[ipts]]) then $
        modmxOcn_[ix[ipts],iy[ipts]] = aotOcn__[i550o,ipts]
     endfor
     b = where(modqaOcn_ gt 0)
     if(b[0] ne -1) then begin
      modAotOcn_ = reform(modAotOcn_,long(nx)*ny,nlamOcn)
      for iband = 0, nlamOcn-1 do begin
       modAotOcn_[b,iband] = modAotOcn_[b,iband] / modqaOcn_[b]
      endfor
      modfnOcn_[b]  = modfnOcn_[b] / (modAotOcn_[b,i550o]*modqaOcn_[b])
      modAotOcn_ = reform(modAotOcn_,nx,ny,nlamOcn)
     endif

;    Find the std deviation of the 550 nm channel
     for ipts = 0L, npts-1L do begin
      if(modNumOcn_[ix[ipts],iy[ipts]] gt 1) then $
       modStdOcn_[ix[ipts],iy[ipts]] = modStdOcn_[ix[ipts],iy[ipts]] $
        + (aotOcn__[i550o,ipts]-modAotOcn_[ix[ipts],iy[ipts],i550o])^2. $
          / (modNumOcn_[ix[ipts],iy[ipts]] - 1.)
     endfor
    endif
    modnumOcn_ = float(modnumOcn_)

    b = where(modAotOcn_ eq 0.)
    if(b[0] ne -1) then modAotOcn_[b] = 1.e15
    b = where(modqaOcn_ eq 0.)
    if(b[0] ne -1) then modqaOcn_[b] = 1.e15
    if(b[0] ne -1) then modnumOcn_[b] = 1.e15
    if(b[0] ne -1) then modStdOcn_[b] = 1.e15
    if(b[0] ne -1) then modfnOcn_[b] = 1.e15
    if(b[0] ne -1) then modmnOcn_[b] = 1.e15
    if(b[0] ne -1) then modmxOcn_[b] = 1.e15
    modAotOcn[*,*,*,it] = modAotOcn_
    modqaOcn[*,*,0,it] = modqaOcn_
    modnumOcn[*,*,0,it] = modnumOcn_
    modStdOcn[*,*,0,it] = modStdOcn_
    modfnOcn[*,*,0,it] = modfnOcn_
    modmnOcn[*,*,0,it] = modmnOcn_
    modmxOcn[*,*,0,it] = modmxOcn_

   endfor

;  ----------------------------------------------------------------
;  Write to output files
   if(keyword_set(h4zip)) then shave_ = h4zip
   if(keyword_set(shave)) then shave_ = shave
   shave = shave_
   case method of
    'ocean' : tag = 'ocn'
    'land'  : tag = 'lnd'
    'deep'  : tag = 'blu'
   endcase

   filehead = satellite+'_L2_'+tag+'.'+odsver+'.'+qawtstr
   filehead = satellite+'_L2_'+tag+'.'+odsver+'_'+collection+'.'+qawtstr
   write_aot, outdir, filehead, nx, ny, dx, dy, ntday, nlamOcn, date, $
              lonOut, latOut, olevOcn, modAotOcn, shave=shave, geos4=geos4, $
              synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

   filehead = satellite+'_L2_'+tag+'.'+odsver+'.'+qaflstr
   filehead = satellite+'_L2_'+tag+'.'+odsver+'_'+collection+'.'+qaflstr
   write_qafl, outdir, filehead, nx, ny, dx, dy, ntday, 1, date, $
               lonOut, latOut, 550., modfnOcn, modqaOcn, $
               modnumOcn, modstdOcn, modmnOcn, modmxOcn, shave=shave, geos4=geos4, $
               synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

;  if not(noundef) and first date then write undef files
   if(not(noundef) and date eq datestart) then begin
    filehead = 'undef.'+satellite+'_L2_'+tag+'.'+odsver+'.'+qawtstr
    undef = modAotOcn
    undef[*] = 1.e15
    write_aot, outdir, filehead, nx, ny, dx, dy, ntday, nlamOcn, date, $
               lonOut, latOut, olevOcn, undef, shave=shave, geos4=geos4, $
               synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

    filehead = 'undef.'+satellite+'_L2_'+tag+'.'+odsver+'.'+qaflstr
    undef = modfnOcn
    undef[*] = 1.e15
    write_qafl, outdir, filehead, nx, ny, dx, dy, ntday, 1, date, $
                lonOut, latOut, 550., undef, undef, $
                undef, undef, undef, undef, shave=shave, geos4=geos4, $
                synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

   endif

;  ---------------
;  Save any values that go to the next day, and set switch so as not to read day again
   a = where(timefOcn ge 1440-dt/2)
   if(a[0] ne -1) then begin
    saveOcn = 1
    npts = n_elements(a)
    aotOcns = aotOcn[*,a]
    aotOcns = reverse(aotOcns,1)
    aotOcns = reform(aotOcns,nlamOcn*npts)
    lonOcns = lonOcn[a]
    latOcns = latOcn[a]
    levOcns = levOcn[*,a]
    levOcns = reverse(levOcns,1)
    levOcns = reform(levOcns,nlamOcn*npts)
    timeOcns = timeOcn[a]-1440.

    aotfOcns = aotfOcn[a]
    lonfOcns = lonfOcn[a]
    latfOcns = latfOcn[a]
    levfOcns = levfOcn[a]
    timefOcns = timefOcn[a]-1440.

    aotqOcns = aotqOcn[a]
    lonqOcns = lonqOcn[a]
    latqOcns = latqOcn[a]
    levqOcns = levqOcn[a]
    timeqOcns = timeqOcn[a]-1440.
   endif else begin
    saveOcn = 0
   endelse

cycle:
  date = stringit(date_)

  endwhile


end
