; Colarco, April 2013
; Plot the refractive indices used in our simulations

; Tau
  set_plot, 'ps'
  device, file='refindex.imag.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=8, /encapsulated
  !p.font=0

  opticsdir = '/home/colarco/sandbox/radiation/x/'
  readoptics, opticsdir+'optics_OC.v1_4.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_OPAC, refimag_OPAC
  readoptics, opticsdir+'optics_OC.v5_5.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_HT2C4, refimag_HT2C4
  readoptics, opticsdir+'optics_OC.v7_5.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_HT2C5, refimag_HT2C5
  readoptics, opticsdir+'optics_OC.v3_5.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_Kirch, refimag_Kirch
  x = lambda*1e6

  plot, x, refreal_OPAC[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='Imaginary Part', $
        title = 'Refractive Index', $
        xrange=[.2,1], yrange=[.001,1], xstyle=1, /xlog, /ylog, ystyle=1, $
        xticks=8, xtickv=.2+findgen(9)*.1, $
        xtickn=['0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
  loadct, 0
  polyfill, [.354,.388,.388,.354,.354],[.006,.005,.048,.058,.006], color=200
  plots, [.354,.388], [.006,.005], thick=3, color=160
  plots, [.354,.388], [.012,.010], thick=3, color=160
  plots, [.354,.388], [.024,.020], thick=3, color=160
  plots, [.354,.388], [.036,.030], thick=3, color=160
  plots, [.354,.388], [.048,.040], thick=3, color=160
  plots, [.354,.388], [.058,.048], thick=3, color=160
  polyfill, [.22,.245,.245,.22,.22], [.002,.002,.0028,.0028,.002], color=200
  plots, [.22,.245], [.00235,.00235], color=160, thick=3
  xyouts, .25, .0021, 'OMI Absorbing Smoke Models'

  loadct, 39
  oplot, x, abs(refimag_OPAC), thick=6, color=208
  oplot, x, abs(refimag_HT2C4), thick=6, color=84
  oplot, x, abs(refimag_HT2C5), thick=6, color=0
  oplot, x, abs(refimag_Kirch), thick=6, color=254
  loadct, 39

  fac = 1.5
  plots, [.22,.245], 10^(-3+.95*3), thick=6, color=208
  plots, [.22,.245], 10^(-3+.90*3), thick=6, color=84
  plots, [.22,.245], 10^(-3+.85*3), thick=6, color=0
  plots, [.22,.245], 10^(-3+.80*3), thick=6, color=254
  xyouts, .25, 10^(-3+.93*3), 'OPAC'
  xyouts, .25, 10^(-3+.88*3), 'Hammer et al. 2015 (!9r!3 = 1.8 g cm!E-3!N, BrC/POC = 0.5)'
  xyouts, .25, 10^(-3+.83*3), 'Hammer et al. 2015 (!9r!3 = 1.8 g cm!E-3!N, BrC/POC = 1.0)'
  xyouts, .25, 10^(-3+.78*3), 'Kirchstetter et al. 2004'

  device, /close

end
