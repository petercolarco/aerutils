; Make a two panel map of the global, monthly difference
; in AI (OMAERUV - MERRAero) where the left panel is
; for OMAERUV using own surface pressure and the right
; panel is OMAERUV using MERRAero surface pressure

  filetemplate = 'monthly.aimask_hold.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200706')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  filetemplate = 'monthly.pomi_hold.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)

  filetemplate = 'monthly.pgeo_hold.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omig=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
  nc4readvar, filename_omig, 'ai', ai_omig, lon=lon, lat=lat
  a = where(ai_omig gt 1e14)
  ai_omig[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Difference is OMI - MERRAero
  diff  = ai_omi  - ai
  diffg = ai_omig - ai

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'figures2.ai_pressure_map.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-90,-180,90,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.2,.475,.9], charsize=.75
  xyouts, .025, .91, /normal, charsize=.75, 'a) AI Difference: OMAERUV (own pressure) - MERRAero'
  xyouts, .475, .91, /normal, charsize=.75, align=1, 'June 2007'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
colors=reverse(colors)
  plotgrid, diff[*,*,it], levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3


  loadct, 0
  map_set, limit=[-90,-180,90,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.2,.975,.9], charsize=.75, /noerase
  xyouts, .525, .91, /normal, charsize=.75, 'b) AI Difference: OMAERUV (MERRAero pressure) - MERRAero'
  xyouts, .975, .91, /normal, charsize=.75, align=1, 'June 2007'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
colors=reverse(colors)
  plotgrid, diffg[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  makekey, .3, .1, .4, .05, 0, -.05, $
   colors=make_array(11,val=255), align=.5, charsize=.75, $
   labels=[' ','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  loadct, 66
  makekey, .3, .1, .4, .05, 0, -.05, $
   labels=make_array(11,val=' '), $
   colors=colors

; Overplot the topography
  loadct, 39
  nc4readvar, 'topography.1152x721.nc', 'zs', z, lon=lon, lat=lat
  contour, /overplot, z, lon, lat, color=224, c_thick=4, levels=[1000]
  map_continents, thick=3

  device, /close
  
  endfor


end
