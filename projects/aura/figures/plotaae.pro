; Recover the sampling
  restore, file='getregions.aae.200707.sav'

; Region of interest
  latedge = [20,24]
  lonedge = findgen(21)-25.
  lonnode = -24.5+findgen(20)
  nx = n_elements(lonnode)
  regname = 'nafrica'
  xrange = [-25,-5]

  set_plot, 'ps'
  device, file='plotaae.ps', /color
  !p.font=0

; AAE
  loadct, 0
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[1,3], $
   xtitle='longitude', ytitle='AAE', $
   title='AAE: MERRAero = red'
  aae_    = fltarr(nx,2)
  for ix = 0, nx-1 do begin
   a = where(lon gt lonedge[ix] and lon le lonedge[ix+1] and $
             lat gt latedge[0]  and lat le latedge[1])
   aae_[ix,0]    = mean(aae[a])
   aae_[ix,1]    = stddev(aae[a])
  endfor
  loadct, 62
  fillmeanstd, lonnode, aae_[*,0], aae_[*,1], color=200, fillcolor=50
  oplot, lonnode, aae_[*,0], color=200, thick=6

  device, /close

end
