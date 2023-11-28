; Aerocom Dust AOD (Huneeus 2011)
  aod = [35, 34, 35, 24, 33, 22, 21, 27, 34, 26, 31, 10, 53]/1000.
  nmod = n_elements(aod)

  set_plot, 'ps'
  device, file='plot_aerocom.ps', /color, /helvetica, font_size=12
  !p.font=0

  xtickname = [' ',string(indgen(13)+1,format='(i2)'),' ']
  plot, indgen(12), /nodata, xrange=[0,14], xtitle='Model', $
   yrange=[0,0.06], ytitle='Dust AOD', xstyle=9, ystyle=9, $
   xticks=14, xminor=1, xtickn=xtickname
  plots, indgen(nmod)+1, aod, psym=sym(1), symsize=2

; Median
  plots, indgen(nmod)+1, median(aod), lin=2   ; my calculation

; Plot our model
  loadct, 39
  plots, 7, 0.053, psym=sym(5), color=254, symsize=3

; Plot MERRA-2
  plots, 5.5, 0.03, psym=sym(5), color=84, symsize=3

; Plot CCMI
  plots, 8.5, 0.023, psym=sym(5), color=176, symsize=3

  device, /close
end
