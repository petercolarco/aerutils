; Colarco
; This code mimics the functionality of the sample_month.pro procedure
; but is intended to be used to read and sample the satellite observations
; so the monthly means of the weighted satellite data can be generated
; consistently with how the model monthly means are done.

  pro sample_month_satellite, satId, satPath, expId, modPath, yyyy, mm, type, $
                    pixelweight=pixelweight, modelwantlev=modelwantlev, ifirst=ifirst, $
                    nx=nx, ny=ny, nv=nv, nz=nz, lon=lon, lat=lat, lev=lev, varlist=varlist, $
                    hourly=hourly, qawt=qawt

  if(not(keyword_set(modelwantlev))) then modelwantlev = ['-9999']
  if(not(keyword_set(ifirst))) then ifirst = 1
  if(not(keyword_set(pixelweight))) then pixelweight=0
  if(not(keyword_set(hourly))) then hourly=0

; Change meaning of qawt flag
;  qawt = 0 (or not set) and no qa-weighting is done
;  qawt = 1 and you use only qawt=3 values
;  qawt > 1 and you do Level-3 style qa-weighting
  qawtstr = 'noqawt'
  qaflstr = 'noqafl'
  if(keyword_set(qawt)) then begin
   case qawt of
    0: begin
       qawtstr = 'noqawt'
       qaflstr = 'noqafl'
       end
    1: begin
       qawtstr = 'qawt3'
       qaflstr = 'qafl3'
       end
    else: begin
       qawtstr = 'qawt'
       qaflstr = 'qafl'
       end
   endcase
  endif


  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', $
         'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
  ndays = [31,28,31,30,31,30,31,31,30,31,30,31]


  nd = ndays[fix(mm)-1]
; Fix leap year; not general
  if( (fix(yyyy)/4 eq float(yyyy)/4.) and mm eq '02') then nd = 29

; Random seed for the output filename (supports multiple instances in one directory)
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

; make a sample ddf file for the satellite and model
  satddf = 'sat.'+rnum+'.ddf'
  satqaddf = 'satqa.'+rnum+'.ddf'
  modddf = 'mod.'+rnum+'.ddf'
  modnc  = 'modtau.'+rnum+'.nc'
  testnc = 'test.'+rnum
  latsddf= 'lats4d.'+rnum+'.ddf'
; check on hourly
  if(hourly) then begin
   ntd = 24
   incstr = ' 1hr'
  endif else begin
   ntd = 4
   incstr = ' 6hr'
  endelse

  openw, lun, satddf, /get_lun
  printf, lun, $
   'dset '+satpath+'Y%y4/M%m2/'+satid+'_L2.aero_'+type+'.'+qawtstr+'.%y4%m2%d2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+string(nd*ntd)+' linear 0z01'+mon[fix(mm)-1]+yyyy+incstr
  free_lun, lun

  openw, lun, satqaddf, /get_lun
  printf, lun, $
   'dset '+satpath+'Y%y4/M%m2/'+satid+'_L2.aero_'+type+'.'+qaflstr+'.%y4%m2%d2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+string(nd*ntd)+' linear 0z01'+mon[fix(mm)-1]+yyyy+incstr
  free_lun, lun

; read from tau2d
  openw, lun, modddf, /get_lun
  printf, lun, $
   'dset '+modpath+'Y%y4/M%m2/'+satid+'_L2.aero_'+type+'.'+qawtstr+'.%y4%m2%d2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+string(nd*ntd)+' linear 0z01'+mon[fix(mm)-1]+yyyy+incstr
  free_lun, lun

; On first time through, check the grids and get varlist
  if(ifirst) then begin

;   Get the satellite grid to check nx,ny
    ga_getvar, satddf, '', varout, lon=lon, lat=lat, /noprint
    nx = n_elements(lon)
    ny = n_elements(lat)
;   Check to see if need to shift the satellite
    a = where(lon lt 0)
    xshift = 0
    if(a[0] ne -1) then xshift = n_elements(a)

    ga_getvar, modddf, '', varout, varlist=varlist, lon=lon, lat=lat, lev=lev, $
     /noprint, wantlev=modelwantlev
    nv = n_elements(varlist)
    nz = n_elements(lev)
    if(n_elements(lon) ne nx or n_elements(lat) ne ny) then begin
     print, 'check that satddf and modddf are on same grid; stop'
     stop
    endif

    ifirst = 0
  endif

; Now get the satellite data
  print, 'Getting satellite data on: ', yyyy, mm
  print, '...getting tau'
  ga_getvar, satddf, 'aodtau', sattau, wantlev=['550'], /save, ofile='tmp.nc'
  sattau = reform(sattau)
  sattau = shift(sattau,xshift,0,0)
  a = where(sattau gt 1e14)
  if(a[0] ne -1) then sattau[a] = !values.f_nan

  print, '...getting qaflags'
  ga_getvar, satqaddf, 'qasum', satqawt, wantlev=['550'], /save, ofile='tmp.nc'
  satqawt = reform(satqawt)
  satqawt = shift(satqawt,xshift,0,0)
  a = where(satqawt gt 1e14)
  if(a[0] ne -1) then satqawt[a] = !values.f_nan
  satqawttot = total(reform(satqawt,nx*ny,nd*ntd),2,/nan)
  a = where(satqawttot eq 0.)
  if(a[0] ne -1) then satqawttot[a] = !values.f_nan

  if(pixelweight) then begin
   print, '...getting num'
   ga_getvar, satqaddf, 'num', satnum, wantlev=['550'], /save, ofile='tmp.nc'
   satnum = reform(satnum)
   satnum = shift(satnum,xshift,0,0)
   a = where(satnum gt 1e14)
   if(a[0] ne -1) then satnum[a] = !values.f_nan
   satnumtot = total(reform(satqawt*satnum,nx*ny,nd*ntd),2,/nan)
   a = where(satnumtot eq 0.)
   if(a[0] ne -1) then satnumtot[a] = !values.f_nan
  endif

  sattau = reform(sattau,nx*ny*nd*ntd)
  satqawt = reform(satqawt,nx*ny*nd*ntd)
  if(pixelweight) then satnum = reform(satnum,nx*ny*nd*ntd)
 
