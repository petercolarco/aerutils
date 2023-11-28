; Plot a comparison of the randomly generated points against the full
; statistics computed earlier...

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for im = 0, 11 do begin

; Get GPM all month PDF
  filen = file_search('gpm/','*polar*txt')

  filen = filen[where(strpos(filen,'2006'+mm[im]) ne -1)]

  for i = 0, n_elements(filen)-1 do begin

   print, filen[i]
   read_pdf, filen[i], n_, lon_, lat_, psza_, pvza_, psaa_, pvaa_, psca_

   if(i eq 0) then begin
    n = n_
    lon = lon_
    lat = lat_
    psza = psza_
    pvza = pvza_
    psaa = psaa_
    pvaa = pvaa_
    psca = psca_
   endif else begin
    n = n + n_
    lon = [lon,lon_]
    lat = [lat,lat_]
    psza = psza+psza_
    pvza = pvza+pvza_
    psaa = psaa+psaa_
    pvaa = pvaa+pvaa_
    psca = psca+psca_
   endelse 

  endfor

; Get the random distribution pdf
  file = 'gpm/gpm.random.2006'+mm[im]+'.txt'
  read_random, file, lon__, lat__, $
               vza__, sza__, vaa__, saa__, scat__, $
               date__, time__, time_ss__

;; Keep only first 1000 points
;  sza__  = sza__[*,0:99]
;  vza__  = vza__[*,0:99]
;  saa__  = saa__[*,0:99]
;  vaa__  = vaa__[*,0:99]
;  scat__ = scat__[*,0:99]

; Make PDF of the random fields
  psza__ = histogram(sza__,min=0.,max=80.,location=lsza)
  pvza__ = histogram(vza__,min=0.,max=90., location=lvza)
  psaa__ = histogram(saa__,min=0.,max=360., location=lsaa)
  pvaa__ = histogram(vaa__,min=0.,max=360., location=lvaa)
  psca__ = histogram(scat__,min=0.,max=180., location=lsca)


; Make some plots
  set_plot, 'ps'
  device, file='compare_distribution.gpm.2006'+mm[im]+'.ps', /helvetica, font_size=14, /color, $
   xsize=24, ysize=36
  !p.font=0
  !p.multi=[0,2,3]
  loadct, 39

  plot, indgen(81), psza*1.d/max(psza), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Solar Zenith Angle', ytitle='Relative Frequency', title='SZA -- 2006'+mm[im], $
   xrange=[0,80], xstyle=1
  oplot, indgen(81), psza*1.d/max(psza), thick=6
  oplot, indgen(81), psza__*1.d/max(psza__), thick=6, color=84, lin=2

  plot, indgen(91), pvza*1.d/max(pvza), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Viewing Zenith Angle', ytitle='Relative Frequency', title='VZA -- 2006'+mm[im], $
   xrange=[0,90], xstyle=1
  oplot, indgen(91), pvza*1.d/max(pvza), thick=6
  oplot, indgen(91), pvza__*1.d/max(pvza__), thick=6, color=84, lin=2

  plot, indgen(361), psaa*1.d/max(psaa), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Solar Azimuth Angle', ytitle='Relative Frequency', title='SAA -- 2006'+mm[im], $
   xrange=[0,360], xstyle=1
  oplot, indgen(361), psaa*1.d/max(psaa), thick=6
  oplot, indgen(361), psaa__*1.d/max(psaa__), thick=6, color=84, lin=2

  plot, indgen(361), pvaa*1.d/max(pvaa), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Viewing Azimuth Angle', ytitle='Relative Frequency', title='VAA -- 2006'+mm[im], $
   xrange=[0,360], xstyle=1
  oplot, indgen(361), pvaa*1.d/max(pvaa), thick=6
  oplot, indgen(361), pvaa__*1.d/max(pvaa__), thick=6, color=84, lin=2

  plot, indgen(181), psca*1.d/max(psca), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Scattering Angle', ytitle='Relative Frequency', title='Scattering Angle -- 2006'+mm[im], $
   xrange=[0,180], xstyle=1
  oplot, indgen(181), psca*1.d/max(psca), thick=6
  oplot, indgen(181), psca__*1.d/max(psca__), thick=6, color=84, lin=2

  

  device, /close

  endfor

end
