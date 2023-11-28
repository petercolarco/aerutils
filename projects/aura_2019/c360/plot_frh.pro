  i = 22680
  date = '20160924'


; Variables
  ext20 = fltarr(72,4,2,2)
  ext80 = fltarr(72,4,2,2)
  ssa20 = fltarr(72,4,2,2)
  ssa80 = fltarr(72,4,2,2)
  h    = fltarr(72,2)
  rhoa = fltarr(72,2)
  bc   = fltarr(72,2)
  oc   = fltarr(72,2)
  brc  = fltarr(72,2)

  expid = ['c360R_era5_v10p22p2_aura_loss_bb3']
  psd   = ['', '.oracles']
  cases = ['', 'bcgf', 'low', 'bcgf_low3']

  for iexp = 0, 0 do begin
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
     read_ext_profile, fileinp, date, ext_, ssa_, rc, /rh20
     if(rc) then begin
      ssa20[*,icas,ipsd,iexp] = ssa_[*,i]
      ext20[*,icas,ipsd,iexp] = ext_[*,i]
     endif
     read_ext_profile, fileinp, date, ext_, ssa_, rc, /rh80
     if(rc) then begin
      ssa80[*,icas,ipsd,iexp] = ssa_[*,i]
      ext80[*,icas,ipsd,iexp] = ext_[*,i]
     endif
    endfor
   endfor
  endfor

; Chosen levels to be between 1 - 5 km for profile
  set_plot, 'ps'
  device, file='plot_frh.profile.'+expid[0]+'.'+date+'.ps', /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   yrange=[1,7], ytitle='altitude [km]', ystyle=1, $
   xrange=[1,2.5], xtitle='fRH [532 nm]'
  color = [180,80]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 0,0 do begin
   for ipsd = 0,1 do begin
    rat = ext80[*,icas,ipsd,0]/ext20[*,icas,ipsd,0]
    oplot, rat, h[*,0]/1000., $
      thick=thick[icas], color=color[ipsd,0], lin=lin[icas]
   endfor
  endfor

  loadct, 39
  color = [208,254]
  lin   = [0,1,2,0]
  thick = [8,1,2,12]
  for icas = 3,3 do begin
   for ipsd = 0,1 do begin
    rat = ext80[*,icas,ipsd,0]/ext20[*,icas,ipsd,0]
    oplot, rat, h[*,0]/1000., $
      thick=thick[icas], color=color[ipsd,0], lin=lin[icas]
   endfor
  endfor


  device, /close


  set_plot, 'ps'
  device, file='plot_frh.'+date+'.ps', /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   yrange=[1,2.5], ytitle='fRH [532 nm]', ystyle=1, $
   xrange=[0,600], xtitle='Extinction [532 nm, Mm!E-1!N]', xstyle=1
  color = [180,80]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 0,0 do begin
   for ipsd = 0,1 do begin
    rat = ext80[51:64,icas,ipsd,0]/ext20[51:64,icas,ipsd,0]
    plots, ext20[51:64,icas,ipsd,0]*1000., rat, psym=sym(1), color=color[ipsd], noclip=1
   endfor
  endfor

  loadct, 39
  color = [208,254]
  lin   = [0,1,2,3]
  thick = [8,1,2,12]
  for icas = 3,3 do begin
   for ipsd = 0,1 do begin
    rat = ext80[51:64,icas,ipsd,0]/ext20[51:64,icas,ipsd,0]
    plots, ext20[51:64,icas,ipsd,0]*1000., rat, psym=sym(1), color=color[ipsd], noclip=1
   endfor
  endfor


  device, /close

end
