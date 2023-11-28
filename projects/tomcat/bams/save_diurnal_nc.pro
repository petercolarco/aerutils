  pro save_diurnal_nc, head, nx, ny, nt, lon, lat, var, varname, nn

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]


  fileout = head+'.nc'
  cdfid = ncdf_create(fileout,/clobber)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    idVar       = NCDF_VARDEF(cdfid,varname,[idLon,idLat,idTime],/float)
    idNum       = NCDF_VARDEF(cdfid,'num',[idLon,idLat,idTime],/float)
    ncdf_control,cdfid,/endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idDate, lindgen(nt)
    ncdf_varput, cdfid, idVar, var
    ncdf_varput, cdfid, idNum, nn
  ncdf_close, cdfid

; Make a grads compatible file
  nx = string(n_elements(lon),format='(i4)')
  ny = string(n_elements(lat),format='(i4)')
  dx = string(lon[1]-lon[0],format='(f7.5)')
  dy = string(lat[1]-lat[0],format='(f7.5)')
  openw, lun, 'tmp.ddf', /get
  printf, lun, 'dset '+fileout
  printf, lun, 'xdef lon '+nx+' linear -180 '+dx
  printf, lun, 'ydef lat '+ny+' linear -90 '+dy
  printf, lun, 'tdef time 24 linear 0z5jun1971 1hr'
  free_lun, lun
  cmd = 'lats4d.sh -i tmp.ddf -o '+head+' -ftype xdf -shave'
  spawn, cmd
  spawn, 'rm -f tmp.ddf'
  spawn, 'rm -f '+fileout


end
