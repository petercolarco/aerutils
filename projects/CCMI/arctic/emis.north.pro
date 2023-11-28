; Make some plots of global statistics based on annual mean (decadal)
; values

  red   = [0, 120, 253,   5,  35]
  green = [0, 120, 141, 112, 132]
  blue  = [0, 120,  60, 176,  67]

  iblack = 0
  igrey  = 1
  ired   = 2
  iblue  = 3
  igreen = 4

  tvlct, red, green, blue

  ddf = 'ref_c2_h53.ann.ddf'

  area, lon, lat, nx, ny, dx, dy, area, grid='b'
; discard area for latitude < 50 N
  a = where(lat lt 50)
  area[*,a] = 0.

  yyyy = strpad(1960+findgen(141),1000)

; integrate
  nc4readvar, ddf, ['ocem001','ocem002'], ocem, /sum
  ocem = aave(ocem,area)*365*86400./1e9*total(area)
  nc4readvar, ddf, 'oceman', oceman
  oceman = aave(oceman,area)*365*86400./1e9*total(area)

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
; discard area for latitude < 50 N
  a = where(lat lt 50)
  area[*,a] = 0.
  ocembb = aave(ocembb,area)*30.*86400./1e9*total(area)
  ocembb = total(reform(ocembb,12,nt/12),1)
  xx = findgen(28)+1980


  set_plot, 'ps'
  device, file='emis.north.ps', /helvetica, /color, font_size=14, $
   xsize=20, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  x = findgen(141)+1960
  plot, x, ocem-oceman, /nodata, $
        charsize=.75, $
        thick=3, ytitle='Aerosol Carbon Emissions [Tg yr!E-1!N]', $
        xtitle='year', $
        xrange=[1980,2015], xticks=14, xminor=2, $
        title='Annual Aerosol Carbon Biomass Burning Emissions (North of 50!Eo!N N)', $
        xstyle=9, ystyle=9, yrange=[0,30]
  oplot, xx, ocembb, color=iblue, thick=3
  oplot, x, ocem-oceman, color=ired, thick=8

  device, /close

end
