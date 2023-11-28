  expid = 'gmi.dad_Np'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt 20220501L)
  filename = filename[a]
  nymd = nymd[a]

  vars = ['rh2']


  for ii = 0, 0 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000

  wantlev = [30.,10,20.,50.,100.]

  for jj = 0, n_elements(wantlev)-1 do begin

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
   'rh2'  : begin
                  levels = [findgen(11)*5]
                  varn = 'rh2'
                  tag  = 'Relative Humidity [%]'
                  ctab = 39
                  end
   'suextcoef'  : begin
                  varn = 'suextcoef'
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

  nc4readvar, filename, varn, rh, lon=lon, lat=lat, sum=sum, wantlev=wantlev[jj], wantlat = [-40,40]
stop
  a = where(rh gt 1e14)
  if(a[0] ne -1) then rh[a] = !values.f_nan
  for it = 0, n_elements(filename)-1 do begin
   for iy = 0, n_elements(lat)-1 do begin
    rh[*,iy,it] = max(rh[*,iy,it])
   endfor
  endfor
  rh = transpose(mean(rh,dim=1,/nan))*100.

; Now make a plot
  set_plot, 'ps'
  device, file='plot_rh_zonal_vertical.'+expid+'.'+varo+ $
   '.'+string(wantlev[jj],format='(i04)')+'hpa.ps', $
   /color, /helvetica, font_size=14, $
   xsize=36, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x0 = 12
  x = indgen(n_elements(nymd))+12
  xmax = max(x)
;  xmax = 110
;  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, rh, x, lat, /nodata, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-40,40],  yticks=8, $
   ytitle = 'latitude'

  loadct, ctab
  contour, rh, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
;  contour, h, x, lat, /over, levels=indgen(20)+18, c_label=make_array(20,val=1)
  contour, rh, x, lat, /nodata, noerase=1, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-40,40],  yticks=8, $
   ytitle = 'latitude', xtitle='Day of Year'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(i2)'), align=0
  xyouts, .525, .01, Tag+' @ '+$
    string(wantlev[jj],format='(i-4)')+' hPa', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=0

  device, /close

  endfor

  endfor
end
