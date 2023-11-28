  expid = 'c90R'
  filetemplate = expid+'.aer.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2, lon=lon, lat=lat, lev=lev, time=time
; SO2 kg m-2 to DU
  so2 = so2/(0.064)*6.022e23/2.687e20

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='so2_map.'+expid+'.'+nymd[i]+'.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=16, ysize=16
  !p.font=0

  loadct, 0
  map_set, /stereo, 90,-30, /iso, /horizon, /cont, $
    limit=[50,-180,90,180], position=[.1,.2,.9,.9]

  loadct, 53
  levels = [1,2,5,10,20,50]
  colors = [50,80,110,160,200,255]
  contour, /over, so2[*,*,i], lon, lat, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_set, /stereo, 90,-30, /iso, /grid, /horizon, /cont, /noerase, $
    limit=[50,-180,90,180], position=[.1,.2,.9,.9], color=200
  map_continents, thick=2

  makekey, .15, .1, .7, .05, 0, -0.025, colors=make_array(6, val=120), $
   labels=string(levels,format='(i2)'), align=0
  loadct, 53
  makekey, .15, .1, .7, .05, 0, -0.025, colors=colors, $
   labels=make_array(6,val=' '), align=0
  loadct, 0
  xyouts, .5, .025, /normal, align=.5, 'SO!D2!N [DU]'
  xyouts, .5, .92, /normal, align=.5, nymd[i]


  device, /close

  endfor

end

