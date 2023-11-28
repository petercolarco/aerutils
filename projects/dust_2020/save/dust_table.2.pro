  pro mfrac, diam, dm, xmin, xmax, mfrac, afrac, tl96=tl96
   nbin = n_elements(xmin)
   mfrac = fltarr(nbin)
   afrac = fltarr(nbin)
   for ibin = 0, nbin-2 do begin
    a = where(diam ge xmin[ibin] and diam lt xmin[ibin+1])
    mfrac[ibin] = total(dm[a])
    afrac[ibin] = total(dm[a]/diam[a])
;print, n_elements(a)
   endfor
   ibin = nbin-1
   a = where(diam ge xmin[ibin] and diam le xmax)
   mfrac[ibin] = total(dm[a])
   afrac[ibin] = total(dm[a]/diam[a])

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


  pro compute_model, name, diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
                     tau_, ssa_, mfr_, afr_

  tau_ = fltarr(3)
  ssa_ = fltarr(3)
  mfr_ = fltarr(3)
  afr_ = fltarr(3)

  device, file='dust_table.2.'+name+'.ps', /color, /helvetica, font_size=18, $
   xsize=24, ysize=13.5, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, indgen(10), /nodata, $
   xrange=[0.1,40], /xlog, xstyle=9, xtitle='diameter [!Mm!Nm]', xthick=3, $
   yrange=[0,1], ystyle=9, thick=3, $
   ytitle='AOD!D550 nm!N', ythick=3, $
   title=name, $
   position=[.1,.12,.85,.92]

  nbin = n_elements(diam)
  nbin_ = n_elements(xmin)

; If GEOS then read table and get asymmetry parameter at 550 nm
  if(name eq 'GEOS') then begin
   filename = '/misc/prc10/colarco/radiation/geosMie/DU/optics_DU.input.v15_6.nc'
   readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
               rh, rmass, refreal, refimag
   g = reform(g[5,0,*])
  end

  tl96 = 0
  if(name eq 'GEOS' or name eq 'ModelE') then tl96 = 1

  mfrac, diam, dm, xmin, xmax, mfrac, afrac, tl96=tl96
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_[0] = total(mfrac*mee)
  ssa_[0] = total(mfrac*mee*ssa)/tau_[0]
  mfr_[0] = total(mfrac)
  afr_[0] = total(afrac)
if(name eq 'GEOS') then print, 'ASYM0 = ', total(g*mfrac*mee*ssa)/total(mfrac*mee*ssa)
  for ibin = 0, nbin_-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mfrac[ibin]*mee[ibin], $
    thick=24, color=84, noclip=0
   plots,[xmin[ibin+1],xmin[ibin+1]], $
    [mfrac[ibin]*mee[ibin],mfrac[ibin+1]*mee[ibin+1]], $
    thick=24, color=84, noclip=0
  endfor
  plots, [xmin[nbin_-1],xmax], mfrac[nbin_-1]*mee[nbin_-1], thick=24, color=84

  mfrac, diam[0:nbin-2], dv, xmin, xmax, mfrac, afrac, tl96=tl96
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_[1] = total(mfrac*mee)
  ssa_[1] = total(mfrac*mee*ssa)/tau_[1]
  mfr_[1] = total(mfrac)
  afr_[1] = total(afrac)
if(name eq 'GEOS') then print, 'ASYM1 = ', total(g*mfrac*mee*ssa)/total(mfrac*mee*ssa)
  for ibin = 0, nbin_-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mfrac[ibin]*mee[ibin], $
    thick=24, color=148, noclip=0
   plots,[xmin[ibin+1],xmin[ibin+1]], $
    [mfrac[ibin]*mee[ibin],mfrac[ibin+1]*mee[ibin+1]], $
    thick=24, color=148, noclip=0
  endfor
  plots, [xmin[nbin_-1],xmax], mfrac[nbin_-1]*mee[nbin_-1], thick=24, color=148

  loadct, 0
  mfrac, diam[0:nbin-2], dv_, xmin, xmax, mfrac, afrac, tl96=tl96
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_[2] = total(mfrac*mee)
  ssa_[2] = total(mfrac*mee*ssa)/tau_[2]
  mfr_[2] = total(mfrac)
  afr_[2] = total(afrac)
