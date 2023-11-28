; Colarco
; Open and read the OMAERUV used height climatologies

  openr, lun, 'Zaer_clm.dat', /f77, /get
  data = fltarr(12,360,180)
  readu, lun, data
  free_lun, lun

  openr, lun, 'Zaer_caliopclm.dat', /f77, /get
  data_caliop = fltarr(12,360,180)
  readu, lun, data_caliop
  free_lun, lun

; Where data_caliop is undefined used data from GOCART
  a = where(data_caliop lt -990.)
  data_caliop[a] = data[a]

  lon =  (findgen(360)-179.5)
  lat =  (findgen(180)-89.5)

  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = 1.
  dy = 1.

; Now let's write out a series of files
  mon = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
  for i = 0, 11 do begin
   fileout = 'height.'+strpad(i+1,10)+'.nc'
   cdfid = ncdf_create(fileout, /clobber)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    idHgt       = NCDF_VARDEF(cdfid,'height',[idLon,idLat], /float)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idDate, i+1
    ncdf_varput, cdfid, idHgt, reform(data_caliop[i,*,*])
   ncdf_close, cdfid

; Make a control file and process
   fileout_ = 'height.'+strpad(i+1,10)+'.ctl'
   openw, lun, fileout_, /get_lun
   printf, lun, 'dset ^'+fileout
   printf, lun, 'undef 1e15'
   printf, lun, 'xdef lon '+string(nx)+' linear -179.5 '+string(dx)
   printf, lun, 'ydef lat '+string(ny)+' linear -89.5 '+string(dy)
   printf, lun, 'tdef time 1 linear 12z15'+mon[i]+'2007 24hr'
   free_lun, lun

   fileout2 = 'height.2007'+strpad(i+1,10)
   cmd = 'lats4d.sh -v -i '+fileout_+' -o '+fileout2+' -ftype xdf -geos1x125a'
   spawn, cmd, /sh

  endfor


end


