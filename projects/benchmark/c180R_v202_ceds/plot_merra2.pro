; Plot dust emission time series and mean climatology for nine source
; regions after Kok et al. 2021

  expid = 'c180R_v202_ceds'

  regName = ['Western North Africa', 'Eastern North Africa', $
             'Sahel', 'Middle East and Central Asia', $
             'East Asia', 'North America', 'Australia', $
             'South America', 'Southern Africa','Mid-Atlantic']

; Skip the reading and go to the plotting
;  goto, jump

; Define the source regions
  lon0 = [-20, 7.5, -20, 35, 70, -130, 110, -80,   0, -50]
  lon1 = [7.5, 35,   35, 75, 120, -80, 160, -20,  40, -20]
  lat0 = [ 18, 18,    0,  0,  35,  20, -40, -60, -40,   4]
  lat1 = [37.5, 37.5, 18, 35, 50, 45,  -10,   0,   0,  40]

; Make a map of the source regions
  map_set, /cont

;  for i = 0, 9 do begin
  for i = 0, 0 do begin

   x0 = lon0[i]
   x1 = lon1[i]
   y0 = lat0[i]
   y1 = lat1[i]

   if(i ne 3) then begin
     plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   endif else begin
     plots, [x0,x1,x1,70,70,x0,x0], [y0,y0,y1,y1,50,50,y0]
   endelse

  endfor

; Get the dust emissions
  ddf = expid+'.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20110000L and nymd lt 20210000L)
  filename = filename[a]
  nymd = nymd[a]
  ddf = 'd5124_m2_jan79.ddf'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename2 = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20110000L and nymd lt 20210000L)
  filename2 = filename2[a]
  nymd = nymd[a]
  nt = n_elements(filename)
  ext = fltarr(nt,10)
  duext = fltarr(nt,10)
  merra2 = fltarr(nt,10)
  nx = 720
  dx = 0.5
  lon = -180 + findgen(nx)*dx
  ny = 361
  dy = 0.5
  lat = -90 + findgen(ny)*dy
  area, lon, lat, nx, ny, dx, dy, area
  area, lon2, lat2, nx2, ny2, dx2, dy2, area2, grid='d'
;  for i = 0, 9 do begin
  for i = 0, 0 do begin
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
   a = where(lon2 ge x0 and lon2 le x1)
   b = where(lat2 ge y0 and lat2 le y1)
   area2_ = area2[a,*]
   area2_ = area2_[*,b]
   nc4readvar, filename, 'totexttau', ext_, wantlon=[x0,x1], wantlat=[y0,y1], $
    lon=lon_, lat=lat_, /template, /sum
   nc4readvar, filename, 'duexttau', duext_, wantlon=[x0,x1], wantlat=[y0,y1], $
    lon=lon_, lat=lat_, /template, /sum
   nc4readvar, filename2, 'totexttau', merra2_, wantlon=[x0,x1], wantlat=[y0,y1], $
    lon=lon_, lat=lat_, /template, /sum
   a = where(ext_ lt 0)
   ext_[a] = !values.f_nan
   duext_[a] = !values.f_nan
   merra2_[a] = !values.f_nan
   if(i eq 3) then begin
    a = where(lon_ gt 70.)
    b = where(lat_ gt 35.)
    for j = a[0], a[n_elements(a)-1] do begin
     for k = b[0], b[n_elements(b)-1] do begin
      ext_[j,k,*] = !values.f_nan
      duext_[j,k,*] = !values.f_nan
      merra2_[j,k,*] = !values.f_nan
     endfor
    endfor
   endif
   ext[*,i] = aave(ext_,area_,/nan)
   duext[*,i] = aave(duext_,area_,/nan)
   merra2[*,i] = aave(merra2_,area2_,/nan)
  endfor

  save, file='plot_merra2.sav', /variables

jump:
  restore, file='plot_merra2.sav'

