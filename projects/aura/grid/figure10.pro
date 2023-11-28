; Colarco
; February 2016
; Four Panel Plot to Number of AOT retrievals by OMAERUV

; Setup the plot
  plotfile = 'figure10.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0

  levels=[1,5,10,20,50,100,150]
  colors=[0,32,80,128,192,208,255]

; Panel 1: SSA Plots (June)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200706')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.6,.475,.95]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV Number of AOD Retrievals (June 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 2: SSA Plots (July)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.6,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV Number of AOD Retrievals (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 3: SSA Plots (August)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200708')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.1,.475,.45]
  xyouts, .025, .455, /normal, charsize=.75, $
   'c) OMAERUV Number of AOD Retrievals (August 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3


; Panel 4: SSA Plots (September)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200709')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.1,.975,.45]
  xyouts, .525, .455, /normal, charsize=.75, $
   'd) OMAERUV Number of AOD Retrievals (September 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

  loadct, 0
  map_continents, thick=3
  makekey, .3, .05, .4, .025, 0, -.015, $
   colors=make_array(7,val=255),align=0, charsize=.75,  $
   labels=['1','5','10','20','50','100','150']
  loadct, 34
  makekey, .3, .05, .4, .025, 0, -.025, $
   labels=make_array(7,val=' '), $
   colors=colors


  device, /close
  

end
