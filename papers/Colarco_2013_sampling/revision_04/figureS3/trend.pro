; Colarco, March 2013
; Read in the sampled data and calculate the linear trend and
; significance.  The formalism follows from Zhang and Reid (2010) and
; Weatherhead et al. (1998).

  pro trend, res, sample, iplot=iplot, tplot=tplot

  if(not(keyword_set(iplot))) then iplot = 1
  if(not(keyword_set(tplot))) then tplot = 1
  iplot = iplot -1 

  if(tplot ne 1 and tplot ne 4) then stop

  case tplot of
   1: begin
      position = [.05,.2,.95,.9]
      xsize=12
      ysize=10
      noerase = 0
      lstr = ''
      end
   4: begin
      position = [ [.025,.6,.475,.95], $
                   [.525,.6,.975,.95], $
                   [.025,.15,.475,.525], $
                   [.525,.15,.975,.525] ]
      xsize=24
      ysize=20
      noerase = 0
      if(iplot eq 0) then lstr = '!4(a)!3 '
      if(iplot eq 1) then lstr = '!4(b)!3 '
      if(iplot eq 2) then lstr = '!4(c)!3 '
      if(iplot eq 3) then lstr = '!4(d)!3 '
      if(iplot gt 0) then noerase = 1
      end
   endcase

;  res = 'c'
;  sample = 'caliop1'
  area, lon, lat, nx, ny, dx, dy, area, grid = res

;  nthresh = 6
  nthresh = 12
;  nthresh = 24
nthresh = 2
  case sample of
   'supermisr' : sample_title = ' MW '
   'lat1'      : sample_title = ' L1 '
   'lat2'      : sample_title = ' L2 '
   'lat3'      : sample_title = ' L3 '
   'lat4'      : sample_title = ' L4 '
   'lat5'      : sample_title = ' L5 '
   'misr1'     : sample_title = ' N1 '
   'misr2'     : sample_title = ' N2 '
   'misr3'     : sample_title = ' N3 '
   'misr4'     : sample_title = ' N4 '
   'caliop1'   : sample_title = ' C1 '
   'caliop2'   : sample_title = ' C2 '
   'caliop3'   : sample_title = ' C3 '
   'caliop4'   : sample_title = ' C4 '
   'inverse_supermisr' : sample_title = ' !Super-MISR '
   'inverse_misr1'     : sample_title = ' !MISR1 '
   'inverse_misr2'     : sample_title = ' !MISR2 '
   'inverse_misr3'     : sample_title = ' !MISR3 '
   'inverse_misr4'     : sample_title = ' !MISR4 '
   'inverse_caliop1'   : sample_title = ' !CALIOP1 '
   'inverse_caliop2'   : sample_title = ' !CALIOP2 '
   'inverse_caliop3'   : sample_title = ' !CALIOP3 '
   'inverse_caliop4'   : sample_title = ' !CALIOP4 '
   else        : sample_title = ' '
  endcase
  samplestr = '.'+sample
  if(sample_title eq ' ') then samplestr = ''

  yyyy = strpad(indgen(10)+2003,1000L)
  nyr  = n_elements(yyyy)
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nm   = 12
  nt   = 12*nyr

  aot    = fltarr(nx,ny,nt)
  slope  = make_array(nx,ny,val=!values.f_nan)
  offset = make_array(nx,ny,val=!values.f_nan)
  num    = make_array(nx,ny,val=0)
  y      = make_array(nx,ny,nt,val=!values.f_nan)

  for iy = 0, nyr-1 do begin
   for im = 0, nm-1 do begin

;     read_monthly, 'MYD04', sample, yyyy[iy], mm[im], aotsat, res=res, /ocean
     read_monthly, 'MYD04', sample, yyyy[iy], mm[im], aotsat, res=res, /exclude, /inver
print, yyyy[iy], mm[im]
     aot[*,*,iy*nm+im] = aotsat
   endfor
  endfor

; Deseasonalize the monthly mean AOT by removing the mean of Januarys
; from January, etc.
  aotm = fltarr(nx,ny,12)
  for im = 0, nm-1 do begin
   aotm[*,*,im] = mean(aot[*,*,im:nt-1:12],dimension=3,/nan)
   for iy = 0, nyr-1 do begin
    aot[*,*,iy*nm+im] = aot[*,*,iy*nm+im] - aotm[*,*,im]
   endfor
  endfor