; Create the template for the output file
  idvar = lonarr(nv)
  filetag = qawtstr
  if(pixelweight) then filetag = filetag+'_pw'
  filetag = filetag + '.'
  
  fileout = modpath+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2.aero_'+type+'.'+filetag+yyyy+mm+'.hdf'
  cdfid = ncdf_create(modnc,/clobber)
    idLon       = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat       = NCDF_DIMDEF(cdfid,'lat',ny)
    idlambdaO   = NCDF_DIMDEF(cdfid,'lev', nz)
    idTime      = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idLambda    = NCDF_VARDEF(cdfid,'lev',[idLambdaO], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    for iv = 0, nv-1 do begin
     idvar[iv] = NCDF_VARDEF(cdfid,varlist[iv],[idLon,idLat,idLambdaO,idTime], /float)
    endfor
    ncdf_attput, cdfid, /global, "Conventions", "COARDS"
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idLambda, lev
    ncdf_varput, cdfid, idDate, long(yyyy)*1000L+long(mm)*100L+15L


; Do the model

; Loop over model file variables
  for iv = 0, nv-1 do begin

   print, 'Getting model variable '+varlist[iv]+' # ' $
    +strcompress(string(iv+1),/rem)+'/'+strcompress(string(nv),/rem)+' on: ', yyyy, mm

;  Some variables we don't care about; ignore these
   if(varlist[iv] ne 'delp' and varlist[iv] ne 'rh' and $
      varlist[iv] ne 'q') then begin

;    Read data a single variable at a time
;    Only bother to do the read and aggregatation if the satellite has data
     a = where(finite(sattau) eq 1)
     b = where(finite(sattau) eq 0)
     if(a[0] ne -1) then begin
      ga_getvar, modddf, varlist[iv], vartmp, wantlev=modelwantlev, $
       time=time, lon=lon, lat=lat, lev=lev, /save, ofile='tmp.nc'
      vartmp = reform(vartmp,nx,ny,nz,nd*ntd)
      vartmp = shift(vartmp,xshift,0,0,0)

;     Check on the resolutions
      if(n_elements(lon) ne nx or n_elements(lat) ne ny) then begin
       print, 'Your satellite and model datasets have different horizontal resolution; exit'
       stop
      endif
      vartmp = transpose(vartmp,[0,1,3,2])
      vartmp = reform(vartmp,nx*ny*nd*ntd,nz)
 
      for iz = 0, nz-1 do begin
       if(not pixelweight) then begin
        vartmp[a,iz] = vartmp[a,iz]*satqawt[a]
       endif else begin
        vartmp[a,iz] = vartmp[a,iz]*satqawt[a]*satnum[a]
       endelse
       if(b[0] ne -1) then vartmp[b,iz] = !values.f_nan
      endfor
     endif else begin
;     otherwise, make vartmp full of undef
      vartmp = make_array(nx,ny,nd*ntd,nz, val=1.e15)
     endelse

;    And normalize
     vartmp = reform(vartmp,nx*ny,nd*ntd,nz)
     vartmp = total(vartmp,2,/nan)
     denom  = satqawttot
     if(pixelweight) then denom = satnumtot
     a = where(finite(denom) eq 1)
     b = where(finite(denom) eq 0)
     for iz = 0, nz-1 do begin
      if(a[0] ne -1) then vartmp[a,iz] = vartmp[a,iz]/denom[a]
      if(b[0] ne -1) then vartmp[b,iz] = 1.e15
     endfor

;    reform varout for output
     varout = reform(vartmp,nx,ny,nz)

;    Write out
     ncdf_varput, cdfid, idvar[iv], varout

   endif

  endfor
      
  ncdf_close, cdfid

; lats4d it so it's grads readable
  dstr = '12z15'+mon[fix(mm)-1]+yyyy
  openw, lun, latsddf, /get_lun
  printf, lun, 'dset ^'+modnc
  printf, lun, 'undef 1e15'
  printf, lun, 'xdef lon '+string(nx)+' linear 0 '+string(360./nx)
  printf, lun, 'ydef lat '+string(ny)+' linear -90 '+string(180./(ny-1))
  printf, lun, 'zdef lev '+string(nz)+' levels '+string(lev,format='(8(1e10.3,1x))')
  printf, lun, 'tdef time 1 linear '+dstr+' 1mo'
  printf, lun, 'vars '+string(nv)
  for iv = 0, nv-1 do begin
  printf, lun, varlist[iv]+' '+string(nz)+' 99 '+varlist[iv]
  endfor
  printf, lun, 'endvars'
  free_lun, lun

  cmd = 'lats4d -i '+latsddf+' -o '+testnc+' -ftype xdf'
  spawn, cmd

; Cleanup
  cmd = 'mv -f '+testnc+'.nc '+fileout
  spawn, cmd
  cmd = 'rm -f '+satddf+' '+satqaddf+' '+modddf+' '+latsddf+' '+modnc+' tmp.nc'
  spawn, cmd


end
