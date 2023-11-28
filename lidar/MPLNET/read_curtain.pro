; Colarco, February 2011
; Read the curtain files

  pro read_curtain,  filename, lon, lat, time, z0, z, dz, $
                     pblh = pblh, $
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
                     du = du, $
                     so2 = so2, $
                     so4 = so4, $
                     ss = ss, $
                     oc = oc, $
                     bc = bc, $
                     cloud = cloud

; Check keywords
  if(keyword_set(pblh))           then pblh_ = pblh
  if(keyword_set(cloud))          then cloud_ = cloud 
  if(keyword_set(extinction_tot)) then extinction_tot_ = extinction_tot
  if(keyword_set(ssa_tot))        then ssa_tot_ = ssa_tot
  if(keyword_set(aback_sfc_tot))  then aback_sfc_tot_  = aback_sfc_tot
  if(keyword_set(backscat_tot))   then backscat_tot_   = backscat_tot
  if(keyword_set(bc))             then bc_ = bc


  nfile = n_elements(filename)

  for ifile = 0, nfile-1 do begin
   read_curtain_, filename[ifile], lon_, lat_, time_, z0_, z_, dz_, $
                     pblh = pblh_, $
                     extinction_tot = extinction_tot_, $
                     extinction_du  = extinction_du_, $
                     extinction_su  = extinction_su_, $
                     extinction_ss  = extinction_ss_, $
                     extinction_oc  = extinction_oc_, $
                     extinction_bc  = extinction_bc_, $
                     tau_tot = tau_tot_, $
                     tau_du  = tau_du_, $
                     tau_su  = tau_su_, $
                     tau_ss  = tau_ss_, $
                     tau_oc  = tau_oc_, $
                     tau_bc  = tau_bc_, $
                     ssa_tot = ssa_tot_, $
                     ssa_du  = ssa_du_, $
                     ssa_su  = ssa_su_, $
                     ssa_ss  = ssa_ss_, $
                     ssa_oc  = ssa_oc_, $
                     ssa_bc  = ssa_bc_, $
                     backscat_tot = backscat_tot_, $
                     backscat_du  = backscat_du_, $
                     backscat_su  = backscat_su_, $
                     backscat_ss  = backscat_ss_, $
                     backscat_oc  = backscat_oc_, $
                     backscat_bc  = backscat_bc_, $
                     aback_sfc_tot = aback_sfc_tot_, $
                     aback_sfc_du  = aback_sfc_du_, $
                     aback_sfc_su  = aback_sfc_su_, $
                     aback_sfc_ss  = aback_sfc_ss_, $
                     aback_sfc_oc  = aback_sfc_oc_, $
                     aback_sfc_bc  = aback_sfc_bc_, $
                     aback_toa_tot = aback_toa_tot_, $
                     aback_toa_du  = aback_toa_du_, $
                     aback_toa_su  = aback_toa_su_, $
                     aback_toa_ss  = aback_toa_ss_, $
                     aback_toa_oc  = aback_toa_oc_, $
                     aback_toa_bc  = aback_toa_bc_, $
                     bc = bc_, $
                     cloud = cloud_

   if(ifile eq 0) then begin
    lon  = lon_
    lat  = lat_
    time = time_
    z0   = z0_
    z    = z_
    dz   = dz_
    nz   = n_elements(z[*,0])
    if(keyword_set(pblh)) then pblh = pblh_
    if(keyword_set(cloud)) then cloud = cloud_
    if(keyword_set(extinction_tot)) then extinction_tot = extinction_tot_
    if(keyword_set(ssa_tot)) then ssa_tot = ssa_tot_
    if(keyword_set(aback_sfc_tot)) then aback_sfc_tot = aback_sfc_tot_
    if(keyword_set(backscat_tot)) then backscat_tot = backscat_tot_
    if(keyword_set(bc)) then bc = bc_
   endif else begin
    lon  = [lon,lon_]
    lat  = [lat,lat_]
    time = [time,time_]
    z0   = [z0,z0_]
    z    = [[z],[z_]]
    dz   = [[dz],[dz_]]
    if(keyword_set(pblh)) then pblh = [pblh,pblh_]
    if(keyword_set(cloud)) then cloud = [[cloud],[cloud_]]
    if(keyword_set(extinction_tot)) then extinction_tot = [[extinction_tot],[extinction_tot_]]
    if(keyword_set(ssa_tot)) then ssa_tot = [[ssa_tot],[ssa_tot_]]
    if(keyword_set(aback_sfc_tot)) then aback_sfc_tot = [[aback_sfc_tot],[aback_sfc_tot_]]
    if(keyword_set(backscat_tot)) then backscat_tot = [[backscat_tot],[backscat_tot_]]
    if(keyword_set(bc)) then bc = [[bc],[bc_]]
   endelse
   nt = n_elements(time)

  endfor

end
