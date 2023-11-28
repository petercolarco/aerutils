  expid = 'c180R_v202_ceds'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[84:131]
  nymd = nymd[84:131]

  vars = ['niexttau','ssexttau','duexttau', $
          'suexttau']

  vars = ['totexttau_870', 'duexttau870','suexttau870','ccexttau870','ssexttau','totexttau','niexttau']

  for ii = 0,3 do begin

  varo = vars[ii]
  print, varo
  sum = 0
;  dcolors = findgen(51)*5
  dcolors = [findgen(20)*10,192+findgen(30)*2]
  levels = findgen(50)*.0004
  ctab = 39

  title = 'Stratospheric AOD [550 nm] (x 1000)'

  case varo of
   'ssexttau'  : begin
                  varn = 'ssstexttau002'
                  tag  = 'Sea Salt'
                  end
   'niexttau'  : begin
                  varn = ['nistexttau002']
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
   'suexttau870'  : begin
                  varn = 'sustexttau003'
                  tag  = 'Sulfate'
                  title = 'Stratospheric AOD [870 nm] (x 1000)'
                  end
   'duexttau870'  : begin
                  varn = 'dustexttau003'
                  tag  = 'Dust'
                  title = 'Stratospheric AOD [870 nm] (x 1000)'
                  end
   'totexttau' : begin
                 varn =  ['totstexttau002']
                 tag  = 'Total'
                 end
  'totexttau_870' : begin
                 varn =  ['totstexttau003']
                 tag  = 'Total'
                 title = 'Stratospheric AOD [870 nm] (x 1000)'
                 end
   'totexttau_noni' : begin
                 varn =  ['duextcoef','ssextcoef','suextcoef',$
                          'brcextcoef','bcextcoef','ocextcoef']
                 tag  = 'Total (no nitrate)'
                 sum = 1
                 end
   'ccexttau'  : begin
                  varn =  ['brcstexttau002','bcstexttau002','ocstexttau002']
                  tag  = 'Carbonaceous'
                  sum = 1
                  end
   'ccexttau870'  : begin
                  varn =  ['brcstexttau003','bcstexttau003','ocstexttau003']
                  tag  = 'Carbonaceous'
                  title = 'Stratospheric AOD [870 nm] (x 1000)'
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
  xyrs = n_elements(x)/12
  xmax = n_elements(x)
  if(xyrs ne n_elements(x)/12.) then xyrs = xyrs+1
  if(xyrs ne n_elements(x)/12.) then xmax = xyrs*12
  xtickname = string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)')
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

  levels = levels[0:49:5]
  for i = 0, 9 do begin
   plots, [.1+i*0.08,.1+i*.08], [0.09,0.08], /normal
   xyouts, .1+i*0.08, .05, string(levels[i]*1000.+.1,format='(i-2)'), /normal, align=0.5
  endfor
  plots, [.9,.9], [.09,.08], /normal
  xyouts, .9, .05, '20', /normal, align=.5
  xyouts, .525, .01, Tag+' '+title, align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(n_elements(dcolors),val=''), align=.5

  device, /close

  endfor

end
