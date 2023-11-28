  expid = 'gmi.aer'
expid = 'G5GMAO'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd eq 20220122L)
  nymd = nymd[a[12]]
  filename = filename[a[12]]
stop
  nc4readvar, filename, 'so2cmass', so2, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
; SO2 kg m-2 to DU
  so2 = so2/(0.064)*6.022e23/2.687e20

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='so2_map.'+expid+'.'+nymd[i]+'_'+strmid(nhms[i],0,2)+'z.ps', $
   /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=10
  !p.font=0

  loadct, 41
  map_set, 0, 80, /horizon, /cont, $
    limit=[-40,-20,0,200], position=[.05,.2,.95,.9], $
    e_horizon={fill:1, color:138}, e_continents={fill:1, color:224}

  loadct, 53
  levels = [1,2,3,5,7,10,15,20,30,50]/10.
  colors = 50+findgen(10)*20
  contour, /over, so2[*,*,i], lon, lat, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_set, 0, 80, /grid, /horizon, /cont, /noerase, $
    limit=[-40,-20,0,200], position=[.05,.2,.95,.9], color=200
  map_continents, thick=4, /hires
  map_continents, /countries

  makekey, .15, .1, .7, .05, 0, -0.035, colors=make_array(10, val=120), $
   labels=string(levels,format='(f3.1)'), align=0
  loadct, 53
  makekey, .15, .1, .7, .05, 0, -0.035, colors=colors, $
   labels=make_array(10,val=' '), align=0
  loadct, 0
  xyouts, .5, .025, /normal, align=.5, 'SO!D2!N [DU]'
  xyouts, .5, .92, /normal, align=.5, nymd[i]+' '+strmid(nhms[i],0,2)+'z'
  xyouts, .05, .92, /normal, expid

  device, /close

  endfor

end

