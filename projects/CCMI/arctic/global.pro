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

  yyyy = strpad(1960+findgen(141),1000)

; Global AOT
  nc4readvar, ddf, ['totexttau','suexttauvolc'], totexttau, /sum
  totexttau = aave(totexttau,area)
  nc4readvar, ddf, 'duexttau', duexttau
  duexttau = aave(duexttau,area)
  nc4readvar, ddf, ['suexttau','suexttauvolc'], suexttau, /sum
  suexttau = aave(suexttau,area)
  nc4readvar, ddf, 'suexttauvolc', suvexttau
  suvexttau = aave(suvexttau,area)
  nc4readvar, ddf, 'ssexttau', ssexttau
  ssexttau = aave(ssexttau,area)
  nc4readvar, ddf, 'ocexttau', ocexttau
  ocexttau = aave(ocexttau,area)
  nc4readvar, ddf, 'bcexttau', bcexttau
  bcexttau = aave(bcexttau,area)

  set_plot, 'ps'
  device, file='aot.global.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  x = indgen(141)+1960
  plot, x, suexttau, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Component AOT', xtitle='year', $
        xrange=[1960,2100], xstyle=9, xticks=14, xminor=2, $
        title='Global Annual Average Component AOD', $
        ystyle=9, yrange=[0,.15], yticks=3, yminor=5
  oplot, x, duexttau, color=ired, thick=6
  oplot, x, ssexttau, color=iblue, thick=6
  oplot, x, suexttau, color=igrey, thick=6
  oplot, x, suexttau-suvexttau, color=igrey, thick=6, lin=2
  oplot, x, ocexttau+bcexttau, color=igreen, thick=6

  device, /close


end
