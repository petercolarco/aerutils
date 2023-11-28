; Make a three panel map of the global, monthly difference
; in AI (OMAERUV - MERRAero) where the OMAERUV is using
; the MERRAero surface pressure

  filetemplate = 'monthly.aimask_hold.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  filetemplate = 'monthly.pgeo_hold.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omig=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omig, 'ai', ai_omig, lon=lon, lat=lat
  a = where(ai_omig gt 1e14)
  ai_omig[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  plotfile = 'figures3.other_months.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=30, xoff=.5, yoff=.5
  !p.font=0

  position = [ [.05,.7,.95,.95], $
               [.05,.4,.95,.65], $
               [.05,.1,.95,.35] ]

  nt = n_elements(nymd)

; Overplot the topography
  nc4readvar, 'topography.1152x721.nc', 'zs', z, lon=lont, lat=latt

  for it = 1, nt-1 do begin

  case it of
   1: begin
      title = 'a) AI Difference: OMAERUV (MERRAero pressure) - MERRAero'
      dates = 'July 2007'
      end
   2: begin
      title = 'b) AI Difference: OMAERUV (MERRAero pressure) - MERRAero'
      dates = 'August 2007'
      end
   3: begin
      title = 'c) AI Difference: OMAERUV (MERRAero pressure) - MERRAero'
      dates = 'September 2007'
      end
  endcase

; Difference is OMI - MERRAero
  diffg = ai_omig[*,*,it] - ai[*,*,it]

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,it-1], charsize=.75, /noerase
  xyouts, .05, position[3,it-1]+.005, /normal, charsize=.75, title
  xyouts, .95, position[3,it-1]+.005, /normal, charsize=.75, align=1, dates
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diffg[*,*], levels, colors, lon, lat, dx, dy, /map
  loadct, 39
  contour, /overplot, z, lont, latt, color=224, c_thick=4, levels=[1000]
  map_continents, thick=3



  endfor

  loadct, 0
  makekey, .1, .05, .8, .035, 0, -.015, $
   colors=make_array(11,val=255), align=.5, charsize=.75, $
   labels=[' ','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  loadct, 66
  makekey, .1, .05, .8, .035, 0, -.015, $
   labels=make_array(11,val=' '), $
   colors=colors

  device, /close

  


end
