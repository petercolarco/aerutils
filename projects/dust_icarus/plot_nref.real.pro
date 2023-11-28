; Plot refractive indices for different dust models

; OPAC (full refractive indices)
  filedir = '/home/colarco/sandbox/radiation/x/'
  filename = 'optics_DU.v1_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  set_plot, 'ps'
  device, file='plot_nref.real.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 0
  plot, lambda*1d6, refreal[*,0,0], /nodata, $
   xrange=[.25,40], xstyle=1, /xlog, xtitle='lambda [!Mm!Nm]', $
   yrange=[1,4], ystyle=1, ytitle='Real Part', yticks=3, ymin=2
  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=100


; MERRA-2 (truncated)
  filedir = '/home/colarco/sandbox/radiation/x/'
  filename = 'optics_DU.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  loadct, 39
  oplot, lambda*1e6, refreal[*,0,0], thick=8

; Mie (new optics)
  filename = 'optics_DU.v18_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  oplot, lambda*1e6, refreal[*,0,0], thick=8, color=254, lin=2

  device, /close

end
