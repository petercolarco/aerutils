  expid = 'c180R_calbucco'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

;  nc4readvar, filename, 'sucmass', su, lon=lon, lat=lat
;  nc4readvar, filename, 'ducmass', du, lon=lon, lat=lat

  lat2 = 1
  lon2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2

  expid = 'c180Rb_calbucco'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
;  nc4readvar, filename, 'sucmass', su2, lon=lon, lat=lat
;  nc4readvar, filename, 'ducmass', du2, lon=lon, lat=lat

  sut = fltarr(nf)
  sut2 = fltarr(nf)
  dut = fltarr(nf)
  dut2 = fltarr(nf)
  du  = reform(du,nx*ny*1L,nf)
  du2 = reform(du2,nx*ny*1L,nf)
  su  = reform(su,nx*ny*1L,nf)
  su2 = reform(su2,nx*ny*1L,nf)
  a = where(lat2 lt -15)
  for i = 0, nf-1 do begin
   sut[i]  = total(su[*,i]*area)
   sut2[i] = total(su2[*,i]*area)
   dut[i]  = total(du[a,i]*area[a])
   dut2[i] = total(du2[a,i]*area[a])
  endfor

stop

  red   = [0, 237, 204, 153, 102, 65, 35, 0    , 152]
  green = [0, 248, 236, 216, 194, 174, 139, 88 , 152]
  blue  = [0, 251, 230, 201, 164, 118, 69, 36  , 152]
  tvlct, red, green, blue
  levels   = [1,2,5,10,20,30,50]
  dcolors=indgen(n_elements(levels))+1
  igrey  = n_elements(red)-1
  iblack = 0

  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'sucmass', su, lon=lon, lat=lat
   check, su*1e6
   set_plot, 'ps'
   device, file='sucmass.'+expid+'.'+strmid(filename[i],17,14,/rev)+'.ps', $
    /helvetica, font_size=12, $
    xsize=16, ysize=12, xoff=.1, yoff=.1, /color
   !p.font=0

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   position = [.05,.1,.95,.95]
   plot_map, su*1e6, lon, lat, dx, dy, levels, dcolors, position, igrey, /contour
   xyouts, .1, .95, 'Sulfate Mass Loading [mg m!E-3!N]', /normal
   xyouts, .9, .95, strmid(filename[i],17,14,/rev), /normal, align=1

   makekey, .25, .15, .5, .03, 0, -.04, /noborder, align=0, $
     color=make_array(n_elements(levels),val=igrey), $
     label=string(levels,format='(i2)')
   makekey, .25, .15, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

   device, /close

  endfor

end
