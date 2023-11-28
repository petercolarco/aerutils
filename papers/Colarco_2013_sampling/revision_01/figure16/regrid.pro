; regrid and plot trend and differences
  restore, filename='trend_hires.sav'


; Now remap this to 10 x 10
  area, lonr, latr, nxr, nyr, dxr, dyr, arear, grid = 'ten'
  sloper = fltarr(nxr,nyr)
  for ix = 1, nxr-1 do begin
   for iy = 0, nyr-1 do begin
    sloper[ix,iy] = !values.f_nan
    a = where(lon2 ge lonr[ix]-dxr/2. and lon2 lt lonr[ix]+dxr/2. and $
              lat2 ge latr[iy]-dyr/2. and lat2 lt latr[iy]+dyr/2. and $
              finite(slope) eq 1)
    if(a[0] ne -1) then sloper[ix,iy] = total(area[a]*slope[a])/total(area[a])
   endfor
  endfor
  ix = 0
  for iy = 0, nyr-1 do begin
    sloper[ix,iy] = !values.f_nan
    a = where( (lon2 ge lonr[nxr-1]-dxr/2. or lon2 lt lonr[ix]+dxr/2.) and $
              lat2 ge latr[iy]-dyr/2. and lat2 lt latr[iy]+dyr/2. and $
              finite(slope) eq 1)
    if(a[0] ne -1) then sloper[ix,iy] = total(area[a]*slope[a])/total(area[a])
  endfor


  restore, filename='../figure14/MYD04.qast.ten.num.trend.sav'
;  slope[where(finite(abs(slope/tstd)) eq 0)] = !values.f_nan
  slope10 = slope
  signif10 = slope
  signif10[*] = !values.f_nan
  a = where(abs(slope/tstd) gt 0)
  signif10[a] = 0.
  a = where(abs(slope/tstd) gt 2)
  signif10[a] = 1.

  position = [ [.025,.2,.475,.9], $
               [.525,.2,.975,.9] ]
  xsize=24
  ysize=10
  noerase = 0
  lstr = ''
  set_plot, 'ps'
  device, file='./MYD04'+samplestr+'.qast.'+res+'.num'+'.trend.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=xsize, ysize=ysize, /encap
 !p.font=0

  p0 = 0
  p1 = 0
  geolimits = [-75,-180,75,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

; Plot the regridded trend
  map_set, p0, p1, position=position[*,0], /noborder, limit=geolimits, noerase=noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, aotsat, [-.1], [220], lon, lat, dx, dy, /map, /missing

  dlevels=findgen(21)*.2-2.1
  dlevels[0] = -2000.

;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1

  plotgrid, sloper*100., dlevels, dcolors, lonr, latr, dxr, dyr, /map

  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,0], limit=geolimits
  map_grid, /box

  levstr = string(dlevels,format='(f4.1)')
  levstr[0:20:2] = ' '
  levstr = [' ','-1.9',' ','-1.5',' ','-1.1',' ','-0.7',' ','-0.3',' ',$
            ' ','0.3',' ','0.7',' ','1.1',' ','1.5',' ','1.9',' ']
  title = 'MODIS Aqua Full Swath Regridded Trend' 
  xyouts, position[0,0], position[3,0]+.05, lstr+title, /normal, charsize=1.2
  xyouts, .25, .12, 'AOT trend 100*AOT yr!E-1!N', /normal, align=.5
  makekey, .025, .055, .45, .05, 0, -.035, color=dcolors, $
   align=.5, label=levstr


sloper = sloper-slope10
a = where(signif10 ne 1)
sloper[a] = !values.f_nan
; Plot the delta in trends
  map_set, p0, p1, position=position[*,1], /noborder, limit=geolimits, noerase=1
; plot missing data as light shade
  loadct, 0
  plotgrid, aotsat, [-.1], [220], lon, lat, dx, dy, /map, /missing

  dlevels=findgen(21)*.04-.58
  dlevels[0] = -2000.

;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1

  plotgrid, sloper*100., dlevels, dcolors, lonr, latr, dxr, dyr, /map

; Make a box around each grid cell where the trend changes sign
  for ix = 0, nxr-1 do begin
   for iy = 0, nyr-1 do begin
    color=0
    if(sloper[ix,iy] lt -0.02) then color=21
    if( (sloper[ix,iy]+slope10[ix,iy] gt 0 and slope10[ix,iy] lt 0) or $
        (sloper[ix,iy]+slope10[ix,iy] lt 0 and slope10[ix,iy] gt 0)) then $
        plots, lonr[ix]+[-dxr,dxr,dxr,-dxr,-dxr]/2., $
               latr[iy]+[-dyr,-dyr,dyr,dyr,-dyr]/2., color=color
   endfor
  endfor

  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,1], limit=geolimits
  map_grid, /box

  levstr = string(dlevels,format='(f4.2)')
  levstr[0:20:2] = ' '
  levstr = [' ','-0.54',' ','-0.46',' ','-0.38',' ','-0.30',' ','-0.22',' ',$
            '-0.14',' ','-0.06',' ',' ','0.06',' ','0.14',' ','0.22',' ']
  title = 'Difference in AOT Trend (MODIS Full Swath Regridded - 10!Eo!N)'
  xyouts, position[0,1], position[3,1]+.05, lstr+title, /normal, charsize=1.2
  xyouts, .75, .12, 'Difference in AOT trend 100*AOT yr!E-1!N', /normal, align=.5
  makekey, .525, .055, .45, .05, 0, -.035, color=dcolors, $
   align=.5, label=levstr




  device, /close

end
