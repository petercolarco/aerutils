; Plot dust emission time series and mean climatology for nine source
; regions after Kok et al. 2021

  expid = 'c180R_v202_ceds'

  regName = ['Western North Africa', 'Eastern North Africa', $
             'Sahel', 'Middle East and Central Asia', $
             'East Asia', 'North America', 'Australia', $
             'South America', 'Southern Africa']
  regName_ = ['Western!CNorth!CAfrica', 'Eastern!CNorth!CAfrica', $
             'Sahel', 'Middle East!Cand!CCentral Asia', $
             'East Asia', 'North America', 'Australia', $
             'South America', 'Southern!CAfrica']

; Define the source regions
  lon0 = [-20, 7.5, -20,  35,  70, -130,  110, -80,-.01]
  lon1 = [7.5, 35,   35,  75, 120,  -80,  160, -20,  40]*1.
  lat0 = [ 18, 18, -.01,-.01,  35,   20,  -40, -60, -40]*1.
  lat1 = [37.5, 37.5, 18, 35,  50,   45,  -10,   0,   0]

; Make a map of the source regions
  set_plot, 'ps'
  device, file='plot_duem.regions.ps', /color, /helvetica,$
   font_size=12, xsize=20, ysize=12
  !p.font=0
  loadct, 0
  map_set, 0, 0, /mercator, /horizon, /noborder, $
    e_continents={fill:1,color:200}, limit=[-60,-160,60,170]

  for i = 0, 8 do begin

   x0 = lon0[i]
   x1 = lon1[i]
   y0 = lat0[i]
   y1 = lat1[i]

   if(i ne 3) then begin
     plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   endif else begin
     plots, [x0,x1,x1,70,70,x0,x0], [y0,y0,y1,y1,50,50,y0]
   endelse

   xyouts, x0+1, y1-5, regName_[i], charsize=.8

  endfor

  device, /close

; Skip the reading and go to the plotting
;  goto, jump


; Get the dust emissions
  ddf = expid+'.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20110000L and nymd lt 20210000L)
  filename = filename[a]
  nymd = nymd[a]
  nt = n_elements(filename)
  duem = fltarr(nt,9)
  mduem = fltarr(nt,9)
  nx = 720
  dx = 0.5
  lon = -180 + findgen(nx)*dx
  ny = 361
  dy = 0.5
  lat = -90 + findgen(ny)*dy
  area, lon, lat, nx, ny, dx, dy, area
; Get MERRA2
  ddf = 'd5124_m2_jan79.ddf'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename2 = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20110000L and nymd lt 20210000L)
  filename2 = filename2[a]
  nymd = nymd[a]
  nhms = nhms[a]
  area, mlon, mlat, nx_, ny_, dx_, dy_, marea, grid='d'


  for i = 0, 8 do begin
print, i
   x0 = lon0[i]
   x1 = lon1[i]
   y0 = lat0[i]
   y1 = lat1[i]
   if(i eq 3) then y1 = 50.
   a = where(lon ge x0 and lon le x1)
   b = where(lat ge y0 and lat le y1)
   area_ = area[a,*]
   area_ = area_[*,b]
   a = where(mlon ge x0 and mlon le x1)
   b = where(mlat ge y0 and mlat le y1)
   marea_ = marea[a,*]
   marea_ = marea_[*,b]
   nc4readvar, filename, 'duem', duem_, wantlon=[x0,x1], wantlat=[y0,y1], $
    lon=lon_, lat=lat_, /template, /sum
   nc4readvar, filename2, 'duem', mduem_, wantlon=[x0,x1], wantlat=[y0,y1], $
    lon=mlon_, lat=mlat_, /template, /sum
   if(i eq 3) then begin
    a = where(lon_ gt 70.)
    b = where(lat_ gt 35.)
    for j = a[0], a[n_elements(a)-1] do begin
     for k = b[0], b[n_elements(b)-1] do begin
      duem_[j,k,*] = 0.
     endfor
    endfor
    a = where(mlon_ gt 70.)
    b = where(mlat_ gt 35.)
    for j = a[0], a[n_elements(a)-1] do begin
     for k = b[0], b[n_elements(b)-1] do begin
      mduem_[j,k,*] = 0.
     endfor
    endfor
   endif
   duem[*,i] = aave(duem_,area_)*total(area_)*30.*86400/1.e9  ; Tg mon-1
   mduem[*,i] = aave(mduem_,marea_)*total(marea_)*30.*86400/1.e9  ; Tg mon-1
  endfor

  save, file='plot_duem.sav', /variables

