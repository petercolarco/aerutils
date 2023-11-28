; Get the G5GMAO extract at La Reunion
; Valid hourly, 21:30z21Jan2022 -> 23:30z29Jan2022
  nc4readvar, 'G5GMAO/G5GMAO.reunion.nc', 'so2', so2g5, lon=lon, lat=lat, lev=levg5
  a = where(so2g5 gt 1e14)
  so2g5[a] = !values.f_nan
  so2g5 = so2g5*29./64*1e9
  a = where(levg5 le 900.)
  levg5 = levg5[a]
  so2g5 = transpose(reform(so2g5[2,2,a,*]))


; Get the GMI GOCART SO2
  expid = 'gmi'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[8:17]
  nc4readvar, filename, 'so2', so2gocart, $
   lon=lon, lat=lat, lev=lev, wantlon=[55.5,55.5], wantlat=[-21.1,-21.1]
  a = where(so2gocart gt 1e14)
  so2gocart[a] = !values.f_nan
  so2gocart = so2gocart*29/64.*1e9
  a = where(lev le 900.)
  so2gocart = transpose(so2gocart[a,*])

; Get the GMI SO2
  expid = 'gmi'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[8:17]
  nc4readvar, filename, 'so2gmi', so2gmi, $
   lon=lon, lat=lat, lev=lev, wantlon=[55.5,55.5], wantlat=[-21.1,-21.1]
  nc4readvar, filename, 'h', h, $
   lon=lon, lat=lat, lev=lev, wantlon=[55.5,55.5], wantlat=[-21.1,-21.1]
  a = where(so2gmi gt 1e14)
  so2gmi[a] = !values.f_nan
  so2gmi = so2gmi*1e9
  a = where(lev le 900.)
  so2gmi = transpose(so2gmi[a,*])
  lev = lev[a]
  h = h[a,0]

; Make a plot
  set_plot, 'ps'
  device, file='so2_reunion.ps', $
   /color, /helvetica, font_size=16, $
   xoff=.5, yoff=.5, xsize=24, ysize=20
  !p.font=0

  x = indgen(195)*1./24+22-(2.5/24.)
  y = interpol(h,lev,levg5)/1000.
  contour, so2g5, x, y, /nodata, $
   yrange=[15,40], xrange=[20,28], xstyle=9, ystyle=9, $
   levels=[1,2,5,10,20,50,100,200,500], /cell_fill, xticks=8, $
   position =[.05,.2,.95,.95]
  loadct, 39
  contour, /over, so2g5, x, y, $
   levels=[1,2,5,10,20,50,100,200,500,1000], /cell_fill, $
   c_colors=40+findgen(10)*20

  makekey, .1, .05, .8, .05, 0, -0.035, colors=40+findgen(10)*20, $
   labels=string([1,2,5,10,20,50,100,200,500,1000],format='(i4)'), $
   align = 0

  loadct, 0
  contour, /over, so2gmi, indgen(10)+20, h/1000., levels=[1,2,5,10,20,50,100,200,500,1000]

  device, /close

end
