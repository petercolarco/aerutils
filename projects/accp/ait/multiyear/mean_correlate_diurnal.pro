  pro mean_correlate_diurnal, nx, ny
  
; Make a plot
  varn = 'preccon'
  filen = varn+'_annual.full.2012_2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num
  filen = varn+'_annual.full.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod1, num1

  set_plot, 'ps'
  snx = string(nx,format='(i02)')
  sny = string(ny,format='(i02)')
  fileo = 'mean_correlate_annual.'+snx+'_'+sny+'.ps'
  device, file=fileo, /helvetica, font_size=12, /color, $
   xsize=18, ysize=14
  !p.font=0

; Get the inclination cases
  ninc = 3
  inc = ['045','055','065']
  correl = fltarr(nx,ny,ninc,2)
  for iinc = 0, ninc-1 do begin
   filen = varn+'_annual.nadir'+inc[iinc]+'.2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod_, num_
   filen = varn+'_annual.nadir'+inc[iinc]+'.2012_2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod__, num__
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     statistics, aod1[ix,iy,*], aod_[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,0] = r
     statistics, aod[ix,iy,*], aod__[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,1] = r
    endfor
   endfor
  endfor

; Plot the correlation
  plot, indgen(24), /nodata, $
   xrange=[0,4], yrange=[0.25,1], $
   xticks=4, yticks=3, xminor=1, yminor=1, ystyle=1, $
   ytitle='Correlation of sub-sample versus Full', $
   xtitle='Inclination', $
   xtickn=[' ','45!Eo!N','55!Eo!N','65!Eo!N',' ']

; Average and plot the correlations across the tropics for preccon
  loadct, 39
  colors = 40+findgen(ninc)*40+10
  yval = fltarr(ninc)
  for iinc = 0, ninc-1 do begin
   yval[iinc] = mean(correl[*,2:3,iinc,0])
  endfor
  oplot, indgen(ninc)+1, yval, thick=6
  for iinc = 0, ninc-1 do begin
   plots, iinc+1, yval[iinc], psym=sym(5), color=84, symsize=2
  endfor
  for iinc = 0, ninc-1 do begin
   yval[iinc] = mean(correl[*,2:3,iinc,1])
  endfor
  oplot, indgen(ninc)+1, yval, thick=6, lin=2
  for iinc = 0, ninc-1 do begin
   plots, iinc+1, yval[iinc], psym=sym(5), color=84, symsize=2
  endfor

; Make a plot
  varn = 'pm25'
  filen = varn+'_annual.full.2012_2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod, num
  filen = varn+'_annual.full.2014.nc4'
  aggregate_diurnal, filen, varn, nx, ny, aod1, num1

; Get the inclination cases
  ninc = 3
  inc = ['045','055','065']
  correl = fltarr(nx,ny,ninc,2)
  for iinc = 0, ninc-1 do begin
   filen = varn+'_annual.nadir'+inc[iinc]+'.2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod_, num_
   filen = varn+'_annual.nadir'+inc[iinc]+'.2012_2014.nc4'
   aggregate_diurnal, filen, varn, nx, ny, aod__, num__
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     statistics, aod1[ix,iy,*], aod_[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,0] = r
     statistics, aod[ix,iy,*], aod__[ix,iy,*], xmean, ymean, xstd, ystd, $
       r, bias, rms, skill, linslope, linoffset
     correl[ix,iy,iinc,1] = r
    endfor
   endfor
  endfor
  yval = fltarr(ninc)
  for iinc = 0, ninc-1 do begin
   yval[iinc] = mean(correl[*,2:3,iinc,0])
  endfor
  oplot, indgen(ninc)+1, yval, thick=6
  for iinc = 0, ninc-1 do begin
   plots, iinc+1, yval[iinc], psym=sym(5), color=208, symsize=2
  endfor
  for iinc = 0, ninc-1 do begin
   yval[iinc] = mean(correl[*,3:4,iinc,1])
  endfor
  oplot, indgen(ninc)+1, yval, thick=6, lin=2
  for iinc = 0, ninc-1 do begin
   plots, iinc+1, yval[iinc], psym=sym(5), color=208, symsize=2
  endfor


  device, /close

end
