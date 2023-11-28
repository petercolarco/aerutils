; Plot the annual AOD difference

  ddf1 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.full.totexttau.day.annual.2014.nc4'
  ddf2 = '/misc/prc19/colarco/M2R12K/annual/M2R12K.gpm055.nodrag.1100km.totexttau.day.annual.2014.nc4'
  tag  = 'gpm055.1100km'

  nc4readvar, ddf1, 'totexttau', aod1, lon=lon, lat=lat
  nc4readvar, ddf2, 'totexttau', aod2, lon=lon, lat=lat

  area, lon, lat, nx, ny, dx, dy, area

  a = where(aod2 gt 1000.)
  aod2[a] = !values.f_nan

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  set_plot, 'ps'
  device, file='annual_mean.aod.'+tag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  dlevels     = [-10,-0.02,-0.015,-0.01,-0.005,-0.002,0.002,0.005,0.01,0.015,0.02]
  dlabelarray = [' ',string(dlevels[1:10],format='(f6.3)')]

  xycomp, aod2, aod1, lon, lat, dx, dy, $
   colortable=64, levels=findgen(11)*.1, colors=indgen(11)*25, $
   dlevels=[-10,findgen(11)*.005-0.025], $
   dlabelarray=dlabelarray, $
   dcolors=reverse(indgen(11)*25), $
   geolimit=[-90,-180,90,180], /contour

  device, /close

;  xycomp, aotn2, aotn1, lon, lat, dx, dy, $
;   colortable=64, levels=indgen(11)*2, colors=indgen(11)*25, $
;   dlevels=[-10,-6,-4,-2,-1,1,2,4,6], dcolors=reverse(indgen(9)*35), $
;   geolimit=[-65,-180,65,180]

;  device, /close


end

