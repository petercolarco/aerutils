; Make some plots of global statistics based on annual mean (decadal)
; values

  ddf = 'ref_c2_h53.biomass.ddf'

  area, lon, lat, nx, ny, dx, dy, area, grid='half'

  yyyy = strpad(1960+findgen(141),1000)

; integrate
  nc4readvar, ddf, 'biomass', ocem
  ocem = aave(ocem,area)*365*86400./1e9*total(area)*1.4 ; POM scaling

; Get MERRA-2 emissions
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[0:419]
  nhms = nhms[0:419]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nt = n_elements(nymd)
  nc4readvar, filename, 'ocembb', ocembb, lon=lon, lat=lat
; Now make a global mean
  lon2 = 1
  lat2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2
  ocembb = aave(ocembb,area)*30.*86400./1e9*total(area)
  ocembb = total(reform(ocembb,12,nt/12),1)
  xx = findgen(35)+1980


  set_plot, 'ps'
  device, file='emis.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  x = findgen(141)+1960
  plot, x, /nodata, color=84, $
    xrange=[1980,2015], xstyle=9, ystyle=9, thick=3, $
    ytitle='Aerosol Carbon Emissions [Tg yr!E-1!N]', xticks=7, xminor=5, $
    xtickname=[string(nymd[0:419:60]/10000L,format='(i4)'),' '], $
    yrange=[0,100]
  oplot, xx, ocembb, color=84, thick=6
  oplot, x, ocem, color=254, thick=8

  device, /close

end
