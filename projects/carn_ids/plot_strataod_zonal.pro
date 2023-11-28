  expid = 'c180R_v202_lasouf'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:60]
  nymd = nymd[0:60]

  vars = ['niexttau','ssexttau','duexttau', $
          'suexttau']

  vars = ['totexttau']

  for ii = 0, 0 do begin

  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(51)*5
  levels = findgen(51)*.0003
  ctab = 39

  case varo of
   'ssexttau'  : begin
                  varn = 'ssextcoef'
                  tag  = 'Sea Salt'
                  end
   'niexttau'  : begin
                  varn = 'niextcoef'
                  tag  = 'Nitrate'
                  end
   'suexttau'  : begin
                  varn = 'suextcoef'
                  tag  = 'Sulfate'
                  end
   'duexttau'  : begin
                  varn = 'duextcoef'
                  tag  = 'Dust'
                  end
   'totexttau' : begin
                 varn =  ['totstexttau002']
                 tag  = 'Total'
                 levels = findgen(51)*.0005
                 end
   'totexttau_noni' : begin
                 varn =  ['duextcoef','ssextcoef','suextcoef',$
                          'brcextcoef','bcextcoef','ocextcoef']
                 tag  = 'Total (no nitrate)'
                 sum = 1
                 levels = findgen(51)*.0005
                 end
   'ccexttau'  : begin
                  varn =  ['brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Carbonaceous'
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_strataod_zonal.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = n_elements(x)
  contour, ext, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[0,xmax], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[0,xmax], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  levels = levels[0:50:5]
  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.3)'), align=0
  xyouts, .525, .01, Tag+' Stratospheric AOD [550 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(n_elements(dcolors),val=''), align=.5

  device, /close

  endfor

end
