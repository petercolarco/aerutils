  expid = '07km'
  filetemplate = 'c48R_H40_aura.tavg3d_aer_p.'+expid+'.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

; Get a variable

  nfile = n_elements(filename)

  for ifile =0, nfile-1 do begin
   nc4readvar, filename[ifile], 'ocbiob', oc, lon=lon, lat=lat, lev=lev
   a = where(lon eq -105)
   oc = reform(oc[a,*,*])
   a = where(oc gt 1e14)
   oc[a] = -999.

   set_plot, 'ps'
   device, file='c48R_H40_aura.tavg3d_aer_p.'+expid+'.'+ $
                nymd[ifile]+'_'+nhms[ifile]+'.ps', $
           /color, /helvetica, font_size=12, xoff=.5, yoff=.5
   !p.font=0
   loadct, 56

   levels = [.1,.2,.5,1,2,5,10]
   colors = 32 + indgen(7)*35
check, oc*1e9
   contour, oc*1e9, lat, lev, $
    /cell, levels=levels, c_colors=colors, $
    xrange=[30,50], yrange=[1000,40], /ylog, $
    position = [.1,.2,.95,.93], $
    xstyle=9, ystyle=9
   loadct, 0
   contour, oc*1e12, lat, lev, /nodata, /noerase, $
    /cell, levels=levels, c_colors=colors, $
    xrange=[30,50], yrange=[1000,40], /ylog, $
    position = [.1,.22,.95,.93], $
    xtitle='latitude', ytitle='altitude [hPa]', $
    xstyle=9, ystyle=9
   plots, [33,33], [1000,40]
   makekey, .1, .05, .85, .05, 0, -0.035, align=0,  $
     colors=make_array(7,val=0), labels=string(levels,format='(f4.1)')
   xyouts, .5, .95, /normal, nymd[ifile]+' '+nhms[ifile], align=.5
   xyouts, .05, .95, /normal, expid
   loadct, 56
   makekey, .1, .05, .85, .05, 0, -0.05, $
     colors=colors, labels=make_array(7,val=' ')
   device, /close

endfor

end

