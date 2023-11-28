      position = [.05,.2,.95,.9]
      xsize=12
      ysize=10
      noerase = 0
 iplot = 0


; Get the trend
  area, lon, lat, nx, ny, dx, dy, area, grid = 'd'
cdfid = ncdf_open('trend_stuff.nc4')
id = ncdf_varid(cdfid,'slope')
ncdf_varget, cdfid, id, slope
id = ncdf_varid(cdfid,'signif')
ncdf_varget, cdfid, id, signif
ncdf_close, cdfid


   set_plot, 'ps'
   device, file='./signif.eps', $
           /color, /helvetica, font_size=9, $
           xoff=.5, yoff=.5, xsize=xsize, ysize=ysize, /encap
  !p.font=0


  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  map_set, p0, p1, position=position[*,iplot], /noborder, limit=geolimits, noerase=noerase, /hammer, /iso

; plot missing data as light shade
  loadct, 0
  aotsat = signif
  aotsat[*] = 0.
  plotgrid, aotsat, [-.1], [220], lon, lat, dx, dy, /map, /missing



  loadct, 39
  dlevels=[0,2.]
  dcolors=[255,254]

  signif[where(finite(abs(signif)) eq 0)] = !values.f_nan
  plotgrid, signif, dlevels, dcolors, lon, lat, dx, dy, /map

  title = 'Aot trend statistical significance'
  xyouts, .5, .13, title, /normal, charsize=1.2, align=.5
  loadct, 0
  makekey, .11, .065, .26, .05, 0, -.035, color=[180], $
   align=.5, label=[' ']
  loadct, 39
  makekey, .37, .065, .52, .05, 0, -.035, color=dcolors, $
   align=.5, label=[' ',' ']
    xyouts, .24, .03, 'No Data', /normal, align=.5
    xyouts, .50, .03, 'Trend Not Significant', /normal, align=.5
    xyouts, .76, .03, 'Trend Significant!Cat 95% Confidence', /normal, align=.5


  loadct, 0
  map_continents, color=0, thick=1
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,iplot], /noborder, limit=geolimits, $
   /hammer, /iso, /horizon, /grid, glinestyle=0, color=160, glinethick=.5
;  map_grid, /box


device, /close
end
