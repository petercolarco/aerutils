; Plot the MEE ~550 nm for each case using GEOS size bins
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin = 8

  set_plot, 'ps'
  device, file='plot_ssa.size.nonsphere.ps', /color, /helvetica, font_size=18, $
   xsize=24, ysize=13.5, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0.1,40], /xlog, xstyle=9, xtitle='diameter [!Mm!Nm]', xthick=3, $
   yrange=[0.5,1], ystyle=9, thick=3, ytitle='SSA!D550 nm!N', ythick=3,$
   position=[.1,.12,.85,.92]
  xyouts, .01, .95, /normal, '(b)'


  loadct, 39

; OPAC
  filedir = '/misc/prc10/colarco/radiation/geosMie/DU/'
  filename = 'optics_DU.input.opac.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 6
  ssa = reform(bsca[ilam,0,*])/reform(bext[ilam,0,*])
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=0
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=0
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=0

; GEOS
  filename = 'optics_DU.input.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 5
  ssa = reform(bsca[ilam,0,*])/reform(bext[ilam,0,*])
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=84, lin=2
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], $
    thick=18, color=84, lin=2
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=84, lin=2


; Woodward
  filename = 'optics_DU.input.woodward.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
; This is really 500 nm...
  ilam = 3
  ssa = reform(bsca[ilam,0,*])/reform(bext[ilam,0,*])
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=208
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], $
    thick=18, color=208
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=208

; Balkanski
  filename = 'optics_DU.input.balkanski.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 28
  ssa = reform(bsca[ilam,0,*])/reform(bext[ilam,0,*])
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=254
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], $
    thick=18, color=254
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=254

; Balkanski
  filename = 'optics_DU.input.balkanski27.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 28
  ssa = reform(bsca[ilam,0,*])/reform(bext[ilam,0,*])
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=48, lin=2
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], $
    thick=18, color=48, lin=2
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=48, lin=2
goto, jump
  plots, [.15,.3], .8, thick=18, color=84, lin=2
  plots, [.15,.3], .77, thick=18, color=0
  plots, [.15,.3], .74, thick=18, color=208
  plots, [.15,.3], .71, thick=18, color=254
  plots, [.15,.3], .68, thick=18, color=48, lin=2

  xyouts, .35, .79, 'GEOS'
  xyouts, .35, .76, 'OPAC'
  xyouts, .35, .73, 'Woodward'
  xyouts, .35, .70, 'Balkanski (1.5%)'
  xyouts, .35, .67, 'Balkanski (2.7%)'
jump:
  device, /close

end
