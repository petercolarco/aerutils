; Colarco, December 2015
; Make a map of the monthly mean AI difference OMI - MERRAero

  varwant  = 'ai'
  ver      = 'v7_5'
  datewant = '200706'
  plotfile = 'ai_diff.OMAERUV-MERRAero.'+ver+'.'+datewant+'.ps'
  title    = 'OMI - MERRAero UV Aerosol Index Difference ('+datewant+')'
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/'+ver+'/dR_MERRA-AA-r2-v1621.ai.'+datewant+'.nc4'

  nc4readvar, filename, 'ai_omi', ai_omi, lon=lon, lat=lat
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14 or ai_omi gt 1e14)
  ai[a] = !values.f_nan
  ai_omi[a] = !values.f_nan

  diff = ai_omi - ai

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
  levels=[-100,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  colors=reverse(20+findgen(9)*30)
  plotgrid, diff, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(9,val=255), $
   labels=[' ','-1.5','-1','-0.5','-0.1','0.1','0.5', $
               '1','1.5']
  loadct, 72
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(9,val=' '), $
   colors=colors



  device, /close
  

end
