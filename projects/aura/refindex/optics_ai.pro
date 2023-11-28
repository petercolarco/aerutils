  filetemplate = 'v1.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 8)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', aiv1, time=time, lon=lon, lat=lat
  nc4readvar, filename, 'ai_omi', aiomi, time=time, lon=lon, lat=lat

  filetemplate = 'v5.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', aiv5, time=time, lon=lon, lat=lat

  filetemplate = 'v7.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', aiv7, time=time, lon=lon, lat=lat

  b = where(aiv1 gt 1e14 or aiomi gt 1e14)
  aiv1[b] = !values.f_nan
  aiv5[b] = !values.f_nan
  aiv7[b] = !values.f_nan
  aiomi[b] = !values.f_nan

  aiv1_  = mean(aiv1,dimension=3,/nan)
  aiv5_  = mean(aiv5,dimension=3,/nan)
  aiv7_  = mean(aiv7,dimension=3,/nan)
  aiomi_ = mean(aiomi,dimension=3,/nan)

  !p.multi=[0,2,2]
  map_set, limit=[-40,-30,30,40], title='OMI'
  contour, aiomi_, lon, lat, /overplot, lev=findgen(10)*.25, /cell
  map_continents
  map_set, limit=[-40,-30,30,40], /noerase, title='v1'
  contour, aiv1_, lon, lat, /overplot, lev=findgen(10)*.25, /cell
  map_continents
  !p.multi=[2,2,2]
  map_set, limit=[-40,-30,30,40], /noerase, title='v5'
  contour, aiv5_, lon, lat, /overplot, lev=findgen(10)*.25, /cell
  map_continents
  !p.multi=[1,2,2]
  map_set, limit=[-40,-30,30,40], /noerase, title='v7'
  contour, aiv7_, lon, lat, /overplot, lev=findgen(10)*.25, /cell
  map_continents

  lon2 = 1.
  lat2 = 1.
  area, lon, lat, nx, ny, dx, dy, area, $
        grid='d', lon2=lon2, lat2=lat2

  aiv1  = reform(aiv1,nx*ny*1L,n_elements(time))
  aiv5  = reform(aiv5,nx*ny*1L,n_elements(time))
  aiv7  = reform(aiv7,nx*ny*1L,n_elements(time))
  aiomi = reform(aiomi,nx*ny*1L,n_elements(time))

  a = where(lon2 gt 15 and lon2 lt 25 and lat2 gt -10 and lat2 lt 0)

  plot, indgen(10)-2, indgen(10)-2

  loadct, 39
  plots, aiomi[a,*], aiv1[a,*], psym=3
  plots, aiomi[a,*], aiv5[a,*], psym=3, color=84
  plots, aiomi[a,*], aiv7[a,*], psym=3, color=254

  statistics, aiomi[a,*], aiv1[a,*], xmean, ymean1, xstd, ystd1, r1, bias1, rms1
  statistics, aiomi[a,*], aiv5[a,*], xmean, ymean5, xstd, ystd5, r5, bias5, rms5
  statistics, aiomi[a,*], aiv7[a,*], xmean, ymean7, xstd, ystd7, r7, bias7, rms7

end
