; Goal is to lift whole plume by some delta-z and plot/overwrite file

  dates = ['20070904_00', '20070904_03', '20070904_06', $
           '20070904_09', '20070904_12', '20070904_15', $
           '20070904_18', '20070904_21', '20070905_00']
  ndates = n_elements(dates)

  lift_alt = [1,2,3,4,5]
  lift_dir = 'lift_'+['1','2','3','4','5']+'km'
  nlift    = n_elements(lift_alt)

  for idates = ndates-1, ndates-1 do begin

  nymd = dates[idates]
  yyyy = strmid(nymd,0,4)
  mm   = strmid(nymd,4,2)
  filedir = '/misc/prc14/colarco/dR_F25b18/inst3d_aer_v/'
  filed   = 'Y'+yyyy+'/M'+mm+'/'
  filen   = 'dR_F25b18.inst3d_aer_v.'+nymd+'00z.nc4'

  for ialt = 0, nlift-1 do begin

; copy master file over
  spawn, '\cp -f '+filedir+filed+filen+' '+filedir+lift_dir[ialt], /sh


  liftz = lift_alt[ialt]

  filename = filedir+lift_dir[ialt]+'/'+filen
print, filename
  nc4readvar, filename, 'delp', delp, lat=lat, lon=lon
  nc4readvar, filename, 'ps', ps
  nc4readvar, filename, 'airdens', rhoa

; Form a vertical coordinate
  nx = n_elements(lon)
  ny = n_elements(lat)
  he   = fltarr(nx,ny,73)
  dz   = fltarr(nx,ny,72)
  he[*,*,72] = 0.
  for iz = 71, 0, -1 do begin
   dz[*,*,iz] = delp[*,*,iz]/rhoa[*,*,iz]/9.81
   he[*,*,iz] = he[*,*,iz+1]+dz[*,*,iz]
  endfor
  he = he / 1000.   ; km
  dz = dz / 1000.   ; km

; Now open the file to write
  cdfid = ncdf_open(filename,/write)
  vars = ['OCphilic','OCphobic','BCphilic','BCphobic','SO4']
  nvars = n_elements(vars)
  id = intarr(nvars)
  varval = fltarr(nx,ny,72,nvars)
  varvalout = fltarr(nx,ny,72,nvars)

  for ivar = 0, nvars-1 do begin
   id[ivar] = ncdf_varid(cdfid,vars[ivar])
   ncdf_varget, cdfid, id[ivar], oc
   varval[*,*,*,ivar] = oc
  endfor

; Lift
  ocout = fltarr(nx,ny,72)
  for ix = 0, nx-1 do begin
  for iy = 0, ny-1 do begin
   for iz = 71, 1, -1 do begin
    zlow = he[ix,iy,iz+1]+liftz
    zup  = he[ix,iy,iz]+liftz
    a = where(zlow gt he[ix,iy,*]) ; min index = lower
    b = where(zup gt he[ix,iy,*])  ; min index = upper
    for izz = min(a), min(b), -1 do begin
     if(he[ix,iy,izz] lt zlow) then $
      f = (he[ix,iy,izz-1]-zlow)/(zup-zlow)
     if(he[ix,iy,izz-1] gt zup) then $
      f = (zup-he[ix,iy,izz])/(zup-zlow)
     f = min([f,1.])
     for ivar = 0, nvars-1 do begin
      varvalout[ix,iy,izz,ivar] = varvalout[ix,iy,izz,ivar]$
       +varval[ix,iy,iz,ivar]*delp[ix,iy,iz]*f/delp[ix,iy,izz]
     endfor
    endfor
   endfor
  endfor

  endfor

  for ivar = 0, nvars-1 do begin
   ncdf_varput, cdfid, id[ivar], varvalout[*,*,*,ivar]
  endfor

  ncdf_close, cdfid

endfor
endfor



end
