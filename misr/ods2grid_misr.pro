; Colarco, Sept. 2008
; Procedure is to take MOD04/MYD04 ODS files and grid to a requested
; model resolution.  Various keywords control grid resolution, orientation,
; and quality weighting. Operate on one ODS file at a time, but allow for
; possibility to read in bracketing files to get the data in other days.

; Arguments:
;  datestart    - YYYYMMDD of first date to act on
;  dateend      - YYYYMMDD of last date to act on
;  satellite    - satellite ID ("MISR" for now)

; Keywords:
;  odsdir       - location of ODS files (else /output/MISR/Level3/ODS)
;  outdir       - location for gridded output
;  resolution   - spatial resolution (a,b,c,d,e, default is "b")
;  ntday        - number of grid times per day (default is 4; ie., every 6 hrs)
;  noundef      - if set, do not produce an "undef" file of the first time
;  geos4        - if set, use GEOS4 lons (0 - 360), else GEOS5 (-180 - 180)
;  qatype       - one of "qawt", "qawt3", or "noqawt" (default is "noqawt")
;                 "noqaqwt" - all retrievals are weighted equally in aggregate
;                 "qawt3"   - retain only the qawt = 3 retrievals
;                 "qawt"    - weight according to qawt (this is like Level 3)

  pro ods2grid_misr, satellite, datestart, dateend, $
      odsdir = odsdir, odsver = odsver, outdir = outdir, $
      resolutions = resolutions, ntday = ntday, $
      noundef = noundef, geos4=geos4, h4zip=h4zip, shave=shave, $
      qatype = qatype, $
      synopticoffset=synopticoffset, $
      obsspecial=obsspecial

  spawn, 'echo $MODISDIR', headDIR
; Check the keywords
  if(not(keyword_set(geos4))) then geos4 = 0
  if(not(keyword_set(noundef))) then noundef = 0
  if(not(keyword_set(ntday))) then ntday = 4
  if(not(keyword_set(resolutions))) then resolutions = ['b','c','d']
  if(not(keyword_set(odsdir))) then odsdir = headDir+'/MISR/Level3/ODS_03/'
  if(not(keyword_set(outdir))) then $
   outdir = headDir+'/MISR/Level3/'
  if(not(keyword_set(qatype))) then qatype = 'noqawt'
  if(not(keyword_set(odsver))) then odsver = 'aero_tc8'
; Synoptic offset from 0Z in minutes of base time for day
  if(not(keyword_set(synopticoffset))) then synopticoffset = 0
; Special name of ODS files
  if(not(keyword_set(obsspecial))) then obsspecial = 'obs'

; Initial
  saveODS = 0

; Algorithm
; MISR data are available in a number of algorithms
; We will select ODS files from the latest algorithm available
  algorithm = ['F12_0022']
  nalg = n_elements(algorithm)
  ialg = 0

; Min tau (for now, can select a threshold of the minimum tau to
; consider in aggregating; here I assume tau is valid at 550 nm
; and values below the threshold are treated as missing)
  mintau = 0.0

; Time step
  dt = (24*60) / ntday

; ----------------------------------------------------------------
  date = datestart
  while(long(date) le long(dateend)) do begin

  Print, 'Begin: ', date

; Create the filename to read
  yyyy = stringit(long(date)/10000L)
  mm   = stringit((long(date) - (long(yyyy)*10000L))/100L)
  if(long(mm) lt 10) then mm = '0'+mm
  dd   = stringit(long(date)-(long(yyyy)*10000L + long(mm)*100L))
  if(long(dd) lt 10) then dd = '0'+dd
  odsfile = odsdir + 'Y'+yyyy+'/M'+mm+'/misr_'+algorithm[ialg]+'.'+odsver+'.'+obsspecial+'.'+yyyy+mm+dd+'.ods'
; Check also for weird case of zero length files
  spawn, 'ls -s '+odsfile, result
  result=strsplit(result,/extract)
  fail = 0
  if(long(result[0]) eq 0L) then fail = 1
  if(saveODS eq 0 and not fail) then begin
   odsread_misr, odsfile, fail, $
                 levOcn, latOcn, lonOcn, timeOcn, aotOcn
  endif

; If any have been saved, then revert
; Catches case of land saved, ocean not, or vice versa
  if(saveODS) then begin
    aotOcn = aotOcns
    lonOcn = lonOcns
    latOcn = latOcns
    levOcn = levOcns
    timeOcn = timeOcns
  endif

; What is the next date?
  caldat, julday(mm,dd,yyyy)+1, mm_, dd_, yyyy_
  date_ = yyyy_*10000L+mm_*100L+dd_
  yyyy_ = stringit(yyyy_)
  mm_   = stringit(mm_)
  if(long(mm_) lt 10) then mm_ = '0'+mm_
  dd_   = stringit(dd_)
  if(long(dd_) lt 10) then dd_ = '0'+dd_
  odsfile_ = odsdir + 'Y'+yyyy_+'/M'+mm_+'/misr_'+algorithm[ialg]+'.'+odsver+'.'+obsspecial+'.'+yyyy_+mm_+dd_+'.ods'
  spawn, 'ls -s '+odsfile_, result
  result=strsplit(result,/extract)
  fail_ = 0
  if(long(result[0]) eq 0L) then fail_ = 1
  if(not(fail_)) then $
   odsread_misr, odsfile_, fail_, $
                 levOcn_, latOcn_, lonOcn_, timeOcn_, aotOcn_

