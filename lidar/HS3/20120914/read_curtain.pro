; Colarco, February 2011
; Read the curtain files

  pro read_curtain, filename, lon, lat, time, z, dz, $
                    extinction_tot = extinction_tot, $
                    extinction_du  = extinction_du, $
                    extinction_su  = extinction_su, $
                    extinction_ss  = extinction_ss, $
                    extinction_oc  = extinction_oc, $
                    extinction_bc  = extinction_bc, $
                    tau_tot = tau_tot, $
                    tau_du  = tau_du, $
                    tau_su  = tau_su, $
                    tau_ss  = tau_ss, $
                    tau_oc  = tau_oc, $
                    tau_bc  = tau_bc, $
                    ssa_tot = ssa_tot, $
                    ssa_du  = ssa_du, $
                    ssa_su  = ssa_su, $
                    ssa_ss  = ssa_ss, $
                    ssa_oc  = ssa_oc, $
                    ssa_bc  = ssa_bc, $
                    backscat_tot = backscat_tot, $
                    backscat_du  = backscat_du, $
                    backscat_su  = backscat_su, $
                    backscat_ss  = backscat_ss, $
                    backscat_oc  = backscat_oc, $
                    backscat_bc  = backscat_bc, $
                    aback_sfc_tot = aback_sfc_tot, $
                    aback_sfc_du  = aback_sfc_du, $
                    aback_sfc_su  = aback_sfc_su, $
                    aback_sfc_ss  = aback_sfc_ss, $
                    aback_sfc_oc  = aback_sfc_oc, $
                    aback_sfc_bc  = aback_sfc_bc, $
                    aback_toa_tot = aback_toa_tot, $
                    aback_toa_du  = aback_toa_du, $
                    aback_toa_su  = aback_toa_su, $
                    aback_toa_ss  = aback_toa_ss, $
                    aback_toa_oc  = aback_toa_oc, $
                    aback_toa_bc  = aback_toa_bc, $
                    cloud = cloud, radiances = radiances, $
                    depol = depol


  cdfid = ncdf_open(filename)

; Get the mandatory
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
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


; Depolarization ratio
  if(keyword_set(depol)) then begin
   id = ncdf_varid(cdfid,'depol')
   ncdf_varget, cdfid, id, depol
  endif

; Extinction
  if(keyword_set(extinction_tot)) then begin
   id = ncdf_varid(cdfid,'extinction')
   ncdf_varget, cdfid, id, extinction_tot
  endif
  if(keyword_set(extinction_du)) then begin
   id = ncdf_varid(cdfid,'extinction_du')
   ncdf_varget, cdfid, id, extinction_du
  endif
  if(keyword_set(extinction_su)) then begin
   id = ncdf_varid(cdfid,'extinction_su')
   ncdf_varget, cdfid, id, extinction_su
  endif
  if(keyword_set(extinction_ss)) then begin
   id = ncdf_varid(cdfid,'extinction_ss')
   ncdf_varget, cdfid, id, extinction_ss
  endif
  if(keyword_set(extinction_oc)) then begin
   id = ncdf_varid(cdfid,'extinction_oc')
   ncdf_varget, cdfid, id, extinction_oc
  endif
  if(keyword_set(extinction_bc)) then begin
   id = ncdf_varid(cdfid,'extinction_bc')
   ncdf_varget, cdfid, id, extinction_bc
  endif
  if(keyword_set(extinction_oc)) then begin
   id = ncdf_varid(cdfid,'extinction_oc')
   ncdf_varget, cdfid, id, extinction_oc
  endif

; Tau
  if(keyword_set(tau_tot)) then begin
   id = ncdf_varid(cdfid,'tau')
   ncdf_varget, cdfid, id, tau_tot
  endif
  if(keyword_set(tau_du)) then begin
   id = ncdf_varid(cdfid,'tau_du')
   ncdf_varget, cdfid, id, tau_du
  endif
  if(keyword_set(tau_su)) then begin
   id = ncdf_varid(cdfid,'tau_su')
   ncdf_varget, cdfid, id, tau_su
  endif
  if(keyword_set(tau_ss)) then begin
   id = ncdf_varid(cdfid,'tau_ss')
   ncdf_varget, cdfid, id, tau_ss
  endif
  if(keyword_set(tau_oc)) then begin
   id = ncdf_varid(cdfid,'tau_oc')
   ncdf_varget, cdfid, id, tau_oc
  endif
  if(keyword_set(tau_bc)) then begin
   id = ncdf_varid(cdfid,'tau_bc')
   ncdf_varget, cdfid, id, tau_bc
  endif
  if(keyword_set(tau_oc)) then begin
   id = ncdf_varid(cdfid,'tau_oc')
   ncdf_varget, cdfid, id, tau_oc
  endif

