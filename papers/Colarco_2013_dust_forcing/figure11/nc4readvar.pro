; Colarco, June 2012
; Generic reader for gridded nc4 style files typical of GEOS-5
; model output.
; Inputs:
; filename is one of:
;  1) an explicit filename (or list of filenames)
;  2) a grads-style control file (.ctl or .ddf)
;  3) a grads-style template (requires additional argument for
;     tdef)
;  4) an opendap URL (requires additional argument for tdef)
; varlist:
;  a case insensitive list of variable names to read from the file
; Outputs:
; varval:
;  the returned variables

; Lots of options follow:

; wanttime is an optional 2-element string array of [yyyymmdd,hhmmss]

  pro nc4readvar, filename, varlist, varval, $
                  tdef=tdef, $
                  sum = sum, template=template, $
                  lon=lon, lat=lat, lev=lev, time=time, $
                  nymd=nymd, nhms=nhms, $
                  wantlon=wantlon, wantlat=wantlat, wantlev = wantlev, $
                  wantnymd=wantnymd, wantnhms=wantnhms, $
                  rc = rc

!quiet = 1d
    rc = 0

;   How many files are given as input?
    nfile = n_elements(filename)
    nymd = make_array(nfile,val=-1L)
    nhms = make_array(nfile,val=-1L)

;   If more than one file is requested it must be (for now) an
;   explicit filename
    if(nfile gt 1) then begin
     for ifile = 0, nfile-1 do begin
      len = strlen(filename[ifile])
;     Multiple control/ddf/http files not supported
      if(strmid(filename[ifile],len-4,4) eq '.ctl' or $
         strmid(filename[ifile],len-4,4) eq '.ddf' or $
         strmid(filename[ifile],0,4) eq 'http'         ) then rc = 8000
;     Multiple templates not supported
      if(strpos(filename[ifile],'%') ge 0) then rc = 8001
     endfor
    endif
    if(rc gt 0) then return

;   Now see what sort of filename is presented
    filename_ = filename
    len = strlen(filename[0])
;   If the file is a grads ddf or ctl then we expect it to provide a
;   tdef suitable for expanding the times
    if(strmid(filename[0],len-4,4) eq '.ctl' or $
       strmid(filename[0],len-4,4) eq '.ddf'     ) then begin
       ga_times, filename[0], nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
       filename_ = strtemplate(filetemplate,nymd,nhms)
;      Suppose control file is actually a pointer to opendap url
       if(strmid(filename_[0],0,4) eq 'http') then begin
        if(not(keyword_set(tdef))) then begin
         rc = 8002
         return
        endif
        dateexpand, 1L, 1L, 1L, 1L, nymd, nhms, tdef=tdef, jday=jday
        filename_ = make_array(n_elements(nymd),val=filename_[0])
       endif
    endif
    if(strpos(filename[0],'%') ge 0 or $
       strmid(filename[0],0,4) eq 'http' ) then begin
       if(not(keyword_set(tdef))) then begin
        rc = 8003
        return
       endif
       dateexpand, 1L, 1L, 1L, 1L, nymd, nhms, tdef=tdef, jday=jday
       filename_ = strtemplate(filename[0],nymd,nhms)
    endif

;   At this point I have a list of filenames
;   If my list is based on a template I also have a list of dates
;   that those filenames encompass.  If I am asking for wantnymd or
;   wantnhms then I would like to reduce the list of filenames to
;   encompass that.  This only works for wantnymd at present.
    if(long(nymd[0]) gt 0 and keyword_set(wantnymd)) then begin
       if(n_elements(wantnymd) ne 1 and n_elements(wantnymd ne 2)) then begin
          rc = 8004
          return
       endif
       if(n_elements(wantnymd) eq 1) then begin
          nhms_want = 120000L
          if(keyword_set(wantnhms)) then nhms_want = wantnhms[0]
          jday_want = julday_nymd(wantnymd[0],nhms_want)
          jday      = julday_nymd(nymd,nhms)
          diff      = jday-jday_want
          a = where(abs(diff) eq min(abs(diff)))
          nymd = nymd[a]
          nhms = nhms[a]
          filename_ = filename_[a]
       endif else begin
          nhms_want = [120000L,120000L]
          if(keyword_set(wantnhms)) then nhms_want = wantnhms
          jday_want = julday_nymd(wantnymd,nhms_want)
          jday      = julday_nymd(nymd,nhms)
          diff      = jday - min(jday_want)
          a0 = where(abs(diff) eq min(abs(diff)))
          diff      = jday - max(jday_want)
          a1 = where(abs(diff) eq min(abs(diff)))
          nymd = nymd[a0:a1]
          nhms = nhms[a0:a1]
          filename_ = filename_[a0:a1]
      endelse
    endif
    nymd_sav = nymd
    nhms_sav = nhms
    nfile = n_elements(filename_)

