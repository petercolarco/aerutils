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

  pro ods2grid_hourly, satellite, datestart, dateend, $
      collection=collection, $
      odsdir = odsdir, odsver = odsver, outdir = outdir, $
      ntday = ntday, nthresh=nthresh, $
      noundef = noundef, geos4=geos4, h4zip=h4zip, shave=shave, regrid=regrid, $
      qatype = qatype, $
      synopticoffset=synopticoffset, $
      samplingmethod=samplingmethod, $
      method=method, resolutions=resolutions, inverse=inverse

; Check the keywords
  spawn, 'echo $MODISDIR', headDIR
  if(not(keyword_set(nthresh))) then nthresh = 1   ; # of valid pixels to count
  if(not(keyword_set(geos4))) then geos4 = 0
  if(not(keyword_set(noundef))) then noundef = 0
  if(not(keyword_set(ntday))) then ntday = 4
  if(not(keyword_set(resolutions))) then resolutions = ['b','c','d','ten']
  if(not(keyword_set(odsdir))) then odsdir = headDir+'/MODIS/Level3/'+satellite+'/ODS/'
  if(not(keyword_set(outdir))) then $
   outdir = headDir+'/MODIS/Level3/'+satellite+'/'
  if(not(keyword_set(deepblue))) then deepblue = 0
  if(not(keyword_set(odsver))) then odsver = 'aero_005'
; Synoptic offset from 0Z in minutes of base time for day
  if(not(keyword_set(synopticoffset))) then synopticoffset = 0
; Special name of ODS files
  if(not(keyword_set(method))) then method = 'ocean'
;  sampling = ''
;  if(keyword_set(samplingmethod)) then sampling = samplingmethod+'.'
  if(not(keyword_set(inverse))) then inverse = 0
; Collection
  if(not(keyword_set(collection))) then collection = '051'

  samplings = ['','supermisr.','misr1.','misr2.','misr3.','misr4.',$
               'caliop1.','caliop2.','caliop3.','caliop4.',$
               'lat1.','lat2.','lat3.','lat4.','lat5.']

  if(inverse) then $
    samplings = ['supermisr.','misr1.','misr2.','misr3.','misr4.',$
                 'caliop1.','caliop2.','caliop3.','caliop4.']

  if(keyword_set(samplingmethod)) then $
    samplings = samplingmethod

; Colarco 7/21/16
  samplings=''


; Check on method
  if(not(keyword_set(qatype))) then begin
   qatype = 'qawt'
;   if(method eq 'land' or method eq 'deep') then qatype = 'qawt3'
   if(method eq 'land') then qatype = 'qawt3'
  endif

; Set up for qatype
  case qatype of
   'noqawt': begin
             qawtstr = 'noqawt'
             qaflstr = 'noqafl'
             qaststr = 'noqast'
             qathresh = 1
             end
   'qawt3':  begin
             qawtstr = 'qawt3'
             qaflstr = 'qafl3'
             qaststr = 'qast3'
             qathresh = 3  ; only choose points >= 3 qawt
             end
   'qawt':   begin
             qawtstr = 'qawt'
             qaflstr = 'qafl'
             qaststr = 'qast'
             qathresh = 1
             end
  endcase

; Initial
  saveObs = 0

; Min tau (for now, can select a threshold of the minimum tau to
; consider in aggregating; here I assume tau is valid at 550 nm
; and values below the threshold are treated as missing)
  mintau = 0.0

  if(satellite eq 'MOD04') then begin
   if(method eq 'ocean') then kx = 301
   if(method eq 'land' ) then kx = 302
   if(method eq 'deep' ) then kx = 310
  endif else begin
   if(method eq 'ocean') then kx = 311
   if(method eq 'land' ) then kx = 312
   if(method eq 'deep' ) then kx = 320
  endelse
  kt = 45
  ktqa = 74

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
  odsfile = odsdir + 'Y'+yyyy+'/M'+mm+'/'+satellite+'_L2_'+collection+'.'+odsver+'.'+method+'.'+yyyy+mm+dd+'.ods'
