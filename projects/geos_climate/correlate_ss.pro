  expid = 'S2S1850CO2x4pl'
  filetemplate = expid+'.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[0:455]

  nc4readvar, filename, 'sscmass', ss, lon=lon, lat=lat
  sst = mean(ss,dim=3)

  filetemplate = expid+'.surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[0:455]
  nc4readvar, filename, 'u10m', u, lon=lon, lat=lat
  nc4readvar, filename, 'v10m', v, lon=lon, lat=lat
  nc4readvar, filename, 'ts', ts, lon=lon, lat=lat
  nc4readvar, filename[0], 'frocean', fr, lon=lon, lat=lat
  u = sqrt(u*u+v*v)

  nx = n_elements(lon)
  ny = n_elements(lat)
  corr = fltarr(nx,ny)
  corr2 = fltarr(nx,ny)

  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    corr[ix,iy] = correlate(ss[ix,iy,*],u[ix,iy,*])
    corr2[ix,iy] = correlate(ss[ix,iy,*],ts[ix,iy,*])
   endfor
  endfor

  a = where(fr lt .95)
  corr[a] = !values.f_nan
  corr2[a] = !values.f_nan



  set_plot, 'ps'
  device, file='correlate_ss.wind.ps', /color
  !p.font=0

  loadct, 39
  colors=[0,48,84,176,208,254]
  map_set, /cont, position=[.05,.2,.95,.95]
  contour, /over, corr, lon, lat, /cell, levels=[-1,0,.1,.2,.4,.8],$
    c_colors=colors
  contour, /over, sst*1e6, lon, lat, levels=[5,10,20,30,50,70]
  makekey, .1, .1, .8, .05, 0, -.05, colors=colors, $
   labels=['-1','0','0.1','0.2','0.4','0.8']
  device, /close


  set_plot, 'ps'
  device, file='correlate_ss.ts.ps', /color
  !p.font=0

  loadct, 39
  colors=[0,48,84,176,208,254]
  map_set, /cont, position=[.05,.2,.95,.95]
  contour, /over, corr2, lon, lat, /cell, levels=[-1,0,.1,.2,.4,.8],$
    c_colors=colors
  contour, /over, sst*1e6, lon, lat, levels=[5,10,20,30,50,70]
  makekey, .1, .1, .8, .05, 0, -.05, colors=colors, $
   labels=['-1','0','0.1','0.2','0.4','0.8']
  device, /close


end