;  If no file found...
   if(fail and fail_) then goto, cycle

;  Now assemble to work on:
   if(not fail_) then begin
    rc_ = 1
    rc  = 0
    if(not fail) then rc = 1
    rcsave = rc
    if(saveODS) then rc = 1
    stitch, rc, rc_, levOcn, levOcn_, levOcn, rcstitch
    if(rcstitch eq 0) then goto, cycle
    stitch, rc, rc_, latOcn, latOcn_, latOcn, rcstitch
    stitch, rc, rc_, lonOcn, lonOcn_, lonOcn, rcstitch
    stitch, rc, rc_, timeOcn, timeOcn_+1440., timeOcn, rcstitch
    stitch, rc, rc_, aotOcn, aotOcn_, aotOcn, rcstitch
    rc = rcsave
   endif

; Variables to be gridded for output
; MISR has 4 AOT channels
  olevOcn = levOcn[uniq(levOcn,sort(levOcn))]
  nlamOcn = n_elements(olevOcn)

; reform the AOT variables
  npts = n_elements(aotOcn)/nlamocn
  aotOcn = reform(aotOcn,nlamOcn,npts)
  levOcn = reform(levOcn,nlamOcn,npts)
  lonOcn = reform(lonOcn,nlamOcn,npts)
  latOcn = reform(latOcn,nlamOcn,npts)
  timeOcn = reform(timeOcn,nlamOcn,npts)

; And for compatibility with old GRITAS files, swap order of levels
  olevOcn = reverse(oLevOcn)
  aotOcn = reverse(aotOcn,1)
  levOcn = reverse(levOcn,1)
  i550o = 2

; ------------------------------------------------
; End of ODS file read and assembly; now aggregate
; Loop over resolutions
  for ires = 0, n_elements(resolutions)-1 do begin

   resolution = resolutions[ires]
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
 'ten': begin
        nx = 36
        ny = 19
        end
  endcase

; Create the output grid
  dy = 180.d/(ny-1)
  dx = 360.d/nx
  lonOut = -180.d + dindgen(nx)*dx
  latOut =  -90.d + dindgen(ny)*dy

  modAOTOcn = make_array(nx,ny,nlamOcn,ntday,val=1.e15)    ; average AOT
  modNumOcn = make_array(nx,ny,1,ntday,val=1.e15)          ; Number of points making up average
  modStdOcn = make_array(nx,ny,1,ntday,val=1.e15)          ; Standard deviation about average
  modmnOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; Minimum AOT value (550) (nonzero QA)
  modmxOcn  = make_array(nx,ny,1,ntday,val=1.e15)          ; Maxmimum AOT value (550) (nonzero QA)

;  Loop over time and subset input fields
   for it = 0, ntday-1 do begin
    modAOTOcn_ = fltarr(nx,ny,nlamOcn)    ; average AOT
    modNumOcn_ = intarr(nx,ny)            ; Number of points making up average
    modStdOcn_ = fltarr(nx,ny)            ; Standard deviation about average
    modmnOcn_  = fltarr(nx,ny)
    modmxOcn_  = fltarr(nx,ny)

    modmnOcn_[*,*] =  9999.
    modmxOcn_[*,*] = -9999.


    minsyn = it*dt + synopticoffset
;   Here I need to select then the points I want to operate on for this
;   synoptic time

;   Aggregate the averages
    a = where(timeOcn[0,*] ge minsyn-dt/2 and timeOcn[0,*] lt minsyn+dt/2 and aotOcn gt 0)
    if(a[0] ne -1) then begin
     aotOcn_ = aotOcn[*,a]
     lonOcn_ = lonOcn[0,a]
     latOcn_ = latOcn[0,a]

     ix = interpol(indgen(nx),lonOut,lonOcn_)
     iy = interpol(indgen(ny),latOut,latOcn_)
     ix = fix(ix+0.5)
     iy = fix(iy+0.5)
     b = where(ix ge nx)
     if(b[0] ne -1) then ix[b] = 0
     npts = n_elements(ix)
     for ipts = 0L, npts-1L do begin
      modAotOcn_[ix[ipts],iy[ipts],*] = modAotOcn_[ix[ipts],iy[ipts],*] $
       + aotOcn_[*,ipts]

      modNumOcn_[ix[ipts],iy[ipts]] = modNumOcn_[ix[ipts],iy[ipts]] + 1

      if(aotOcn_[i550o,ipts] lt modmnOcn_[ix[ipts],iy[ipts]]) then $
        modmnOcn_[ix[ipts],iy[ipts]] = aotOcn_[i550o,ipts]
      if(aotOcn_[i550o,ipts] gt modmxOcn_[ix[ipts],iy[ipts]]) then $
        modmxOcn_[ix[ipts],iy[ipts]] = aotOcn_[i550o,ipts]
     endfor
     
     b = where(modNumOcn_ gt 0)
     if(b[0] ne -1) then begin
      modAotOcn_ = reform(modAotOcn_,long(nx)*ny,nlamOcn)
      for iband = 0, nlamOcn-1 do begin
       modAotOcn_[b,iband] = modAotOcn_[b,iband] / modNumOcn_[b]
      endfor
      modAotOcn_ = reform(modAotOcn_,nx,ny,nlamOcn)
     endif

