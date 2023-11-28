; File to read
  lambda = '532'
  filedir  = './output/data/'
  filename = 'dR_MERRA-AA-r1.square_spiral_'+lambda+'nm.2_0deg.rot_w30.20100827.nc'

; Read
  depol = 1
  extinction = 1
  cloud=1
  read_curtain, filedir+filename, lon, lat, time, z, dz, $
                extinction_tot=extinction, cloud=cloud

  datestr = strcompress(string(time[0],format='(i8)'),/rem)

  plotfile = filename+'.ps'

  nt = n_elements(time)

  z  = transpose(z) /  1000. ; km
  dz = transpose(dz) / 1000. ; km
    
    

; Transpose arrays to be (time,hght)
  extinction = transpose(extinction)
  cloud      = transpose(cloud)

; Put time into hour of day
  time = (time - long(time))*24.

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color
  !p.font=0
 

  position = [.15,.2,.95,.9]
  a = where(time lt time[0])
  if(a[0] ne -1) then time[a] = time[a]+24.
  plot, indgen(n_elements(time)), /nodata, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle='altitude [km]', $
     position=position, $
     title = 'GEOS-5 Extinction Profile !C'+ $
             'along HS3 track '+datestr, $
             charsize=.75
  loadct, 39
  levelarray = findgen(60)*.005

  colorarray = findgen(60)*4+16
  plotgrid, extinction, levelarray, colorarray, $
            time, z, time[1]-time[0], dz
  labelarray = strarr(60)
  labels = [0., 0.05,0.1,0.15,0.2,0.25]
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
     if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(labels[il],format='(f5.3)')
  endfor
  makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
   label=labelarray, $
   align=.5, /no

; Overplot the cloud
  loadct, 0
  contour, /over, cloud, time, reform(z[0,*]), $
           levels=findgen(10)*.1+.1, c_color=255-findgen(10)*10, $
           /cell


; Make an inset map for display
  loadct, 0
  dxplot = position[2]-position[0]
  dyplot = position[3]-position[1]
  x0 = position[0]+.65*dxplot
  x1 = position[0]+.95*dxplot
  y0 = position[1]+.65*dyplot
  y1 = position[1]+.95*dyplot
  polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=255, /normal
  map_set, /noerase, position=[x0,y0,x1,y1], limit=[5,-55,25,-35]
; Plot the AOT
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r1/inst2d_hwl_x/Y2010/M08/'+ $
             'dR_MERRA-AA-r1.inst2d_hwl_x.20100827_1200z.nc4'
  nc4readvar, filename, 'totexttau', aot, lon=lonm, lat=latm
  loadct, 39
  levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
  labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
  colorArray = [30,64,80,96,144,176,192,199,208,254,10]
  dx = lonm[1]-lonm[0]
  dy = latm[1]-latm[0]
  plotgrid, aot, levelarray, colorarray, lonm, latm, dx, dy, /map
  map_continents, thick=.5
  oplot, lon, lat, thick=6
  a = where((time-fix(time+.0001)) lt .001)
  for i = 0, n_elements(a)-1 do begin
   xyouts, lon[a[i]], lat[a[i]], strpad(fix(time[a[i]]+.0001),10), $
           color=254, charsize=.5
  endfor
  usersym, [-1,1,1,-1,-1]*.25, [-1,-1,1,1,-1]*.25, color=254, /fill
  plots, lon[a], lat[a], psym=8
  plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], thick=6, /normal
 
    device, /close


end
