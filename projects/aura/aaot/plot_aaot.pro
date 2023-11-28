; Colarco, December 2015
; Make a map of the monthly mean AI

  want     = 'omi'
  ver      = 'v7_5'
  datewant = '200706'
  if(want eq 'omi') then begin
    plotfile = 'aaot.OMAERUV.'+datewant+'.ps'
    title    = 'OMI AAOD [388 nm] ('+datewant+')'
    filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.aot_omi388.'+datewant+'.nc4'
  endif else begin
    plotfile = 'aaot.MERRAero.'+ver+'.'+datewant+'.ps'
    title    = 'MERRAero AAOD [388 nm] ('+datewant+')'
    filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/'+ver+'/dR_MERRA-AA-r2-v1621.aot388.'+datewant+'.nc4'
  endelse
  nc4readvar, filename, 'aaot', aaot, lon=lon, lat=lat

  a = where(aaot gt 1e14)
  aaot[a] = !values.f_nan

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], title=title
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  levels=[0,.25,.5,.75,1,1.25,1.5]/10.
  colors=[0,32,80,128,192,208,255]
  plotgrid, aaot, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(7,val=255), align=0, $
   labels=['0','0.025','0.05','0.075','0.1','0.125','0.15']
  loadct, 34
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors



  device, /close
  

end
