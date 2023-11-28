; Plot refractive indices for different dust models

  set_plot, 'ps'
  device, file='plot_nref.real.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[.25,40], xstyle=1, /xlog, xtitle='lambda [!Mm!Nm]', $
   yrange=[1,3], ystyle=1, ytitle='Real Part', yticks=4, ymin=2

  xyouts, .01, 0.95, /normal, '(a)'

  loadct, 39

; OPAC
  filedir = './'
  filename = 'integ-du_opac_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, refreal[*,0,0], thick=8

; GEOS
  filename = 'integ-du_v15_6_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=84, lin=2


; Woodward
  filename = 'integ-du_woodward_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=208

; Balkanski
  filename = 'integ-du_balkanski_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=254

; Balkanski
  filename = 'integ-du_balkanski27_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=48, lin=2

  xyouts, .3, 2.85, '!4OPAC !3(Hess et al. 1998)'
  xyouts, .3, 2.60, '!4Colarco et al. !3(2014)', color=84
  xyouts, .3, 2.35, '!4Woodward !3(2001)', color=208
  xyouts, .3, 2.10,  '!4Balkanski 1.5% !3(2007)', color=254
  xyouts, .3, 1.85,  '!4Balkanski 2.7% !3(2007)', color=48

  xyouts, .3, 2.75, '!3MONARCH (LW), SILAM, MASINGAR, NAAPS', chars=.8
  xyouts, .3, 2.50, 'GEOS, GEFS, ~ModelE (SW)', chars=.8
  xyouts, .3, 2.25, 'IFS', chars=.8
  xyouts, .3, 2.00, 'UM, ~MONARCH (SW)', chars=.8
  xyouts, .3, 1.75, 'AM4', chars=.8

  device, /close

end
