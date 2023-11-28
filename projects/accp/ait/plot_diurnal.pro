  pro plotit, nx, ny, num, aod, noerase, ct, cthick, ccol, xoff
;  noerase = 0
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    if(max(num[ix,iy,*]) gt 0) then begin
;     var = aod[ix,iy,*]-min(aod[ix,iy,*])
     var = reform(aod[ix,iy,*])
     var = var/max(var)
    x = ix*1./nx+.005
    dx = 1./nx-.015
    y = iy*1./ny+.005
    dy = 1./ny-.015
    loadct, 0
    plot, indgen(24)+1, var, noerase=noerase, /nodata, $
     xrange=[0,25], yrange=[0.5,1], $
     position=[x,y,x+dx,y+dy], xticks=1, yticks=1, $
     xtickn=[' ',' '], ytickn=[' ',' '], xstyle=1, ystyle=1, color=180
    loadct, ct
    oplot, indgen(24)+1, reform(var), thick=cthick, color=ccol
    noerase = 1
    xyouts, xoff, .55, string(total(num[ix,iy,*])/365.,format='(i6)'), $
     /data, color=ccol, charsize=.7
    endif
   endfor
  endfor

  end

  pro plot_diurnal, varn, inc, nx, ny
  
; Make a plot
  filen = varn+'_annual.full.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num

  set_plot, 'ps'
  snx = string(nx,format='(i02)')
  sny = string(ny,format='(i02)')
  fileo = varn+'_annual.inc'+inc+'.'+snx+'_'+sny+'.ps'
  device, file=fileo, /helvetica, font_size=12, /color, $
   xsize=36, ysize=18
  !p.font=0

  plotit, nx, ny, num, aod, 0, 0, 6, 0, 1

; Overplot another case
  filen = varn+'_annual.wide'+inc+'.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num
  plotit, nx, ny, num, aod, 1, 39, 3, 254, 8

; Overplot another case
  filen = varn+'_annual.nadir'+inc+'.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num
  plotit, nx, ny, num, aod, 1, 39, 3, 84, 15

  loadct, 0
  map_set, /cont, /noerase, position=[.01,.01,.99,.99], color=110
  device, /close

end
