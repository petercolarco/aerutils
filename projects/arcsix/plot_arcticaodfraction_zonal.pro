  expid = 'MERRA2'
; Get the tropopause pressure [Pa]
  filetemplate = expid+'.tavg1_2d_aer_Nx.monthly.ddf'
  expid = 'c180R_v10p23p0_sc'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd gt 20170000L and nymd lt 20220000L)
  filename = filename[a]
  nymd = nymd[a]

  vars = ['ssexttau','duexttau','ocexttau','suexttau','bcexttau']

  for ii = 0, 5 do begin

  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(51)*5
  levels = findgen(51)*.003
  ctab = 39


  if(expid eq 'c180R_v10p23p0_sc') then varn = varn+'550'

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum, lev=lev
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_arcticaod_zonal.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xyrs = n_elements(x)/12
  xmax = n_elements(x)+1
  if(xyrs ne n_elements(x)/12.) then xyrs = xyrs+1
  if(xyrs ne n_elements(x)/12.) then xmax = xyrs*12
  xtickname = string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[60,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext, x+.5, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[60,90],  yticks=6, $
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
