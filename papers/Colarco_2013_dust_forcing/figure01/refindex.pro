; Colarco, April 2013
; Plot the refractive indices used in our simulations

; Tau
  set_plot, 'ps'
  device, file='refindex.omi.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /encapsulated
  !p.font=0
  !P.multi = [0,1,2]
  loadct, 39
  opticsdir = '/Users/pcolarco/sandbox/radiation/x/'
  readoptics, opticsdir+'carma_optics_DU.v1.nbin=08.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_OPAC, refimag_OPAC
  readoptics, opticsdir+'carma_optics_DU.v10.nbin=08.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_OBS, refimag_OBS
  readoptics, opticsdir+'carma_optics_DU.v5.nbin=08.nc', reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal_SF, refimag_SF
  x = lambda*1e6
  plot, x, refreal_OPAC[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='Real Part', $
        title='Refractive Index', $
        xrange=[.2,40], yrange=[1,3.5], xstyle=1, /xlog
  oplot, x, refreal_OPAC, thick=6, color=254
  oplot, x, refreal_OBS, thick=6, color=208
  oplot, x, refreal_SF, thick=6, color=84

; superimpose OMI/AERONET points
  lambda2 = [0.354,0.388,0.44,  0.55,  0.675, 0.87,  1.02]
  refr2   = [1.53, 1.53, 1.494, 1.498, 1.505, 1.486, 1.470]
  refi2   = [0.007,0.005,0.0037,0.0024,0.0019,0.0019,0.002]
  plots, lambda2, refr2, psym=4


  lambda_h  = [0.290, 0.315, 0.345, 0.380, 0.420, 0.460, 0.500, 0.545, 0.605, 0.665, 0.720, $
                0.765, 0.825, 0.935, 1.050, 1.145, 1.264, 1.585, 1.885, 2.255, 2.645, 3.165, 3.710]
  refimag_h = [.0207, .0185, .0165, .0025, .0015, .0013, .0012, .0011, .0010, .0010, .0009, $
               .0009, .0008, .0008, .0007, .0006, .0007, .0008, .0011, .0020, .0054, .0151, .0389]
  refreal_h = [1.519, 1.528, 1.527, 1.516, 1.512, 1.515, 1.516, 1.517, 1.517, 1.517, 1.517, $
               1.518, 1.518, 1.519, 1.519, 1.519, 1.519, 1.518, 1.518, 1.518, 1.518, 1.518, 1.518]
  oplot, lambda_h, refreal_h, thick=6, color=26


  fac = 1.5
  plots, [.3,.45], fac*1.4 + 1, thick=6, color=254
  plots, [.3,.45], fac*1.3 + 1, thick=6, color=84
  plots, [.3,.45], fac*1.2 + 1, thick=6, color=208
  plots, [.3,.45], fac*1.1 + 1, thick=6, color=26
  xyouts, .5, fac*1.38 + 1, 'OPAC'
  xyouts, .5, fac*1.28 + 1, 'SF'
  xyouts, .5, fac*1.18 + 1, 'OBS'
  xyouts, .5, fac*1.08 + 1, 'Haapanala et al. (2012) Table 1'

  plot, x, refreal_OPAC[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='Imaginary Part', $
        xrange=[.2,40], yrange=[.0005,1.5], xstyle=1, /xlog, /ylog, ystyle=1
  oplot, x, refimag_OPAC, thick=6, color=254
  oplot, x, refimag_OBS, thick=6, color=208
  oplot, x, refimag_SF, thick=6, color=84
  oplot, lambda_h, refimag_h, thick=6, color=26
  plots, lambda2, refi2, psym=4


  device, /close

end
