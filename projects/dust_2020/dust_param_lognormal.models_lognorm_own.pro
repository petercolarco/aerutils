; This gets the values from the non-spherical optics Osku prepared
; from here: /misc/opk01/topete/du/
  pro getoptics, model, mee, ssa
   filedir = '/home/colarco/sandbox/radiation_v2/pygeosmie/'
   filename = filedir+'integ-du_'+model+'_lognorm_own-raw.nc'
   cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid,'bext')
   ncdf_varget, cdfid, id, bext
   id = ncdf_varid(cdfid,'bsca')
   ncdf_varget, cdfid, id, bsca
   ncdf_close, cdfid
   ilam = 1
   mee = reform(bext[ilam,0,*])/1000.
   ssa = reform(bsca[ilam,0,*]/bext[ilam,0,*])
  end


  pro mfrac, diam, dm, xmin, xmax, mfrac, afrac, tl96=tl96
   nbin = n_elements(xmin)
   mfrac = fltarr(nbin)
   afrac = fltarr(nbin)
   mfract = total(dm)
   afract = total(dm/diam)
   for ibin = 0, nbin-2 do begin
    a = where(diam ge xmin[ibin] and diam lt xmin[ibin+1])
    mfrac[ibin] = total(dm[a]);/mfract
    afrac[ibin] = total(dm[a]/diam[a]);/afract
;print, n_elements(a)
   endfor
   ibin = nbin-1
   a = where(diam ge xmin[ibin] and diam le xmax)
   mfrac[ibin] = total(dm[a]);/mfract
   afrac[ibin] = total(dm[a]/diam[a]);/afract

;  GEOS, OMA, AM4 are all doing Tegen and Lacis partitioning in their
;  first four size bins, apply that here by destributing what is
;  computed above according the Tegen and Lacis (1996) mass
;  fractions. This presumes only done for the appropriate models.
   if(tl96 eq 1) then begin
    mft = total(mfrac[0:3])
    mfrac[0] = 0.009*mft
    mfrac[1] = 0.081*mft
    mfrac[2] = 0.234*mft
    mfrac[3] = 0.676*mft
   end

;print, n_elements(a)
;print, ' '
  end

  
; Given a diameter grid (diam) and the mass in each point (dm) and the
; model particle bins (xmin, xmax) compute the optical properties by
; integrating onto the model bins
  pro compute_model, name, diam, dm, xmin, xmax, mee, ssa, $
                     tau_, ssa_, mfr_, afr_

  nbin = n_elements(diam)
  nbin_ = n_elements(xmin)

; If GEOS then read table and get asymmetry parameter at 550 nm
;  if(name eq 'GEOS') then begin
;   filename = '/misc/prc10/colarco/radiation/geosMie/DU/optics_DU.input.v15_6.nc'
;   readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
;               rh, rmass, refreal, refimag
;   g = reform(g[5,0,*])
;  end

  tl96 = 0
  if(name eq 'GEOS' or name eq 'ModelE' or name eq 'AM4') then tl96 = 1

  mfrac, diam, dm, xmin, xmax, mfrac, afrac, tl96=tl96
;print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_ = total(mfrac*mee)
  ssa_ = total(mfrac*mee*ssa)/tau_
  mfr_ = total(mfrac)
  afr_ = total(afrac)
;if(name eq 'GEOS') then print, 'ASYM0 = ', total(g*mfrac*mee*ssa)/total(mfrac*mee*ssa)
end


; -----------------------------------------------------------------
; Start here
  vmd = findgen(351)*.01 + 1.5  ; um
  sig = findgen(101)*.01 + 1.5

; Get a wide set of size bins
  nbin = 100
  rmrat = (100./0.001d)^(3.d/(nbin-1))
  rmin  = 0.001
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
  diam = r*2.

