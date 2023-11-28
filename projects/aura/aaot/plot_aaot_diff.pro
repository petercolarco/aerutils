; Colarco, December 2015
; Make a map of the monthly mean AI

  want     = 'omi'
  ver      = 'v1_5'
  datewant = '200709'
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.aot_omi388.'+datewant+'.nc4'
  nc4readvar, filename, 'aaot', aaot_omi, lon=lon, lat=lat
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/'+ver+'/dR_MERRA-AA-r2-v1621.aot388.'+datewant+'.nc4'
  nc4readvar, filename, 'aaot', aaot, lon=lon, lat=lat
  plotfile = 'aaot_diff.OMAERUV-MERRAero.'+ver+'.'+datewant+'.ps'
  title    = 'OMI - MERRAero AAOD Difference [388 nm] ('+datewant+')'

  a = where(aaot gt 1e14 or aaot_omi gt 1e14)
  aaot[a] = !values.f_nan
  aaot_omi[a] = !values.f_nan

  diff = aaot_omi - aaot

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], title=title
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)
  plotgrid, diff, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(9,val=255), $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(9,val=' '), $
   colors=colors


  device, /close
  

end