stop
; If any of the variables are not saved then read the file again
  if(saveObs eq 0) then begin
   readods, odsfile, kx, kt, lat, lon, lev, time, obs, rc=fail, ks=ks, $
            ktqa=ktqa, qathresh=qathresh, obsq=obsq
  endif

; If any have been saved, then revert
; Catches case of land saved, ocean not, or vice versa
  if(saveObs) then begin
    obs  = obss
    obsq = obsqs
    lon  = lons
    lat  = lats
    lev  = levs
    time = times
    ks   = kss
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
  readods, odsfile_, kx, kt, lat_, lon_, lev_, time_, obs_, rc=fail_, ks=ks_, $
           ktqa=ktqa, qathresh=qathresh, obsq=obsq_

;  If no file found...
   if(fail and fail_) then goto, cycle

;  Now assemble to work on:
   if(not fail_) then begin
    rc_ = 1
    rc  = 0
    if(not fail) then rc = 1
    rcsave = rc
    if(saveObs) then rc = 1
    stitch, rc, rc_, lev, lev_, lev, rcstitch
    if(rcstitch eq 0) then goto, cycle
    stitch, rc, rc_, lon, lon_, lon, rcstitch
    stitch, rc, rc_, lat, lat_, lat, rcstitch
    stitch, rc, rc_, time, time_+1440., time, rcstitch
    stitch, rc, rc_, obs, obs_, obs, rcstitch
    stitch, rc, rc_, obsq, obsq_, obsq, rcstitch
    stitch, rc, rc_, ks, ks_, ks, rcstitch
    rc = rcsave
   endif

; for noqawt give all points equal qawt
  if(qatype eq 'noqawt') then begin
   obsq = 1.
  endif

; First, reduce to the sampling set of obs points for the day
  for isample = 0, n_elements(samplings)-1 do begin
    sampling = samplings[isample]

;   Aggregate the time and level specific variables
    a = where(lev eq 550.)
;   Sampling switches
    case sampling of
;    Approximately MISR width swath centered at column 10 below (caliop1)
     'supermisr.' : a = where(lev eq 550. and (ks mod 135) ge 4 and (ks mod 135) le 48)
;    Approximately MISR width swath centered at column 10 below (caliop1)
     'misr1.'     : a = where(lev eq 550. and (ks mod 135) ge 4 and (ks mod 135) le 18)
;    Approximately MISR width swath centered at column 10 below (caliop1)
     'misr2.'     : a = where(lev eq 550. and (ks mod 135) ge 19 and (ks mod 135) le 48)
     'misr3.'     : a = where(lev eq 550. and (ks mod 135) ge 49 and (ks mod 135) le 87)
     'misr4.'     : a = where(lev eq 550. and (ks mod 135) ge 123 and (ks mod 135) le 135)
;    This shifts the subpoint to column 10, which is about 9 degrees west of nadir
     'caliop1.'   : a = where(lev eq 550. and (ks-10.)/135. eq long((ks-10)/135))
;    This shifts the subpoint to column 30, which is about 5 degrees west of nadir
     'caliop2.'   : a = where(lev eq 550. and (ks-30.)/135. eq long((ks-30)/135))
     'caliop3.'   : a = where(lev eq 550. and (ks-67)/135. eq long((ks-67)/135))
     'caliop4.'   : a = where(lev eq 550. and (ks-129)/135. eq long((ks-129)/135))
;    Several latitudinal samplings ala Geogdzhayev et al. 2013
     'lat1.'      : a = where(lev eq 550. and ((ks-1) mod (135*135)) le 134)
     'lat2.'      : a = where(lev eq 550. and ((ks+(135.*135.)-(4.*27*135.)-1) mod (135*135)) le 134)
     'lat3.'      : a = where(lev eq 550. and ((ks+(135.*135.)-(3.*27*135.)-1) mod (135*135)) le 134)
     'lat4.'      : a = where(lev eq 550. and ((ks+(135.*135.)-(2.*27*135.)-1) mod (135*135)) le 134)
     'lat5.'      : a = where(lev eq 550. and ((ks+(135.*135.)-(1.*27*135.)-1) mod (135*135)) le 134)
     else         : a = where(lev eq 550.)
    endcase

