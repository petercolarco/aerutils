  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'prs', prs, lon=lon, lat=lat
  a = where(prs gt 1e14)
  prs[a] = !values.f_nan
  nc4readvar, filename, 'prso', prso, lon=lon, lat=lat
  a = where(prso gt 1e14)
  prso[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Difference is OMI - MERRAero
  diff = prso - prs

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'prsdiff.'+nymd[it]+'.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], charsize=.75, $
   title='OMAERUV - MERRAero Surface Pressure Difference [hPa]'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-50,-40,-30,-20,-10,-1,1,10,20,30,40,50]
  colors=reverse(findgen(13)*20)
colors=reverse(colors)
  plotgrid, diff[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(13,val=255), align=.5, $
   labels=[' ','-50','-40','-30','-20','-10','-1','1','10','20','30','40','50']
  loadct, 66
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

  device, /close
  
  endfor


end
