; Get Santiago's returned file -- why didn't he just give me what I
;                                 gave him!  Note that I took his
;                                 "hdf" file and converted to netcdf
;                                 as "ncks -3 *.hdf I.nc"
  filename = './2007m0605t1407-o15368_julian156.nc'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'AI')
  ncdf_varget, cdfid, id, ai_inp
  id    = ncdf_varid(cdfid,'SCAN_LINES')
  ncdf_varget, cdfid, id, scan_lines
  ncdf_close, cdfid
; Put onto same grid as below will have...Santiago gives 60x1201
  ai_return = make_array(60,1644,val=min(ai_inp))
  ai_return[*,199:1399] = ai_inp

; Now read in my own fields
  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
  ai      = h5d_read(var_id)
  h5f_close, file_id

  set_plot, 'ps'
  device, file='omi_granule_julian156.2.ps', xsize=24, ysize=24, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0

; Color palette
  red   = [0,255,237,199,127,65,29,34,37,8]
  green = [0,255,248,233,205,182,145,94,52,29]
  blue  = [0,217,177,180,187,196,168,148,88]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1


; Plot VL computed AI
  map_set, /cont, title='AI VLIDORT', $
   position=[.025,.6,.475,.95]
  levels = [-5,-.25,0,.25,.5,.75,1,1.5,2]
  plotgrid, ai, levels, dcolors, lon, lat, .02, .02, psym=3
  map_continents


; Plot RETURN AI
  map_set, /cont, /noerase, title='AI RETURN', $
   position=[.525,.6,.975,.95]
  plotgrid, ai_return, levels, dcolors, lon, lat, .02, .02, psym=3
  map_continents

  makekey, .25,.55,.5,.025,0,-.025, color=make_array(n_elements(red)-1,val=0), $
   labels=['-5','-0.25','0','0.25','0.5','0.75','1','1.5','2'], align=0
  makekey, .25,.55,.5,.025,0,-.025, color=dcolors, $
   labels=make_array(n_elements(red)-1,val=' '), align=0


; Plot DIFFERENCE
  red   = [178,214,244,253,247,209,146,67,33]
  green = [24,96,165,219,247,229,197,147,102]
  blue  = [43,77,130,199,247,240,222,195,172]
  red   = [0,reverse(red)]
  green = [0,reverse(green)]
  blue  = [0,reverse(blue)]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1
  levels = [-2000,-2,-1,-.5,-.1,.1,.5,1,2]
  map_set, /cont, /noerase, title='AI RETURN-AI VLIDORT', $
   position=[.025,.1,.475,.45]
  plotgrid, ai_return-ai, levels, dcolors, lon, lat, .02, .02, psym=3
  map_continents
  makekey, .05,.05,.4,.025,0,-.025, color=make_array(n_elements(red)-1,val=0), $
   labels=[' ','-2','-1','-0.5','-0.1','0.1','0.5','1','2'], align=.5
  makekey, .05,.05,.4,.025,0,-.025, color=dcolors, $
   labels=make_array(n_elements(red)-1,val=' '), align=.5


  map_set, /cont, /noerase, title='AI valid (red = where missing in AI RETURN)', $
   position=[.525,.1,.975,.45]
  a = where(ai gt -100 and ai_return gt -100)
  plots, lon[a], lat[a], psym=3
  a = where(ai gt -100 and ai_return lt -100)
  plots, lon[a], lat[a], psym=3, color=254
  map_continents

; Plot a second page
; Color palette
  red   = [0,255,237,199,127,65,29,34,37,8]
  green = [0,255,248,233,205,182,145,94,52,29]
  blue  = [0,217,177,180,187,196,168,148,88]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1

; Plot VL computed AI
  map_set, /cont, title='AI VLIDORT', $
   position=[.025,.6,.475,.95]
  levels = [-5,-.25,0,.25,.5,.75,1,1.5,2]
  plotgrid, ai, levels, dcolors, lon, lat, .02, .02, psym=3
  map_continents
  plots, [-35,-5,-5,-35,-35], [5,5,20,20,5]

; Scatter plot
  plot, findgen(10)-2, findgen(10)-2, $
   position=[.55,.625,.975,.95], $
   xtitle='AI VLIDORT', ytitle='AI RETURN', $
   xrange=[-2,3], yrange=[-2,3], $
   xstyle=9, ystyle=9
  a = where(lon gt -35 and lon lt -5 and lat gt 5 and lat lt 20)
  plots, ai[a], ai_return[a], psym=3

  device, /close

end