;   If inverse sampling is requested then redo
    if(inverse) then begin
     case sampling of
;     Approximately MISR width swath centered at column 10 below (caliop1)
      'supermisr.' : a = where(lev eq 550. and not ((ks mod 135) ge 4 and (ks mod 135) le 48))
;     Approximately MISR width swath centered at column 10 below (caliop1)
      'misr1.'     : a = where(lev eq 550. and not ((ks mod 135) ge 4 and (ks mod 135) le 18))
;     Approximately MISR width swath centered at column 10 below (caliop1)
      'misr2.'     : a = where(lev eq 550. and not ((ks mod 135) ge 19 and (ks mod 135) le 48))
      'misr3.'     : a = where(lev eq 550. and not ((ks mod 135) ge 49 and (ks mod 135) le 87))
      'misr4.'     : a = where(lev eq 550. and not ((ks mod 135) ge 123 and (ks mod 135) le 135))
;     This shifts the subpoint to column 10, which is about 9 degrees west of nadir
      'caliop1.'   : a = where(lev eq 550. and not ((ks-10.)/135. eq long((ks-10)/135)))
;     This shifts the subpoint to column 30, which is about 5 degrees west of nadir
      'caliop2.'   : a = where(lev eq 550. and not ((ks-30.)/135. eq long((ks-30)/135)))
      'caliop3.'   : a = where(lev eq 550. and not ((ks-67)/135. eq long((ks-67)/135)))
      'caliop4.'   : a = where(lev eq 550. and not ((ks-129)/135. eq long((ks-129)/135)))
      else         : a = where(lev eq 550.)
     endcase
     sampling = 'inverse_'+sampling
    endif

    if(a[0] ne -1) then begin
     obss__  = obs[a]
     obsqs__ = obsq[a]
     lons__  = lon[a]
     lats__  = lat[a]
     times__ = time[a]
    endif


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

; At this point I think that the lon/lat are equivalently dimensioned and
; ordered for the aotOcn as for the aotfOcn, aotqOcn.

  modAOT = make_array(nx,ny,ntday,val=1.e15)          ; average AOT
  modNum = make_array(nx,ny,ntday,val=1.e15)          ; Number of points making up average
  modStd = make_array(nx,ny,ntday,val=1.e15)          ; Standard deviation about average
  modqa  = make_array(nx,ny,ntday,val=1.e15)          ; QA of observation
  modmn  = make_array(nx,ny,ntday,val=1.e15)          ; Minimum AOT value (550) (nonzero QA)
  modmx  = make_array(nx,ny,ntday,val=1.e15)          ; Maxmimum AOT value (550) (nonzero QA)

; Loop over time and subset input fields
  dt = (24*60) / ntday

  for it = 0, ntday-1 do begin
    modAOT_ = fltarr(nx,ny)            ; average AOT
    modNum_ = intarr(nx,ny)            ; Number of points making up average
    modStd_ = fltarr(nx,ny)            ; Standard deviation about average
    modqa_  = fltarr(nx,ny)
    modmn_  = fltarr(nx,ny)
    modmx_  = fltarr(nx,ny)
    modmn_[*,*] =  9999.
    modmx_[*,*] = -9999.

    minsyn = it*dt + synopticoffset
;   Here I need to select then the points I want to operate on for this
;   synoptic time

