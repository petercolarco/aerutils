; Colarco, March 2013
; Read in the sampled data and calculate the linear trend and
; significance.  The formalism follows from Zhang and Reid (2010) and
; Weatherhead et al. (1998).

  pro trend_model, sample, iplot=iplot, tplot=tplot

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
  area, lon, lat, nx, ny, dx, dy, area, grid = 'd'

;  nthresh = 6
  nthresh = 12
;  nthresh = 24
nthresh = 2
  case sample of
   'modis_aqua' : sample_title = ' Full Swath (Aqua) '
   'calipso'   : sample_title = ' Curtain (Aqua) '
   'misr_aqua'      : sample_title = ' Narrow (Aqua) '
   'calipso_calipso'      : sample_title = ' Curtain (CALIPSO) '
   'misr_calipso'      : sample_title = ' Narrow (CALIPSO) '
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

     read_monthly_model, 'dR_MERRA-AA-r2', sample, yyyy[iy], mm[im], aotsat, $
                    res=res, exclude=exclude, inverse=inverse, $
                    lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot_, reg_std=reg_std_
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
   device, file='./MYD04'+samplestr+'.qast.'+res+'.num'+'.trend.eps', $
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

  dlevels=findgen(21)*.2-2.1
  dlevels[0] = -2000.

;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1

; mask missing data
  slope[where(finite(abs(slope/tstd)) eq 0)] = !values.f_nan
  plotgrid, slope*100., dlevels, dcolors, lon, lat, dx, dy, /map

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

  title = 'MERRAero'+ sample_title

  levstr = string(dlevels,format='(f4.1)')
  levstr[0:20:2] = ' '
  levstr = [' ','-1.9',' ','-1.5',' ','-1.1',' ','-0.7',' ','-0.3',' ',$
            ' ','0.3',' ','0.7',' ','1.1',' ','1.5',' ','1.9',' ']
  if(tplot eq 1) then begin
   title = 'MERRAero'+ sample_title + '(AOT trend 100*AOT yr!E-1!N [550 nm])'
   xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2
   makekey, .1, .055, .8, .05, 0, -.035, color=dcolors, $
    align=.5, label=levstr
  endif
  if(tplot eq 4) then begin
   title = 'MERRAero'+ sample_title
   xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2
   if(iplot eq 0) then begin
    title = 'AOT trend 100*AOT yr!E-1!N'
    xyouts, .5, .08, title, /normal, charsize=1.2, align=.5
    makekey, .1, .035, .8, .035, 0, -.025, color=dcolors, $
     align=.5, label=levstr
   endif
  endif
  if(iplot eq tplot-1) then device, /close

end
