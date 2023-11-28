  wantlon=[15,15]
  wantlat=[-10,-10]

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

; Plot the spectral SSA
  set_plot, 'ps'
  device, file='spectral_ssa.ps', /color, /helvetica, font_size=12
  !p.font=0
  
  plot, indgen(10), /nodata, $
   xrange=[300,550], xtitle='Wavelength [!Mmm]', $
   yrange=[0.85,1], ytitle='Single Scattering Albedo'
  x = [354,388,500]
  loadct, 39
  plots, x, ssa[0,*], psym=sym(1), symsize=1.5
  plots, x, ssa[1,*], psym=sym(1), symsize=1.5, color=84
  plots, x, ssa[2,*], psym=sym(1), symsize=1.5, color=176
  plots, x, ssa[4,*], psym=sym(1), symsize=1.5, color=208
  plots, x, ssa[3,*], psym=sym(6), symsize=1.5

  device, /close

end
