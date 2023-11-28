; Fairly generic reader that takes a grads template and requested date
; and constructs the actual filename for direct read.
; Also, checks the levels array order and if oriented wrong (i.e.,
; if the first level on the file is the surface) swaps order for
; consistency with GEOS-5.

  pro nc4readvar_, filename, varlist, varval, $
                   sum = sum, template=template, $
                   lon=lon, lat=lat, lev=lev, time=time, $
                   nymd=nymd, nhms=nhms, $
                   tdefnymd=tdefnymd, tdefnhms=tdefnhms, $
                   wantlon=wantlon, wantlat=wantlat, wantlev = wantlev, $
                   wantnymd=wantnymd, wantnhms=wantnhms, $
                   rc = rc

!quiet = 1d
    rc = 0

;   Open the filename
    cdfid = -1
    on_ioerror, getout
    cdfid = ncdf_open(filename)
getout:
    if(cdfid lt 0) then begin
     rc = 4
     return
    endif

;    Get the horizontal dimensions
     id = ncdf_varid(cdfid,'lon')
     if(id ne -1) then begin
      varinq = ncdf_varinq(cdfid,'lon')
     endif else begin
      id = ncdf_varid(cdfid,'longitude')
      varinq = ncdf_varinq(cdfid,'longitude')
     endelse
     ncdf_varget, cdfid, id, lon
     xdim = varinq.dim[0]

     id = ncdf_varid(cdfid,'lat')
     if(id ne -1) then begin
      varinq = ncdf_varinq(cdfid,'lat')
     endif else begin
      id = ncdf_varid(cdfid,'latitude')
      varinq = ncdf_varinq(cdfid,'latitude')
     endelse
     ncdf_varget, cdfid, id, lat
     ydim = varinq.dim[0]

;    If wantlon or wantlat are requested, then find the
;    the offsets in the provided file
     offset = [0,0]
     if(keyword_set(wantlon)) then begin
      a = where(lon ge wantlon[0] and lon le wantlon[1]) 
      if(a[0] eq -1 and (wantlon[0] eq wantlon[1])) then begin
       lon1 = min(lon[where(lon ge wantlon[0])])
       lon2 = max(lon[where(lon le wantlon[0])])
       del1 = abs(lon1 - wantlon[0])
       del2 = abs(wantlon[0] - lon2)
       if(del1 le del2) then a = where(lon eq lon1) else $
                             a = where(lon eq lon2)
      endif
      if(a[0] eq -1) then begin
       print, 'nc4readvar_: Error in wantlon and lon combination; exit'
       stop
      endif
      offset[0] = a[0]
      lon = lon[a]
     endif

     if(keyword_set(wantlat)) then begin
      a = where(lat ge wantlat[0] and lat le wantlat[1])
      if(a[0] eq -1 and (wantlat[0] eq wantlat[1])) then begin
       lat1 = min(lat[where(lat ge wantlat[0])])
       lat2 = max(lat[where(lat le wantlat[0])])
       del1 = abs(lat1 - wantlat[0])
       del2 = abs(wantlat[0] - lat2)
       if(del1 le del2) then a = where(lat eq lat1) else $
                             a = where(lat eq lat2)
      endif
      if(a[0] eq -1) then begin
       print, 'nc4readvar_: Error in wantlat and lat combination; exit'
       stop
      endif
      offset[1] = a[0]
      lat = lat[a]
     endif
     nx = n_elements(lon)
     ny = n_elements(lat)
     count  = [nx,ny]

;    Get the levels
;    If wantlev is specified assume we're only asking for
;    a single level on output.  In this case we don't reverse.
     ilev = 0
     lev = 0.
     do_reverse = 0
     nz = 0
     zdim = -1
     id = ncdf_varid(cdfid,'lev')
     if(id ne -1) then varinq = ncdf_varinq(cdfid,'lev')
     if(id eq -1) then begin
      id = ncdf_varid(cdfid,'levels')
      if(id ne -1) then varinq = ncdf_varinq(cdfid,'levels')
     endif
     if(id ne -1) then begin
;     file has levels (may only be one)
      zdim = varinq.dim[0]
      ncdf_varget, cdfid, id, levels

;     If a specific level is requested
      if(keyword_set(wantlev)) then begin
;      Find level closest to requested
       diff = abs(levels-wantlev[0])
       result = min(diff,ilev)
       if(ilev[0] eq -1) then begin
        print, 'Requested level not found; exit'
        stop
       endif
       if(wantlev[0] gt max(levels) or wantlev[0] lt min(levels)) then $
        print, 'wantlev out of bounds of data, taking an edge value'
       levels = levels[ilev]
      endif

;     Levels that are left over at this point; may need reversing
      nz = n_elements(levels)
      if(levels[0] gt levels[nz-1]) then do_reverse=1
      lev = levels
      if(do_reverse) then lev = reverse(lev)

     endif

;    Time seems to be the tricky bit here.  Here's why: Until I
;    check the file I don't know how many times are in an
;    individual file.  So you could have the situation of a single
;    file for a year but that contains 12 months of data.  Then you
;    need to parse the file and assign the correct month to the date
;    actually being sought by, e.g., the file template.  So
;    here's the possibilities.
;     - if no grads template then use times in file and check for
;       nearest neighbor(s) to any requested time, else return all
;       times in file
;     - if a grads template was used then you have access to
;       tdefnymd and tdefnhms which override the times in the
;       file and specify the first nt times to play with.

     if(keyword_set(tdefnymd)) then begin
      nymd = tdefnymd
      nhms = tdefnhms
      nt   = n_elements(nymd)
      time = strpad(nymd,10000000L)+'_'+strpad(nhms,100000L)
     endif else begin
      nc4time, filename, time, nymd, nhms, cdfid=cdfid
      nt = n_elements(time)
     endelse
