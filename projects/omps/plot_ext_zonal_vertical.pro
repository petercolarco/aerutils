  expid = 'c90F_J10p14p1'
  filetemplate = expid+'.tavg3d_aer_p.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  vars = ['suextcoef','totextcoef','ssextcoef','duextcoef', $
          'niextcoef','ccextcoef']


  for ii = 0, 5 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]

  wantlev = [850.]

  case varo of
   'ssextcoef'  : begin
                  varn = 'ssextcoef'
                  tag  = 'Sea Salt'
                  ctab = 57
                  end
   'niextcoef'  : begin
                  varn = 'niextcoef'
                  tag  = 'Nitrate'
                  ctab = 53
                  end
   'suextcoef'  : begin
                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
                            0.002,0.003,0.004,0.005,0.1,0.2]
                  varn = 'suextcoef'
                  tag  = 'Sulfate'
                  ctab = 52
                  end
   'duextcoef'  : begin
                  varn = 'duextcoef'
                  tag  = 'Dust'
                  ctab = 56
                  end
   'totextcoef' : begin
                  varn =  ['duextcoef','ssextcoef','suextcoef','niextcoef',$
                           'brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Total'
                  ctab = 51
                  sum = 1
                  end
   'ccextcoef'  : begin
                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
                            0.002,0.003,0.005,0.1,0.2,0.3]
                  varn =  ['brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Carbonaceous'
                  ctab = 54
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum, wantlev=wantlev
  a = where(ext gt 1e14)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal_vertical.'+expid+'.'+varo+ $
   '.'+string(wantlev,format='(i04)')+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext*1e3, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext*1e3, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext*1e3, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f6.4)'), align=0
  xyouts, .525, .01, Tag+' Extinction @ '+$
    string(wantlev,format='(i4)')+' hPa [km!E-1!N, 550 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

  endfor
end
