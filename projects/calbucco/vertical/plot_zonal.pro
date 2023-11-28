  expid = 'c180R_calbucco'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd eq '20150427')
  filename = filename[a]
  nf = n_elements(filename)

  red   = [0, 237, 204, 153, 102, 65, 35, 0    , 152]
  green = [0, 248, 236, 216, 194, 174, 139, 88 , 152]
  blue  = [0, 251, 230, 201, 164, 118, 69, 36  , 152]
  tvlct, red, green, blue
  levels   = [1,2,5,10,20,30,50]/100.
  dcolors=indgen(n_elements(levels))+1
  igrey  = n_elements(red)-1
  iblack = 0

  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'suconc', su, lon=lon, lat=lat, lev=lev
   a = where(lon ge -50 and lon le -35)
   su = reform(total(su[a,*,*],1)/n_elements(lon[a]))
   a = where(su gt 1e12)
   su[a] = !values.f_nan

   nc4readvar, filename[i], 'duconc', du, lon=lon, lat=lat, lev=lev
   a = where(lon ge -50 and lon le -35)
   du = reform(total(du[a,*,*],1)/n_elements(lon[a]))
   a = where(du gt 1e12)
   du[a] = !values.f_nan

   set_plot, 'ps'
   device, file='vertical.'+expid+'.'+strmid(filename[i],17,14,/rev)+'.ps', $
    /helvetica, font_size=12, $
    xsize=16, ysize=12, xoff=.1, yoff=.1, /color
   !p.font=0

   red   = [0, 237, 204, 153, 102, 65, 35, 0    , 152]
   green = [0, 248, 236, 216, 194, 174, 139, 88 , 152]
   blue  = [0, 251, 230, 201, 164, 118, 69, 36  , 152]
   tvlct, red, green, blue
   levels   = [5,10,20,30,50,100,200]/100.
   contour, su, lat, lev, /nodata, $
    xrange=[-10,-40], xstyle=9, xtitle='Latitude', $
    yrange=[1000,30], ystyle=9, /ylog, ytitle='Pressure [hPa]', $
    thick=3, position=[.15,.25,.95,.9], xticks=6
   contour, /overplot, su*1e9, lat, lev, levels=levels, c_colors=dcolors, /fill
   contour, su, lat, lev, /nodata, /noerase, $
    xrange=[-10,-40], xstyle=9, xtitle='Latitude', $
    yrange=[1000,30], ystyle=9, /ylog, ytitle='Pressure [hPa]', $
    thick=3, position=[.15,.25,.95,.9], xticks=6

   makekey, .25, .1, .6, .03, 0, -.04, /noborder, align=0, $
     color=make_array(n_elements(levels),val=igrey), $
     label=string(levels,format='(f4.2)')
   makekey, .25, .1, .6, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']


;   ct = colortable(63)
;   c = contour(su*1e9, lat, lev, $
;               rgb_table=ct, $
;               /fill,c_value=levels, xmajor=10, xminor=1, $
;               xtitle='Latitude', ytitle='Pressure [hPa]', $
;               position=[.15,.25,.95,.9], $
;               xrange=[-60,-15], yrange=[1000,10], /ylog)
;   cb = colorbar(TITLE='Sulfate Mass Concentration [$ug m^{-3}$]', $
;                 position=[.175,.12,.475,.17])

;   levels   = [1,2,5,10,20,30,50]
;   ct = colortable(65)
;   c = contour(du*1e9, lat, lev, $
;               rgb_table=ct, $
;               /fill,c_value=levels, xmajor=10, xminor=1, $
;               xtitle='Latitude', ytitle='Pressure [hPa]', $
;               /overplot, transparency=30, $
;               xrange=[-60,-15], yrange=[1000,10], /ylog)

   red   = [0, 255,254,254,253,252,227,177, 152]
   green = [0, 255,217,178,141,78,26,0    , 152]
   blue  = [0, 178,178,76,60,42,28,38     , 152]
   tvlct, red, green, blue
   levelsd  = [1,2,5,10,20,30,50]
   contour, /overplot, du*1e9, lat, lev, levels=levelsd, c_colors=dcolors, $
     c_thick=3, c_label=make_array(n_elements(dcolors),val=1)

   xyouts, .15, .95, 'Sulfate Concentration [mg m!E-3!N]', /normal
   xyouts, .95, .95, strmid(filename[i],17,14,/rev), /normal, align=1

   device, /close

  endfor

end
