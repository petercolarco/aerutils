; horizontal plot -- makes postscript

  pro hplot, input_, lon, lat, $
      scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr, substr=substr, $
      datadir=datadir, er2=er2, dc8=dc8, ghawk=ghawk, $
      datewant=datewant, routelat=routelat, routelon=routelon, $
      countries=countries

a = where(input_ ge 1.e14)
if(a[0] ne -1) then input_[a] = !values.f_nan

; scalefactor to multiply the input array by
  if(not(keyword_set(scalefac))) then scalefac = 1.
; levels to contour
  if(not(keyword_set(levelarray))) then levelarray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
; colors of each level
  if(not(keyword_set(colorarray))) then colorArray = [30,64,80,96,144,176,192,199,208,254,10]
; color table to use
  if(not(keyword_set(colortable))) then colortable = 39
; image resolution in cm
  if(not(keyword_set(resolution))) then resolution = [12,10]
; format string to label key
  if(not(keyword_set(formatstr))) then formatstr = '(f5.1)'
; directory to store images in
  if(not(keyword_set(dir))) then dir = './'
; name of image file (less the .ps extension)
  if(not(keyword_set(image))) then image = 'image'
; title
  if(not(keyword_set(title))) then title = 'title'

  input = input_*scalefac

  dx = lon[1] - lon[0]
  dy = lat[1] - lat[0]

  nx = n_elements(lon)
  ny = n_elements(lat)

  maplimits = [lat[0],lon[0],lat[ny-1],lon[nx-1]]

  spawn, 'mkdir -p '+dir

  set_plot, 'ps'
  fileps  = dir+'/'+image+'.ps'
  filepng = dir+'/'+image+'.png'
  device, file=fileps, /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=resolution[0], ysize=resolution[1]
  !p.font=0

  loadct, colortable

  map_set, /noborder, limit=maplimits, position=[.05,.2,.95,.88]
  plotgrid, input, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, thick=5, color=0
  if(keyword_set(countries)) then map_continents, countries=countries
  map_set, /noerase, limit=maplimits, position=[.05,.2,.95,.88]
  xyouts, .05, .94, title, /normal, charsize=.9
  map_grid, /box, charsize=.8

  labelarray = strcompress(string(levelarray,format=formatstr),/rem)
  makekey, .05, .1, .9, .025, 0, -.05, color=colorarray, label=labelarray, $
   align=0, charsize=.75

  if(keyword_set(substr)) then begin
   xyouts, .05, .02, /normal, substr, charsize=.5
  endif

  if(keyword_set(dc8)) then begin
   get_dc8_navtrack, datadir, datewant, lon, lat, lev, prs, gmt
   oplot, lon, lat, thick=6, color=0
  endif

  if(keyword_set(er2)) then begin
   get_er2_navtrack, datadir, datewant, lon, lat, lev, prs, gmt
   oplot, lon, lat, thick=6, color=0
  endif

  if(keyword_set(ghawk)) then begin
   read_ghawk_track, ghawk, lon, lat, trackalt, trackdates
   oplot, lon, lat, thick=6, color=0
  endif

; fragile!!!
  if(keyword_set(routelat)) then begin
   colors = [0, 80, 254]
   rts = size(routelat)
   for its = 0, rts[0]-1 do begin
    plots, routelon[*,its], routelat[*,its], thick=6, lin=its
   endfor
  endif


  device, /close

  cmd = 'convert -density 150 '+fileps+' '+filepng
  spawn, cmd

end
