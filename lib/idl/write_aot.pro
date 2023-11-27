  pro write_aot, outPath, filehead, nx, ny, dx, dy, nt, nlev, date, $
                 lon, lat, lev, aot, save=save, geos4=geos4, $
                 synopticoffset=synopticoffset, resolution=resolution, $
                 h4zip=h4zip, shave=shave, regrid=regrid

;  Random seed for the output filename (supports multiple instances in one directory)
   rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

   date = stringit(date)
   yyyy = strmid(date,0,4)
   mm   = strmid(date,4,2)
   dd   = strmid(date,6,2)
   monstr = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
;  Synoptic offset from 0Z in minutes of base time for day
   if(not(keyword_set(synopticoffset))) then synopticoffset = 0
   offhr = fix(synopticoffset/60)
   offmn = synopticoffset-offhr*60
   offhr = strcompress(string(offhr),/rem)
   offmn = strcompress(string(offmn),/rem)
   if(offmn lt 10) then offmn = '0'+offmn
   hstr = offhr+':'+offmn+'z'
   dstr = hstr+dd+monstr[fix(mm)-1]+yyyy
;  Set time for end of day
   offhr = strcompress(string(24-(24/nt)+fix(offhr)),/rem)
   hstr = offhr+':'+offmn+'z'
   dstrf = hstr+dd+monstr[fix(mm)-1]+yyyy
   latstimestr = ' -time '+dstr+' '+dstrf

;  AOT Ocean
   fileout = 'aot.'+rnum+'.nc'
   cdfid = ncdf_create(fileout, /clobber)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idlambdaO = NCDF_DIMDEF(cdfid,'lev', nlev)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idLambdaOcean  = NCDF_VARDEF(cdfid,'lev',[idLambdaO], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    idAotOcean      = NCDF_VARDEF(cdfid,'aodtau',[idLon,idLat,idLambdaO,idTime], /float)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idDate, lindgen(nt)*(24/nt*60)
    ncdf_varput, cdfid, idLambdaOcean, lev
    ncdf_varput, cdfid, idAotOcean, aot
   ncdf_close, cdfid
   fileout_ = 'aot.'+rnum+'.ctl'
   levStr = ''
   for iband = 0, nlev-1 do begin
    levStr = levStr+string(lev[iband])+' '
   endfor
   openw, lun, fileout_, /get_lun
   printf, lun, 'dset ^'+fileout
   printf, lun, 'undef 1e15'
   printf, lun, 'xdef lon '+string(nx)+' linear -180 '+string(dx)
   printf, lun, 'ydef lat '+string(ny)+' linear -90 '+string(dy)
   printf, lun, 'zdef lev '+string(nlev)+' levels '+levStr
   printf, lun, 'tdef time '+string(nt)+' linear '+dstr+' '+string(24/nt)+'hr'
;   printf, lun, 'vars 1'
;   printf, lun, 'aodtau '+string(nlev)+' 99 Aerosol Optical Thickness'
;   printf, lun, 'endvars'
   free_lun, lun

;  Process and store file
   spawn, '/bin/mkdir -p '+outPath+'Y'+yyyy+'/M'+mm+'/'

   lonstr = ' -lon -180 '+strcompress(string(max(lon)),/rem)
   lonstr = ''

   if(keyword_set(geos4)) then begin
    lonstr = ' -lon 0 '+strcompress(string(max(lon+180.)),/rem)
   endif

;  Override the gridding for specified resolution
   if(keyword_set(resolution)) then begin
    if(keyword_set(geos4)) then begin
     case resolution of
      'a': lonstr=' -fv4x5'
      'b': lonstr=' -fv2x25'
      'c': lonstr=' -fv1x125'
     else: begin
           print, 'unallowed resolution for geos4 flag; exit'
           stop
           end
     endcase
    endif else begin
     case resolution of
      'a': lonstr=' -geos4x5'
      'b': lonstr=' -geos2x25'
      'c': lonstr=' -geos1x125'
      'd': lonstr=' -geos0.5'
      'e': lonstr=' -geos0.25'
    'ten': lonstr=' -geos10x10'
     else: begin
           print, 'unallowed resolution for geos5; exit'
           stop
           end
     endcase
    endelse
;   Check for the requested regrid style
;   regrid is one of either "" (linear interpolation), "a" (box average),
;   "s" (bessel), or "v" (vote)
    if(not(keyword_set(regrid))) then begin
     lonstr = lonstr+'a '
    endif else begin
     lonstr = lonstr + regrid+' '
    endelse
   endif

   if(keyword_set(h4zip) or keyword_set(shave)) then begin
    shavestr = ' -shave '
   endif else begin
    shavestr = ' '
   endelse

; Override the resolution/regridding stuff
lonstr = ' '

   cmd = 'lats4d.sh -format netcdf4 -v -i '+fileOut_+' -o test.'+rnum+' -ftype xdf'+lonstr+latstimestr+shavestr
   spawn, cmd
   if(shavestr ne ' ') then begin
    cmd = 'chmod g+w,g+s test.'+rnum+'.nc4 '
    spawn, cmd
   endif
   spawn, '/bin/mv -f test.'+rnum+'.nc4 '+outPath+'Y'+yyyy+'/M'+mm+'/'+filehead+'.'+date+'.nc4'
   if(not keyword_set(save)) then spawn, 'rm -f '+fileOut+' '+fileOut_

end
