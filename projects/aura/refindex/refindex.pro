; Colarco, April 2013
; Plot the refractive indices used in our simulations

; Tau
  set_plot, 'ps'
  device, file='refindex.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /encapsulated
  !p.font=0
  !P.multi = [0,1,2]
  loadct, 39
  opticsdir = '/home/colarco/sandbox/radiation/x/'
  readoptics, opticsdir+'optics_OC.v1_4.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_OPAC, refimag_OPAC
  readoptics, opticsdir+'optics_OC.v5_5.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_HT2C4, refimag_HT2C4
  readoptics, opticsdir+'optics_OC.v7_5.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_HT2C5, refimag_HT2C5
  x = lambda*1e6
  plot, x, refreal_OPAC[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='Real Part', $
        title='Refractive Index', $
        xrange=[.2,1], yrange=[1,3.5], xstyle=1, /xlog

  loadct, 39

  oplot, x, refreal_OPAC, thick=6, color=208
  oplot, x, refreal_HT2C4, thick=6, color=84
  oplot, x, refreal_HT2C5, thick=6, color=0

  loadct, 0
  oplot, [.354,.388], [1.5,1.5], thick=6, color=160

  loadct, 39
  fac = 1.5
  plots, [.22,.245], fac*1.4 + 1, thick=6, color=208
  plots, [.22,.245], fac*1.3 + 1, thick=6, color=84
  plots, [.22,.245], fac*1.2 + 1, thick=6, color=0
  xyouts, .25, fac*1.36 + 1, 'OPAC'
  xyouts, .25, fac*1.26 + 1, 'Hammer et al. 2015 (!9r!3 = 1.8 g cm!E-3!N, BrC/POC = 0.5)'
  xyouts, .25, fac*1.16 + 1, 'Hammer et al. 2015 (!9r!3 = 1.8 g cm!E-3!N, BrC/POC = 1.0)'

  plot, x, refreal_OPAC[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='Imaginary Part', $
        xrange=[.2,1], yrange=[.0005,1.5], xstyle=1, /xlog, /ylog, ystyle=1
  loadct, 0
  polyfill, [.354,.388,.388,.354,.354],[.006,.005,.048,.058,.006], color=200
  plots, [.354,.388], [.006,.005], thick=3, color=160
  plots, [.354,.388], [.012,.010], thick=3, color=160
  plots, [.354,.388], [.024,.020], thick=3, color=160
  plots, [.354,.388], [.036,.030], thick=3, color=160
  plots, [.354,.388], [.048,.040], thick=3, color=160
  plots, [.354,.388], [.058,.048], thick=3, color=160

  loadct, 39
  oplot, x, abs(refimag_OPAC), thick=6, color=208
  oplot, x, abs(refimag_HT2C4), thick=6, color=84
  oplot, x, abs(refimag_HT2C5), thick=6, color=0

  device, /close

end
