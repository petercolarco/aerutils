; Colarco, February 2011
; Read the curtain files

  pro read_curtain, filename, lon, lat, time, z, dz, orbit_track, $
                    bc = bc, so2 = so2, airdens = airdens


  cdfid = ncdf_open(filename)

; Get the mandatory
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'orbit_track')
  ncdf_varget, cdfid, id, orbit_track
  id = ncdf_varid(cdfid,'h0')
  ncdf_varget, cdfid, id, z0
  id = ncdf_varid(cdfid,'h')
  if(id ne -1) then begin
   ncdf_varget, cdfid, id, z 
  endif else begin
   id = ncdf_varid(cdfid,'airdens')
   ncdf_varget, cdfid, id, airdens
   id = ncdf_varid(cdfid,'delp')
   ncdf_varget, cdfid, id, delp
   z = airdens
   nz = n_elements(airdens[*,0])
   dz = delp/airdens/9.81
   z[nz-1,*] = z0+0.5*dz[nz-1,*]
   for iz = nz-2, 0, -1 do begin
    z[iz,*] = z[iz+1,*] + 0.5*(dz[iz,*]+dz[iz+1,*])
   endfor
  endelse


; tracers
  if(keyword_set(bc)) then begin
   id = ncdf_varid(cdfid,'bc')
   ncdf_varget, cdfid, id, bc
  endif
  if(keyword_set(so2)) then begin
   id = ncdf_varid(cdfid,'SO2')
   ncdf_varget, cdfid, id, so2
  endif
  if(keyword_set(airdens)) then begin
   id = ncdf_varid(cdfid,'airdens')
   ncdf_varget, cdfid, id, airdens
  endif

; Create the hght coordinate
  nt = n_elements(time)
  nz = n_elements(z[*,0])
  dz = fltarr(nz,nt)
  dz[nz-1,*] = 2.*(z[nz-1,*]-z0)
  for iz = nz-2, 0, -1 do begin
   dz[iz,*] = 2.*(z[iz,*]- (z[iz+1,*]+0.5*(dz[iz+1,*])) )
  endfor

  ncdf_close, cdfid

end