; given the per bin mee and ssa use PSDs imposed on bins to compute
; AOD and SSA integrated. Use NAAPS to set the total mass load

  tau_table = fltarr(9,351,101)
  mee_table = fltarr(9,351,101)
  mfr_table = fltarr(9,351,101)
  afr_table = fltarr(9,351,101)
  ssa_table = fltarr(9,351,101)
  frc_table = fltarr(9,351,101)

  tau_table_pre = fltarr(9,1)
  mee_table_pre = fltarr(9,1)
  mfr_table_pre = fltarr(9,1)
  afr_table_pre = fltarr(9,1)
  ssa_table_pre = fltarr(9,1)
  frc_table_pre = fltarr(9,1)

; Define the "preset" PSD (e.g., OPAC)
  rmed = [0.27,1.6,11.]
  sigma = [1.95,2.0,2.15]
  frac = [7.5,168.7,45.6]
  frac = frac/total(frac)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, /vol, rlow=rlow, rup=rup
  dm_opac = dvdr*dr
  dm_opac = dm_opac*1.695

  models = ['GEOS','MASINGAR','AM4','MONARCH','ModelE','IFS','SILAM','UM','NAAPS']

  for ivmd = 0, 350 do begin
  for isig = 0, 100 do begin
print, ivmd, isig
  lognormal, vmd[ivmd]/2., sig[isig], 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695

; GEOS (8-bin)
  imod = 0
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'geos', mee_geos, ssa_geos
  endif
  mee = mee_geos
  ssa = ssa_geos
  compute_model, 'GEOS', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'GEOS', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_

; MONARCH
  imod = 3
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'monarch', mee_mon, ssa_mon
  endif
  mee = mee_mon
  ssa = ssa_mon
  compute_model, 'MONARCH', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'MONARCH', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; AM4
  imod = 2
  y = 8-imod
;  xmin=[0.2,2,3.6,6,12]
;  xmax=20
;  mee =[1.86,0.54,0.28,0.15,0.08]
;  ssa =[0.97,0.91,0.86,0.79,0.7]
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'am4', mee_am4, ssa_am4
  endif
  mee = mee_am4
  ssa = ssa_am4
  compute_model, 'AM4', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'AM4', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; NAAPS
  imod = 8
  y = 8-imod
  mee = 0.59
  ssa = 0.88
;  plots, 5, mee, psym=sym(4), color=0, symsize=3
  tau_table[imod,ivmd,isig] = 1.
  ssa_table[imod,ivmd,isig] = ssa
  mfr_table[imod,ivmd,isig] = total(dm)
  afr_table[imod,ivmd,isig] = total(dm/diam)

; ModelE
  imod = 4
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,4,8,16]
  xmax=32
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'modele', mee_modele, ssa_modele
  endif
  mee = mee_modele
  ssa = ssa_modele
  compute_model, 'ModelE', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'ModelE', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; IFS
  imod = 5
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'ifs', mee_ifs, ssa_ifs
  endif
  mee = mee_ifs
  ssa = ssa_ifs
  compute_model, 'IFS', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'IFS', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; SILAM
  imod = 6
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'silam', mee_silam, ssa_silam
  endif
  mee = mee_silam
  ssa = ssa_silam
  compute_model, 'SILAM', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'SILAM', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; UM
  imod = 7
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'um', mee_um, ssa_um
  endif
  mee = mee_um
  ssa = ssa_um
  compute_model, 'UM', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'UM', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


