; Make some plots of global statistics based on annual mean (decadal)
; values

  red   = [0, 120, 253,   5,  35]
  green = [0, 120, 141, 112, 132]
  blue  = [0, 120,  60, 176,  67]

  iblack = 0
  igrey  = 1
  ired   = 2
  iblue  = 3
  igreen = 4

  tvlct, red, green, blue

  ddf = 'ref_c2_h53.ann.ddf'

  area, lon, lat, nx, ny, dx, dy, area, grid='b'
; discard area for latitude < 60 N
  a = where(lat lt 60)
  area[*,a] = 0.

  yyyy = strpad(1960+findgen(141),1000)

; Global AOT
  nc4readvar, ddf, ['totexttau','suexttauvolc'], totexttau, /sum
  totexttau = aave(totexttau,area)
  nc4readvar, ddf, ['totscatau','suscatauvolc'], totscatau, /sum
  totscatau = aave(totscatau,area)
  nc4readvar, ddf, 'duexttau', duexttau
  duexttau = aave(duexttau,area)
  nc4readvar, ddf, 'suexttau', suexttau
  suexttau = aave(suexttau,area)
  nc4readvar, ddf, 'suexttauvolc', suexttauv
  suexttauv = aave(suexttauv,area)
  nc4readvar, ddf, 'ssexttau', ssexttau
  ssexttau = aave(ssexttau,area)
  nc4readvar, ddf, 'ocexttau', ocexttau
  ocexttau = aave(ocexttau,area)
  nc4readvar, ddf, 'bcexttau', bcexttau
  bcexttau = aave(bcexttau,area)
  nc4readvar, ddf, ['bcdp001','bcdp002','bcwt002','bcsv002'], bcdp, /sum
  bcdp = aave(bcdp,area)
  nc4readvar, ddf, ['sudp003','suwt003','susv003'], sudp, /sum
  sudp = aave(sudp,area)
  nc4readvar, ddf, ['sudp003volc','suwt003volc','susv003volc'], sudpv, /sum
  sudpv = aave(sudpv,area)
  nc4readvar, ddf, ['ocdp001','ocdp002','ocwt002','ocsv002'], ocdp, /sum
  ocdp = aave(ocdp,area)

  set_plot, 'ps'
  device, file='aot.north.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  x = findgen(141)+1960
  plot, x, suexttau+suexttauv, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Component AOT', xtitle='year', $
        xrange=[1960,2100], xticks=14, xminor=2, $
        title='Annual Average Component AOD (North of 60!Eo!N N)', $
        xstyle=9, ystyle=9, yrange=[0,0.25]
  oplot, x, duexttau, color=ired, thick=6
  oplot, x, ssexttau, color=iblue, thick=6
  oplot, x, suexttau+suexttauv, color=igrey, thick=6
  oplot, x, suexttau, color=igrey, thick=6, lin=2
  oplot, x, ocexttau+bcexttau, color=igreen, thick=6

  device, /close

  set_plot, 'ps'
  device, file='aot.north.limit.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  x = findgen(141)+1960
  plot, x, suexttau, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Component AOT', xtitle='year', $
        xrange=[1960,2100], xstyle=1, xticks=14, xminor=2, $
        yrange=[0,0.05], $
        title='Annual Average Component AOT (North of 60!Eo!N N)'
  oplot, x, duexttau, color=208, thick=6
  oplot, x, ssexttau, color=74, thick=6
  oplot, x, suexttau+suexttauv, color=176, thick=6
  oplot, x, suexttau, color=176, thick=6, lin=2
  oplot, x, ocexttau, color=254, thick=6
  oplot, x, bcexttau, thick=6

  device, /close

; Single scattering albedo
  set_plot, 'ps'
  device, file='ssa.north.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  plot, x, suexttau, /nodata, $
        charsize=.75, $
        yrange=[0.95,1], $
        thick=3, ytitle='Single Scattering Albedo', xtitle='year', $
        xrange=[1960,2100], xstyle=9, xticks=14, xminor=2, $
        title='Annual Average Single Scattering Albedo (North of 60!Eo!N N)', $
        ystyle=9
  oplot, x, totscatau/totexttau, thick=6

  device, /close

; Deposition
; put deposition in units of Tg yr-1
  bcdp = bcdp*total(area)*365*86400./1e9
  sudp = sudp*total(area)*365*86400./1e9
  sudpv = sudpv*total(area)*365*86400./1e9
  ocdp = ocdp*total(area)*365*86400./1e9
  set_plot, 'ps'
  device, file='dep.north.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  plot, x, sudp+sudpv, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Aerosol Deposition [Tg yr!E-1!N]', xtitle='year', $
        xrange=[1960,2100], xstyle=1, xticks=14, xminor=2, $
        title='Annual Average Component Deposition (North of 60!Eo!N N)'
  oplot, x, sudp+sudpv, thick=6, color=176
  oplot, x, sudp, thick=6, color=176, lin=2
  oplot, x, ocdp, thick=6, color=254
  oplot, x, bcdp*10, thick=6
  xyouts, 1, 3.2, 'BC x 10'

  device, /close


end
