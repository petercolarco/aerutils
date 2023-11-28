; Colarco
; February 2016
; Four Panel Plot to Fraction of AOD as Smoke Retrieved

; Setup the plot
  plotfile = 'figure12.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0

  levels=[.01,.02,.05,.1,.2,.5,.8]
  colors=[0,32,80,128,192,208,255]

; Panel 1: SSA Plots (June)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200706')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  nc4readvar, filename, 'nsmok', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.6,.475,.95]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV Fraction of AOD Retrievals Returned as Smoke (June 2007)'
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
  nc4readvar, filename, 'nsmok', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.6,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV Fraction of AOD Retrievals Returned as Smoke (July 2007)'
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
  nc4readvar, filename, 'nsmok', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.1,.475,.45]
  xyouts, .025, .455, /normal, charsize=.75, $
   'c) OMAERUV Fraction of AOD Retrievals Returned as Smoke (August 2007)'
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
  nc4readvar, filename, 'nsmok', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.1,.975,.45]
  xyouts, .525, .455, /normal, charsize=.75, $
   'd) OMAERUV Fraction of AOD Retrievals Returned as Smoke (September 2007)'
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
   labels=['0.01','0.02','0.05','0.1','0.2','0.5','0.8']
  loadct, 34
  makekey, .3, .05, .4, .025, 0, -.025, $
   labels=make_array(7,val=' '), $
   colors=colors


  device, /close
  

end
