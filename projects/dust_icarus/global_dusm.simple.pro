; Array for global AOD
  expid = ['d5124_m2_jan79', 'merra2gmi', $
           'c180F_pI20p1-acma_spher','c180F_pI20p1-acma_gocart']

  nexpid = n_elements(expid)
  ddf = expid
  ddf[0:1] = ddf[0:1]+'.ddf'
  ddf[2:nexpid-1]  = ddf[2:nexpid-1]+'.tavg2d_aer_x.ctl'

  duem   = fltarr(12,nexpid)
  duem25 = fltarr(12,nexpid)

  color     = [120, 120, 254, 208]
  lin       = [  0,   2,   0,   0]

  for iexpid = 0, nexpid-1 do begin

   print, iexpid+1, nexpid

   expctl = ddf[iexpid]
   ga_times, expctl, nymd, nhms, template=filetemplate
   filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
   nc4readvar, filename, 'duexttau', duex_, lon=lon, lat=lat
   nc4readvar, filename, 'dusmass25', dusm25_, lon=lon, lat=lat
   nc4readvar, filename, 'dusmass', dusm_, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area, grid='d'
   duem[*,iexpid] = aave(duex_,area)/aave(dusm_,area)/1.e6
   duem25[*,iexpid] = aave(duex_,area)/aave(dusm25_,area)/1.e6

  endfor

  set_plot, 'ps'
  device, file='global_dusm.simple.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 39
  x = findgen(12)+1
  xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, duem[*,0], thick=6, /nodata, $
   xstyle=9, xrange=[0,13], xticks=13, xtickn=xtickn, $
   ystyle=9, yrange=[0,12], ytitle='Ratio AOD/PM [m!E3!N mg!E-1!N]', $
   position=[.15,.15,.95,.95], yticks=6
  for iexpid = 0, nexpid-1 do begin
   if(iexpid lt 2) then loadct, 0
   if(iexpid ge 2) then loadct, 39
   oplot, x, duem[*,iexpid], color=color[iexpid], thick=10, lin=lin[iexpid]
   oplot, x, duem25[*,iexpid], color=color[iexpid], thick=10, lin=lin[iexpid]
  endfor

  device, /close

end
