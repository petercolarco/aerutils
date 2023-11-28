  expid = 'c180R_v202_hungatonga_f6'
  filetemplate = expid+'.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau003', su, lon=lon, lat=lat, lev=lev, time=time

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='su_map.'+expid+'.'+nymd[i]+'_'+strmid(nhms[i],0,2)+'z.ps', $
   /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  loadct, 0
  map_set, /horizon, /cont, $
    limit=[-50,-180,20,180], position=[.05,.2,.95,.9]

  loadct, 65
  levels = [.01,.02,.05,.1,.2,.5,1]
  colors = indgen(7)*40
  contour, /over, su[*,*,i], lon, lat, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_set, /grid, /horizon, /cont, /noerase, $
    limit=[-50,-180,20,180], position=[.05,.2,.95,.9], color=200
  map_continents, thick=2

  makekey, .15, .1, .7, .05, 0, -0.035, colors=make_array(7, val=120), $
   labels=string(levels,format='(f4.2)'), align=0
  loadct, 65
  makekey, .15, .1, .7, .05, 0, -0.035, colors=colors, $
   labels=make_array(7,val=' '), align=0
  loadct, 0
  xyouts, .5, .025, /normal, align=.5, 'Sulfate AOD [870 nm]'
  xyouts, .5, .92, /normal, align=.5, nymd[i]
  xyouts, .05, .92, /normal, expid


  device, /close

  endfor

end