;    Get the selected times, nymd for now
     if(keyword_set(wantnymd)) then begin
      a = -1
      if(n_elements(wantnymd eq 1)) then begin
         nhms_want = 120000L
         if(keyword_set(wantnhms)) then nhms_want = wantnhms[0]
         jday_want = julday_nymd(wantnymd[0],nhms_want)
         jday      = julday_nymd(nymd,nhms)
         diff      = jday-jday_want
         a = where(abs(diff) eq min(abs(diff)))
      endif else begin
         nhms_want = [120000L,120000L]
         if(keyword_set(wantnhms)) then nhms_want = wantnhms
         jday_want = julday_nymd(wantnymd,nhms_want)
         jday      = julday_nymd(nymd,nhms)
         diff      = jday - min(jday_want)
         a0 = where(abs(diff) eq min(abs(diff)))
         diff      = jday - max(jday_want)
         a1 = where(abs(diff) eq min(abs(diff)))
         a  = where(nymd ge nymd[a0] and nymd le nymd[a1]) 
      endelse
      if(a[0] eq -1) then begin
       rc = 2
stop
       ncdf_close, cdfid
       return
      endif
      itime = a[0]
      nt = n_elements(a)
      time   = time[a]
      nymd   = nymd[a]
      nhms   = nhms[a]
     endif else begin
      if(nt gt 0) then begin
       itime = 0
      endif
     endelse

;    At this point you've read the dimensions of the file
;    and reduced them to any range specified by wantlon,
;    wantlat, wantlev, wantnymd, and wantnhms
;    If all you wanted was this information (varlist is
;    empty) then exit
     if(varlist[0] eq '') then begin
      ncdf_close, cdfid
      varval = 1.e15
      return
     endif

;    A variable is requested, so compare the requested
;    variable names to those actually in the file

;    Get the variable names in the file
     filestruct = ncdf_inquire(cdfid)
     fvars = filestruct.nvars

;    Compare to variables requested
;    varlist is the requested variables
;    This could be a template, e.g., duem for all
;    duemXXX bins, so we construct a local array
;    varlist_ that is the actual variables from the
;    file to satisfy the request.
     icnt = 0
     for ivar = 0, n_elements(varlist)-1 do begin
      rc = 999
      len = strlen(varlist[ivar])

      for fvar = 0, fvars-1 do begin
       varinq = ncdf_varinq(cdfid,fvar)
       varn = strlowcase(varinq.name)

;      If an exact match is found select that variable
       if(varn eq strlowcase(varlist[ivar])) then begin
        if(icnt eq 0) then varlist_ = varinq.name
        if(icnt gt 0) then varlist_ = [varlist_,varinq.name]
        icnt = icnt+1
        rc = 0
       endif else begin
;      An exact match wasn't found, so check if templating is
;      successful.  This will pick up all variables in the file that
;      match the template
        if(keyword_set(template)) then begin
         vlen = strlen(varn)
         if(vlen lt len) then continue
         if(strmid(varn,0,len) eq strlowcase(varlist[ivar])) then begin
          if(icnt eq 0) then varlist_ = varinq.name
          if(icnt gt 0) then varlist_ = [varlist_,varinq.name]
          icnt = icnt+1
          rc = 0 
         endif
        endif
       endelse
      endfor
      if(rc ne 0) then begin
       print, 'nc4readvar_: problem getting requested variable ', varlist[ivar]
       return
      endif
     endfor

;    Determine offset and count for time and levels
;    Possibly the requested variable is a 2-d variable in an otherwise
;    3-d file; need to account for that.
     varinq = ncdf_varinq(cdfid,varlist_[0])
     dims   = varinq.dim
     if(zdim ne -1) then begin
      a = where(dims eq zdim)
      if(a[0] eq -1) then nz = 0
;     Give a default level value
      if(a[0] eq -1) then lev = 1000.
     endif

     if(nz gt 0) then begin
      offset = [offset,ilev]
      count  = [count,nz]
     endif

     if(nt gt 0) then begin
      offset = [offset,itime]
      count  = [count,nt]
     endif

;    Now read the variable
     nvar = n_elements(varlist_)
     for ivar = 0, nvar-1 do begin
      id = ncdf_varid(cdfid,varlist_[ivar])
      if(id eq -1) then begin
       rc = 1
       ncdf_close, cdfid
       return
      endif

      ncdf_varget, cdfid, id, varval_, offset=offset, count=count
      sarr = size(varval_)

      if(nz ge 0 and do_reverse) then varval_ = reverse(varval_,3,/overwrite)
      if(ivar eq 0) then varval = varval_
      if(ivar gt 0) then begin
       if(keyword_set(sum)) then begin
        varval = varval + varval_
       endif else begin
        varval = [varval, varval_]
       endelse
      endif
     endfor

    ncdf_close, cdfid

;   Variable at this point is (nx*nvar,ny,nz,nt)
;   Reform and return as (nx*nt,ny,nz,nvar)
    if(keyword_set(sum)) then nvar = 1
    if(not(keyword_set(sum))) then varlist = varlist_
    nz = max([nz,1])
    nt = max([nt,1])
    varval = reform(varval,nx,nvar,ny,nz,nt)
    varval = transpose(varval,[0,4,2,3,1])
    varval = reform(varval,nx*nt,ny,nz,nvar)

end