;    Find the std deviation of the 550 nm channel
     for ipts = 0L, npts-1L do begin
      if(modNumOcn_[ix[ipts],iy[ipts]] gt 1) then $
       modStdOcn_[ix[ipts],iy[ipts]] = modStdOcn_[ix[ipts],iy[ipts]] $
        + (aotOcn_[i550o,ipts]-modAotOcn_[ix[ipts],iy[ipts],i550o])^2. $
          / (modNumOcn_[ix[ipts],iy[ipts]] - 1.)
     endfor
    endif


;   Now store the average for later
    modnumOcn_ = float(modnumOcn_)

    b = where(modAotOcn_ eq 0.)
    if(b[0] ne -1) then modAotOcn_[b] = 1.e15
    b = where(modNumOcn_ eq 0.)
    if(b[0] ne -1) then modNumOcn_[b] = 1.e15
    if(b[0] ne -1) then modmnOcn_[b] = 1.e15
    if(b[0] ne -1) then modmxOcn_[b] = 1.e15
    if(b[0] ne -1) then modstdOcn_[b] = 1.e15
    modAotOcn[*,*,*,it] = modAotOcn_
    modnumOcn[*,*,0,it] = modnumOcn_
    modStdOcn[*,*,0,it] = modStdOcn_
    modmnOcn[*,*,0,it] = modmnOcn_
    modmxOcn[*,*,0,it] = modmxOcn_
   endfor

;  ----------------------------------------------------------------
;  Write to output files
   if(keyword_set(h4zip)) then shave_ = h4zip
   if(keyword_set(shave)) then shave_ = shave
   shave = shave_

;  Check on algorithm name: possibly have leftovers from previous

   filehead = 'MISR_L2.'+odsver+'_'+algorithm[ialg]+'.noqawt'

   outdir_ = outdir + resolution + '/GRITAS/'

   write_aot, outdir_, filehead, nx, ny, dx, dy, ntday, nlamOcn, date, $
              lonOut, latOut, olevOcn, modAotOcn, shave=shave, geos4=geos4, $
              synopticoffset=synopticoffset, resolution=resolution

   filehead = 'MISR_L2.'+odsver+'_'+algorithm[ialg]+'.noqafl'

   modfnOcn = modnumOcn
   modqaOcn = modnumOcn
   modfnOcn[*] = 1.e15
;   modqaOcn[*] = 1.e15
   write_qafl, outdir_, filehead, nx, ny, dx, dy, ntday, 1, date, $
               lonOut, latOut, 550., modfnOcn, modqaOcn, $
               modnumOcn, modstdOcn, modmnOcn, modmxOcn, shave=shave, geos4=geos4, $
              synopticoffset=synopticoffset, resolution=resolution

;  if not(noundef) and first date then write undef files
   if(not(noundef) and date eq datestart) then begin
    filehead = 'undef.MISR_L2.'+odsver+'_'+algorithm[ialg]+'.noqawt'
    undef = modAotOcn
    undef[*] = 1.e15
    write_aot, outdir_, filehead, nx, ny, dx, dy, ntday, nlamOcn, date, $
               lonOut, latOut, olevOcn, undef, shave=shave, geos4=geos4, $
               synopticoffset=synopticoffset, resolution=resolution

    filehead = 'undef.MISR_L2.'+odsver+'_'+algorithm[ialg]+'.noqafl'
    undef = modfnOcn
    undef[*] = 1.e15
    write_qafl, outdir_, filehead, nx, ny, dx, dy, ntday, 1, date, $
                lonOut, latOut, 550., undef, undef, $
                undef, undef, undef, undef, shave=shave, geos4=geos4, $
               synopticoffset=synopticoffset, resolution=resolution

   endif

   endfor  ; resolutions

;  Save any values that go to the next day, and set switch so as not to read day again
   a = where(timeOcn[0,*] ge 1440-dt/2)
   if(a[0] ne -1) then begin
    saveODS = 1
    npts = n_elements(a)
    aotOcns = aotOcn[*,a]
    aotOcns = reverse(aotOcns,1)
    aotOcns = reform(aotOcns,nlamOcn*npts)
    lonOcns = reform(lonOcn[*,a],nlamOcn*npts)
    latOcns = reform(latOcn[*,a],nlamOcn*npts)
    levOcns = levOcn[*,a]
    levOcns = reverse(levOcns,1)
    levOcns = reform(levOcns,nlamOcn*npts)
    timeOcns = reform(timeOcn[*,a]-1440.,nlamOcn*npts)

   endif else begin
    saveODS = 0
   endelse
    

cycle:
  date = stringit(date_)

  endwhile


end