;  for i = 0, 9 do begin
  for i = 0, 0 do begin

   set_plot, 'ps'
   device, file='plot_merra2.'+string(i,format='(i1)')+'.ps', $
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
   ymax = max([ext[*,i],merra2[*,i]])
   plot, indgen(nt), /nodata, $
    yrange=[0,ymax], ytitle='AOD', yminor=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=1, $
    xtickv=xtickv, xtickname=make_array(xyrs+1,val=' '), $
    title=regName[i]+' Time Series and Deseasonalized Anomaly', $
    position=[.08,.28,.6,.92]
   oplot, x+1, ext[*,i], thick=8, color=100
   oplot, x+1, duext[*,i], thick=8, color=100, lin=2
   oplot, x+1, merra2[*,i], thick=8, color=0

;  Plot the climatology
   ext_ = reform(ext[*,i],12,xyrs)
   duext_ = mean(reform(duext[*,i],12,xyrs),dimension=2)
   merra2_ = mean(reform(merra2[*,i],12,xyrs), dimension=2)

   ymax = max([max(ext_),max(merra2_)])
   plot, indgen(12)+1, /nodata, /noerase, $
    xrange=[0,13], xticks=13, xminor=1, $
    xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
    yrange=[0,ymax], yminor=2, ytitle='AOD', $
    position=[.66,.1,.98,.92], title='Climatology and Range'
   polymaxmin, indgen(12)+1, ext_, color=100, fillcolor=200, edge=200
   oplot, indgen(12)+1, duext_, lin=2, color=100, thick=8
   oplot, indgen(12)+1, merra2_, thick=8
;  Print the total mean emissions
   xmean = string(total(ext[*,i])/xyrs/12.,format='(f4.2)')
   duxmean = string(total(duext[*,i])/xyrs/12.,format='(f4.2)')
   mxmean = string(total(merra2[*,i])/xyrs/12.,format='(f4.2)')
   xmean = string(total(ext[*,i])/xyrs/12.,format='(f4.2)')
   xyouts, 1, .1*!y.crange[1], 'Annual Mean: ', /data
   xyouts, 5, .1*!y.crange[1], /data, xmean+' ('+duxmean+')', color=100
   xyouts, 8.5, .1*!y.crange[1], /data, mxmean
;  Compute the correlation
   statistics, merra2[*,i], ext[*,i], xmean, ymean, xstd, ystd, $
               r, bias, rms, skill, linslope, linoffset
   statistics, merra2[*,i], duext[*,i], xmean, ymean, xstd, ystd, $
               dur, dubias, rms, skill, linslope, linoffset
   xr = string(r,format='(f5.2)')
   duxr = string(dur,format='(f5.2)')
   xbias = string(bias,format='(f5.2)')
   duxbias = string(dubias,format='(f5.2)')
   xyouts, 1, .05*!y.crange[1], 'Bias: ', /data
   xyouts, 2.5, .05*!y.crange[1], /data, xbias+' ('+duxbias+')', color=100
   xyouts, 7, .05*!y.crange[1], 'r: ', /data
   xyouts, 7.5, .05*!y.crange[1], /data, xr+' ('+duxr+')', color=100



;  Inset an anomaly plot
   smean = mean(ext_,dim=2)
   for j = 0, xyrs-1 do begin
    ext_[*,j] = ext_[*,j]-smean
   endfor
   ext_ = reform(ext_,12*xyrs)
   ymax = max(abs(ext_))
   plot, indgen(nt), /nodata, /noerase, $
    yrange=[-ymax,ymax], yminor=2, ytitle = 'AOD', yticks=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=8, $
    xtickv=xtickv, xtickname=xtickname, $
    position = [.08, .1, .6, .25]
   loadct, 39
   for j = 0, nt-1 do begin
    x = j+1
    y = ext_[j]
    if(y gt 0) then color=84
    if(y le 0) then color=254
    polyfill, x+[-.4,.4,.4,-.4,-.4], [0,0,y,y,0], color=color
   endfor
   plots, [1,nt], 0
  

   device, /close

  endfor
end