; Find the linear trend of the deseasonalized AOT
; At the end "y" is the linear model of the time series
; "slope" is the "omega" term in Weatherhead and Zhang and Reid
  t = findgen(nt) / 12.   ; time in units of years
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    a = where(finite(aot[ix,iy,*]) eq 1)
    if(a[0] ne -1) then begin
     result = linfit(t[a],aot[ix,iy,a])
     num[ix,iy]    = n_elements(a)
     slope[ix,iy]  = result[1]
     offset[ix,iy] = result[0]
     y[ix,iy,a]    = result[0] + result[1]*t[a]
    endif
   endfor
  endfor

; Calculate the "noise" where noise is the deviation from the linear
; trend using only points with good values.
; "tstd" is the "sigma_omega" in references.
  noise = aot - y
  corr  = make_array(nx,ny,val=!values.f_nan)
  nstd  = make_array(nx,ny,val=!values.f_nan)
  tstd  = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    a = where(finite(aot[ix,iy,*]) eq 1)
    if(a[0] ne -1) then begin
;    The is the standard deviation of the noise (sigma_n)
     nstd[ix,iy] = stddev(noise[ix,iy,a])
;     corr[ix,iy] = a_correlate(noise[ix,iy,a],[-1])
;     tstd[ix,iy] = nstd[ix,iy]/(nyr^1.5)*sqrt((1.+corr[ix,iy])/(1.-corr[ix,iy]))
     x = noise[ix,iy,*]
     y = shift(x,1)
     b = where(finite(x) eq 1 and finite(y) eq 1, count)
     if(count ge nthresh) then begin
      corr[ix,iy] = correlate(x[b],y[b])
;      tstd[ix,iy] = nstd[ix,iy]/(nyr^1.5)*sqrt((1.+corr[ix,iy])/(1.-corr[ix,iy]))
      tstd[ix,iy] = nstd[ix,iy]/((count/12.)^1.5)*sqrt((1.+corr[ix,iy])/(1.-corr[ix,iy]))
     endif
    endif
   endfor
  endfor
  

; Plot the trend
  if(iplot eq 0) then begin
   set_plot, 'ps'
   device, file='./MYD04'+samplestr+'.qast.'+res+'.num'+'.signif.eps', $
           /color, /helvetica, font_size=9, $
           xoff=.5, yoff=.5, xsize=xsize, ysize=ysize, /encap
  !p.font=0
  endif
  p0 = 0
  p1 = 0
  geolimits = [-75,-180,75,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

  map_set, p0, p1, position=position[*,iplot], /noborder, limit=geolimits, noerase=noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, aotsat, [-.1], [220], lon, lat, dx, dy, /map, /missing

  loadct, 39
  dlevels=[0,2.]
  dcolors=[255,254]

; mask missing data
  plotgrid, abs(slope/tstd), dlevels, dcolors, lon, lat, dx, dy, /map

  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,iplot], limit=geolimits
  map_grid, /box

; Resstr
  case res of
   'ten' : resstr = '10!E O!N x 10!E O!N'
   'b'   : resstr = '2!E O!N x 2.5!E O!N'
   'c'   : resstr = '1!E O!N x 1.25!E O!N'
   'd'   : resstr = '0.5!E O!N x 0.625!E O!N'
  endcase

  title = 'MODIS Aqua'+ sample_title

  if(tplot eq 1) then begin
   title = 'MODIS Aqua'+ sample_title + '('+resstr+', AOT trend 100*AOT yr!E-1!N [550 nm])'
   xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2
   makekey, .1, .055, .8, .05, 0, -.035, color=dcolors, $
    align=.5, label=levstr
  endif
  if(tplot eq 4) then begin
   title = 'MODIS Aqua'+ sample_title
   xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2
   if(iplot eq 0) then begin
    title = 'Statistical Significance of AOT Trend'
    xyouts, .5, .1, title, /normal, charsize=1.2, align=.5
    loadct, 0
    makekey, .11, .055, .26, .035, 0, -.025, color=[180], label=[' ']
    loadct, 39
    makekey, .37, .055, .52, .035, 0, -.025, color=[255,254], $
     label=[' ',' ',' ']
    xyouts, .24, .03, 'No Data', /normal, align=.5
    xyouts, .50, .03, 'Trend Not Significant', /normal, align=.5
    xyouts, .76, .03, 'Trend Significant!Cat 95% Confidence', /normal, align=.5
   endif
  endif
  if(iplot eq tplot-1) then device, /close

end
