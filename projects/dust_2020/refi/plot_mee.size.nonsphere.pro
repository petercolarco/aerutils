; Plot the MEE ~550 nm for each case using GEOS size bins
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin = 8

  set_plot, 'ps'
  device, file='plot_mee.size.nonsphere.ps', /color, /helvetica, font_size=18, $
   xsize=24, ysize=13.5, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0.1,40], /xlog, xstyle=9, xtitle='diameter [!Mm!Nm]', xthick=3, $
   yrange=[0.05,5], /ylog, ystyle=9, thick=3, $
   ytitle='MEE!D550 nm!N [m!E2!N g!E-1!N]', ythick=3, $
   position=[.1,.12,.85,.92]

  xyouts, .01, .95, /normal, '(a)'


  loadct, 39

; OPAC
  filedir = '/misc/prc10/colarco/radiation/geosMie/DU/'
  filename = 'optics_DU.input.opac.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 6
  mee = reform(bext[ilam,0,*])/1000.
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mee[ibin], thick=18, color=0
   plots,[xmin[ibin+1],xmin[ibin+1]], [mee[ibin],mee[ibin+1]], thick=18, color=0
  endfor
  plots, [xmin[nbin-1],xmax], mee[nbin-1], thick=18, color=0

; GEOS
  filename = 'optics_DU.input.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 5
  mee = reform(bext[ilam,0,*])/1000.
;stop
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mee[ibin], thick=18, color=84, lin=2
   plots,[xmin[ibin+1],xmin[ibin+1]], [mee[ibin],mee[ibin+1]], $
    thick=18, color=84, lin=2
  endfor
  plots, [xmin[nbin-1],xmax], mee[nbin-1], thick=18, color=84, lin=2


; Woodward
  filename = 'optics_DU.input.woodward.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
; This is really 500 nm...
  ilam = 3
  mee = reform(bext[ilam,0,*])/1000.
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mee[ibin], thick=18, color=208
   plots,[xmin[ibin+1],xmin[ibin+1]], [mee[ibin],mee[ibin+1]], $
    thick=18, color=208
  endfor
  plots, [xmin[nbin-1],xmax], mee[nbin-1], thick=18, color=208

; Balkanski
  filename = 'optics_DU.input.balkanski.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 28
  mee = reform(bext[ilam,0,*])/1000.
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mee[ibin], thick=18, color=254
   plots,[xmin[ibin+1],xmin[ibin+1]], [mee[ibin],mee[ibin+1]], $
    thick=18, color=254
  endfor
  plots, [xmin[nbin-1],xmax], mee[nbin-1], thick=18, color=254

; Balkanski
  filename = 'optics_DU.input.balkanski27.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 28
  mee = reform(bext[ilam,0,*])/1000.
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], mee[ibin], thick=18, color=48, lin=2
   plots,[xmin[ibin+1],xmin[ibin+1]], [mee[ibin],mee[ibin+1]], $
    thick=18, color=48, lin=2
  endfor
  plots, [xmin[nbin-1],xmax], mee[nbin-1], thick=18, color=48, lin=2

  plots, [10,17], 10^(alog10(3.)), thick=18, color=0
  plots, [10,17], 10^(alog10(3.)-.1), thick=18, color=84, lin=2
  plots, [10,17], 10^(alog10(3.)-.2), thick=18, color=208
  plots, [10,17], 10^(alog10(3.)-.3), thick=18, color=254
  plots, [10,17], 10^(alog10(3.)-.4), thick=18, color=48, lin=2

  xyouts, 20, 10^(alog10(3.)-.03), 'OPAC'
  xyouts, 20, 10^(alog10(3.)-.13), 'Colarco et al.'
  xyouts, 20, 10^(alog10(3.)-.23), 'Woodward [500 nm]'
  xyouts, 20, 10^(alog10(3.)-.33), 'Balkanski (1.5%)'
  xyouts, 20, 10^(alog10(3.)-.43), 'Balkanski (2.7%)'

  device, /close

end
