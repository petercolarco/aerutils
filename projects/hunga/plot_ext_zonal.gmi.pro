  expid = 'C90c_HTerupV01b'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
stop
  vars = ['so4']

  for it = 0, n_elements(nymd)-1 do begin

  for ii = 0, 0 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000

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
   'so4'  : begin
;                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
;                            0.002,0.003,0.004,0.005,0.1,0.2]
                  varn = 'so4'
                  tag  = 'Sulfate'
                  ctab = 39
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

  nc4readvar, filename[it], varn, ext, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-50,10]
  nc4readvar, filename[it], 'airdens', rhoa, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-50,10]
  a = where(ext gt 1e14)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  ext = (mean(ext*rhoa,dim=1,/nan))*1e7
  ext = ext * 1100.  ; ad hoc conversion of sulfate mass to extinction

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal.'+expid+'.'+varo+ $
   '.'+nymd[it]+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=20, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))+12
  xmax = max(x)
  xmax = 59
;  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext, lat, lev, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[-50,10], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[100,5], /ylog,$
   ytitle = 'altitude [hPa]'

  loadct, ctab
  contour, ext, lat, lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
;  contour, h, lat, lev, /over, levels=indgen(22)+16, c_label=make_array(20,val=1)
  contour, ext, lat, lev, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[-50,10], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[100,5], /ylog,$
   ytitle = 'altitude [hPa]'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, Tag+' Extinction @ '+$
    nymd[it]+', [10!E4!N km!E-1!N, 870 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

endfor

endfor
end
