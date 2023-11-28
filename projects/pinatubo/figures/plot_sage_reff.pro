; Plot the zonal mean extinction profile from SAGE/merged observations
; for the indicated month

; Read the SAGE database, nominally returns 525 nm extinction
  read_sage, nymd, height, lat, $
             ae1020, ae525, reff, sad, $
             nae1020, nae525, nreff, nsad

; Pick a date to look at
  wantnymd = '199106'
  a = where(nymd+'15' ge wantnymd)
  data  = reform(reff[a[0],*,*])

  colors = 25. + findgen(8)*30
  set_plot, 'ps'
  device, file='sage_reff.'+strmid(wantnymd,0,6)+'.ps', $
   /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,90], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90
  loadct, 56
  levels = [.15,.2,.25,.3,.35,.4,.5,.7]
  plotgrid, data, levels, colors, lat, height, 5., 0.5
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=[-90,90], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90


  xyouts, .15, .12, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
