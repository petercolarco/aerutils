  pro write_var,  outPath, filehead, nx, ny, dx, dy, date, $
                  lon, lat, var, varname, resolution=resolution, $
                  h4zip=h4zip, shave=shave, regrid=regrid

;  Random seed for the output filename (supports multiple instances in one directory)
   rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

;  date = yyyymmddhh string
   date = stringit(date)
   yyyy = strmid(date,0,4)
   mm   = strmid(date,4,2)
   dd   = strmid(date,6,2)
   hh   = strmid(date,8,2)
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
   latstimestr = ' -time '+dstr+' '+dstr

;  AOT Ocean
   fileout = 'aot.'+rnum+'.nc'
   cdfid = ncdf_create(fileout, /clobber)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    idAot       = NCDF_VARDEF(cdfid,varname,[idLon,idLat,idTime], /float)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idDate, 1L
    ncdf_varput, cdfid, idAot, var
   ncdf_close, cdfid
   fileout_ = 'aot.'+rnum+'.ctl'

   openw, lun, fileout_, /get_lun
   printf, lun, 'dset ^'+fileout
   printf, lun, 'undef 1e15'
   printf, lun, 'xdef lon '+string(nx)+' linear -180 '+string(dx)
   printf, lun, 'ydef lat '+string(ny)+' linear -90 '+string(dy)
   printf, lun, 'tdef time '+string(1)+' linear '+dstr+' 1hr'
   free_lun, lun

;  Process and store file

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

   lonstr = lonstr+'a'

   cmd = 'lats4d.sh -format netcdf4 -v -i '+fileOut_+' -o test.'+rnum+' -ftype xdf'+lonstr+latstimestr
   spawn, cmd
   datestr = yyyy+mm+dd+'_'+hh+'00z'
   spawn, '/bin/mv -f test.'+rnum+'.nc4 '+outPath+'/'+filehead+'.'+datestr+'.nc4'
   if(not keyword_set(save)) then spawn, 'rm -f '+fileOut+' '+fileOut_

end
