; Array for global AOD
  expid = ['d5124_m2_jan79', 'merra2gmi', $
           'c180F_pI20p1-acma', 'c180F_pI20p1-acma_mie', $, $
           'c180F_pI20p1-acma_miet', 'c180F_pI20p1-acma_nodu', $
           'c180F_pI20p1-acma_spher','c180F_pI20p1-acma_gocart']

  nexpid = n_elements(expid)
  ddf = expid
  ddf[0:1] = ddf[0:1]+'.ddf'
  ddf[2:nexpid-1]  = ddf[2:nexpid-1]+'.tavg2d_aer_x.ctl'

  totexttau = fltarr(12,nexpid)
  duexttau  = fltarr(12,nexpid)

  color     = [120, 120, 0, 254, 254, 176, 254, 208]
  lin       = [  0,   2, 0,   2,   1,   0,   0,   0]

  for iexpid = 0, nexpid-1 do begin

   print, iexpid+1, nexpid

   expctl = ddf[iexpid]
   ga_times, expctl, nymd, nhms, template=filetemplate
   filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
   nc4readvar, filename, 'totexttau', totexttau_, lon=lon, lat=lat
   nc4readvar, filename, 'duexttau', duexttau_, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area, grid='d'
   totexttau[*,iexpid] = aave(totexttau_,area)
   duexttau[*,iexpid]  = aave(duexttau_,area)

  endfor

  set_plot, 'ps'
  device, file='global_aod.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 39
  x = findgen(12)+1
  xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, totexttau[*,0], thick=6, /nodata, $
   xstyle=4, xrange=[0,13], xticks=13, xtickn=xtickn, $
   ystyle=9, yrange=[0.1,0.24], ytitle='Total', $
   position=[.15,.5,.95,.95], yticks=7
  for iexpid = 0, nexpid-1 do begin
   if(iexpid lt 2) then loadct, 0
   if(iexpid ge 2) then loadct, 39
   oplot, x, totexttau[*,iexpid], color=color[iexpid], thick=6, lin=lin[iexpid]
  endfor


  plot, totexttau[*,0], thick=6, /nodata, /noerase, $
   xstyle=9, xrange=[0,13], xticks=13, xtickn=xtickn, $
   ystyle=9, yrange=[0.,0.06], ytitle='Dust', $
   position=[.15,.15,.95,.45], yticks=3
  for iexpid = 0, nexpid-1 do begin
   if(iexpid lt 2) then loadct, 0
   if(iexpid ge 2) then loadct, 39
   oplot, x, duexttau[*,iexpid], color=color[iexpid], thick=6, lin=lin[iexpid]
  endfor


  device, /close

end
