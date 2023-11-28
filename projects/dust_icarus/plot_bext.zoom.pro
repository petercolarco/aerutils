; Plot refractive indices for different dust models

; OPAC (full refractive indices)
  filedir = '/home/colarco/sandbox/radiation/x/'
  filename = 'optics_DU.v1_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  set_plot, 'ps'
  device, file='plot_bext.zoom.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 0
  plot, lambda*1d6, bext[*,0,1], /nodata, $
   xrange=[6,20], xstyle=1, /xlog, xtitle='lambda [!Mm!Nm]', $
   xticks=14, xtickv=[findgen(15)+6], $
   yrange=[0,1000], ystyle=1, $
   ytitle='Mass Extinction Efficiency [m!E2!N kn!E-1!N]'
  oplot, lambda*1e6, bext[*,0,1], thick=16, color=100, lin=2


; MERRA-2 (truncated)
  filedir = '/home/colarco/sandbox/radiation/x/'
  filename = 'optics_DU.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  loadct, 39
  oplot, lambda*1e6, bext[*,0,1], thick=8

; MERRA-2 (spheres, not_truncated)
  filename = 'optics_DU.v15_6.spheres.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, bext[*,0,1], thick=8, lin=2

; MERRA-2 (spheres, truncated)
  filename = 'optics_DU.v15_6.spheres.truncate_nref.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, bext[*,0,1], thick=8, lin=1

; Spher (new optics, truncated)
  filename = 'optics_DU.v17_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  oplot, lambda*1e6, bext[*,0,1], thick=8, color=254

;
; Mie (new optics, truncated)
  filename = 'optics_DU.v18_6.truncate_nref.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  oplot, lambda*1e6, bext[*,0,1], thick=8, color=254, lin=1

; Mie (new optics)
  filename = 'optics_DU.v18_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  oplot, lambda*1e6, bext[*,0,1], thick=8, color=254, lin=2

  device, /close

end
