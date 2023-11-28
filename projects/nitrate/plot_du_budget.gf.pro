  expid = 'c90F_J10p14p1'
  expip = 11
  set_plot, 'ps'
  device, file='plot_du_budget.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  xt = 2000.+findgen(241)/12.

  plot, xt, indgen(241), /nodata, xticks=20, $
   yrange=[0,300], xrange=[2000,2020],  $
   position=[.05,.4,.95,.95], xminor=1, xtickn=make_array(21,val=' ')

  loadct, 39

   filetemplate = expid+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
;filename = filename[0:11]
   nc4readvar, filename, 'ducmass', ducmass, lon=lon, lat=lat, time=time
   nc4readvar, filename, 'dusv', dusv
   dusv = -dusv
;   nc4readvar, filename, 'dusv0', dusv, /sum, /tem
   nc4readvar, filename, 'dusd0', dusd, /sum, /tem
   nc4readvar, filename, 'dudp0', dudp, /sum, /tem
   nc4readvar, filename, 'duwt0', duwt, /sum, /tem
   nc4readvar, filename, 'duem0', duem, /sum, /tem
   area, lon, lat, nx, ny, dx, dy, area
   dum = aave(ducmass,area)*total(area)/1.e9
   dusv = aave(dusv,area)*total(area)/1.e9*30*86400
   dusd = aave(dusd,area)*total(area)/1.e9*30*86400
   dudp = aave(dudp,area)*total(area)/1.e9*30*86400
   duwt = aave(duwt,area)*total(area)/1.e9*30*86400
   duem = aave(duem,area)*total(area)/1.e9*30*86400
   x = 2000+expip+findgen(n_elements(time))/12.
   oplot, x, duwt+dusv, thick=6, color=84
   oplot, x, dusd+dudp, thick=6, color=208
   oplot, x, duem, thick=6, color=160
   oplot, x, duwt+dusv+dusd+dudp, thick=6, color=254, lin=2

; print the average values
  mloss = mean(duwt+dusv+dusd+dudp)
  mwet  = mean(duwt+dusv)
  mdry  = mean(dudp+dusd)
  memi  = mean(duem)
  xyouts, min(x)-2, memi, string(memi,format='(f6.1)')+' Tg', color=176
  xyouts, min(x)-2, mwet, string(mwet,format='(f6.1)')+' Tg', color=84
  xyouts, min(x)-2, mdry, string(mdry,format='(f6.1)')+' Tg', color=208
  xyouts, min(x)-4, mloss, string(mloss,format='(f6.1)')+' Tg', color=254

  plot, xt, /nodata, xticks=20, /noerase, $
   xtickn=string([xt[0:240:12]],format='(i4)'), $
   yrange=[-10,60], xrange=[2000,2020], $
   position=[.05,.05,.95,.4], xminor=1, yticks=7, $
   ytickn=[string((indgen(7)-1)*10,format='(i3)'),' '], yminor=2
   oplot, x, dum, thick=6
   tot = duem - (dusd+dudp+duwt+dusv)

; Now plot the accumulated...
  accum = fltarr(n_elements(time))
  accum[0] = tot[0]
  for i = 1, n_elements(time)-1 do begin
   accum[i] = accum[i-1]+tot[i]
  endfor
  oplot, x, accum, thick=6, color=254

; plot the average values
  mcm = mean(dum)
  mac = mean(accum)
  xyouts, min(x)-2, mcm, string(mcm,format='(f5.1)')+' Tg'
  xyouts, min(x)-2, mac, string(mac,format='(f5.1)')+' Tg', color=254



  device, /close

end
