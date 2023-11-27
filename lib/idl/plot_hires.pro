; Colarco, October 2006
; Use IDL code to plot a hires aerosol image of the day suitable for
; serving to Google Earth

  pro plot_hires, varout, lon, lat, $
      wantlev=wantlev, wanttime=wanttime, name=name, $
      scalefac=scalefac, levelarray=levelarray, dir=dir, $
      colorarray=colorarray, $
      title=title, formatstr=formatstr, dods=dods

  if(not(keyword_set(scalefac))) then scalefac = 1.
  if(not(keyword_set(levelarray))) then levelarray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]

  varout_ = varout*scalefac

  set_plot, 'z'
  loadct, 39
  if(not(keyword_set(colorarray))) then colorArray = [30,64,80,96,144,176,192,199,208,254,10]
  nl = n_elements(lon)

  case nl of
   288 : begin
         dx = 1.25
         dy = 1.
         end
   540 : begin
         dx = 0.666
         dy = 0.5
         end
   1080 : begin
         dx = 0.333
         dy = 0.25
         end
   1152 : begin
         dx = 0.3125
         dy = 0.25
         end
   ELSE: begin
         dx = 2.5
         dy = 2.
         end
  endcase

  device, set_resolution=[2048,1024]
  map_set, /noborder, /cylindrical, xmargin=0, ymargin=0
  plotgrid, varout_, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  tvlct, r, g, b, /get
  write_png, name+'.png', tvrd(), r, g, b
  device, /close

  device, set_resolution=[500,60], z_buffering=0
  if(not(keyword_set(formatstr))) then formatstr = '(f5.1)'
  if(keyword_set(title)) then xyouts, .5, .8, title, /normal, align=.5
  labelarray = strcompress(string(levelarray,format=formatstr),/rem)
  labelarray = [' ',' ']
  makekey, .05, .3, .9, .45, 0, -.2, $
   label = labelarray, color=colorarray, align=0, /noborder
  tvlct, r, g, b, /get
  write_png, dir+'/legend.png', tvrd(), r, g, b
  device, /close

end
