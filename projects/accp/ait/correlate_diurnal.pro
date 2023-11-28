  pro plotit, nx, ny, ninc, correl
  incstr = ['40','45','50','55','60','65']+'!Eo!N'
  noerase = 0
  colors = 40+findgen(ninc)*40
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
print, ix, iy, max(correl[ix,iy,*,*]), min(correl[ix,iy,*,*])
    x = ix*1./nx+.005
    dx = 1./nx-.015
    y = iy*1./ny+.005
    dy = 1./ny-.015
    loadct, 0
    plot, indgen(24)+1, noerase=noerase, /nodata, $
     xrange=[0,ninc+1], yrange=[-1,1], $
     position=[x,y,x+dx,y+dy], xticks=1, yticks=2, $
     xtickn=[' ',' '], ytickn=[' ',' ',' '], xstyle=1, ystyle=1, color=180
    plots, [0,ninc+1], 0, color=180
    noerase = 1
    loadct, 39
    for iinc = 0, ninc-1 do begin
     a = where(finite(correl[ix,iy,iinc,*]) ne 1)
     if(a[0] ne -1) then continue
     y = correl[ix,iy,iinc,0]
     polyfill, 1+iinc+[-0.33,0,0,-.33,-.33], [0,0,y,y,0], color=colors[iinc], /data
     y = correl[ix,iy,iinc,1]
     polyfill, 1+iinc+[0,.33,.33,0,0], [0,0,y,y,0], color=colors[iinc]+10, /data
     xyouts, iinc+1, -.15, incstr[iinc], chars=.5, align=0.5
    endfor
   endfor
  endfor

  end

  pro correlate_diurnal, varn, nx, ny
  
; Make a plot
  filen = varn+'_annual.full.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num

  set_plot, 'ps'
  snx = string(nx,format='(i02)')
  sny = string(ny,format='(i02)')
  fileo = varn+'_correlate_annual.'+snx+'_'+sny+'.ps'
  device, file=fileo, /helvetica, font_size=12, /color, $
   xsize=36, ysize=18
  !p.font=0

; Get the inclination cases
  ninc = 6
  inc = ['040','045','050','055','060','065']
  correl = fltarr(nx,ny,ninc,2)
  for iinc = 0, ninc-1 do begin
   filen = varn+'_annual.wide'+inc[iinc]+'.2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod_, num_
   filen = varn+'_annual.nadir'+inc[iinc]+'.2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod__, num__
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     statistics, aod[ix,iy,*], aod_[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,0] = r
     statistics, aod[ix,iy,*], aod__[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,1] = r
    endfor
   endfor
  endfor

  plotit, nx, ny, ninc, correl


  loadct, 0
  map_set, /cont, /noerase, position=[.01,.01,.99,.99], color=110
  device, /close

end
