; Make some plots of smoke AOD based on model run

  filetemplate = 'c90R_pI32_fires.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  nymd = nymd[0:19]
  nhms = nhms[0:19]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  for i = 0, nf-1 do begin

   set_plot, 'ps'
   device, file='brcexttau.c90R_pI32_fires.'+nymd[i]+'.ps', /color, $
    /helvetica, font_size=14, xoff=.5, yoff=.5, xsize=14, ysize=12
   !p.font=0

   nc4readvar, filename[i], 'brcexttau', tau, lon=lon, lat=lat

   loadct, 0
   map_set, limit=[40,-150,85,-60], $
    position=[.05,.2,.95,.9], title=nymd[i]
   makekey, .1, .1, .8, .05, 0, -.035, colors=make_array(6,val=255), $
    labels=['0.1','0.2','0.3','0.5','0.7','1'], align=0
   loadct, 56
   levels = [.1, .2, .3, .5, .7, 1]
   colors = findgen(6)*40+40
   contour, tau, lon, lat, /overplot, $
    levels=levels, c_color=colors, /cell
   makekey, .1, .1, .8, .05, 0, -.035, colors=colors, $
    labels=make_array(6,val=' ')
   loadct, 0
   map_continents, /hires
   map_continents, /countries, /usa
   device, /close

  endfor

end