if(name eq 'GEOS') then print, 'ASYM2 = ', total(g*mfrac*mee*ssa)/total(mfrac*mee*ssa)
  for ibin = 0, nbin_-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mfrac[ibin]*mee[ibin], $
    thick=10, color=0, lin=0, noclip=0
   plots,[xmin[ibin+1],xmin[ibin+1]], $
    [mfrac[ibin]*mee[ibin],mfrac[ibin+1]*mee[ibin+1]], $
    thick=10, color=0, lin=0, noclip=0
  endfor
  plots, [xmin[nbin_-1],xmax], mfrac[nbin_-1]*mee[nbin_-1], $
   thick=10, color=0, lin=0

  device, /close
  end

  set_plot, 'ps'
  device, file='dust_table.psd.ps', /color, /helvetica, font_size=18, $
   xsize=18, ysize=14
  !p.font=0

  loadct, 39

; given the per bin mee and ssa use PSDs imposed on bins to compute
; AOD and SSA integrated. Use NAAPS to set the total mass load

  tau_table = fltarr(8,3)
  mee_table = fltarr(8,3)
  mfr_table = fltarr(8,3)
  afr_table = fltarr(8,3)
  ssa_table = fltarr(8,3)

; Get the Kok PSD from Nature 2017 Figure 2b
  read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2
; the bin spacing is approximately logarithmic, therefore the dlnd is
; a constant factor and can be ignored; i.e., dm ~ dmdlnd
; Only need to tune the total amount. Use NAAPS to adjust
  dm = dmdlnd
  naaps_mee = 0.59 ; [m2 g-1]
  a = where(diam ge 0.2 and diam le 10.)
  b = where(diam lt 0.2)
  c = where(diam gt 20.)
  tau = total(dm[a])*naaps_mee
  dm = dm/tau
  print, 'Kok:   ', total(dm[a]), total(dm), total(dm[a])/total(dm), $
                    total(dm[b])/total(dm), total(dm[c])/total(dm)
  mfr_table[6,0] = total(dm[a])
  afr_table[6,0] = total(dm[a]/diam[a])
  plot, diam, dm*2600./diam, thick=18, /nodata, $
   xrange=[0.1,40], xstyle=9, /xlog, xthick=3, $
;   yrange=[.01,100], ystyle=9, /ylog, ythick=3, $
   yrange=[0,1], ystyle=9,  ythick=3, $
   xtitle='diameter [!Mmm]', ytitle='dM/d(ln d) [normalized]'
  oplot, diam, dm/max(dm), thick=18, color=84
  
; Now use the mix from OPAC DESE model per Hess 1998, only the mineral
; part -- use Kok sub-bin for radius, pretend that dv = mass
  r  = diam/2.
  dr = diam[1:231]-diam[0:230]
  dr = [dr,dr[230]]
  rlow = r[0:230]
  rup  = r[1:231]
  rmed = [0.27,1.6,11.]
  sigma = [1.95,2.0,2.15]
  frac = [7.5,168.7,45.6]
  frac = frac/total(frac)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, /vol, rlow=rlow, rup=rup
  dv = dvdr*(rup-rlow)
  a = where(diam ge 0.2 and diam le 10.)
  tau = total(dv[a])*naaps_mee
  dv = dv/tau
  print, 'OPAC:  ', total(dv[a]), total(dv), total(dv[a])/total(dv), $
                    total(dv[b])/total(dv), total(dv[c])/total(dv)
  mfr_table[6,1] = total(dv[a])
  afr_table[6,1] = total(dv[a]/diam[a])
  oplot, r*2., dv/max(dv), thick=18, color=148

