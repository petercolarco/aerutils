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
  device, file='dust_lognormal_param.psd.ps', /color, /helvetica, font_size=18, $
   xsize=18, ysize=14
  !p.font=0

  loadct, 39
  plot, indgen(10)+1, thick=18, /nodata, $
   xrange=[0.1,40], xstyle=9, /xlog, xthick=3, $
   yrange=[0.0001,2], ystyle=9,  ythick=3, /ylog, $
   xtitle='diameter [!Mmm]', ytitle='dM/d(ln d) [normalized]', $
   position=[.2,.15,.95,.95]

; Get the candidate longormal distributions
  nbin = 100
  rmrat = (100./0.001d)^(3.d/(nbin-1))
  rmin  = 0.001
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
  diam = r*2.

  vmd = 2.5
  sig = 2.
  lognormal, vmd/2., sig, 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=84

  vmd = 4.5
  lognormal, vmd/2., sig, 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=148

  loadct, 0
  vmd = 3.5
  lognormal, vmd/2., sig, 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=160

  sig=1.7
  lognormal, vmd/2., sig, 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=160, lin=1

  sig=2.3
  lognormal, vmd/2., sig, 1., $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=160, lin=2
 
  rmed = [0.27,1.6,11.]
  sigma = [1.95,2.0,2.15]
  frac = [7.5,168.7,45.6]
  frac = frac/total(frac)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, /vol, rlow=rlow, rup=rup
  dm = dvdr*dr
  dm = dm*1.695
  oplot, diam, dm/max(dm), thick=18, color=100



  device, /close

end
