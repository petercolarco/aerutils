  wantlon=[15,15]
  wantlat=[-10,-10]

; Mongu
  wantlon=[23.13,23.13]
  wantlat=[-15.3,-15.3]
  aeronetlam = [440,670,870,1020]
  aeronet = [0.88,0.86,0.83,0.8]
  model   = [0.845,0.86,0.80,0.76] 
  models  = [0.87,0.88,0.815,0.76] 
  stnWant = 'Mongu_Inn'

; Namibe;
;  wantlon=[12.18,12.18]
;  wantlat=[-15.16,-15.16]
;  aeronetlam = [440,670,870,1020]
;  aeronet = [0.88,0.88,0.865,0.845]
;  model   = [0.875,0.90,0.87,0.865] 
;  models  = [0.89,0.91,0.88,0.87] 
;  stnWant = 'Namibe'

  expid = ['gsfun','schill','nobc','low','nosoa','nodu','nosu','nobrc']

  nexpid = n_elements(expid)

  aod = fltarr(nexpid+1,3)
  ssa = fltarr(nexpid+1,3)
  ai  = fltarr(nexpid+1)

; Get the omi
  filen = 'omaeruv.monthly.201609.nc4'
  nc4readvar, filen, 'ai', ai_, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'aot', aot, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'aot388', aot388, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'aot354', aot354, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'ssa', ssa_, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'ssa388', ssa388, wantlon=wantlon, wantlat=wantlat
  nc4readvar, filen, 'ssa354', ssa354, wantlon=wantlon, wantlat=wantlat
  ai[0] = ai_
  aod[0,0] = aot354
  aod[0,1] = aot388
  aod[0,2] = aot
  ssa[0,0] = ssa354
  ssa[0,1] = ssa388
  ssa[0,2] = ssa_

; Now get the experiments
  for i = 1, nexpid do begin
   filen = 'c180R_v202_aura_'+expid[i-1]+'.monthly.201609.nc4'
   nc4readvar, filen, 'ai', ai_, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'maot', aot, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'maot388', aot388, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'maot354', aot354, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'mssa', ssa_, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'mssa388', ssa388, wantlon=wantlon, wantlat=wantlat
   nc4readvar, filen, 'mssa354', ssa354, wantlon=wantlon, wantlat=wantlat
   ai[i] = ai_
   aod[i,0] = aot354
   aod[i,1] = aot388
   aod[i,2] = aot
   ssa[i,0] = ssa354
   ssa[i,1] = ssa388
   ssa[i,2] = ssa_
  endfor

  aae = -alog( ((1.-ssa[*,0])*aod[*,0]) / ((1.-ssa[*,1])*aod[*,1])) / $
         alog( 354./388. )

; Get the AERONET
  getaeronetaod, stnWant, 'AOD_440nm', time, aod__
  a = where(aod__ gt 0.4)

; Get the model AERONET full AOD series
  lam = ['340','380','440','500','532','675','870','1020']
  ssaall = fltarr(n_elements(lam),2)
  expid = 'c180R_v202_aura'
  for ilam = 0, n_elements(lam)-1 do begin
   ssa_ = 1.
   getmodelaod, expid, stnWant, lam[ilam], aod_, ssa=ssa_
   ssaall[ilam,0] = mean(ssa_[a]*aod_[a])/mean(aod_[a])
  endfor
  expid = 'c180R_v202_aura_schill'
  for ilam = 0, n_elements(lam)-1 do begin
   ssa_ = 1.
   getmodelaod, expid, stnWant, lam[ilam], aod_, ssa=ssa_
   ssaall[ilam,1] = mean(ssa_[a]*aod_[a])/mean(aod_[a])
  endfor

; Plot the spectral SSA
  set_plot, 'ps'
  device, file='spectral_ssa.'+stnWant+'.ps', /color, /helvetica, font_size=12
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[300,1050], xtitle='Wavelength [!Mmm]', $
   yrange=[0.75,0.95], ytitle='Single Scattering Albedo', $
   xstyle=1
  x = [354,388,500]
  loadct, 39
  plots, float(lam), ssaall[*,1], thick=8, color=60
  plots, x, ssa[0,*], psym=sym(1), symsize=3
  plots, x, ssa[2,*], psym=sym(1), symsize=2, color=60
  loadct, 38
  plots, float(lam), ssaall[*,0], thick=8, color=80
  plots, x, ssa[1,*], psym=sym(1), symsize=2, color=80
;  plots, x, ssa[4,*], psym=sym(1), symsize=1.5, color=208
;  plots, x, ssa[3,*], psym=sym(6), symsize=1.5

  plots, aeronetlam, aeronet, psym=sym(5), symsize=3
;  plots, aeronetlam, model, psym=sym(5), color=80, symsize=2
  loadct, 39
;  plots, aeronetlam, models, psym=sym(5), color=60, symsize=1.5
;  plots, aeronetlam, models, psym=sym(10), symsize=1.5, color=255

  device, /close

end
