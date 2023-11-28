  pro mfrac, diam, dm, xmin, xmax, mfrac, afrac
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
;print, n_elements(a)
;print, ' '
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
  c = where(diam gt 10.)
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
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_table[0,0] = total(mfrac*mee)
  ssa_table[0,0] = total(mfrac*mee*ssa)/tau_table[0,0]
  mfr_table[0,0] = total(mfrac)
  afr_table[0,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_table[0,1] = total(mfrac*mee)
  ssa_table[0,1] = total(mfrac*mee*ssa)/tau_table[0,1]
  mfr_table[0,1] = total(mfrac)
  afr_table[0,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac), format='(9(f6.4,1x))'
  tau_table[0,2] = total(mfrac*mee)
  ssa_table[0,2] = total(mfrac*mee*ssa)/tau_table[0,2]
  mfr_table[0,2] = total(mfrac)
  afr_table[0,2] = total(afrac)
stop

; MONARCH
  imod = 2
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  mee =[1.90,3.24,2.93,1.55,0.73,0.41,0.22,0.11]
  ssa =[0.98,0.99,0.99,0.97,0.95,0.93,0.90,0.85]
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

; AM4
  imod = 1
  y = 8-imod
  xmin=[0.2,2,3.6,6,12]
  xmax=20
  mee =[1.86,0.54,0.28,0.15,0.08]
  ssa =[0.97,0.91,0.86,0.79,0.7]
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

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
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

; IFS
  imod = 4
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  mee = [2.5,0.95,0.4]
  ssa = [0.96,0.90,0.83]
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

; SILAM
  imod = 5
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  mee = [2.497,0.827,0.240,0.067]
  ssa = [0.968,0.893,0.778,0.700]
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

; UM
  imod = 6
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  mee = [0.702,0.141]
  ssa = [0.962,0.871]
  mfrac, diam, dm, xmin, xmax, mfrac, afrac
print, mfrac, total(mfrac)
  tau_table[imod,0] = total(mfrac*mee)
  ssa_table[imod,0] = total(mfrac*mee*ssa)/tau_table[imod,0]
  mfr_table[imod,0] = total(mfrac)
  afr_table[imod,0] = total(afrac)
  mfrac, diam[0:230], dv, xmin, xmax, mfrac, afrac
  tau_table[imod,1] = total(mfrac*mee)
  ssa_table[imod,1] = total(mfrac*mee*ssa)/tau_table[imod,1]
  mfr_table[imod,1] = total(mfrac)
  afr_table[imod,1] = total(afrac)
  mfrac, diam[0:230], dv_, xmin, xmax, mfrac, afrac
  tau_table[imod,2] = total(mfrac*mee)
  ssa_table[imod,2] = total(mfrac*mee*ssa)/tau_table[imod,2]
  mfr_table[imod,2] = total(mfrac)
  afr_table[imod,2] = total(afrac)

;  mee_table[*,0] = tau_table[*,0]/total(dm)
;  mee_table[*,1] = tau_table[*,1]/total(dv)
  mee_table = tau_table/mfr_table

end
