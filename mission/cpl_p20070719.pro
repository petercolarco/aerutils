; colarco
; cpl comparison on Jul 19, 2007

  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg3d_aer_p.latest'
  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg3d_aer_p'
  ga_getvar, url, 'du', dummr, lon=lon, lat=lat, lev=lev, $
   wanttime = ['15:20z19jul2007'], wantlon=['-80.9265'], wantlat=['12.8453'], $
   wantlev = [-9999]


; make a fake profile of temperature
  t0 = 300.             ; K
  scaleheight = 8000.   ; m
  lapserate = 0.009     ; K m-1
  height = -1.*scaleheight*alog(lev/1000.)
  temp = t0 -height*lapserate
  rhoa = lev*100./(287.*temp)

  duconc = rhoa*dummr*1e9    ; ug m-3

; plot
  set_plot, 'ps'
  device, file='du_conc.1630z19jul2007.cpl_point.ps', /helvetica, $
          font_size=14, xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0

  plot, duconc, height/1000., /nodata, $
   xtitle = 'Dust Concentration [!Mm!3g m!E-3!N]', xrange=[0,250], xstyle=9, $
   ytitle = 'height [km]', yrange=[0,10], ystyle=9, $
   xthick=3, ythick=3
  oplot, duconc, height/1000., thick=6
  device, /close



end
