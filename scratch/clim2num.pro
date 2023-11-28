; Read in the aerosol climatology of mass mixing ratio
; apply scaling factors to convert to number per kg of air

  varname = ['du001','du002','du003','du004','du005', $
             'ss001','ss002','ss003','ss004','ss005', $
             'SO4','BCphobic','BCphilic','OCphobic','OCphilic']
  scalefac = [1.27e15,0.,0.,0.,0., $
              2.66e17,1.03e16,7.32e13,0.,0.,$
              9.05e16,1.68e19,1.68e19,1.01e18,1.01e18]

  clmfile = ['200201','200202','200203','200204','200205','200206',$
             '200207','200208','200209','200210','200211','200212']

  nfile = n_elements(clmfile)
  nvar = n_elements(varname)
  for iv = 0, nvar-1 do begin
   print, varname[iv],scalefac[iv]
  endfor


; Loop over the files
  for ifile = 0, nfile-1 do begin
   infile = 'gfedv2.aero.eta.'+clmfile[ifile]+'clm.hdf'
   ofile  = 'gfedv2.aero_num.eta.'+clmfile[ifile]+'clm.hdf'
   ga_getvar, infile, '', /noprint, lon=lon, lat=lat, lev=lev, time=time
   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)

   cdfid = ncdf_create('tmp.nc', /clobber)
    idx  = ncdf_dimdef(cdfid,'lon',nx)
    idy  = ncdf_dimdef(cdfid,'lat',ny)
    idz  = ncdf_dimdef(cdfid,'lev',nz)
    idt  = ncdf_dimdef(cdfid,'time',1)
    idLon  = ncdf_vardef(cdfid,'longitude',[idx])
    idLat  = ncdf_vardef(cdfid,'latitude',[idy])
    idLev  = ncdf_vardef(cdfid,'level',[idz])
    idTime = ncdf_vardef(cdfid,'time',[idt],/long)
   idvar = lonarr(nvar)
   for iv = 0, nvar-1 do begin
    idvar[iv] = ncdf_vardef(cdfid, varname[iv], [idx,idy,idz,idt])
   endfor
   ncdf_control, cdfid, /endef
   ncdf_varput, cdfid, idLon, lon
   ncdf_varput, cdfid, idLat, lat
   ncdf_varput, cdfid, idLev, lev
   ncdf_varput, cdfid, idTime, time

;   for iv = 0, nvar-1 do begin
   for iv = 0, nvar-1 do begin
print, iv
    if(scalefac[iv] ne 0) then begin
     ga_getvar, infile, varname[iv], var
     var = var*scalefac[iv]
    endif else begin
     var = make_array(nx,ny,nz,1,val=0.)
    endelse
    ncdf_varput, cdfid, idvar[iv], var
   endfor
   ncdf_close, cdfid

;  Now run through lats4d to make grads readable file
   dstr = gradsdate(time)
   openw, lun, 'tmp.ddf', /get_lun
   printf, lun, 'dset ^tmp.nc'
   printf, lun, 'undef 1e15'
   printf, lun, 'xdef lon '+string(nx)+' linear 0 '+string(360./nx)
   printf, lun, 'ydef lat '+string(ny)+' linear -90 '+string(180./(ny-1))
   printf, lun, 'zdef lev '+string(nz)+' levels '+string(lev[0:7],format='(8(1e10.3,1x))')
   for iz = 1,8 do begin
    printf, lun, string(lev[8*iz:8*iz+7],format='(8(1e10.3,1x))')
   endfor
   printf, lun, 'tdef time 1 linear '+dstr+' 6hr'
   printf, lun, 'vars '+string(nvar)
   for iv = 0, nvar-1 do begin
    printf, lun, varname[iv]+'=>'+strlowcase(varname[iv])+' '+string(nz)+' 99 '+varname[iv]
   endfor
   printf, lun, 'endvars'
   free_lun, lun

   cmd = 'lats4d -i tmp.ddf -o out -ftype xdf'
   spawn, cmd
   cmd = '\mv -f out.nc '+ofile
   spawn, cmd

  endfor

end
