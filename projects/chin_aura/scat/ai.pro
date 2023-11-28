; Database of events
  lats =   48
  lons = -104
  dates = 20070904L

  lft = 'lift_'+['0','1','2','3','4','5']+'km'

  for ilft = 0, n_elements(lft)-1 do begin

  wantnymd = string(dates,format='(i8)')
  print, wantnymd
  wantlon  = lons
  wantlat  = lats
  filename = '/misc/prc14/colarco/dR_F25b18/inst3d_aer_v/'+lft[ilft]+'/dR_F25b18.ai.20070904.nc4'
  nc4readvar, filename, 'ana', ai_replay, lon=lon, lat=lat
  nc4readvar, filename, 'obs', ai_omi, lon=lon, lat=lat

  a = where(ai_replay gt 100)
  ai_replay[a]   = !values.f_nan
  ai_omi[a]      = !values.f_nan

  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  levels = [0,1,2,3,4,6,10]

  red   = [0,255,254,254,253,252,227,177]
  green = [0,255,217,178,141,78,26,0]
  blue  = [0,178,118,76,60,42,28,38]
  tvlct, red, green, blue
  colors = indgen(7)+1
  iblack = 0


; Make a series of plots
  set_plot, 'ps'
  device, file='ai.'+lft[ilft]+'.'+wantnymd+'.ps', /helvetica, font_size=12, $
   xsize=12, ysize=16, xoff=.5, yoff=.5, /color
  !p.font=0
  geolimit=[wantlat-10,wantlon-20,wantlat+10,wantlon+20]

  map_set, limit=geolimit, position=[.1,.55,.95,.95], $
           title='Replay', color=iblack
  map_continents, /countries, /cont, /hires, /usa, color=iblack
  plotgrid, ai_replay, levels, colors, lon, lat, dx, dy, /map
  plots, wantlon+[-1,0,1,0,-1], wantlat+[0,-1,0,1,0], color=iblack, thick=3

  map_set, limit=geolimit, /cont, /noerase, position=[.1,.1,.95,.5], $
           title='OMI', color=iblack
  map_continents, /countries, /cont, /hires, /usa, color=iblack
  plotgrid, ai_omi, levels, colors, lon, lat, dx, dy, /map
  plots, wantlon+[-1,0,1,0,-1], wantlat+[0,-1,0,1,0], color=iblack, thick=3

  xyouts, .525, .079, /normal, 'Aerosol Index', $
          align=.5, charsize=.7
  makekey, .1, .05, .85, .025, 0, -.025, color=colors, $
           label=strcompress(string(levels,format='(f4.1)')), align=0

  device, /close

  endfor

end