; MASINGAR
  imod = 1
  y = 8-imod
  xmin=[0.2,0.32,0.5,0.8,1.3,2,3.2,5,8,13]
  xmax=20
  if(ivmd eq 0 and isig eq 0) then begin
   getoptics, 'masingar', mee_masingar, ssa_masingar
  endif
  mee = mee_masingar
  ssa = ssa_masingar
  compute_model, 'MASINGAR', diam, dm, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,ivmd,isig] = tau_
  ssa_table[imod,ivmd,isig] = ssa_
  mfr_table[imod,ivmd,isig] = mfr_
  afr_table[imod,ivmd,isig] = afr_

  compute_model, 'MASINGAR', diam, dm_opac, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table_pre[imod,0] = tau_
  ssa_table_pre[imod,0] = ssa_
  mfr_table_pre[imod,0] = mfr_
  afr_table_pre[imod,0] = afr_


  endfor
  endfor

  mee_table = tau_table/mfr_table
  albedo = 0.06
  gasym  = 0.75
  upfrac = (1.-gasym/2.)/2.
  fac1   = (1.-albedo)^2.*2.*upfrac
  fac2   = 4.*albedo
  frc_table = -(fac1*tau_table*ssa_table-fac2*(1.-ssa_table)*tau_table)

  mee_table_pre = tau_table_pre/mfr_table_pre
  albedo = 0.06
  gasym  = 0.75
  upfrac = (1.-gasym/2.)/2.
  fac1   = (1.-albedo)^2.*2.*upfrac
  fac2   = 4.*albedo
  frc_table_pre = -(fac1*tau_table_pre*ssa_table_pre-fac2*(1.-ssa_table_pre)*tau_table_pre)

goto, skipplot
; Make a series of plots
  for imod = 0,7 do begin
   set_plot, 'ps'
   device, file='dust_param_lognormal.models_lognorm_own.'+models[imod]+'.ps', /color, $
    /helvetica, font_size=14, xsize=42, ysize=14
   !p.font=0

