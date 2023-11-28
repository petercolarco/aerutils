; Read the aggregate aerosol files from getregions.pro and make a plot
; that illustrates relevant behavior
; This version takes all the fields and aggregates them to a 1 degree
; resolution in longitude

  datewant = '200706'

  restore, file='getgeom.'+datewant+'.sav'

; Region of interest
  latedge = [35,40]
  lonedge = findgen(46)-125.
  lonnode = -124.5+findgen(45)
  nx = n_elements(lonnode)
  regname = 'namerica'

  xrange = [-125,-80]

; Plot some regional stuff
  set_plot, 'ps'
  device, file='plotgeom_aggregate.'+datewant+'_'+regname+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=26
  !p.font=0
  !p.multi = [0,2,5]

; PRS
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[1050,700], $
   xtitle='longitude', ytitle='Surface Pressure [hPa]', $
   title='pressure'
  prs_    = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   prs_[ix,0]    = mean(prs[a])
   prs_[ix,1]    = stddev(prs[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, prs_[*,0], prs_[*,1], color=200, fillcolor=50
  oplot, lonnode, prs_[*,0], color=200, thick=6


; AI
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,2], $
   xtitle='longitude', ytitle='AI', $
   title='AI: MERRAero = red, OMAERUV = blue'
  ai_    = fltarr(nx,2)
  aiomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ai_[ix,0]    = mean(ai[a])
   aiomi_[ix,0] = mean(aiomi[a])
   ai_[ix,1]    = stddev(ai[a])
   aiomi_[ix,1] = stddev(aiomi[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, ai_[*,0], ai_[*,1], color=200, fillcolor=50
  loadct, 57
  fillmeanstd, lonnode, aiomi_[*,0], aiomi_[*,1], color=200, fillcolor=50
  loadct, 62
  oplot, lonnode, ai_[*,0], color=200, thick=6
  loadct, 57
  oplot, lonnode, aiomi_[*,0], color=200, thick=6

; LER
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='LER', $
   title='LER388: MERRAero = red, OMAERUV = blue'
  ler_    = fltarr(nx,2)
  leromi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   ler_[ix,0]    = mean(ler[a])
   leromi_[ix,0] = mean(leromi[a])
   ler_[ix,1]    = stddev(ler[a])
   leromi_[ix,1] = stddev(leromi[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, ler_[*,0], ler_[*,1], color=200, fillcolor=50
  loadct, 57
  fillmeanstd, lonnode, leromi_[*,0], leromi_[*,1], color=200, fillcolor=50
  loadct, 62
  oplot, lonnode, ler_[*,0], color=200, thick=6
  loadct, 57
  oplot, lonnode, leromi_[*,0], color=200, thick=6


; RAD
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Radiance @ 388', $
   title='Radiance @ 388 nm: MERRAero = red, OMAERUV = blue'
  rad_    = fltarr(nx,2)
  radomi_ = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   rad_[ix,0]    = mean(rad[a])
   radomi_[ix,0] = mean(radomi[a])
   rad_[ix,1]    = stddev(rad[a])
   radomi_[ix,1] = stddev(radomi[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, rad_[*,0], rad_[*,1], color=200, fillcolor=50
  loadct, 57
  fillmeanstd, lonnode, radomi_[*,0], radomi_[*,1], color=200, fillcolor=50
  loadct, 62
  oplot, lonnode, rad_[*,0], color=200, thick=6
  loadct, 57
  oplot, lonnode, radomi_[*,0], color=200, thick=6



; Transmissivity
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0.1,.25], $
   xtitle='longitude', ytitle='Transmissivity', $
   title='transmissivity'
  trans_    = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   trans_[ix,0]    = mean(trans[a])
   trans_[ix,1]    = stddev(trans[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, trans_[*,0], trans_[*,1], color=200, fillcolor=50
  oplot, lonnode, trans_[*,0], color=200, thick=6


; Spherical Albedo
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[.15,.35], $
   xtitle='longitude', ytitle='Spherical Albedo', $
   title='spherical albedo'
  spher_    = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   spher_[ix,0]    = mean(spher[a])
   spher_[ix,1]    = stddev(spher[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, spher_[*,0], spher_[*,1], color=200, fillcolor=50
  oplot, lonnode, spher_[*,0], color=200, thick=6


; Transmissivity as function of pressure
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=[1050,650], yrange=[0.1,.25], $
   xtitle='pressure [hPa]', ytitle='Transmissivity', $
   title='transmissivity'
  a = where(lon gt lonedge[0] and lon le lonedge[nx] and $
            lat gt latedge[0]  and lat le latedge[1])
  loadct, 39
  col = (sca[a]-min(sca[a]))/(max(sca[a])-min(sca[a]))*255
  plots, prs[a], trans[a], psym=sym(1), color=col, symsize=.25


; Spherical Albedo
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=[1050,650], yrange=[0.15,.35], $
   xtitle='pressure [hPa]', ytitle='Spherical Albedo', $
   title='spherical albedo'
  a = where(lon gt lonedge[0] and lon le lonedge[nx] and $
            lat gt latedge[0]  and lat le latedge[1])
  loadct, 39
  col = (sca[a]-min(sca[a]))/(max(sca[a])-min(sca[a]))*255
  plots, prs[a], spher[a], psym=sym(1), color=col, symsize=.25


;; Scattering Angle
;  loadct, 0
;  plot, findgen(2), /nodata, $
;   xrange=xrange, yrange=[100,180], $
;   xtitle='longitude', ytitle='Scattering Angle', $
;   title='scattering angle'
;  sca_    = fltarr(nx,2)
;  for ix = 0, nx-1 do begin
;   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
;             lat gt latedge[0]  and lat le latedge[1])
;   sca_[ix,0]    = mean(sca[a])
;   sca_[ix,1]    = stddev(sca[a])
;  endfor
;  loadct, 62
;  fillmeanstd, lonnode, sca_[*,0], sca_[*,1], color=200, fillcolor=50
;  oplot, lonnode, sca_[*,0], color=200, thick=6

; Transmissivity as function of scattering angle
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=[80,180], yrange=[0.1,.25], $
   xtitle='scattering angle', ytitle='Transmissivity', $
   title='transmissivity'
  a = where(lon gt lonedge[0] and lon le lonedge[nx] and $
            lat gt latedge[0]  and lat le latedge[1])
  loadct, 39
  col = (prs[a]-min(prs[a]))/(max(prs[a])-min(prs[a]))*255
  plots, sca[a], trans[a], psym=sym(1), color=col, symsize=.25


; Spherical Albedo
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=[80,180], yrange=[0.15,.35], $
   xtitle='scattering angle', ytitle='Spherical Albedo', $
   title='spherical albedo'
  a = where(lon gt lonedge[0] and lon le lonedge[nx] and $
            lat gt latedge[0]  and lat le latedge[1])
  loadct, 39
  col = (prs[a]-min(prs[a]))/(max(prs[a])-min(prs[a]))*255
  plots, sca[a], spher[a], psym=sym(1), color=col, symsize=.25

device, /close

end
