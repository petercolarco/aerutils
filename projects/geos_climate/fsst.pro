; SST in deg C
  ts1 = findgen(37)

; "GEOS"
  fsst1 = -1.107211-0.010681*ts1-0.002276*ts1^2+60.288927*1./(40.-ts1)

; Jaegle
  fsst2 = .3+.1*ts1-0.0076*ts1^2+.00021*ts1^3

  set_plot, 'ps'
  !p.font=0
  device, file='fsst.ps'

  plot, ts1, fsst1, /nodata, $
   xtitle = 'Skin Temperature [!Eo!NC]', $
   ytitle = 'Emissions scale factor'
  oplot, ts1, fsst1, thick=6
  oplot, ts1, fsst2, thick=6, lin=2

  device, /close

end
