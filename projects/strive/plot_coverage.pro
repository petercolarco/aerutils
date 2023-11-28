  loadct, 0

  set_plot, 'ps'
  device, file='plot_coverage.ps', /color, /helvetica, font_size=14, $
   xsize=16, ysize=12
  !p.font=0

  latb = -85. + findgen(18)*10.
;goto, jump
  bins = fltarr(9,18)

  for i = 0,7 do begin

   filename = 'argos'+string(i+1,format='(i1)')+'.csv'
   filename = 'c180R_v10p23p0_sc.tavg3d_aer_p.argos'+string(i+1,format='(i1)')+'.trj.nc'
   read_argos, filename, lon, lat, time, sza
   a = where(sza gt 88.)
   if(a[0] ne -1) then lon[a] = !values.f_nan
   if(a[0] ne -1) then lat[a] = !values.f_nan

   for j = 0, 17 do begin
    a = where( (finite(lat) eq 1) and $
               (lat gt latb[j]-5. and lat le latb[j]+5.))
    if(a[0] ne -1) then bins[i,j] = bins[i,j]+n_elements(a)
   endfor

  endfor

  for j = 0, 17 do begin
   bins[8,j] = total(bins[0:7,j])
  endfor

jump:
  binsn = fltarr(9,18)
  for i = 0, 8 do begin

   binsn[i,*] = bins[i,*]/total(bins[i,*])
  endfor

  plot, findgen(10), /nodata, $
   yrange=[-90,90], yticks=6, ytitle='Latitude', ystyle=1, $
   xrange=[0,10], xticks=10, xtickn=[' ','0','1','2','3','4','5','6','7','All',' '], $
   xminor=1, position=[.12,.2,.95,.95]
  
  x  = findgen(9)+1
  dx = 1.
  y  = latb
  dy = 10.
  levels=findgen(10)*0.02
  colors=255-findgen(10)*25
  
  plotgrid, binsn, levels, colors, x, y, dx, dy

  plot, findgen(10), /nodata, /noerase, $
   yrange=[-90,90], yticks=6, ytitle='Latitude', ystyle=1, $
   xrange=[0,10], xticks=10, xtickn=[' ','0','1','2','3','4','5','6','7','All',' '], $
   xminor=1, position=[.12,.2,.95,.95]
  
  makekey, .12, .08, .83, .05, 0.01, -0.05, align=0, $
   colors=colors, labels=['<2%','2','4','6','8','10','12','14','16','>18%']


  device, /close
end