;   Check the optional parameters
    if(keyword_set(wantlon)) then begin
     if(n_elements(wantlon) gt 2) then begin
      print, 'wantlon must have 1 or 2 elements; exit'
      stop
     endif
     if(n_elements(wantlon) eq 1) then wantlon = [wantlon,wantlon]
     if(wantlon[1] lt wantlon[0]) then wantlon = reverse(wantlon)
    endif

    if(keyword_set(wantlat)) then begin
     if(n_elements(wantlat) gt 2) then begin
      print, 'wantlat must have 1 or 2 elements; exit'
      stop
     endif
     if(n_elements(wantlat) eq 1) then wantlat = [wantlat,wantlat]
     if(wantlat[1] lt wantlat[0]) then wantlat = reverse(wantlat)
    endif

    if(keyword_set(wantlev)) then begin
     if(n_elements(wantlev) gt 1) then begin
      print, 'wantlev must have 1 element; exit'
      stop
     endif
    endif

;   Now possibly have multiple filenames to cope with, we
;   will stitch them together time sequentially
    defvar = -1
    for ifile = 0, nfile-1 do begin
     if(keyword_set(wantnymd)) then wantnymduse = wantnymd
     if(keyword_set(wantnhms)) then wantnhmsuse = wantnhms
     if(long(nymd_sav[ifile]) gt 0) then begin
      tdefnymd = nymd_sav[where(filename_ eq filename_[ifile])]
      tdefnhms = nhms_sav[where(filename_ eq filename_[ifile])]
      wantnymduse = nymd_sav[ifile]
      wantnhmsuse = nhms_sav[ifile]
     endif
     nc4readvar_, filename_[ifile], varlist, varval_, $
                  sum = sum, template=template, $
                  lon=lon, lat=lat, lev=lev, time=time_, $
                  nymd=nymd_, nhms=nhms_, $
                  tdefnymd=tdefnymd, tdefnhms=tdefnhms, $
                  wantlon=wantlon, wantlat=wantlat, wantlev = wantlev, $
                  wantnymd=wantnymduse, wantnhms=wantnhmsuse, $
                  rc = rc

;    variable comes out in form (nx,nt,ny,nz,nvar)

     if(rc eq 0) then begin
      if(defvar lt 0) then begin
       time   = time_
       nymd   = nymd_
       nhms   = nhms_
       if(varlist[0] ne '') then varval = varval_
       defvar = 1
      endif else begin
       time   = [time,time_]
       nymd   = [nymd,nymd_]
       nhms   = [nhms,nhms_]
       if(varlist[0] ne '') then varval = [varval,varval_]
      endelse
     endif else begin
      return
     endelse
    endfor


;   reform and return as (nx,ny,nz,nt,nvar)
    if(varlist[0] ne '') then begin
     nx = n_elements(lon)
     ny = n_elements(lat)
     nz = n_elements(lev)
     nvar = n_elements(varlist)
     if(keyword_set(sum)) then nvar = 1
     nz = max([n_elements(lev),1])
     nt = max([n_elements(time),1])
     varval = reform(varval,nx,nt,ny,nz,nvar)
     varval = transpose(varval,[0,2,3,1,4])

 ;   Discard extra dimensions
     varval = reform(varval)
    endif


end
