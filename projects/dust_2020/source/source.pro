  ddfs = ['c180R_J10p17p1dev_dust0.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dusta.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dustb.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dustc.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dustd.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_duste.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dustf.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dustg.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dusth.inst2d_hwl_x.ddf', $
          'c180R_J10p17p1dev_dusti.inst2d_hwl_x.ddf' ]



  ddf = ddfs[0]
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'duexttau', duext, wantlon=[-65.6], wantlat=[18.4]

; make a plot
  set_plot, 'ps'
  device, file='source.0.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*13], yrange=[0,1], xstyle=9, ystyle=9, $
   xticks=12, xtickn=string(indgen(14)+18,format='(i2)'), $
   ytitle='Dust AOD', xtitle='Day of June 2020'

  loadct, 65
  x = indgen(24*13)
  oplot, x, duext, thick=6, color=255

  device, /close

; make a plot
  set_plot, 'ps'
  device, file='source.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*13], yrange=[0,1], xstyle=9, ystyle=9, $
   xticks=12, xtickn=string(indgen(14)+18,format='(i2)'), $
   ytitle='Dust AOD', xtitle='Day of June 2020'

  loadct, 65
  x = indgen(24*13)
  oplot, x, duext, thick=6, color=255

  for i = 1, 9 do begin
   ddf = ddfs[i]
   ga_times, ddf, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, 'duexttau', duext, wantlon=[-65.6], wantlat=[18.4]
   oplot, x, duext, thick=6, color=255-i*20
  endfor


  device, /close

end