; Now use the MODIS over ocean retrieved PSD
  loadct, 0
  rmed = [0.294,1.7668]
  sigma = exp([0.6,0.6])
  frac = [.021166,4.572]
  frac = frac/total(frac)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, /vol, rlow=rlow, rup=rup
  dv_ = dvdr*(rup-rlow)
  a = where(diam ge 0.2 and diam le 10.)
  tau = total(dv_[a])*naaps_mee
  dv_ = dv_/tau
  print, 'MODIS: ', total(dv_[a]), total(dv_), total(dv_[a])/total(dv_), $
                    total(dv_[b])/total(dv_), total(dv_[c])/total(dv_)
  mfr_table[6,2] = total(dv_[a])
  afr_table[6,2] = total(dv_[a]/diam[a])
  oplot, r*2., dv_/max(dv_), thick=18, color=148


  device, /close

; truncate all here in 0.2 - 10 um diameter range
  dm = dm[a]
  dv = dv[a]
  dv_ = dv_[a]
  diam = diam[a]
  nbin = n_elements(diam)

  models = ['GEOS/GEFS','AM4','MONARCH','ModelE','IFS','SILAM','UM','NAAPS']

; GEOS (8-bin)
  imod = 0
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
; I'm not sure the origin of these two lines; not consistent
; with other calculations I'm doing
;  mee =[4.466,5.155,2.948,1.273,0.644,0.334,0.167,0.084]
;  ssa =[0.984,0.984,0.970,0.940,0.918,0.886,0.833,0.767]
  mee = [3.018,4.262,3.013,1.229,0.615,0.320,0.165,0.084]
  ssa = [0.983,0.985,0.977,0.947,0.918,0.878,0.824,0.758]
  compute_model, 'GEOS', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_

; MONARCH
  imod = 2
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  mee =[1.90,3.24,2.93,1.55,0.73,0.41,0.22,0.11]
  ssa =[0.98,0.99,0.99,0.97,0.95,0.93,0.90,0.85]
  compute_model, 'MONARCH', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


; AM4
  imod = 1
  y = 8-imod
  xmin=[0.2,2,3.6,6,12]
  xmax=20
  mee =[1.86,0.54,0.28,0.15,0.08]
  ssa =[0.97,0.91,0.86,0.79,0.7]
  compute_model, 'AM4', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


; NAAPS
  imod = 7
  y = 8-imod
  mee = 0.59
  ssa = 0.88
;  plots, 5, mee, psym=sym(4), color=0, symsize=3
  tau_table[imod,*] = 1.
  ssa_table[imod,*] = ssa

; ModelE
  imod = 3
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,4,8,16]
  xmax=32
  mee =[ 4.41328223, 4.50481353, 2.91262658, 1.37943336, $
         0.64098967, 0.30904944, 0.1748042,  0.10046726]
  ssa =[ 0.96982508, 0.97209664, 0.95649694, 0.92296147, $
         0.88139104, 0.82315414, 0.75583888, 0.69754465]
  compute_model, 'ModelE', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


; IFS
  imod = 4
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  mee = [2.5,0.95,0.4]
  ssa = [0.96,0.90,0.83]
  compute_model, 'IFS', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


; SILAM
  imod = 5
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  mee = [2.497,0.827,0.240,0.067]
  ssa = [0.968,0.893,0.778,0.700]
  compute_model, 'SILAM', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


; UM
  imod = 6
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  mee = [0.702,0.141]
  ssa = [0.962,0.871]
  compute_model, 'UM', diam, dm, dv, dv_, xmin, xmax, mee, ssa, $
   tau_, ssa_, mfr_, afr_
  tau_table[imod,*] = tau_
  ssa_table[imod,*] = ssa_
  mfr_table[imod,*] = mfr_
  afr_table[imod,*] = afr_


;  mee_table[*,0] = tau_table[*,0]/total(dm)
;  mee_table[*,1] = tau_table[*,1]/total(dv)
  mee_table = tau_table/mfr_table


; Make a total plot
  set_plot, 'ps'
  device, file='dust_table.2.summary.ps', /helvetica, font_size=14, $
   xsize=42, ysize=14
  !p.font=0