jump:
  restore, file='plot_duem.sav'

  for i = 0, 8 do begin

   set_plot, 'ps'
   device, file='plot_duem.'+string(i,format='(i1)')+'.ps', $
    /helvetica, font_size=12, /color, $
    xsize=28, ysize=12
   !p.font=0

   loadct, 0

   x = indgen(nt)
   xyrs = n_elements(x)/12
   xmax = n_elements(x)
   if(xyrs ne n_elements(x)/12.) then xyrs = xyrs+1
   if(xyrs ne n_elements(x)/12.) then xmax = xyrs*12
   xtickv=[1+findgen(xyrs)*12,nt+1]
   xtickname = [string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)'),' ']
   ymax = max([max(duem[*,i]),max(mduem[*,i])])
   plot, indgen(nt), /nodata, $
    yrange=[0,ymax], ytitle='Tg mon!E-1!N', yminor=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=1, $
    xtickv=xtickv, xtickname=make_array(xyrs+1,val=' '), $
    title=regName[i]+' Time Series and Deseasonalized Anomaly', $
    position=[.08,.28,.6,.92]
   oplot, x+1, duem[*,i], thick=8, color=100
   oplot, x+1, mduem[*,i], thick=8

;  Plot the climatology
   duem_ = reform(duem[*,i],12,xyrs)
   mduem_ = mean(reform(mduem[*,i],12,xyrs),dimension=2)

   plot, indgen(12)+1, /nodata, /noerase, $
    xrange=[0,13], xticks=13, xminor=1, $
    xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
    yrange=[0,ymax], yminor=2, ytitle='Tg mon!E-1!N', $
    position=[.66,.1,.98,.92], title='Climatology and Range'
   polymaxmin, indgen(12)+1, duem_, color=100, fillcolor=200, edge=200
   oplot, indgen(12)+1, mduem_, thick=8
;  Print the total mean emissions
   xmean = string(total(duem[*,i])/xyrs,format='(f5.1)')
   mxmean = string(total(mduem[*,i])/xyrs,format='(f5.1)')
   xyouts, 1, .05*!y.crange[1], 'Annual Total: ', /data
   xyouts, 5, .05*!y.crange[1], xmean, /data, color=100
   xyouts, 7, .05*!y.crange[1], mxmean+' Tg', /data
   statistics, mduem[*,i], duem[*,i], xmean, ymean, xstd, ystd, $
               r, bias, rms, skill, linslope, linoffset 
   rx = string(r,format='(f4.2)')
   xyouts, 10, .05*!y.crange[1], 'r = '+rx, /data

;  Inset an anomaly plot
   smean = mean(duem_,dim=2)
   for j = 0, xyrs-1 do begin
    duem_[*,j] = duem_[*,j]-smean
   endfor
   duem_ = reform(duem_,12*xyrs)
   ymax = max(abs(duem_))
   plot, indgen(nt), /nodata, /noerase, $
    yrange=[-ymax,ymax], yminor=2, ytitle = 'Tg mon!E-1!N', yticks=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=8, $
    xtickv=xtickv, xtickname=xtickname, $
    position = [.08, .1, .6, .25]
   loadct, 39
   for j = 0, nt-1 do begin
    x = j+1
    y = duem_[j]
    if(y gt 0) then color=84
    if(y le 0) then color=254
    polyfill, x+[-.4,.4,.4,-.4,-.4], [0,0,y,y,0], color=color
   endfor
   plots, [1,nt], 0
  

   device, /close

  endfor
end
