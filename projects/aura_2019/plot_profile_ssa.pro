  i = 22680
  date = '20160924'


; Variables
  ssa = fltarr(72,4,2,4)
  ext = fltarr(72,4,2,4)
  h    = fltarr(72,4)
  rhoa = fltarr(72,4)
  bc   = fltarr(72,4)
  oc   = fltarr(72,4)
  brc  = fltarr(72,4)

  expid = ['c360R_v10p22p2_aura', 'c360R_v10p22p2_aura_loss_bb3', 'c360R_v10p22p2_aura_loss_bb4', $
           'c360R_v10p22p2_aura_loss_bb4_gaas']
  psd   = ['', '.oracles']
  cases = ['', 'bcgf', 'low', 'bcgf_low']

  for iexp = 0, 3 do begin
   read_trj_profile, expid[iexp], date, time, h_, rhoa_, bc_, brc_, oc_
   rhoa[*,iexp] = rhoa_[*,i]
   bc[*,iexp]   = bc_[*,i]
   oc[*,iexp]   = oc_[*,i]
   brc[*,iexp]  = brc_[*,i]
   h[*,iexp]    = h_[*,i]
   for ipsd = 0, 1 do begin
    for icas = 0, 3 do begin
     fileinp = expid[iexp]+psd[ipsd]
     if(cases[icas] ne '' and psd[ipsd] eq '') then fileinp = fileinp+'.'+cases[icas]
     if(cases[icas] ne '' and psd[ipsd] ne '') then fileinp = fileinp+'_'+cases[icas]
     print, icas, ipsd, iexp, fileinp
     read_ext_profile, fileinp, date, ext_, ssa_
     ssa[*,icas,ipsd,iexp] = ssa_[*,i]
     ext[*,icas,ipsd,iexp] = ext_[*,i]
    endfor
   endfor
  endfor

; Get the profile
  read_data, altp, ssap, extp, oap, bcp, no3p, so4p

; ----------------------------
  set_plot, 'ps'
  device, file='plot_profile_ssa.'+date+'.ps', /color
  !p.font=0

  loadct, 39
  plot, ssa[*,0,0,0], h[*,0]/1000., /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[0.75,1], xtitle='SSA [532 m]'
  color = [[90,50],[208,254],[192,144],[208,208]]
  lin   = [0,1,2,3]
  thick = [8,8,2,8]
  for icas = 3,3 do begin
   for ipsd = 1,1 do begin
    for iexp = 0,3 do begin
     oplot, ssa[*,icas,ipsd,iexp], h[*,iexp]/1000., $
       thick=thick[icas], color=color[ipsd,iexp], lin=lin[icas]
    endfor
   endfor
  endfor

  oplot, ssap, altp/1000., thick=8, color=0
  device, /close

; ----------------------------
  set_plot, 'ps'
  device, file='plot_profile_ssa.'+date+'.ext.ps', /color
  !p.font=0

  loadct, 39
  plot, ssa[*,0,0,0], h[*,0]/1000., /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[0,200], xtitle='Extinction [532 nm, Mm!E-1!N]'
  color = [[90,50],[208,254],[192,144],[208,208]]
  lin   = [0,1,2,3]
  thick = [8,8,2,8]
  for icas = 3,3 do begin
   for ipsd = 1,1 do begin
    for iexp = 0,3 do begin
     oplot, ext[*,icas,ipsd,iexp]*1000., h[*,iexp]/1000., $
       thick=thick[icas], color=color[ipsd,iexp], lin=lin[icas]
    endfor
   endfor
  endfor

  oplot, extp, altp/1000., thick=8, color=0

  device, /close


; ----------------------------
  set_plot, 'ps'
  device, file='plot_profile_ssa.'+date+'.bc.ps', /color
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[0,5], xtitle='Black Carbon [!Mm!3g m!E-3!N]'
  color = [50,254,144,208]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 0, 0 do begin
   for iexp = 0, 3 do begin
    oplot, bc[*,iexp]*rhoa[*,iexp]*1.e9, h[*,1]/1000., thick=thick[icas], color=color[iexp], lin=lin[icas]
   endfor
  endfor

  oplot, bcp, altp/1000., thick=8, color=0

  device, /close


  set_plot, 'ps'
  device, file='plot_profile_ssa.'+date+'.oa.ps', /color
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[0,30], xtitle='Organic Aerosol [!Mm!3g m!E-3!N]'
  color = [50,254,144,208]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 0, 0 do begin
   for iexp = 0, 3 do begin
    oplot, (oc[*,iexp]+brc[*,iexp])*rhoa[*,iexp]*1.e9, h[*,1]/1000., thick=thick[icas], color=color[iexp], lin=lin[icas]
   endfor
  endfor

  oplot, oap, altp/1000., thick=8, color=0

  device, /close

  set_plot, 'ps'
  device, file='plot_profile_ssa.'+date+'.ratio.ps', /color
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[0,20], xtitle='OA:BC'
  color = [50,254,144,208]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 0, 0 do begin
   for iexp = 0, 3 do begin
    oplot, (oc[*,iexp]+brc[*,iexp])/bc[*,iexp], h[*,1]/1000., thick=thick[icas], color=color[iexp], lin=lin[icas]
   endfor
  endfor

  oplot, oap/bcp, altp/1000., thick=8, color=0
  device, /close

end
