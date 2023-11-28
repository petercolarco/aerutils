  expctl = 'qfed.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc

; Database of events
  lats =  [ 34,  57,  46,  54,  54, $
            57,  34,  47,  68,  33, $
            49,  51,  49,  47,  53,  48]
  lons = -[117, 116, 104, 111, 112, $
           116, 121,  63, 132, 104, $
           109, 102, 102, 105, 106, 104]
  dates = [20060626, 20060704, 20060824, 20060829, 20060904, $
           20060909, 20060918, 20070526, 20070626, 20070708, $
           20070729, 20070804, 20070810, 20070813, 20070819, 20070904]

  for i = 0, n_elements(dates)-1 do begin

  wantnymd = string(dates[i],format='(i8)')
  print, wantnymd
  wantlon  = lons[i]
  wantlat  = lats[i]
  a = where(nymd eq wantnymd)
  a = [a[0]-(dindgen(7)+1),a[0],a[0]+1]
  filename = strtemplate(parsectl_dset(expctl),nymd[a],nhms[a])
  nc4readvar, filename, 'biomass', biomass, lon=lon, lat=lat

  area, lon, lat, nx, ny, dx, dy, area, grid='e'

; convert units of emissions to g m-2 day-1
  biomass = biomass*86400.*1000.
  biomass1 = total(biomass[*,*,0:6],3)/7  ; week before
  biomass2 =       biomass[*,*,7]         ; today
  biomass3 =       biomass[*,*,8]         ; tomorrow
  levels = [.1,.2,.5,1,2,5,10]

  red   = [0,255,254,254,253,252,227,177]
  green = [0,255,217,178,141,78,26,0]
  blue  = [0,178,118,76,60,42,28,38]
  tvlct, red, green, blue
  colors = indgen(7)+1
  iblack = 0


; Make a series of plots
  set_plot, 'ps'
  device, file='qfed.'+wantnymd+'.ps', /helvetica, font_size=12, $
   xsize=12, ysize=24, xoff=.5, yoff=.5, /color
  !p.font=0
  geolimit=[wantlat-10,wantlon-20,wantlat+10,wantlon+20]

  map_set, limit=geolimit, position=[.1,.7,.95,.95], $
           title='Emissions Previous Week (average)', color=iblack
  map_continents, /countries, /cont, /hires, /usa, color=iblack
  plotgrid, biomass1, levels, colors, lon, lat, dx, dy, /map
  plots, wantlon+[-1,0,1,0,-1], wantlat+[0,-1,0,1,0], color=iblack, thick=3

  map_set, limit=geolimit, /cont, /noerase, position=[.1,.4,.95,.65], $
           title='Emissions Today', color=iblack
  map_continents, /countries, /cont, /hires, /usa, color=iblack
  plotgrid, biomass2, levels, colors, lon, lat, dx, dy, /map
  plots, wantlon+[-1,0,1,0,-1], wantlat+[0,-1,0,1,0], color=iblack, thick=3

  map_set, limit=geolimit, /cont, /noerase, position=[.1,.1,.95,.35], $
           title='Emissions Tomorrow', color=iblack
  map_continents, /countries, /cont, /hires, /usa, color=iblack
  plotgrid, biomass3, levels, colors, lon, lat, dx, dy, /map
  plots, wantlon+[-1,0,1,0,-1], wantlat+[0,-1,0,1,0], color=iblack, thick=3

  xyouts, .525, .079, /normal, 'Emissions OC [g m!E-2!N day!E-1!N]', $
          align=.5, charsize=.7
  makekey, .1, .05, .85, .025, 0, -.025, color=colors, $
           label=strcompress(string(levels,format='(f4.1)')), align=0

  device, /close

  endfor

end
