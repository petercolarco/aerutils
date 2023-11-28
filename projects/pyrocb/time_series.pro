  fileout = 'time_series.52_56.126_122.ps'
  wantlat = [52,56]
  wantlon = [-126,-122]

  fileout = 'time_series.54_60.130_120.ps'
  wantlat = [54,60]
  wantlon = [-130,-120]

  fileout = 'time_series.66_70.133_127.ps'
  wantlat = [66,70]
  wantlon = [-133,-127]

  fileout = 'time_series.60_70.100_90.ps'
  wantlat = [60,70]
  wantlon = [-100,-90]

  fileout = 'time_series.68_72.118_112.ps'
  wantlat = [68,72]
  wantlon = [-118,-112]

  ddf = 'aer.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['brcphilic','brcphobic'], brc, /sum, $
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
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)

  ddf = 'ze.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
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
  brc  = mean(mean(brc*airdens,dim=1),dim=1)
  z    = mean(mean(z,dim=1),dim=1)
  ze   = mean(mean(ze,dim=1),dim=1)
  trb  = mean(mean(troppb,dim=1),dim=1)
  trv  = mean(mean(troppv,dim=1),dim=1)
  trt  = mean(mean(troppt,dim=1),dim=1)
  p    = mean(mean(p,dim=1),dim=1)
  ple  = mean(mean(ple,dim=1),dim=1)

; Make an x coordinate
  x  = findgen(nt,nz)
  for i = 0, nt-1 do begin
   x[i,*] = i
  endfor

; Transpose
  brc = transpose(brc)
  z   = transpose(z)
  p   = transpose(p)
  ple = transpose(ple)
  ze  = transpose(ze)/1000.

; Make a plot
  set_plot, 'ps'
  device, file=fileout, /color, font_size=10, /helvetica, $
   xsize=36, ysize=18
  !p.font=0  
  loadct, 0
  levels = [1,2,5,10,20,50,100,200]
  xtickn = fltarr(nt)
  xtickn[0:1] = [22,23]
  xtickn[2:25] = findgen(24)
  xtickn[26:nt-1] = findgen(22)
  xtickn = string(xtickn,format='(i2)')
  contour, brc*1e9, x, p/100., /nodata, $
   yrange=[1000,100], levels=levels, /cell, /ylog, $
   xtickn=xtickn, xrange=[0,nt-1], xstyle=1, xticks=nt-1, $
   position=[.1,.1,.95,.95]
  loadct, 56
  contour, brc*1e9, x, p/100., /over, /cell, levels=levels
  loadct, 0
  xyouts, 2, 1200, 'August 13', /data
  xyouts, 26, 1200, 'August 14', /data
  oplot, x[*,0], trb/100., thick=6, lin=2
  for k = nz, 0, -1 do begin
   oplot, x[*,0], ple[*,k]/100.
  endfor
  for k = 46,38, -1 do begin
   xyouts, 1, .99*ple[1,k]/100., string(ze[0,k],format='(f6.3)'), /data, noclip=1
  endfor

  device, /close

end
