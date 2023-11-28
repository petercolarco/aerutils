; Plot the time series of the global, monthly mean aerosol forcing

  area, lon, lat, nx, ny, dx, dy, area, grid='c'

; Read the regional mask file
  nc4readvar, 'Region_c90_mapl_mask_v01.latlon.nc4', 'region_mask', mask, $
   lon=lon_, lat=lat_
  a = where(mask gt 11)
  mask[a] = 0.

  reg = ['full','r01','r02','r03','r04','r05','r06','r07','r08','r09','r10']
  nreg = n_elements(reg)
  bins = ['full','bin1','bin2','bin3','bin4','bin5']
  nbin = n_elements(bins)

  rmask = [.2,1,2,3,4,5,6,7,8,9,10]-.1

  for ireg = 0, nreg-1 do begin
print, reg[ireg]

  for ibin = 0, nbin-1 do begin

; Make a plot of the time series of global mean AOT
  expctl = reg[ireg]+'_'+bins[ibin]+'.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, ['olrna','olr'], swtnet, lon=lon, lat=lat

; Get the aerosol forcing
  swtnet = swtnet[*,*,*,0]-swtnet[*,*,*,1]
  swtnet = aave(swtnet,area,/nan)

; Make a plot
  if(ibin eq 0) then begin
   set_plot, 'ps'
   device, file='plot_dustforce.ir.'+reg[ireg]+'.ps', /color, font_size=12, /helvetica
   !p.font=0
   loadct, 39
   x = indgen(60)+1
   plot, x, swtnet, /nodata, $
    xrange=[0,60], xticks=6, xstyle=1, ystyle=1, $
    yrange=[0,.8], title=reg[ireg]
   oplot, x, swtnet, thick=6
  endif else begin
   oplot, x, swtnet, thick=4, color=ibin*50
  endelse

  if(ibin eq nbin-1) then begin
   plots, [2,6], .75, thick=6
   plots, [2,6], .72, thick=4, color=50
   plots, [2,6], .69, thick=4, color=100
   plots, [2,6], .66, thick=4, color=150
   plots, [2,6], .63, thick=4, color=200
   plots, [2,6], .6, thick=4, color=250
   xyouts, 6.5, .74, 'All bins'
   xyouts, 6.5, .71, 'bin 1'
   xyouts, 6.5, .68, 'bin 2'
   xyouts, 6.5, .65, 'bin 3'
   xyouts, 6.5, .62, 'bin 4'
   xyouts, 6.5, .59, 'bin 5'
   loadct, 0
   map_set, /noerase, position=[.6,.6,.9,.9]
   mask_ = mask
   if(ireg ne 0) then begin
    a = where(mask gt rmask[ireg]+1)
    mask_[a] = 0.
   endif
   contour, /over, mask_, lon_, lat_, lev=rmask[ireg], /cell, color=100
   map_continents, thick=2
   device, /close
  endif
endfor

endfor

end
