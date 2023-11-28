  expid = 'c180R_calbucco'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  red   = [0, 255,254,254,253,252,227,177, 152]
  green = [0, 255,217,178,141,78,26,0    , 152]
  blue  = [0, 178,178,76,60,42,28,38     , 152]
  tvlct, red, green, blue
  levels   = [1,2,5,10,20,30,50]*10
  dcolors=indgen(n_elements(levels))+1
  igrey  = n_elements(red)-1
  iblack = 0

  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'ducmass', du, lon=lon, lat=lat
   check, du*1e6
   set_plot, 'ps'
   device, file='ducmass.'+expid+'.'+strmid(filename[i],17,14,/rev)+'.ps', $
    /helvetica, font_size=12, $
    xsize=16, ysize=12, xoff=.1, yoff=.1, /color
   !p.font=0

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   position = [.05,.1,.95,.95]
   plot_map, du*1e6, lon, lat, dx, dy, levels, dcolors, position, igrey, /contour
   xyouts, .1, .95, 'Dust/Ash Mass Loading [mg m!E-3!N]', /normal
   xyouts, .9, .95, strmid(filename[i],17,14,/rev), /normal, align=1

   makekey, .25, .15, .5, .03, 0, -.04, /noborder, align=0, $
     color=make_array(n_elements(levels),val=igrey), $
     label=string(levels,format='(i3)')
   makekey, .25, .15, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

   device, /close

  endfor

end
