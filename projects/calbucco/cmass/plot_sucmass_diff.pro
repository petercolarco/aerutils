  expid = 'c180R_calbucco'
  expid2 = 'c180Rb_calbucco'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filetemplate = expid2+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename2=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  red   = [0, 94,50,102,171,230,255,254,253,244,213,158,152]
  green = [0, 79,136,194,221,245,255,224,174,109,62,1  ,152]
  blue  = [0, 162,189,165,164,152,255,139,97,67,79,66  ,152]

  tvlct, red, green, blue
  levels   = [-2000,-2,-1,-.5,-.2,-.1,.1,.2,.5,1,2]
  labels   = string(levels,format='(f4.1)')
  labels[0] = ' '
  dcolors=indgen(n_elements(levels))+1
  igrey  = n_elements(red)-1
  iblack = 0

  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'sucmass', su, lon=lon, lat=lat
   nc4readvar, filename2[i], 'sucmass', su2, lon=lon, lat=lat
   su = su - su2
   check, su*1e6
   set_plot, 'ps'
   device, file='sucmass_diff.'+expid+'.'+strmid(filename[i],17,14,/rev)+'.ps', $
    /helvetica, font_size=12, $
    xsize=16, ysize=12, xoff=.1, yoff=.1, /color
   !p.font=0

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   position = [.05,.1,.95,.95]
   plot_map, su*1e6, lon, lat, dx, dy, levels, dcolors, position, igrey, /contour
   xyouts, .1, .95, '!9D!3Sulfate Mass Loading [mg m!E-3!N]', /normal
   xyouts, .9, .95, strmid(filename[i],17,14,/rev), /normal, align=1

   makekey, .25, .15, .5, .03, 0, -.04, /noborder, align=.5, $
     color=make_array(n_elements(dcolors),val=igrey), $
     label=labels
   makekey, .25, .15, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=make_array(n_elements(dcolors),val=' ')

   device, /close

  endfor

end
