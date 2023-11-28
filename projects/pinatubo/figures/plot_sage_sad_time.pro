; Plot the zonal mean extinction profile from SAGE/merged observations
; for the indicated month

; Read the SAGE database, nominally returns 525 nm extinction
  read_sage, nymd, height, lat, $
             ae1020, ae525, reff, sad, $
             nae1020, nae525, nreff, nsad

; Pick a date to look at
  a = where(nymd ge 19880101 and nymd lt 20010101)
  data  = reform(sad[a,*,*])
  b = where(lat ge -2.5 and lat le 2.5)
  data  = reform(data[*,b,*])
  data  = mean(data,dim=2)
  nt = n_elements(a)
  x = findgen(nt)*(1./12.)

  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='sage_sad_time.ps', $
   /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        ytitle='Altitude [km]', $
        xrange=1988+[0,nt/12], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2
  loadct, 56
  levels = [.1,.2,.5,1,2,3,5,10,20]
  plotgrid, data, levels, colors, 1988+x, height, 1./12., 0.5
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=1988+[0,nt/12], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2


  xyouts, .15, .12, 'Surface Area Density [!9m!3m!E2!N cm!E-3!N]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.1)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
