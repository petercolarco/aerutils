  expid = 'c180R_J10p17p6_merra2'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename = strtemplate(template,nymd,nhms)
;  filename = filename[0:23]
;  nymd = nymd[0:23]

  vars = ['totexttau_noni','ssexttau','ccexttau','duexttau', $
          'niexttau','suexttau','totexttau']

  for ii = 0, 6 do begin

  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(51)*5
  levels = findgen(51)*.0003
  ctab = 39

  case varo of
   'ssexttau'  : begin
                  varn = 'ssstexttau002'
                  tag  = 'Sea Salt'
                  end
   'niexttau'  : begin
                  varn = 'nistexttau002'
                  tag  = 'Nitrate'
                  end
   'suexttau'  : begin
                  varn = 'sustexttau002'
                  tag  = 'Sulfate'
                  end
   'duexttau'  : begin
                  varn = 'dustexttau002'
                  tag  = 'Dust'
                  end
   'totexttau' : begin
                 varn =  ['dustexttau002','ssstexttau002','sustexttau002','nistexttau002',$
                          'brcstexttau002','bcstexttau002','ocstexttau002']
                 tag  = 'Total'
                 sum = 1
                 levels = findgen(51)*.0005
                 end
   'totexttau_noni' : begin
                 varn =  ['dustexttau002','ssstexttau002','sustexttau002',$
                          'brcstexttau002','bcstexttau002','ocstexttau002']
                 tag  = 'Total (no nitrate)'
                 sum = 1
                 levels = findgen(51)*.0005
                 end
   'ccexttau'  : begin
                  varn =  ['brcstexttau002','bcstexttau002','ocstexttau002']
                  tag  = 'Carbonaceous'
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum

; Compute the AOD
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(filename)
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_strataod_zonal.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xyrs = n_elements(x)/12
  xmax = n_elements(x)
  if(xyrs ne n_elements(x)/12.) then xyrs = xyrs+1
  if(xyrs ne n_elements(x)/12.) then xmax = xyrs*12
  xtickname = string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  levels = levels[0:50:5]
  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.3)'), align=0
  xyouts, .525, .01, Tag+' AOD [550 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(n_elements(dcolors),val=''), align=.5

  device, /close

  endfor

end