;   Aggregate the time and level specific variables
    a = where(times__ ge minsyn-dt/2 and times__ lt minsyn+dt/2)

    if(a[0] ne -1) then begin

     obs__  = obss__[a]
     obsq__ = obsqs__[a]
     lon__  = lons__[a]
     lat__  = lats__[a]

     ix = interpol(indgen(nx),lonOut,lon__)
     iy = interpol(indgen(ny),latOut,lat__)
     ix = fix(ix+0.5)
     iy = fix(iy+0.5)
     b = where(ix ge nx)
     if(b[0] ne -1) then ix[b] = 0

     npts_ = n_elements(ix)

     for ipts = 0L, npts_-1L do begin
      obstmp  = obs__[ipts]
      obsqtmp = obsq__[ipts]
      modAot_[ix[ipts],iy[ipts]] = modAot_[ix[ipts],iy[ipts]] $
       + obstmp*obsqtmp

      modNum_[ix[ipts],iy[ipts]] = modNum_[ix[ipts],iy[ipts]] + 1
      modqa_[ix[ipts],iy[ipts]] = modqa_[ix[ipts],iy[ipts]] + obsqtmp

      if(obstmp lt modmn_[ix[ipts],iy[ipts]]) then $
        modmn_[ix[ipts],iy[ipts]] = obstmp
      if(obstmp gt modmx_[ix[ipts],iy[ipts]]) then $
        modmx_[ix[ipts],iy[ipts]] = obstmp
     endfor
     b = where(modqa_ gt 0)
     if(b[0] ne -1) then modAot_[b] = modAot_[b]/modqa_[b]

;    Find the std deviation of the 550 nm channel
     for ipts = 0L, npts_-1L do begin
      if(modNum_[ix[ipts],iy[ipts]] gt 1) then $
       modStd_[ix[ipts],iy[ipts]] = modStd_[ix[ipts],iy[ipts]] $
        + (obs__[ipts]-modAot_[ix[ipts],iy[ipts]])^2. $
          / (modNum_[ix[ipts],iy[ipts]] - 1.)
     endfor
    endif
    modnum_ = float(modnum_)

    b = where(modAot_ eq 0. or modnum_ lt nthresh)
    if(b[0] ne -1) then modAot_[b] = 1.e15
    if(b[0] ne -1) then modnum_[b] = 1.e15
    if(b[0] ne -1) then modqa_[b] = 1.e15
    if(b[0] ne -1) then modStd_[b] = 1.e30
    if(b[0] ne -1) then modmn_[b] = 1.e15
    if(b[0] ne -1) then modmx_[b] = 1.e15
    modAot[*,*,it] = modAot_
    modnum[*,*,it] = modnum_
    modqa[*,*,it] = modqa_
    modStd[*,*,it] = sqrt(modStd_)
    modmn[*,*,it] = modmn_
    modmx[*,*,it] = modmx_
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

   outdir_ = outdir + resolution + '/GRITAS/'

   nbins = 0
   modpdf = 0

   filehead = satellite+'_L2_'+tag+'.'+sampling+odsver+'_'+collection+'.'+qaststr
   write_sample, outdir_, filehead, nx, ny, dx, dy, ntday, 1, nbins, date, $
                 lonOut, latOut, 550., modAot, modpdf, $
                 modqa, modnum, modstd, modmn, modmx, shave=shave, geos4=geos4, $
                 synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

;  if not(noundef) and first date then write undef files
   if(not(noundef) and date eq datestart) then begin
    filehead = 'undef.'+satellite+'_L2_'+tag+'.'+sampling+odsver+'_'+collection+'.'+qaststr
    undef = modAot
    undef[*] = 1.e15
    undefpdf = modpdf
    undefpdf[*] = 1.e15
    write_sample, outdir_, filehead, nx, ny, dx, dy, ntday, 1, nbins, date, $
                  lonOut, latOut, 550., undef, undefpdf, $
                  undef, undef, undef, undef, undef, shave=shave, geos4=geos4, $
                  synopticoffset=synopticoffset, resolution=resolution, regrid=regrid

   endif

  endfor ; ires

  endfor ; isample

;  ---------------
;  Save any values that go to the next day, and set switch so as not to read day again
   a = where(time ge 1440-dt/2)
   if(a[0] ne -1) then begin
    saveObs = 1
    obss = obs[a]
    obsqs = obsq[a]
    lons = lon[a]
    lats = lat[a]
    levs = lev[a]
    times = time[a]-1440.
    kss   = ks[a]
   endif else begin
    saveObs = 0
   endelse

cycle:
  date = stringit(date_)

  endwhile

end