; sort by AOD and put NAAPS last
  a = reverse(sort(tau_table[*,1]))
  b = a
  a[6] = b[7]
  a[7] = b[6]

  loadct, 39
  plot, tau_table[a,0], /nodata, $
   xrange=[0,7], yrange=[0.5,1.75], $
   xstyle=1, ystyle=1, xticks=7, yticks=5, $
   ytitle='"Normalized" AOD', $
   position=[.05,.25,.3,.95], xtickname=make_array(8,val=' ')
  xyouts, indgen(8)-0.1, .45, models[a], $
   orientation=-90, align=0
  oplot, tau_table[a,0], thick=12, color=84
  plots, indgen(8), tau_table[a,0], psym=sym(1), color=84, symsize=1.5
  oplot, tau_table[a,1], thick=12, color=148
  plots, indgen(8), tau_table[a,1], psym=sym(1), color=148, symsize=1.5
  xyouts, 5, 1.65, 'Kok', color=84, /data
  xyouts, 5, 1.58, 'OPAC', color=148, /data
  loadct, 0
  oplot, tau_table[a,2], thick=12, color=160
  plots, indgen(8), tau_table[a,2], psym=sym(1), color=160, symsize=1.5
  xyouts, 5, 1.51, 'MODIS', color=160, /data

; Co-albedo
  loadct, 39
  plot, tau_table[a,0], /nodata, /noerase, $
   xrange=[0,7], yrange=[0,0.16], $
   xstyle=1, ystyle=1, xticks=7, yticks=4, $
   ytitle='Co-Albedo', $
   position=[.375,.25,.625,.95], xtickname=make_array(8,val=' ')
  xyouts, indgen(8)-0.1, -0.0064, models[a], $
   orientation=-90, align=0
  oplot, 1.-ssa_table[a,0], thick=12, color=84
  plots, indgen(8), 1.-ssa_table[a,0], psym=sym(1), color=84, symsize=1.5
  oplot, 1.-ssa_table[a,1], thick=12, color=148
  plots, indgen(8), 1.-ssa_table[a,1], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, 1.-ssa_table[a,2], thick=12, color=160
  plots, indgen(8), 1.-ssa_table[a,2], psym=sym(1), color=160, symsize=1.5

; Calculate forcing after Chylek and Wong (1995)
  albedo = 0.06
  gasym  = [0.754, 0.738, 0.751]
  upfrac = (1.-gasym/2.)/2.
  fac1   = (1.-albedo)^2.*2.*upfrac
  fac2   = 4.*albedo
  force  = fltarr(8,3)
  force[*,0] = -(fac1[0]*tau_table[*,0]*ssa_table[*,0]-fac2*(1.-ssa_table[*,0])*tau_table[*,0])
  force[*,1] = -(fac1[1]*tau_table[*,1]*ssa_table[*,1]-fac2*(1.-ssa_table[*,1])*tau_table[*,1])
  force[*,2] = -(fac1[2]*tau_table[*,2]*ssa_table[*,2]-fac2*(1.-ssa_table[*,2])*tau_table[*,2])

  loadct, 39
  plot, tau_table[a,0], /nodata, /noerase, $
   xrange=[0,7], yrange=[-.9,-.3], $
   xstyle=1, ystyle=1, xticks=7, yticks=4, $
   ytitle='"Normalized" Forcing', $
   position=[.7,.25,.95,.95], xtickname=make_array(8,val=' ')
  xyouts, indgen(8)-0.1, -0.924, models[a], $
   orientation=-90, align=0
  oplot, force[a,0], thick=12, color=84
  plots, indgen(8), force[a,0], psym=sym(1), color=84, symsize=1.5
  oplot, force[a,1], thick=12, color=148
  plots, indgen(8), force[a,1], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, force[a,2], thick=12, color=160
  plots, indgen(8), force[a,2], psym=sym(1), color=160, symsize=1.5
  device, /close


end