; Ssa
  if(keyword_set(ssa_tot)) then begin
   id = ncdf_varid(cdfid,'ssa')
   ncdf_varget, cdfid, id, ssa_tot
  endif
  if(keyword_set(ssa_du)) then begin
   id = ncdf_varid(cdfid,'ssa_du')
   ncdf_varget, cdfid, id, ssa_du
  endif
  if(keyword_set(ssa_su)) then begin
   id = ncdf_varid(cdfid,'ssa_su')
   ncdf_varget, cdfid, id, ssa_su
  endif
  if(keyword_set(ssa_ss)) then begin
   id = ncdf_varid(cdfid,'ssa_ss')
   ncdf_varget, cdfid, id, ssa_ss
  endif
  if(keyword_set(ssa_oc)) then begin
   id = ncdf_varid(cdfid,'ssa_oc')
   ncdf_varget, cdfid, id, ssa_oc
  endif
  if(keyword_set(ssa_bc)) then begin
   id = ncdf_varid(cdfid,'ssa_bc')
   ncdf_varget, cdfid, id, ssa_bc
  endif
  if(keyword_set(ssa_oc)) then begin
   id = ncdf_varid(cdfid,'ssa_oc')
   ncdf_varget, cdfid, id, ssa_oc
  endif

; Backscat
  if(keyword_set(backscat_tot)) then begin
   id = ncdf_varid(cdfid,'backscat')
   ncdf_varget, cdfid, id, backscat_tot
  endif
  if(keyword_set(backscat_du)) then begin
   id = ncdf_varid(cdfid,'backscat_du')
   ncdf_varget, cdfid, id, backscat_du
  endif
  if(keyword_set(backscat_su)) then begin
   id = ncdf_varid(cdfid,'backscat_su')
   ncdf_varget, cdfid, id, backscat_su
  endif
  if(keyword_set(backscat_ss)) then begin
   id = ncdf_varid(cdfid,'backscat_ss')
   ncdf_varget, cdfid, id, backscat_ss
  endif
  if(keyword_set(backscat_oc)) then begin
   id = ncdf_varid(cdfid,'backscat_oc')
   ncdf_varget, cdfid, id, backscat_oc
  endif
  if(keyword_set(backscat_bc)) then begin
   id = ncdf_varid(cdfid,'backscat_bc')
   ncdf_varget, cdfid, id, backscat_bc
  endif
  if(keyword_set(backscat_oc)) then begin
   id = ncdf_varid(cdfid,'backscat_oc')
   ncdf_varget, cdfid, id, backscat_oc
  endif

; Aback_Toa
  if(keyword_set(aback_toa_tot)) then begin
   id = ncdf_varid(cdfid,'aback_toa')
   ncdf_varget, cdfid, id, aback_toa_tot
  endif
  if(keyword_set(aback_toa_du)) then begin
   id = ncdf_varid(cdfid,'aback_toa_du')
   ncdf_varget, cdfid, id, aback_toa_du
  endif
  if(keyword_set(aback_toa_su)) then begin
   id = ncdf_varid(cdfid,'aback_toa_su')
   ncdf_varget, cdfid, id, aback_toa_su
  endif
  if(keyword_set(aback_toa_ss)) then begin
   id = ncdf_varid(cdfid,'aback_toa_ss')
   ncdf_varget, cdfid, id, aback_toa_ss
  endif
  if(keyword_set(aback_toa_oc)) then begin
   id = ncdf_varid(cdfid,'aback_toa_oc')
   ncdf_varget, cdfid, id, aback_toa_oc
  endif
  if(keyword_set(aback_toa_bc)) then begin
   id = ncdf_varid(cdfid,'aback_toa_bc')
   ncdf_varget, cdfid, id, aback_toa_bc
  endif
  if(keyword_set(aback_toa_oc)) then begin
   id = ncdf_varid(cdfid,'aback_toa_oc')
   ncdf_varget, cdfid, id, aback_toa_oc
  endif

; Aback_Sfc
  if(keyword_set(aback_sfc_tot)) then begin
   id = ncdf_varid(cdfid,'aback_sfc')
   ncdf_varget, cdfid, id, aback_sfc_tot
  endif
  if(keyword_set(aback_sfc_du)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_du')
   ncdf_varget, cdfid, id, aback_sfc_du
  endif
  if(keyword_set(aback_sfc_su)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_su')
   ncdf_varget, cdfid, id, aback_sfc_su
  endif
  if(keyword_set(aback_sfc_ss)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_ss')
   ncdf_varget, cdfid, id, aback_sfc_ss
  endif
  if(keyword_set(aback_sfc_oc)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_oc')
   ncdf_varget, cdfid, id, aback_sfc_oc
  endif
  if(keyword_set(aback_sfc_bc)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_bc')
   ncdf_varget, cdfid, id, aback_sfc_bc
  endif
  if(keyword_set(aback_sfc_oc)) then begin
   id = ncdf_varid(cdfid,'aback_sfc_oc')
   ncdf_varget, cdfid, id, aback_sfc_oc
  endif

  if(keyword_set(cloud)) then begin
   id = ncdf_varid(cdfid,'cloud')
   ncdf_varget, cdfid, id, cloud
  endif

  if(keyword_set(radiances)) then begin
   id = ncdf_varid(cdfid,'radiances')
   ncdf_varget, cdfid, id, radiances
  endif

; Create the hght coordinate
  nt = n_elements(time)
  nz = n_elements(z[*,0])
  dz = fltarr(nz,nt)
  dz[nz-1,*] = 2.*(z[nz-1,*]-z0)
  for iz = nz-2, 0, -1 do begin
   dz[iz,*] = 2.*(z[iz,*]- (z[iz+1,*]+0.5*(dz[iz+1,*])) )
  endfor

end
