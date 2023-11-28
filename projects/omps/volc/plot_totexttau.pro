  ddf = 'c180R_pI33p7_volc.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', tot, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat
  nc4readvar, filename, 'brcexttau', brc, lon=lon, lat=lat

  ddf = 'sampa.tavg2d_aer_x.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', tot2, lon=lon, lat=lat

  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  tot_  = aave(tot,area)
  tot2_ = aave(tot2,area)
  su_   = aave(su,area)
  brc_  = aave(brc,area)

  tot   = mean(tot,dim=1)
  tot2  = mean(tot2,dim=1)
  su    = mean(su,dim=1)
  brc   = mean(brc,dim=1)

  loadct, 56
  contour, transpose(tot), indgen(18)+1, lat, $
   /cell, levels=findgen(30)*.01, $
   xrange=[1,18], xticks=17, xstyle=1, $
   yrange=[-90,90], ystyle=1, yticks=6, c_color=findgen(30)*8
  makekey, 0.4, 0.15, 0.2, 0.05, 0,0,color=findgen(30)*8, label=make_array(30,val=' ')

  loadct, 58
  contour, transpose(su), indgen(18)+1, lat, $
   /cell, levels=findgen(30)*.005, $
   xrange=[1,18], xticks=17, xstyle=1, $
   yrange=[-90,90], ystyle=1, yticks=6, c_color=findgen(30)*8
  makekey, 0.4, 0.15, 0.2, 0.05, 0,0,color=findgen(30)*8, label=make_array(30,val=' ')
stop
  loadct, 62
  contour, transpose(brc), indgen(18)+1, lat, $
   /cell, levels=findgen(30)*.005, $
   xrange=[1,18], xticks=17, xstyle=1, $
   yrange=[-90,90], ystyle=1, yticks=6, c_color=findgen(30)*8
  makekey, 0.4, 0.15, 0.2, 0.05, 0,0,color=findgen(30)*8, label=make_array(30,val=' ')

end
