  pro   plotit, a, models, tau, tau2, tau3, tau4, tau5, tau_pre, $
                           ssa, ssa2, ssa3, ssa4, ssa5, ssa_pre, $
                           frc, frc2, frc3, frc4, frc5, frc_pre


  loadct, 39
  plot, tau[a], /nodata, $
   xrange=[-1,7], yrange=[0.5,2], $
   xstyle=1, ystyle=9, xticks=8, yticks=6, $
   ytitle='AOD', $
   position=[.05,.25,.3,.95], xtickname=make_array(9,val=' ')
  xyouts, .055, .89, /normal, '(a)', charsize=1.5
  xyouts, .405, .89, /normal, '(b)', charsize=1.5
  xyouts, .730, .89, /normal, '(c)', charsize=1.5

  xyouts, indgen(8)-0.1, .45, models[a], $
   orientation=-90, align=0
  xyouts, -0.85, .45, 'NAAPS', orientation=-90, align=0
  oplot, tau2[a], thick=12, color=84
  plots, indgen(8), tau2[a], psym=sym(1), color=84, symsize=1.5
  oplot, tau3[a], thick=12, color=148
  plots, indgen(8), tau3[a], psym=sym(1), color=148, symsize=1.5
  xyouts, .1, 1.85, 'D!IV!N = 2.5 !9m!3m', color=84, /data
  xyouts, .1, 1.71, 'D!IV!N = 4.5 !9m!3m', color=148, /data
  loadct, 0
  oplot, tau_pre[a,0], thick=12, color=100
  plots, indgen(8), tau_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, tau[a], thick=12, color=160
  plots, indgen(8), tau[a], psym=sym(1), color=160, symsize=1.5
  oplot, tau4[a], thick=12, color=160, lin=1
  oplot, tau5[a], thick=12, color=160, lin=2
  xyouts, .1, 1.78, 'D!IV!N = 3.5 !9m!3m', color=160, /data
  xyouts, .4, 1.41, '!4OPAC!3', color=100, /data
  plots, -.125, 1.4275, psym=sym(1), color=100, symsize=1.25
;  xyouts, 5.75, 1.71, '!4NAAPS!3', /data
;  plots, 5.55, 1.7375, psym=sym(5), symsize=1.25
  plots, [.1,0.75]-.6, 1.64, thick=12, color=160, lin=1
  plots, [.1,0.75]-.6, 1.57, thick=12, color=160, lin=0
  plots, [.1,0.75]-.6, 1.50, thick=12, color=160, lin=2
  xyouts, .4, 1.63, '!9s!3 = ln(1.7)', color=160, /data
  xyouts, .4, 1.56, '!9s!3 = ln(2.0)', color=160, /data
  xyouts, .4, 1.49, '!9s!3 = ln(2.3)', color=160, /data
;  plots, [0,7], 1, thick=6
  plots, -0.75, 1, psym=sym(5), symsize=1.5
  axis, yaxis=1, yrange=[.3,1.2], yticks=3, /save, $
   ytitle='MEE [m!E2!N g!E-1!N]', ystyle=1

; Co-Albedo
  loadct, 39
  plot, 1-ssa[a], /nodata, /noerase, $
   xrange=[-1,7], yrange=[0,0.2], $
   xstyle=1, ystyle=1, xticks=8, yticks=4, $
   ytitle='Co-Albedo', $
   position=[.4,.25,.65,.95], xtickname=make_array(9,val=' ')
  xyouts, indgen(8)-0.1, -0.0064, models[a], $
   orientation=-90, align=0
  xyouts, -0.85, -0.0064, 'NAAPS', orientation=-90, align=0
  oplot, 1-ssa2[a], thick=12, color=84
  plots, indgen(8), 1-ssa2[a], psym=sym(1), color=84, symsize=1.5
  oplot, 1-ssa3[a], thick=12, color=148
  plots, indgen(8), 1-ssa3[a], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, 1-ssa_pre[a,0], thick=12, color=100
  plots, indgen(8), 1-ssa_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, 1-ssa[a], thick=12, color=160
  plots, indgen(8), 1-ssa[a], psym=sym(1), color=160, symsize=1.5
  oplot, 1-ssa4[a], thick=12, color=160, lin=1
  oplot, 1-ssa5[a], thick=12, color=160, lin=2
