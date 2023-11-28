  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  filetemplate = 'daily.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Difference is OMI - MERRAero
  diff = ai_omi - ai

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'aidiff.pgeo.'+nymd[it]+'.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], charsize=.75, $
   title='OMAERUV - MERRAero AI difference'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  colors=reverse(findgen(9)*30)
colors=reverse(colors)
  plotgrid, diff[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(9,val=255), align=.5, $
   labels=[' ','-1.5','-1','-0.5','-0.1','0.1','0.5','1','1.5']
  loadct, 66
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(9,val=' '), $
   colors=colors

  device, /close
  
  endfor


end
