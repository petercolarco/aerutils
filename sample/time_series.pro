; Read in the time series of AOT at a location

; res
  res = 'ten'

; GSFC
  wantlon = -76.
  wantlat =  38.
  ymax    =  .8
  title   = 'GSFC'
  plotst  = 'gsfc'
  wantnymd = ['20100101','20100415']

; GSFC
  wantlon = -76.
  wantlat =  38.
  ymax    =  .8
  title   = 'GSFC'
  plotst  = 'gsfc'
  wantnymd = ['20100101','20100415']

; Kanpur
  wantlon = 80.
  wantlat = 26.
  ymax    =  3.
  title   = 'Kanpur'
  plotst  = 'kanpur'
  wantnymd = ['20100501','20100731']
  numrange = [0,10000]

; Abracos Hill
  wantlon = -62.
  wantlat = -10.
  ymax    =  3.
  title   = 'Abracos Hill'
  plotst  = 'abracos_hill'
  wantnymd = ['20100715','20101101']
  numrange = [0,10000]

; Abracos Hill
  wantlon = -62.
  wantlat = -10.
  ymax    =  3.
  title   = 'Abracos Hill'
  plotst  = 'abracos_hill'
  wantnymd = ['20100715','20101101']
  numrange = [0,10000]

; Capo Verde
  wantlon = -22.
  wantlat =  16.
  ymax    =  3.
  title   = 'Capo Verde'
  plotst  = 'capo_verde'
  wantnymd = ['20100501','20100815']
  numrange = [0,5000]



; Form the list of files to read
  nc4readvar, 'MYD04_ocn.full.'+res+'.ddf', 'aot', aot, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc

  nc4readvar, 'MYD04_ocn.full.'+res+'.ddf', 'num', num, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc
  
  nc4readvar, 'MYD04_ocn.caliop1.'+res+'.ddf', 'aot', aot_c1, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc

  nc4readvar, 'MYD04_ocn.caliop2.'+res+'.ddf', 'aot', aot_c2, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc

  nc4readvar, 'MYD04_ocn.caliop3.'+res+'.ddf', 'aot', aot_c3, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc

  nc4readvar, 'MYD04_ocn.caliop4.'+res+'.ddf', 'aot', aot_c4, lon=lon, lat=lat, nymd=nymd, nhms=nhms, $
              wantlon=wantlon, wantlat=wantlat, wantnymd=wantnymd, $
              rc=rc

  yyyy = nymd/10000L
  mm   = (nymd - yyyy*10000L)/100L
  dd   = nymd - yyyy*10000L - mm*100L
  jday = julday(mm,dd,yyyy)-julday(12,31,2009)

  aot[where(aot gt 1e14,/null)] = !values.f_nan
  num[where(num gt 1e14,/null)] = !values.f_nan
  aot_c1[where(aot_c1 gt 1e14,/null)] = !values.f_nan
  aot_c2[where(aot_c2 gt 1e14,/null)] = !values.f_nan
  aot_c3[where(aot_c3 gt 1e14,/null)] = !values.f_nan
  aot_c4[where(aot_c4 gt 1e14,/null)] = !values.f_nan

  set_plot, 'ps'
  device, file='time_series.'+plotst+'.'+res+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=16, ysize=15
  !p.font=0

  loadct, 0
  x = jday
  plot, x, aot, /nodata, $
        xthick=3, ythick=3, $
        yrange=[-1,ymax], $
        ytitle='AOT', $
        xstyle=9, ystyle=8, $
        position=[.15,.4,.95,.95]
  oplot, x, aot, thick=6, color=80

  loadct, 1
  nc1 = 0
  maot_c1 = '--'
  saot_c1 = '--'
  a = where(finite(aot_c1) eq 1)
  if(a[0] ne -1) then begin
   nc1 = n_elements(a)
   usersym, [-1,0,1,0,0], -1*[1,0,1,0,3], color=200, thick=6
;   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], aot[a[i]], psym=8 & endfor
   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], 0, psym=8 & endfor
   maot_c1 = string(total(aot[a])/nc1,format='(f4.2)')
   if(nc1 ge 3) then saot_c1 = string(stddev(aot[a]),format='(f4.2)')
  endif

  loadct, 3
  nc2 = 0
  maot_c2 = '--'
  saot_c2 = '--'
  a = where(finite(aot_c2) eq 1)
  if(a[0] ne -1) then begin
   nc2 = n_elements(a)
   usersym, [-1,0,1,0,0], -1*(3+[1,0,1,0,3]), color=200, thick=6
