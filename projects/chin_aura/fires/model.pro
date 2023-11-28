; Database of events
  lats =  [ 47,  68,  33, $
            49,  51,  49,  47,  53,  48]
  lons = -[ 63, 132, 104, $
           109, 102, 102, 105, 106, 104]
  dates = [20070526, 20070626, 20070708, $
           20070729, 20070804, 20070810, 20070813, 20070819, 20070904]

  for idate = n_elements(dates)-1, n_elements(dates)-1 do begin

  nymd = string(dates[idate],format='(i8)')
  mm   = strmid(nymd,4,2)

  filename = '/misc/prc14/colarco/dR_F25b18/inst3d_aer_v/lift_1km/dR_F25b18.inst3d_aer_v.'+nymd+'_0000z.nc4'
  nc4readvar, filename, 'ocphilic', oc, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp
  nc4readvar, filename, 'ps', ps
  nc4readvar, filename, 'airdens', rhoa

; Average a region
  a = where(lon gt lons[idate]-5 and lon le lons[idate]+5)
  delp = reform(total(delp[a,*,*],1))/n_elements(a)
  oc   = reform(total(oc[a,*,*],1))/n_elements(a)
  rhoa = reform(total(rhoa[a,*,*],1))/n_elements(a)
  ps   = reform(total(ps[a,*],1))/n_elements(a)

; Form a vertical coordinate
  ny = n_elements(lat)
  pe   = fltarr(ny,73)
  he   = fltarr(ny,73)
  dz   = fltarr(ny,72)
  pe[*,72] = ps
  he[*,72] = 0.
  for iz = 71, 0, -1 do begin
   pe[*,iz] = pe[*,iz+1]-delp[*,iz]
   dz[*,iz] = delp[*,iz]/rhoa[*,iz]/9.81
   he[*,iz] = he[*,iz+1]+dz[*,iz]
  endfor
  he = he / 1000.   ; km
  dz = dz / 1000.   ; km
  hm = fltarr(ny,72)
  hm[*,71] = dz[*,71]/2.
  for iz = 70, 0, -1 do begin
   hm[*,iz] = hm[*,iz+1]+(dz[*,iz+1]+dz[*,iz])/2.
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='dR_F25b18.'+nymd+'.ps', /color, /helvetica, $
   font_size=14, xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0

  red   = [0,255,254,254,253,252,227,177]
  green = [0,255,217,178,141,78,26,0]
  blue  = [0,178,118,76,60,42,28,38]
  tvlct, red, green, blue
  colors = indgen(7)+1
  iblack = 0
  x  = lat
  dx = 0.5
  a  = where(lat eq 47)
  y  = reform(hm[a[0],*])
  dy = reform(dz[a[0],*])
  plot, indgen(10), /nodata, $
   xrange=[30,60], xstyle=9, yrange=[0,20], ystyle=9, $
   xtitle='latitude', ytitle='altitude [km]', $
   position=[.1,.2,.95,.9]
  levels = [1,2,5,10,20,50,100]
  plotgrid, oc*rhoa*1e9, levels, colors, x, y, dx, dy
  plots, lats[idate]+[-1,0,1,0,-1], [0,-1,0,1,0], thick=3
  plot, indgen(10), /nodata, /noerase, $
   xrange=[30,60], xstyle=9, yrange=[0,20], ystyle=9, $
   xtitle='latitude', ytitle='altitude [km]', $
   title='Replay: OCphilicBIOB [ug m!E-3!N], '+nymd, $
   position=[.1,.2,.95,.9], thick=3

  makekey, .1, .05, .85, .035, 0, -0.04, color=colors, $
   labels=string(levels,format='(i3)'), align=0

  device, /close

  endfor

end
