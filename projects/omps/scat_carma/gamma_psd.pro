; parameters and radii in microns
  alpha = 1.8
  beta  = 20.5
  nbin  = 1000
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
; Put rmin in microns
  rmin = rmin * 1e6
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow

; Gamma distribution
  n = (beta^alpha)*r^(alpha-1.)*exp(-r*beta) / gamma(alpha)
  dndr = n

  set_plot, 'ps'
  device, file='gamma_psd.ps', /helvetica, font_size=14, $
   xs=24, ys=12, xoff=.5, yoff=.5
  !p.font=0
  !p.multi=[0,2,1]

  ncum = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   ncum[ibin] = total(n[ibin:nbin-1])
  endfor
  ncum = ncum/ncum[0]
  plot, r, ncum, /xlog, xrange=[0.01,1], $
        /ylog, yrange=[1e-6,10], ystyle=1, $
        xtitle='radius [!Mm!Nm]', ytitle='N/N0', $
        ytickn=['1e-6','1e-5','1e-4','1e-3','1e-2','1e-1','1','10'], yminor=9

  plot, r, dndr*r/max(dndr*r), /xlog, xrange=[0.01,2], $
        /ylog, yrange=[1e-6,10], ystyle=1, xstyle=1, $
        xtitle='radius [!Mm!Nm]', ytitle='dN/dlogr', $
        ytickn=['1e-6','1e-5','1e-4','1e-3','1e-2','1e-1','1','10'], yminor=9

  device, /close

end
