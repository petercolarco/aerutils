; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  file = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/Y2007/M06/dR_MERRA-AA-r2.inst2d_hwl_x.20070605_1200z.nc4'
  nc4readvar, file, 'duexttau', aod, lon=lon, lat=lat

; Now set up a plot
  set_plot, 'ps'
  device, file='aod_duexttau.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 0
  p0 = 0
  p1 = 0

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase
  loadct, 55
  colors = indgen(254)
  levels = findgen(254)/253./2.
  dx = 0.625
  dy = 0.5
  plotgrid, aod, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  labels = ['0','0.25','0.5']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  loadct, 55
  labels = [' ',' ']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


  device, /close

end
