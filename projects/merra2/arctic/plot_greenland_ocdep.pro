  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[0:419]
  nhms = nhms[0:419]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, ['bcdp','bcsd','bcsv','bcwt'], oc, /template, /sum, $
    lon=lon, lat=lat, wantlon = [-50,-30], wantlat=[70,80]
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  area = area[where(lon ge -50 and lon le -30),*]
  area = area[*,where(lat ge 70 and lat le 80)]
  oc = aave(oc,area)*30*86400*total(area)  ; kg mon-1

  ocd = reform(oc,12,35)/1000.  ; ton mon-1

; Divide into annual cycles
  set_plot, 'ps'
  device, file='plot_greenland_bcdep.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=10, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(12)+1
  plot, x, ocd[*,0], /nodata, $
   thick=6, xstyle=9, ystyle=9, $
   xrange=[0,13], xticks=13, xtitle = 'Month', $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   ytitle='BC deposition [ton mon!E-1!N]', yrange=[0,600], $
   title='35-years of MERRA-2 BC deposition over Greenland'
  for i = 0, 34 do begin
   oplot, x, ocd[*,i], color=160
  endfor
  oplot, x, ocd[*,32], thick=6, color=0
  oplot, x, ocd[*,15], thick=6, color=0, lin=2
  plots, [1,2], 500, thick=6
  plots, [1,2], 460, thick=6, lin=2
  xyouts, 2.25, 490, '2012'
  xyouts, 2.25, 450, '1995'
  device, /close

end

