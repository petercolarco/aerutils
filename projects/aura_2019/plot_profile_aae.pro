  expid  = 'c360R_era5_v10p22p2_aura_loss_bb3'
  expdir = '/misc/prc18/colarco/'+expid+'/trajectories/'

  filename = expdir+expid+'.20160924.trj.nc'
  read_trj_profile, filename, time, h, rhoa, bc, brc, oc
  iz = 55 ; ~3km
;  iz = 61 ; ~1.5 km
;  iz = 52 ; ~4 km
  nt = n_elements(h[0,*])
  h    = reform(h[iz,*])
  rhoa = reform(rhoa[iz,*])
  bc   = reform(bc[iz,*])
  brc  = reform(brc[iz,*])
  oc  = reform(oc[iz,*])

  rat = (brc+oc)/bc


; Get the 2 wavelengths of ext and ssa
  ncase = 9
  nlam  = 2
  cases = ['','.bcgf','.bcgf_low','.low',$
           '.oracles','.oracles_bcgf','.oracles_bcgf_low','.oracles_low',$
           '.oracles_bcgf_low2']
  lam = ['354','388']

  ext = fltarr(nt,ncase,nlam)
  ssa = fltarr(nt,ncase,nlam)
  aae = fltarr(nt,ncase)

  for icase = 0, ncase-1 do begin
   for ilam = 0, 1 do begin
    filename = expdir+expid+cases[icase]+'.20160924.ext-'+lam[ilam]+'nm.nc'
    read_ext_profile, filename, ext_, ssa_
    ext[*,icase,ilam] = ext_[iz,*]
    ssa[*,icase,ilam] = ssa_[iz,*]
   endfor
  endfor

  aae = -alog((ext[*,*,0]-ssa[*,*,0]*ext[*,*,0])/ $
              (ext[*,*,1]-ssa[*,*,1]*ext[*,*,1]))/alog(354./388.)


;  plot, indgen(2), xrange=[0,20], /nodata, yrange=[1,1.2], $
;   xtitle='OC/BC ratio', ytitle='Abs354/Abs388'
;  plots, rat, (1.-ssa[*,0,0])/(1.-ssa[*,0,1]), psym=3
;  plots, rat, (1.-ssa[*,6,0])/(1.-ssa[*,6,1]), psym=3, color=100
;  plots, rat, (1.-ssa[*,5,0])/(1.-ssa[*,5,1]), psym=3, color=150

  set_plot, 'ps'
  device, file='plot_profile_aae.ps', /color, /helvetica, $
   font_size=14
  !p.font=0

  loadct, 39
  plot, indgen(2), xrange=[0,20], /nodata, yrange=[1,3], $
   xtitle='OA/BC ratio', ytitle='AAE', thick=3
  plots, rat, aae[*,0], psym=3
  plots, rat, aae[*,6], psym=3, color=84
  plots, rat, aae[*,5], psym=3, color=254
  plots, rat, aae[*,8], psym=3, color=176


  device, /close

end
