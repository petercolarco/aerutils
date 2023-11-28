; Colarco, July 2018

; Read in the Catchment and PFT (mapped) definitions and grid those up
; to a map
  print, 'getting catchment tile locations'
  read_cdef, ntile, lnmax, lnmin, ltmax, ltmin

  print, 'getting mapped PFTs'
  read_vegtype, ntilepft, ftrop, fxtrop, fgrass

; Create an output grid that matches the actual catchment file grid
  nx = 720
  ny = 287
  lon = -179.75 + 0.5*findgen(nx)
  lat = -59.25 + 0.5*findgen(ny)

  gtrop  = fltarr(nx,ny)
  gxtrop = fltarr(nx,ny)
  ggrass = fltarr(nx,ny)

  for i = 0L, n_elements(ntile)-1 do begin
   ii = where(lon gt lnmin[i] and lon lt lnmax[i])
   jj = where(lat gt ltmin[i] and lat lt ltmax[i])
   if(ii[0] lt 0 or jj[0] lt 0) then continue
   gtrop[ii,jj]  = gtrop[ii,jj]+ftrop[i]
   gxtrop[ii,jj] = gxtrop[ii,jj]+fxtrop[i]
   ggrass[ii,jj] = ggrass[ii,jj]+fgrass[i]
  endfor

; Dump to netcdf files
  cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/pft_trop.nc',/clobber)
  idx = ncdf_dimdef(cdfid,'longitude',nx)
  idy = ncdf_dimdef(cdfid,'latitude', ny)
  idv = ncdf_vardef(cdfid,'frac',[idx,idy])
  idlon = ncdf_vardef(cdfid, 'longitude', [idx])
  idlat = ncdf_vardef(cdfid, 'latitude', [idy])
  ncdf_control,cdfid,/endef
  ncdf_varput, cdfid, idv, gtrop
  ncdf_varput, cdfid, idlon, lon
  ncdf_varput, cdfid, idlat, lat
  ncdf_close, cdfid

; Dump to netcdf files
  cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/pft_xtrop.nc',/clobber)
  idx = ncdf_dimdef(cdfid,'longitude',nx)
  idy = ncdf_dimdef(cdfid,'latitude', ny)
  idv = ncdf_vardef(cdfid,'frac',[idx,idy])
  idlon = ncdf_vardef(cdfid, 'longitude', [idx])
  idlat = ncdf_vardef(cdfid, 'latitude', [idy])
  ncdf_control,cdfid,/endef
  ncdf_varput, cdfid, idv, gxtrop
  ncdf_varput, cdfid, idlon, lon
  ncdf_varput, cdfid, idlat, lat
  ncdf_close, cdfid

; Dump to netcdf files
  cdfid = ncdf_create('/home/colarco/projects/MAP16_BB/pft_grass.nc',/clobber)
  idx = ncdf_dimdef(cdfid,'longitude',nx)
  idy = ncdf_dimdef(cdfid,'latitude', ny)
  idv = ncdf_vardef(cdfid,'frac',[idx,idy])
  idlon = ncdf_vardef(cdfid, 'longitude', [idx])
  idlat = ncdf_vardef(cdfid, 'latitude', [idy])
  ncdf_control,cdfid,/endef
  ncdf_varput, cdfid, idv, ggrass
  ncdf_varput, cdfid, idlon, lon
  ncdf_varput, cdfid, idlat, lat
  ncdf_close, cdfid



end
