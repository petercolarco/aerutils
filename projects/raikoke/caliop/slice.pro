  fileout = 'slice.v3.20190702_15.ps'
  wantlat = [50,80]
  wantlon = [-180,180]

  filename = '/misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.inst3d_aer_misc_v.20190702_1500z.nc4'
  nc4readvar, filename, ['SUEXTCOEF'], su, /sum, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'h', z, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppb', troppb, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppt', troppt, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppv', troppv, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'ps', ps, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', airdens, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat, lev=lev
  nc4readvar, filename, 'th', th, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat, lev=lev
  nc4readvar, filename, 'dtdtrad', dtdtrad, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat, lev=lev
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)

  filename = '/misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.inst3d_prog_misc_v.20190702_1500z.nc4'
  nc4readvar, filename, 'he', ze, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat

; Make a vertical pressure coordinate
  p   = fltarr(nx,ny,nz,nt)
  ple = fltarr(nx,ny,nz+1,nt)
  ple[*,*,nz,*] = ps
  for k = nz-1, 1, -1 do begin
   ple[*,*,k,*] = ple[*,*,k+1,*] - delp[*,*,k,*]
   p[*,*,k,*]   = 10^((alog10(ple[*,*,k+1,*])+alog10(ple[*,*,k,*]))/2.)
  endfor
  

; average
  su   = mean(su,dim=2)
  z    = mean(z,dim=2)
  ze   = mean(ze,dim=2)/1000.
  trb  = mean(troppb,dim=2)
  trv  = mean(troppv,dim=2)
  trt  = mean(troppt,dim=2)
  p    = mean(p,dim=2)
  ple  = mean(ple,dim=2)
  th   = mean(th,dim=2)
  dtdt = mean(dtdtrad,dim=2)*86400.

; Make an x coordinate
  x  = findgen(nx,nz)
  for i = 0, nx-1 do begin
   x[i,*] = lon[i]
  endfor

; Make a plot
  set_plot, 'ps'
  device, file=fileout, /color, font_size=10, /helvetica, $
   xsize=36, ysize=18
  !p.font=0  
  loadct, 0
  levels = [1,2,5,10,20,50,100,200,500,1000,2000,5000]/10.
  contour, su*1e6, x, p/100., /nodata, $
   yrange=[1000,100], levels=levels, /cell, /ylog, ystyle=1, ytickn=[' ',' '], yticks=1, $
   xrange=[-65,160], xstyle=1, xticks=9, $
   position=[.1,.1,.95,.95]
  loadct, 63
  contour, su*1e6, x, p/100., /over, /cell, levels=levels
  loadct, 0
  contour, su*1e6, x, p/100., /nodata, /noerase, $
   yrange=[1000,100], levels=levels, /cell, /ylog, ystyle=1, ytickn=[' ',' '], yticks=1, $
   xrange=[-65,160], xstyle=1, xticks=9, $
   position=[.1,.1,.95,.95]
  oplot, x[*,0], trb/100., thick=8, lin=2
  for k = nz, 0, -1 do begin
   oplot, x[*,0], ple[*,k]/100., thick=3
  endfor
  loadct, 39
;  contour, th, x, p/100., /over, c_thick=5, c_color=72, $
;   levels=[315,320,325,330,335,340,350,360,380,400,420], c_label=make_array(11,val=1)
  contour, dtdt, x, p/100., /over, c_thick=1, c_color=0, $
   levels=2+findgen(13)*2, c_label=[1,0,1,0,1,0,1,0,1,0,1,0,1]
  for k = 49,38, -1 do begin
   xyouts, -71, 1.01*ple[1,k]/100., string(ze[0,k],format='(f4.1)'), /data, noclip=1
  endfor
  xyouts, -75, 250, 'Altitude [km]', orient=90, /data, chars=1.5, align=.5

  loadct, 0
  levels = [1,2,5,10,20,50,100,200,500,1000,2000,5000]
  polyfill, [.14,.51,.51,.14,.14],[.825,.825,.9,.9,.825], color=255, /normal
  makekey, .15, .85, .35, .05, 0., -0.02, $
   color=make_array(12,val=0), label=string(levels,format='(i4)'), align=0
  loadct, 63
  makekey, .15, .85, .35, .05, 0., -0.02, color=indgen(12)*20+10, label=make_array(n_elements(levels),val=' ')


  device, /close

end
