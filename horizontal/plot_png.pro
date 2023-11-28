; Colarco, July 2007
; Feed in a data set and suitable levels and plot a single png file.

  pro plot_png, input_, lon, lat, $
      scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr, mapcontinents=mapcontinents

; scalefactor to multiply the input array by
  if(not(keyword_set(scalefac))) then scalefac = 1.
; levels to contour
  if(not(keyword_set(levelarray))) then levelarray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
; colors of each level
  if(not(keyword_set(colorarray))) then colorArray = [30,64,80,96,144,176,192,199,208,254,10]
; color table to use
  if(not(keyword_set(colortable))) then colortable = 0
; image resolution in pixels
  if(not(keyword_set(resolution))) then resolution = [2048,1024]
; format string to label key
  if(not(keyword_set(formatstr))) then formatstr = '(f5.1)'
; directory to store images in
  if(not(keyword_set(dir))) then dir = './'
; name of image file (less the .png extension)
  if(not(keyword_set(image))) then image = 'image'
; draw the continents on the map?
  if(not(keyword_set(mapcontinents))) then mapcontinents=0

  input = input_*scalefac

  dx = lon[1] - lon[0]
  dy = lat[1] - lat[0]

  nx = n_elements(lon)
  ny = n_elements(lat)

  maplimits = [lat[0],lon[0],lat[ny-1],lon[nx-1]]

  spawn, 'mkdir -p '+dir

  set_plot, 'z'
  loadct, colortable

  device, set_resolution=resolution
  map_set, /noborder, /cylindrical, limit=maplimits, xmargin=0, ymargin=0
  plotgrid, input, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  if(mapcontinents) then map_continents, thick=3, color=255
  tvlct, r, g, b, /get
  write_png, dir+'/'+image+'.png', tvrd(), r, g, b
  device, /close

  device, set_resolution=[300,60], z_buffering=0
  if(keyword_set(title)) then xyouts, .5, .8, title, /normal, align=.5
  labelarray = strcompress(string(levelarray,format=formatstr),/rem)
  align = 0
  nl = n_elements(labelarray)
  if(nl gt 12) then begin
   labelarray[1:nl-2] = ''
   align = 0
  endif
  makekey, .05, .3, .9, .45, 0, -.2, $
   label = labelarray, color=colorarray, align=align
  tvlct, r, g, b, /get
  write_png, dir+'/legend.png', tvrd(), r, g, b
  device, /close

end
