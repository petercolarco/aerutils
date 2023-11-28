  pro plot_time, varval, varname, nymd, title, second=second, third=third

  set_plot, 'ps'
  device, file='plot_emissions_time.'+varname+'.ps', $
   /helvetica, font_size=12, /color, $
   xsize=28, ysize=12
  !p.font=0

  nt = n_elements(varval)

  loadct, 0

  x = indgen(nt)
  xyrs = n_elements(x)/12
  xmax = n_elements(x)
  if(xyrs ne n_elements(x)/12.) then xyrs = xyrs+1
  if(xyrs ne n_elements(x)/12.) then xmax = xyrs*12
  xtickv=[1+findgen(xyrs)*12,nt+1]
  xtickname = [string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)'),' ']
  ymax = max(varval)
  ymin = max([0,0.8*min(varval)])
  if(min(varval) lt 0) then ymin = min(varval)
  if(keyword_set(second)) then ymin = min([ymin,min(0.8*second)])
  if(keyword_set(third))  then ymin = min([ymin,min(0.8*third)])
  plot, indgen(nt), /nodata, $
    yrange=[ymin,ymax], ytitle='Emissions [Tg]', yminor=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=1, $
    xtickv=xtickv, xtickname=make_array(xyrs+1,val=' '), $
    title=title+' Time Series and Deseasonalized Anomaly', $
    position=[.08,.28,.6,.92]
   oplot, x+1, varval, thick=8, color=100
   if(keyword_set(second)) then oplot, x+1, second, thick=6, color=100, lin=2
   if(keyword_set(third))  then oplot, x+1, third, thick=6, color=100, lin=1

;  Plot the climatology
   varval_ = reform(varval,12,xyrs)
   ymin = max([0,0.8*min(varval)])
   if(min(varval) lt 0) then ymin = min(varval)
   ymax = max(varval)
   if(keyword_set(second)) then begin
    second_ = reform(second,12,xyrs)
    ymin = min([ymin,min(0.8*second)])
    if(min(varval) lt 0) then ymin = min([0.8*min(varval),0.8*min(second)])
    xmean_ = string(total(second)/xyrs,format='(i4)')
    if(total(second)/xyrs lt 10) then  xmean_ = string(total(second)/xyrs/12.,format='(f5.2)')
    xmean_ = strcompress(xmean_,/rem)
   endif
   if(keyword_set(third)) then begin
    third_ = reform(third,12,xyrs)
    ymin = min([ymin,min(0.8*third)])
    xmean__ = string(total(third)/xyrs,format='(i4)')
    if(total(third)/xyrs lt 10) then  xmean__ = string(total(third)/xyrs/12.,format='(f5.2)')
    xmean__ = strcompress(xmean__,/rem)
   endif
   plot, indgen(12)+1, /nodata, /noerase, $
    xrange=[0,13], xticks=13, xminor=1, $
    xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
    yrange=[ymin,ymax], yminor=2, ytitle='Emissions [Tg]', $
    position=[.66,.1,.98,.92], title='Climatology and Range'
   polymaxmin, indgen(12)+1, varval_, color=100, fillcolor=200, edge=200
   if(keyword_set(second)) then begin
    polymaxmin, indgen(12)+1, second_, color=100, fillcolor=240, edge=240, lin=2
   endif
   if(keyword_set(third)) then begin
    polymaxmin, indgen(12)+1, third_, color=100, fillcolor=160, edge=160, lin=1
   endif

;  Print the total mean emissions
   xmean = string(total(varval)/xyrs,format='(i4)')
   if(total(varval)/xyrs lt 10) then  xmean = string(total(varval)/xyrs/12.,format='(f5.2)')
   y = !y.crange[0]+0.1*(!y.crange[1]-!y.crange[0])
   xyouts, 1, y, 'Mean Annual Total [Tg]: ', /data
   xyouts, 8, y, /data, xmean
   if(keyword_set(second)) then xyouts, 9.5, y, /data, '('+xmean_+')'
   if(keyword_set(third)) then xyouts, 11.5, y, /data, '('+xmean__+')'

;  Inset an anomaly plot
   smean = mean(varval_,dim=2)
   for j = 0, xyrs-1 do begin
    varval_[*,j] = varval_[*,j]-smean
   endfor
   varval_ = reform(varval_,12*xyrs)
   ymax = max(abs(varval_))
   plot, indgen(nt), /nodata, /noerase, $
    yrange=[-ymax,ymax], yminor=2, ytitle = 'Emissions [Tg]', yticks=2, $
    xrange=[0,nt+1], xticks=xyrs, xminor=12, xstyle=8, $
    xtickv=xtickv, xtickname=xtickname, $
    position = [.08, .1, .6, .25]
   loadct, 39
   for j = 0, nt-1 do begin
    x = j+1
    y = varval_[j]
    if(y gt 0) then color=84
    if(y le 0) then color=254
    polyfill, x+[-.4,.4,.4,-.4,-.4], [0,0,y,y,0], color=color
   endfor
   plots, [1,nt], 0

  device, /close
  
end
