; Get a standard atmosphere profile
  atmosphere, p, pe, dep, z, ze, delz, t, te, rhoa

; Read in the mass
  cdfid = ncdf_open('G41prcR2010.trj.nc')
  id = ncdf_varid(cdfid,'su001')
  ncdf_varget, cdfid, id, sut
  for i = 2,22 do begin
   ii = strpad(i,10)
   id = ncdf_varid(cdfid,'su0'+ii)
   ncdf_varget, cdfid, id, su
   sut = sut+su
  endfor
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, rhoa

  sut = transpose(sut)
  rhoa = transpose(rhoa)


; Make up some latitudes
  lat = -90. + findgen(24)*7.5

; Now plot the mass mixing ratio

  set_plot, 'ps'
;  device, file='omps.ps', /helvetica, font_size=10, $
  device, file='gocart.ps', /helvetica, font_size=10, $
   xsize=16, ysize=24, /color, xoff=.5, yoff=.5
  !p.font=0

  extstr = ['385','449','521','602','676','756','869','1020']

  for iext = 0, 7 do begin


  red   = [0,255,255,254,254,253,252,227,189,128]
  green = [0,255,237,217,178,141,78,26,0,0]
  blue  = [0,204,160,118,76,60,42,28,38,38]
  tvlct, red, green, blue
  nc = n_elements(red)-1
  colors = indgen(nc)+1

; Plot the profile mass mixing ratio
  plot, indgen(10), /nodata, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='mass mixing ratio [ng kg!E-1!N]', $
   position=[.08,.75,.475,.95]
  levels = findgen(9)*150
  contour, /over, sut*1e12, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='mass mixing ratio [ng kg!E-1!N]', $
   position=[.08,.75,.475,.95]

  xyouts, .02, .98, extstr[iext]+' nm', /normal, charsize=1.25
  makekey, .08, .68, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=make_array(nc,val=0), label=string(levels,format='(i4)')
  makekey, .08, .68, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=colors, label=make_array(nc,val=' ')

; Plot the profile mass concentration
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='mass concentration [ng m!E-3!N]', $
   position=[.58,.75,.975,.95]
  levels = findgen(9)*10
  contour, /over, sut*1e12*rhoa, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='mass concentration [ng m!E-3!N]', $
   position=[.58,.75,.975,.95]

  makekey, .58, .68, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=make_array(nc,val=0), label=string(levels,format='(i3)')
  makekey, .58, .68, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=colors, label=make_array(nc,val=' ')

; Get the extinction and plot
  levels = findgen(9)*50.
  filename = 'G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'g')
  ncdf_varget, cdfid, id, g
  ncdf_close, cdfid
  extc = transpose(ext)
  gc   = transpose(g)

  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='extinction [Mm!E-1!N] (CARMA)', $
   position=[.08,.42,.475,.62]
  contour, /over, extc*1e6, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   position=[.08,.42,.475,.62]

  makekey, .08, .35, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=make_array(nc,val=0), label=string(levels,format='(i3)')
  makekey, .08, .35, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=colors, label=make_array(nc,val=' ')


;  filename = './carma_add/G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  filename = './carma_gocart/G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'g')
  ncdf_varget, cdfid, id, g
  ncdf_close, cdfid
  extg = transpose(ext)
  gg   = transpose(g)

  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='extinction [Mm!E-1!N] (AGGREGATE)', $
   position=[.58,.42,.975,.62]
  contour, /over, extg*1e6, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   position=[.58,.42,.975,.62]

  makekey, .58, .35, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=make_array(nc,val=0), label=string(levels,format='(i3)')
  makekey, .58, .35, .395, .02, 0, -.012, charsize=.75, align=0, $
   color=colors, label=make_array(nc,val=' ')


; Difference plot
  red   = [178,214,244,253,247,209,146,67,33]
  green = [24,96,165,219,247,229,197,147,102]
  blue  = [43,77,130,199,247,240,222,195,172]
  red   = [0,reverse(red)]
  green = [0,reverse(green)]
  blue  = [0,reverse(blue)]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1
  nc = n_elements(red)-1
  levels = [-2000,-100,-50,-20,-10,10,20,50,100]
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='!9D!3AGGREGATE - CARMA extinction', $
   position=[.08,.09,.475,.29]
  contour, /over, (extg-extc)*1e6, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   position=[.08,.09,.475,.29]

  labels = string(levels,format='(i4)')
  labels[0] = ' '
  makekey, .08, .02, .395, .02, 0, -.012, charsize=.75, align=0.5, $
   color=make_array(nc,val=0), label=labels
  makekey, .08, .02, .395, .02, 0, -.012, charsize=.75, align=0.5, $
   color=colors, label=make_array(nc,val=' ')



  levels = [-2000,-.2,-.1,-.05,-.01,.01,.05,.1,.2]
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   title='!9D!3AGGREGATE - CARMA asym. par.', $
   position=[.58,.09,.975,.29]
  contour, /over, gg-gc, lat, z/1000., /fill, levels=levels, c_colors=colors
  plot, indgen(10), /nodata, /noerase, $
   xrange=[-90,90], xtitle='latitude', xstyle=9, xticks=6,$
   yrange=[10,40], ytitle='altitude [km]', ystyle=9, $
   position=[.58,.09,.975,.29]

  labels = string(levels,format='(f5.2)')
  labels[0] = ' '
  makekey, .58, .02, .395, .02, 0, -.012, charsize=.75, align=0.5, $
   color=make_array(nc,val=0), label=labels
  makekey, .58, .02, .395, .02, 0, -.012, charsize=.75, align=0.5, $
   color=colors, label=make_array(nc,val=' ')



  endfor

  device, /close


end
