; Array for global AOD
  expid = ['d5124_m2_jan79', 'merra2gmi.adg', $
           'c180F_pI20p1-acma', $
           'c180F_pI20p1-acma_miet', 'c180F_pI20p1-acma_nodu', $
           'c180F_pI20p1-acma_spher','c180F_pI20p1-acma_gocart']

  nexpid = n_elements(expid)
  ddf = expid
  ddf[0:1] = ddf[0:1]+'.ddf'
  ddf[2:nexpid-1]  = ddf[2:nexpid-1]+'.tavg2d_aer_x.ctl'

  duem = fltarr(12,nexpid)

  color     = [140, 140, 0, 254, 176, 254, 208]
  lin       = [  0,   2, 0,   2,   0,   0,   0]

  for iexpid = 0, nexpid-1 do begin

   print, iexpid+1, nexpid

   expctl = ddf[iexpid]
   ga_times, expctl, nymd, nhms, template=filetemplate
   filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
   nc4readvar, filename, 'duem', duem_, lon=lon, lat=lat, /tem, /sum
   area, lon, lat, nx, ny, dx, dy, area, grid='d'
   duem[*,iexpid] = aave(duem_,area)*total(area)*30.*86400/1.e9

  endfor

  set_plot, 'ps'
  device, file='global_duem.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  loadct, 39
  x = findgen(12)+1
  xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, duem[*,0], thick=6, /nodata, $
   xstyle=9, xrange=[0,13], xticks=13, xtickn=xtickn, $
   ystyle=9, yrange=[80,240], ytitle='Emissions [Tg]', $
   position=[.15,.15,.95,.95], yticks=8
  for iexpid = 0, nexpid-1 do begin
   if(iexpid lt 2) then loadct, 0
   if(iexpid ge 2) then loadct, 39
   oplot, x, duem[*,iexpid], color=color[iexpid], thick=12, lin=lin[iexpid]
  endfor

  device, /close

end
