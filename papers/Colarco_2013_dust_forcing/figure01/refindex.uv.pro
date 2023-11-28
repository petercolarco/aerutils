; Colarco, April 2013
; Plot the refractive indices used in our simulations

; Tau
  set_plot, 'ps'
  device, file='refindex.uv.eps', /color, font_size=10, /helvetica, $
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
        xrange=[.2,.5], yrange=[.001,.01], xstyle=1, /xlog, /ylog, ystyle=1
  oplot, x, refimag_OPAC, thick=6, color=254
  oplot, x, refimag_OBS, thick=6, color=208
  oplot, x, refimag_SF, thick=6, color=84
  oplot, lambda_h, refimag_h, thick=6, color=26
  plots, x, refimag_OBS, psym=3
  lambda2 = [0.331,0.360,0.44,  0.55,  0.675, 0.87,  1.02]
  refi2   = [0.006,0.005,0.0037,0.0024,0.0019,0.0019,0.002]
  plots, lambda2, refi2, psym=4
; Linear interpolation of optics files to OMI lambda
  lambda3 = [.354,.388]
  y = interpol(refimag_obs[*,0,0], x, lambda3)
  plots, lambda3, y, psym=5

  gadsfile = 'miam00'
  readref, gadsfile, lambda, refReal_, refImag_

     openr, lun, './levoni.txt', /get_lun
     str = 'a'
     readf, lun, str
     readf, lun, str
     data = fltarr(3,59)
     readf, lun, data
     free_lun, lun
     refreal_ = interpol(data[1,*],data[0,*],lambda)
     refimag_ = abs(interpol(data[2,*],data[0,*],lambda))
;    Wavelengths from Colarco (Dakar) and Kim
     lambda2 = [0.331,0.360,0.44,  0.55,  0.675, 0.87,  1.02]
     refr2   = [1.55, 1.55, 1.494, 1.498, 1.505, 1.486, 1.470]
     refi2   = [0.006,0.005,0.0037,0.0024,0.0019,0.0019,0.002]
;    Use a power-law logarithmic interpolation to baseline wavelengths
     lam   = [lambda2,lambda[where(lambda ge 2. and lambda le 3.)]]
     refre = [refr2,refreal_[where(lambda ge 2. and lambda le 3.)]]
     refim = [refi2,refimag_[where(lambda ge 2. and lambda le 3.)]]
     val   = poly_fit(alog(lam),refim,2)
     int   = val[0] + val[1]*alog(lambda) + val[2]*alog(lambda)^2.
     int354 = val[0] + val[1]*alog(.354) + val[2]*alog(.354)^2.
     int388 = val[0] + val[1]*alog(.388) + val[2]*alog(.388)^2.
     refimag_[where(lambda le 3.)] = int[where(lambda le 3.)]
     plots, .354, int354, psym=6
     plots, .388, int388, psym=6

  device, /close

end