;   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], aot[a[i]], psym=8 & endfor
   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], 0, psym=8 & endfor
   maot_c2 = string(total(aot[a])/nc2,format='(f4.2)')
   if(nc2 ge 3) then saot_c2 = string(stddev(aot[a]),format='(f4.2)')
  endif
;  for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], [.4*ymax,.6*ymax], thick=6, color=200 & endfor

  loadct, 7
  nc3 = 0
  maot_c3 = '--'
  saot_c3 = '--'
  a = where(finite(aot_c3) eq 1)
  if(a[0] ne -1) then begin
   nc3 = n_elements(a)
   usersym, [-1,0,1,0,0], -1*(6+[1,0,1,0,3]), color=200, thick=6
;   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], aot[a[i]], psym=8 & endfor
   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], 0, psym=8 & endfor
   maot_c3 = string(total(aot[a])/nc3,format='(f4.2)')
   if(nc3 ge 3) then saot_c3 = string(stddev(aot[a]),format='(f4.2)')
  endif
;  for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], [.2*ymax,.4*ymax], thick=6, color=200 & endfor

  loadct, 8
  nc4 = 0
  maot_c4 = '--'
  saot_c4 = '--'
  a = where(finite(aot_c4) eq 1)
  if(a[0] ne -1) then begin
   nc4 = n_elements(a)
   usersym, [-1,0,1,0,0], -1*(9+[1,0,1,0,3]), color=200, thick=6
;   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], aot[a[i]], psym=8 & endfor
   for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], 0, psym=8 & endfor
   maot_c4 = string(total(aot[a])/nc4,format='(f4.2)')
   if(nc4 ge 3) then saot_c4 = string(stddev(aot[a]),format='(f4.2)')
  endif
;  for i = 0, n_elements(a)-1 do begin & plots, jday[a[i]], [0,.2*ymax], thick=6, color=200 & endfor

  loadct, 0
  plot, x, aot, /nodata, /noerase, $
        xthick=3, ythick=3, $
        yrange=[-1,ymax], $
        ytitle='AOT', $
        xstyle=9, ystyle=8, title=title, $
        position=[.15,.4,.95,.95]

  usersym, .4*[-1,1,1,-1,-1], .4*[-1,-1,1,1,-1], color=80, /fill
  plots, x, aot, psym=8

  x0 = min(x)+5
  y0 = .9*ymax
  dy = .05*ymax
  plots, [x0,x0+10], y0, thick=6, color=80
  nstr = string(n_elements(where(finite(aot) eq 1,/null)),format='(i3)')
  maot = string(total(aot[where(finite(aot) eq 1,/null)])/nstr,format='(f4.2)')
  saot = string(stddev(aot[where(finite(aot) eq 1,/null)]),format='(f4.2)')

  xyouts, x0+12, y0-0.3*dy, 'Full Swath (n='+nstr+', !9t!X='+maot+', !9s!X='+saot+')', charsize=.8
  loadct, 1
  nstr = string(nc1,format='(i2)')
  plots, [x0,x0+10], y0-dy, thick=6, color=200
  xyouts, x0+12, y0-1.3*dy, 'C1 (n='+nstr+', !9t!X='+maot_c1+', !9s!X='+saot_c1+')', charsize=.8
  loadct, 3
  nstr = string(nc2,format='(i2)')
  plots, [x0,x0+10], y0-2.*dy, thick=6, color=200
  xyouts, x0+12, y0-2.3*dy, 'C2 (n='+nstr+', !9t!X='+maot_c2+', !9s!X='+saot_c2+')', charsize=.8
  loadct, 7
  nstr = string(nc3,format='(i2)')
  plots, [x0,x0+10], y0-3.*dy, thick=6, color=200
  xyouts, x0+12, y0-3.3*dy, 'C3 (n='+nstr+', !9t!X='+maot_c3+', !9s!X='+saot_c3+')', charsize=.8
  loadct, 8
  nstr = string(nc4,format='(i2)')
  plots, [x0,x0+10], y0-4.*dy, thick=6, color=200
  xyouts, x0+12, y0-4.3*dy, 'C4 (n='+nstr+', !9t!X='+maot_c4+', !9s!X='+saot_c4+')', charsize=.8

  plot, x, aot, /nodata, /noerase, $
        xthick=3, ythick=3, $
        yrange=numrange, ytickn=['','','','','',' '], $
        xtitle='Day Number of 2010', ytitle='Number', $
        xstyle=9, ystyle=8, $
        position=[.15,.1,.95,.4]

  loadct, 0
;  axis, /yaxis, ythick=3, yrange=[0,4000], /save, ytitle='Number'
  oplot, x, num, thick=3, color=100, lin=2

  device, /close

end
