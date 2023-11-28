  fileout = 'zonal.v3.30_50n.ps'
  wantlat = [30,50]

  ddf = 'v3.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['suextcoef','brcextcoef','ocextcoef'], su, /sum, $
   wantlat=wantlat, lon=lon, lat=lat, lev=lev

; Get a height
  filename = '/misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.inst3d_prog_misc_v.20190622_0300z.nc4'
  nc4readvar, filename, 'he', ze, $
   wantlat=wantlat, lon=lon, lat=lat

; average
  su   = transpose(mean(mean(su,dim=1),dim=1))
  ze   = transpose(mean(mean(ze,dim=1),dim=1))/1000.

  nt = n_elements(nymd)

; Make an x coordinate
  nz = n_elements(lev)
  x  = findgen(nt,nz)
  for i = 0, nt-1 do begin
   x[i,*] = i
  endfor

; Make a y coordinate
  y  = findgen(nt,nz)
  for j = 0, nz-1 do begin
   y[*,j] = mean([ze[j],ze[j+1]])
  endfor


; Make a plot
  set_plot, 'ps'
  device, file=fileout, /color, font_size=10, /helvetica, $
   xsize=36, ysize=18
  !p.font=0  
  loadct, 0
  levels = findgen(16)
  contour, su*1e7, x, y, /nodata, $
   yrange=[10,35], levels=levels, /cell, ystyle=1, $
   xrange=[min(x),max(x)], xstyle=1, xticks=14, $
   position=[.1,.1,.95,.95]
  loadct, 39
  contour, su*1e7, x, y, /over, /cell, levels=levels, c_colors=indgen(16)*16
  loadct, 0
  contour, su*1e7, x, y, /nodata, /noerase, $
   yrange=[10,35], levels=levels, /cell, ystyle=1, $
   xrange=[min(x),max(x)], xstyle=1, xticks=14, $
   position=[.1,.1,.95,.95]

  loadct, 0
  polyfill, [.14,.51,.51,.14,.14],[.825,.825,.91,.91,.825], color=255, /normal
  makekey, .15, .85, .35, .05, 0., -0.02, $
   color=make_array(16,val=0), label=string(levels,format='(i4)'), align=0
  loadct, 39
  makekey, .15, .85, .35, .05, 0., -0.02, color=indgen(16)*16, label=make_array(n_elements(levels),val=' ')


  device, /close

end
