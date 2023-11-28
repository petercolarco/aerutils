  expid = 'RefD1'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

;  filename = filename[0:23]
;  nymd = nymd[0:23]

  vars = ['totexttau','ssexttau','ccexttau','duexttau', $
          'niexttau','suexttau','suexttauvolc']

  for ii = 0, 6 do begin

  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(8)*30
  levels = [0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]

  case varo of
   'ssexttau'  : begin
                  levels = [.005,.01,.015,.02,.025,.03,.05,.07]
                  varn = 'ssexttau'
                  tag  = 'Sea Salt'
                  ctab = 57
                  end
   'niexttau'  : begin
                  varn = 'niexttau'
                  tag  = 'Nitrate'
                  ctab = 53
                  end
   'suexttau'  : begin
                  levels = [.005,.01,.015,.02,.025,.03,.05,.1]
                  varn = 'suexttau'
                  tag  = 'Sulfate'
                  ctab = 52
                  end
   'suexttauvolc'  : begin
                  levels = [.005,.01,.015,.02,.025,.03,.05,.1]
                  varn = 'suexttauvolc'
                  tag  = 'Sulfate (Volcanic)'
                  ctab = 52
                  end
   'duexttau'  : begin
                  levels = [0.01,0.02,0.03,0.05,0.08,0.1,0.2,0.3]
                  varn = 'duexttau'
                  tag  = 'Dust'
                  ctab = 56
                  end
   'totexttau' : begin
                  levels = [0.01,0.02,0.03,0.05,0.08,0.1,0.2,0.3]
                  varn =  ['totexttau']
                  tag  = 'Total'
                  ctab = 51
                  end
   'ccexttau'  : begin
                  varn =  ['bcexttau','ocexttau']
                  tag  = 'Carbonaceous'
                  ctab = 54
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_aod_zonal.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=30, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(8), $
           labels=string(levels,format='(f5.3)'), align=0
  xyouts, .525, .93, Tag+' AOD [550 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(8,val=''), align=.5

  device, /close

  endfor

end
