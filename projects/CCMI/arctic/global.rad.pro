; Make some plots of global statistics based on annual mean (decadal)
; values

  ddf = 'CCMI_REF_C2.ann.ddf'

  area, lon, lat, nx, ny, dx, dy, area, grid='b'
; discard area for latitude < 60 N
 ; a = where(lat lt 60)
 ; area[*,a] = 0.

; Global AOT

  nc4readvar, ddf, 'RSR', swtnet, wantlev=[1000]
  swtnet = aave(swtnet,area)
  nc4readvar, ddf, 'RSRNA', swtnetna, wantlev=[1000]
  swtnetna = aave(swtnetna,area)

  nc4readvar, ddf, 'RSRS', swgnet, wantlev=[1000]
  swgnet = aave(swgnet,area)
  nc4readvar, ddf, 'RSRSNA', swgnetna, wantlev=[1000]
  swgnetna = aave(swgnetna,area)


  set_plot, 'ps'
  device, file='forcing.global.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  x = findgen(141)+1960
  plot, x, swtnet, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Aerosol Forcing [W m!E-2!N]', xtitle='year', $
        xrange=[1960,2100], xstyle=1, xticks=14, xminor=2, $
        yrange=[-8,4], $
        title='Annual Average Aerosol Radiative Forcing (North of 60!Eo!N N)'
  oplot, x, swtnet-swtnetna, thick=6, color=74
  oplot, x, swgnet-swgnetna, thick=6, color=176
  oplot, x, (swtnet-swgnet)-(swtnetna-swgnetna), thick=6, color=254

  device, /close


end
