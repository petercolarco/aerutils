  ext = 1
  filename = 'c180R_v10p23p0_sc.inst2d_hwl_x.argos1.trj.nc'
  read_argos, filename, lon, lat, time, sza, $
              tau=ext

; Retain only July
  a = where(strmid(time,5,2) eq '07')
  ext = ext[a]
  lon = lon[a]
  lat = lat[a]
  sza = sza[a]

; Keep only daylight
  a = where(sza le 88.)
  ext = ext[a]
  lon = lon[a]
  lat = lat[a]
  sza = sza[a]
  npts = n_elements(a)

; Make an output grid for the plot
  nx = 72
  ny = 46
  dx = 5
  dy = 4.
  lono = -180.+dx/2. + findgen(nx)*dx
  lato = -90.+ findgen(ny)*dy

  ix = interpol(indgen(nx),lono,lon)
  iy = interpol(indgen(ny),lato,lat)
  ix = fix(ix+0.5)
  iy = fix(iy+0.5)

; Fill the grid
  exto = fltarr(nx,ny)
  numo = lonarr(nx,ny)
  for ipts = 0, npts-1 do begin
   exto[ix[ipts],iy[ipts]] = exto[ix[ipts],iy[ipts]] + ext[ipts]
   numo[ix[ipts],iy[ipts]] = numo[ix[ipts],iy[ipts]] + 1
  endfor

  a = where(numo gt 0)
  exto[a] = exto[a]/numo[a]


; Make a plot
  set_plot, 'ps'
  device, file = 'plot_tau.1.ps', /color, /helvetica, font_size=14, $
   xsize=16, ysize=12
  !p.font=0


  map_set,0, 180, position=[.05,.2,.95,.95]
  loadct, 72
  levels = findgen(10)*0.005
  levels[0] = 1.e-12
  colors = reverse(findgen(10)*25+25)
  plotgrid, exto, levels, colors, lono, lato, dx, dy, /map

  loadct, 0
  makekey, .1, .1, .8, .05, 0, -0.04, align=0, charsize=.75, $
   colors=make_array(n_elements(levels),val=0), labels=string(levels,format='(f5.3)')

  loadct, 72
  makekey, .1, .1, .8, .05, 0, -0.04, $
   colors=colors, labels=make_array(n_elements(levels),val=' ')

  loadct, 0
  map_set, 0, 180, /noerase, position=[.05,.2,.95,.95]
  map_continents, thick=3

  device, /close
end
