; Colarco, December 2015
; Make a map of the monthly mean AI

  varwant  = 'ai'
  ver      = 'v1_5'
  datewant = '200709'
  if(varwant eq 'ai_omi') then begin
    plotfile = 'ai.OMAERUV.'+datewant+'.ps'
    title    = 'OMI UV Aerosol Index ('+datewant+')'
    filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.ai.'+datewant+'.nc4'
  endif else begin
    plotfile = 'ai.MERRAero.'+ver+'.'+datewant+'.ps'
    title    = 'MERRAero UV Aerosol Index ('+datewant+')'
    filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/'+ver+'/dR_MERRA-AA-r2-v1621.ai.'+datewant+'.nc4'
  endelse
  nc4readvar, filename, varwant, ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan

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
  levels=[-100,0,.5,1,1.5,2.0,2.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ai, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(7,val=255), align=0, $
   labels=[' ','0','0.5','1','1.5','2','2.5']
  loadct, 34
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors



  device, /close
  

end
