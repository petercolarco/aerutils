  expid = 'c48F_G41-nopin'
; Plot the zonal mixing ratio of sulfate over time
  filetemplate = expid+'.tavg3d_aerdiag_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nt = n_elements(nymd)
  nc4readvar, filename, ['suextcoef','duextcoef','ssextcoef','ocextcoef','bcextcoef'], su, lon=lon, lat=lat, /sum
  nc4readvar, filename, 'rh', rh, lon=lon, lat=lat
; For a file get delp
  nc4readvar, filename[0], 'delp', delp
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'troppb', tropp

; Make a vertical pressure coordinate out of delp (probably only good
; enough in the stratosphere)
  lev = fltarr(72)
  iz = 0
  lev[iz] = 1. + total(delp[*,*,iz]) / (n_elements(lon)*n_elements(lat)) / 2.
  for iz = 1, 71 do begin
   lev[iz] = lev[iz-1] + ( total(delp[*,*,iz-1])+ total(delp[*,*,iz])) /  $
                         (n_elements(lon)*n_elements(lat)) / 2.
  endfor
  lev = lev/100.

; Form into a zonal mean
  su = reform(total(su,1)/n_elements(lon))*1e6        ; Mm
  rh = reform(total(rh,1)/n_elements(lon))
  tropp = reform(total(tropp,1)/n_elements(lon))/100. ; hPa

; Loop and plot
  for i = 0, n_elements(filename)-1 do begin

  set_plot, 'ps'
  device, file='plot_zonal_vertical_extinction_gocart.totextcoef.clim.'+expid+'.'+strmid(nymd[i],0,6)+'.ps', /color, $
   /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle=' ', ytitle=' ', $
        title=' ', $
        xrange=[-90,90], yrange=[400,10], $
        yticks=5, ytickv=[400,200,100,50,20,10], $
        xstyle=9, ystyle=9, /ylog, $
        xticks=6, xtickv=findgen(7)*30-90

  loadct, 56
  colors = 25. + findgen(10)*25
  levels = [0.05,0.1,0.15,0.2,0.3,0.5,1,2,5,10]
  contour, /over, su[*,*,i], lat, lev, levels=levels, /cell
  loadct, 0
  contour, /over, rh[*,*,i], lat, lev, c_colors=160, levels=[.1,.2,.4,.6,.8], c_lab=[1,1,1,1,1]
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='pressure [hPa]', $
        title=strmid(nymd[i],0,6), $
        xrange=[-90,90], yrange=[400,10], $
        xstyle=9, ystyle=9, /ylog, $
        yticks=5, ytickv=[400,200,100,50,20,10], $
        xticks=6, xtickv=findgen(7)*30-90
  oplot, lat, tropp[*,i], thick=6

  xyouts, .15, .12, 'total aerosol extinction [Mm-1]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

  endfor

end
