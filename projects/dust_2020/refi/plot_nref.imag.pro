; GEOS table:  read from optics_DU.v15_6 -- merge of OBS + OPAC (capped) (GEOS)
; OPAC table:  read from "miam00" -- official OPAC
; ECMWF table: read from "woodward.txt" -- this was copied out of
;              Table 2 of Woodward 2001 (need to verify with Sam Remy)
; UKMO table:  read from "balkanski_fig4.txt" from Balkanski et al. 2007
;              medium hemative model (provided by Balkanski, need to
;              check with Melissa Brooks)



; Plot refractive indices for different dust models

  set_plot, 'ps'
  device, file='plot_nref.imag.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[.25,40], xstyle=1, /xlog, xtitle='lambda [!Mm!Nm]', $
   yrange=[.0001,2], ystyle=1, ytitle='Imaginary Part', yticks=4, $
   ytickv=[.0001,.001,.01,.1, 1], /ylog

  xyouts, .01, 0.95, /normal, '(b)'

  loadct, 39

; OPAC
  filedir = './'
  filename = 'integ-du_opac_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, abs(refimag[*,0,0]), thick=8

; GEOS
  filename = 'integ-du_v15_6_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, abs(refimag[*,0,0]), thick=8, color=84, lin=2


; Woodward
  filename = 'integ-du_woodward_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, abs(refimag[*,0,0]), thick=8, color=208

; Balkanski
  filename = 'integ-du_balkanski_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, abs(refimag[*,0,0]), thick=8, color=254

; Balkanski
  filename = 'integ-du_balkanski27_sphere-raw.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  oplot, lambda*1e6, abs(refimag[*,0,0]), thick=8, color=48, lin=2

  y1 = 10^(alog10(0.0001)+1.75/2.*(alog10(2.)-alog10(.0001)))
  y2 = 10^(alog10(0.0001)+1.6/2.*(alog10(2.)-alog10(.0001)))
  y3 = 10^(alog10(0.0001)+1.45/2.*(alog10(2.)-alog10(.0001)))
  y4 = 10^(alog10(0.0001)+1.3/2.*(alog10(2.)-alog10(.0001)))
  y5 = 10^(alog10(0.0001)+1.15/2.*(alog10(2.)-alog10(.0001)))
;  xyouts, .3, y1, '!4OPAC'
;  xyouts, .3, y2, '!4Colarco et al. (2014)', color=84
;  xyouts, .3, y3, '!4Woodward (2001)', color=208
;  xyouts, .3, y4, '!4Balkanski 1.5% (2007)', color=254
;  xyouts, .3, y5, '!4Balkanski 2.7% (2007)', color=48


  device, /close

end