;  plots, [0,7], .12, thick=6
  plots, -.75, .12, symsize=1.5, psym=sym(5)

; Forcing
  loadct, 39
  plot, frc[a], /nodata, /noerase, $
   xrange=[-1,7], yrange=[-1.1,-0.1], $
   xstyle=1, ystyle=1, xticks=8, yticks=5, $
   ytitle='Forcing [W m!E-2!N M!E-1!N]', $
   position=[.725,.25,.975,.95], xtickname=make_array(9,val=' ')
  xyouts, indgen(8)-0.1, -1.133, models[a], $
   orientation=-90, align=0
  xyouts, -1.1, -1.133, 'NAAPS', orientation=-90, align=0
  oplot, frc2[a], thick=12, color=84
  plots, indgen(8), frc2[a], psym=sym(1), color=84, symsize=1.5
  oplot, frc3[a], thick=12, color=148
  plots, indgen(8), frc3[a], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, frc_pre[a,0], thick=12, color=100
  plots, indgen(8), frc_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, frc[a], thick=12, color=160
  plots, indgen(8), frc[a], psym=sym(1), color=160, symsize=1.5
  oplot, frc4[a], thick=12, color=160, lin=1
  oplot, frc5[a], thick=12, color=160, lin=2
;  plots, [0,7], -.457, thick=6
  plots, -.75, -.457, symsize=1.5, psym=sym(5)
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
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
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

  lognormal, vmd[ivmd]/2., sig[isig], 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695

; GEOS (8-bin)
  imod = 0
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  mee = [3.018,4.262,3.013,1.229,0.615,0.320,0.165,0.084]
  ssa = [0.983,0.985,0.977,0.947,0.918,0.878,0.824,0.758]
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
  mee =[1.90,3.24,2.93,1.55,0.73,0.41,0.22,0.11]
  ssa =[0.98,0.99,0.99,0.97,0.95,0.93,0.90,0.85]
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
  mee =[1.1,2.6,2.7,.9,.54,.28,.15,.08]
  ssa =[0.96,0.98,0.98,0.93,0.91,0.86,0.79,0.7]
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
  mee =[ 4.41328223, 4.50481353, 2.91262658, 1.37943336, $
         0.64098967, 0.30904944, 0.1748042,  0.10046726]
  ssa =[ 0.96982508, 0.97209664, 0.95649694, 0.92296147, $
         0.88139104, 0.82315414, 0.75583888, 0.69754465]
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
  mee = [2.5,0.95,0.4]
  ssa = [0.96,0.90,0.83]
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
  mee = [2.497,0.827,0.240,0.067]
  ssa = [0.968,0.893,0.778,0.700]
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
  mee = [0.702,0.141]
  ssa = [0.962,0.871]
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
  mee = [2.07, 3.82, 3.46, 1.41, 0.88, 0.52, 0.31, 0.19, 0.12, 0.07]
  ssa = [0.97, 0.98, 0.97, 0.93, 0.90, 0.86, 0.80, 0.74, 0.67, 0.60]
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
   device, file='dust_param_lognormal.'+models[imod]+'.ps', /color, $
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
    levels =[.95,.98, .99], c_linestyle=[2,1,0], c_thick=[3,3,3]

   plots, 2.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(6), symsize=2
   plots, 3.5, 1.7, psym=sym(5)
   plots, 3.5, 2.3, psym=sym(5)
   plots, 4.5, 2.0, psym=sym(5)


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

   plots, 2.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(6), symsize=2
   plots, 3.5, 1.7, psym=sym(5)
   plots, 3.5, 2.3, psym=sym(5)
   plots, 4.5, 2.0, psym=sym(5)


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

   plots, 2.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(5)
   plots, 3.5, 2.0, psym=sym(6), symsize=2
   plots, 3.5, 1.7, psym=sym(5)
   plots, 3.5, 2.3, psym=sym(5)
   plots, 4.5, 2.0, psym=sym(5)


  device, /close




   set_plot, 'ps'
   device, file='dust_param_lognormal.2.'+models[imod]+'.ps', /color, $
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
  device, file='dust_param_lognormal.ps', /helvetica, font_size=14, $
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
