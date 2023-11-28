; Plot the zonal mean extinction profile from CARMA
; for the indicated month

; Pick a date
  wantdate = '199107'
  expid    = 'c90Fc_H54p3_pin_03'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+$
             expid+'.tavg3d_carma_v.monthly.'+wantdate+'.nc4'
  expid    = 'c90Fc_H54p3_pinlo'
  filename = './'+$
             expid+'.tavg3d_carma_v.monthly.'+wantdate+'.nc4'
  nc4readvar, filename, 'suextcoef', su, lon=lon, lat=lat, lev=lev
  su = mean(su,dim=1)*1e6  ; Mm-1
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  dy = lat[1]-lat[0]

  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='carma_ext.'+expid+'.'+strmid(wantdate,0,6)+'.ps', $
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
  levels = [.05,.1,.15,.2,.25,.3,.4,.5,.7]*1e-6
  levels = [.1,.5,1,2,3,4,5,10,20]
  plotgrid, su, levels, colors, lat, z/1000., dy, delz/1000.
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=[-90,90], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90


  xyouts, .15, .12, 'Extinction [Mm!E-1!N]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.1)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
