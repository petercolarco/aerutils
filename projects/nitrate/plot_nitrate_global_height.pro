  expid = 'Icarusr6r6'
;expid = 'c90F_J10p14p1'
  expid = 'c180F_J10p17p0chl'
  filetemplate = expid+'.tavg3d_aer_p.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  varo = 'nh3'


  case varo of
   'nh3'  : begin
                  varn = 'nh3'
                  scale = 1.e12
                  tag  = 'Ammonia mixing ratio '
                  unit = '[pptm]'
                  end
   'ni'  : begin
                  varn = 'ni'
                  scale = 1.e9
                  tag  = 'Nitrate mixing ratio '
                  unit = '[ppbm]'
                  end
  endcase

  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.005,0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]

  wantlev = [100., 200., 500.]

   set_plot, 'ps'
   device, file='plot_nitrate_global_height.'+expid+'.'+varo+'.ps', $
    /color, /helvetica, font_size=12, $
    xsize=24, ysize=12, xoff=.5, yoff=.5
   !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  plot, indgen(10), /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[0.0001,100],  /ylog, $
   ytitle = tag+unit

  for ii = 0, n_elements(wantlev)-1 do begin

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum, wantlev=wantlev[ii]
  a = where(ext gt 1e14)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  ext = ext * scale
  area, lon, lat, nx, ny, dx, dy, area
  ext = aave(ext,area)

; Now make a plot
  loadct, 39
  oplot, x, ext, thick=6, color=84, lin=ii
print, max(ext)

  endfor

  device, /close

end
