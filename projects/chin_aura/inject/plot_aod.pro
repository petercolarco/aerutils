  expid = '13km'
  filetemplate = 'c48R_H40_aura.tavg2d_aer_x.'+expid+'.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

; Get a variable

  nfile = n_elements(filename)

  for ifile =0, nfile-1 do begin
   nc4readvar, filename[ifile], 'ocexttaubiob', oc, lon=lon, lat=lat

   set_plot, 'ps'
   device, file='c48R_H40_aura.tavg2d_aer_x.'+expid+'.'+ $
                nymd[ifile]+'_'+nhms[ifile]+'.ps', $
           /color, /helvetica, font_size=12, xoff=.5, yoff=.5
   !p.font=0
   loadct, 56

   levels = [.001,.002,.005,.01,.02,.05,.1]
   colors = 32 + indgen(7)*35

   map_set, limit=[30,-120,50,-90], position=[.05,.2,.95,.95]
   contour, /over, oc, lon, lat, /cell, levels=levels, c_colors=colors
   loadct, 0
   makekey, .05, .1, .9, .05, 0, -0.035, align=0,  $
     colors=make_array(7,val=0), labels=string(levels,format='(f5.3)')
   map_continents
   map_continents, /usa
   xyouts, .5, .95, /normal, nymd[ifile]+' '+nhms[ifile], align=.5
   xyouts, .05, .95, /normal, expid
   loadct, 56
   makekey, .05, .1, .9, .05, 0, -0.05, $
     colors=colors, labels=make_array(7,val=' ')
   device, /close

endfor

end

