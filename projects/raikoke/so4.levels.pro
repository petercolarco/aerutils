  level = 200.
  levels = string(level,format='(i03)')

  filetemplate = 'v3.tavg3d_aer_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4', so2v3, lon=lon, lat=lat, lev=lev, time=time, wantlev=[level]
  nc4readvar, filename, 'airdens', rhoa, lon=lon, lat=lat, lev=lev, time=time, wantlev=[level]

  filetemplate = 'v4.tavg3d_aer_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4', so2v4, lon=lon, lat=lat, lev=lev, time=time, wantlev=[level]
  

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='so4conc_omi.'+nymd[i]+'.'+levels+'hpa.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=16, ysize=30
  !p.font=0

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  f = 1.e9  ; convert kg kg-1 of SO2 to ug m-3
  xycomp, alog(so2v3[*,*,i]*rhoa[*,*,i]*f), alog(so2v4[*,*,i]*rhoa[*,*,i]*f), lon, lat, dx, dy, $
   levels=findgen(11)*.25-0.5, colortable=20, colors=100+indgen(11)*15, $
   diff = (so2v3[*,*,i]-so2v4[*,*,i])*rhoa[*,*,i]*f, dlevels=[-1000,-50,-20,-10,-5,-1,1,5,10,20,50], $
   p0=90., geolimits=[30,-180,90,180]

  loadct, 0
  xyouts, .45, .975, align=.5, nymd[i], /normal
print, nymd[i]
  device, /close

  endfor

end