;  tau
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, $
    position=[.05,.225,.3,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='AOD'
   loadct, 70
   nl = 51
   exp_levels, nl, [0.5,1.0,3.0], x, levels
   colors=240-indgen(nl)*(240.-20.)/(nl-1)
   plotgrid, reform(tau_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f4.2)')
   makekey, .05, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.05,.225,.3,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='AOD'
   loadct, 70
   makekey, .05, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors
;  contour overplot the 90 and 95 dust mass coverage
   loadct, 0
   contour, /over, mfr_table[imod,*,*]/max(mfr_table), vmd, sig, $
    levels =[.9,.95, .99], c_linestyle=[2,1,0], c_thick=[3,3,3]


;  co-albedo
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.375,.225,.625,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='Co-Albedo'
   loadct, 70
   levels = findgen(51)*.004
   colors = 240 - findgen(51)*(240-20)/50.
   plotgrid, reform(1.-ssa_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f5.3)')
   makekey, .375, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.375,.225,.625,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title =''
   loadct, 70
   makekey, .375, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors



;  forcing
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.7,.225,.95,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='Relative Forcing'
   loadct, 70
   levels = -3.+findgen(51)*.06
   colors = 240 - findgen(51)*(240-20)/50.
   plotgrid, reform(frc_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f5.2)')
   makekey, .7, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.7,.225,.95,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title =''
   loadct, 70
   makekey, .7, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors


  device, /close




   set_plot, 'ps'
   device, file='dust_param_lognormal.model_lognorm_own.2.'+models[imod]+'.ps', /color, $
    /helvetica, font_size=14, xsize=42, ysize=14
   !p.font=0

;  tau
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, $
    position=[.05,.225,.3,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='MEE [m!E2!N g!E-1!N]'
   loadct, 70
   nl = 51
   exp_levels, nl, [0.,0.6,3.0], x, levels
   colors=240-indgen(nl)*(240.-20.)/(nl-1)
   plotgrid, reform(mee_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f4.2)')
   makekey, .05, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.05,.225,.3,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title =''
   loadct, 70
   makekey, .05, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors
;  contour overplot the 90 and 95 dust mass coverage
   loadct, 0
   contour, /over, mfr_table[imod,*,*]/max(mfr_table), vmd, sig, $
    levels =[.9,.95, .99], c_linestyle=[2,1,0], c_thick=[3,3,3]

goto, jump
;  co-albedo
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.375,.225,.625,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='Co-Albedo'
   loadct, 70
   levels = findgen(51)*.004
   colors = 240 - findgen(51)*(240-20)/50.
   plotgrid, reform(1.-ssa_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f5.3)')
   makekey, .375, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.375,.225,.625,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title =''
   loadct, 70
   makekey, .375, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors



;  forcing
   loadct, 0
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.7,.225,.95,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title ='Relative Forcing'
   loadct, 70
   levels = -3.+findgen(51)*.06
   colors = 240 - findgen(51)*(240-20)/50.
   plotgrid, reform(frc_table[imod,*,*]), levels, colors, vmd+.005, sig+.005, .01, .01
   loadct, 0
   levarr = make_array(n_elements(levels),val=' ')
   a = [0,12,25,38,50]
   levarr[a] = string(levels[a],format='(f5.2)')
   makekey, .7, .075, .25, .05, 0, -0.05, align=0, /noborder, $
    labels=levarr, colors=make_array(n_elements(levels),val=0)
   contour, tau_table[imod,*,*], vmd, sig, /nodata, /noerase, $
    position=[.7,.225,.95,.925], $
    xtitle='VMD [!9m!3m]', xrange=[1.5,5], xstyle=1, $
    ytitle='!9s!3', yrange=[1.5,2.5], ystyle=1, $
    title =''
   loadct, 70
   makekey, .7, .075, .25, .05, -0.05, 0, /noborder, $
    labels=make_array(n_elements(levels),val=' '), colors=colors
jump:

  device, /close

 endfor
skipplot:

; Some kind of synthesis figure
  set_plot, 'ps'
  device, file='dust_param_lognormal.models_lognorm_own.ps', /helvetica, font_size=14, $
   xsize=42, ysize=14, /color
  !p.font=0

; Exclude NAAPS, we'll include by hand
  nm = n_elements(models)
  tau_table = tau_table[0:nm-2,*,*]
  models = models[0:nm-2]

; sort by AOD (common mode VMD = 3.5, SIG = 2)
  i = where(VMD eq 3.5)
  j = where(SIG eq 2.0)
  a = reverse(sort(tau_table[*,i,j]))
;a = [3,4,0,2,5,1,6,7]
a = [7,5,6,4,0,2,3,1]
  tau = tau_table[*,i,j]
  mee = mee_table[*,i,j]
  ssa = ssa_table[*,i,j]
  frc = frc_table[*,i,j]

  tau_pre = tau_table_pre[*,0]
  mee_pre = mee_table_pre[*,0]
  ssa_pre = ssa_table_pre[*,0]
  frc_pre = frc_table_pre[*,0]

; dither about some values
  k = where(VMD eq 2.5)
  l = where(VMD eq 4.5)
  tau2 = tau_table[*,k,j]
  mee2 = mee_table[*,k,j]
  ssa2 = ssa_table[*,k,j]
  frc2 = frc_table[*,k,j]
  tau3 = tau_table[*,l,j]
  tau3 = tau_table[*,l,j]
  mee3 = mee_table[*,l,j]
  ssa3 = ssa_table[*,l,j]
  frc3 = frc_table[*,l,j]
  m = where(SIG eq 1.7)
  n = where(SIG eq 2.3)
  tau4 = tau_table[*,i,m]
  mee4 = mee_table[*,i,m]
  ssa4 = ssa_table[*,i,m]
  frc4 = frc_table[*,i,m]
  tau5 = tau_table[*,i,n]
  mee5 = mee_table[*,i,n]
  ssa5 = ssa_table[*,i,n]
  frc5 = frc_table[*,i,n]

  plotit, a, models, tau, tau2, tau3, tau4, tau5, tau_pre, $
                     ssa, ssa2, ssa3, ssa4, ssa5, ssa_pre, $
                     frc, frc2, frc3, frc4, frc5, frc_pre

jump2:
  device, /close

end
