  filetemplate = 'v3.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2v3, lon=lon, lat=lat, lev=lev, time=time
  
  filetemplate = 'v7.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2v4, lon=lon, lat=lat, lev=lev, time=time
  

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='so2cmass_tropomi.v7.'+nymd[i]+'.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=16, ysize=30
  !p.font=0

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  f = 1./0.064*6.022e23/2.6867e20  ; convert kg m-2 to DU SO2
  xycomp, alog(so2v3[*,*,i]*f), alog(so2v4[*,*,i]*f), lon, lat, dx, dy, $
   levels=findgen(11)*.25-0.5, colortable=20, colors=100+indgen(11)*15, $
   diff = (so2v3[*,*,i]-so2v4[*,*,i])*f, dlevels=[-1000,-25,-20,-15,-10,-5,5,10,15,20,25], $
   p0=90., p1=160., geolimits=[30,-180,90,180]

  loadct, 0
  xyouts, .5, .975, align=.5, nymd[i], /normal
print, nymd[i]
  device, /close

  endfor

end

