  pro plot_time, expid, varval, varname, nymd, title, ylabel, plotf, second=second, third=third

  set_plot, 'ps'
  device, file=plotf+'.'+expid+'.'+varname+'.ps', $
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
  xticks=xyrs
  xtickv=[1+findgen(xyrs)*12,nt+1]
  xtickname = [string(fix(strmid(nymd[0],0,4))+indgen(xyrs+1),format='(i4)'),' ']
  if(xyrs gt 20) then begin
   xticks=xticks/5
   xtickv=xtickv[0:n_elements(xtickv)-1:5]
   xtickname=xtickname[0:n_elements(xtickname)-1:5]
  endif
  ymax = max(varval)
  ymin = max([0,0.8*min(varval)])
  if(min(varval) lt 0) then ymin = min(varval)
  if(keyword_set(second)) then ymin = min([ymin,min(0.8*second)])
  if(keyword_set(third))  then ymin = min([ymin,min(0.8*third)])
  if(keyword_set(second)) then ymax = max([ymax,max(second)])
  if(keyword_set(third))  then ymax = max([ymax,max(third)])
  plot, indgen(nt), /nodata, $
    yrange=[ymin,ymax], ytitle=ylabel, yminor=2, $
    xrange=[0,nt+1], xticks=xticks, xminor=1, xstyle=1, $
    xtickv=xtickv, xtickname=make_array(xticks+1,val=' '), $
    title=title+' Time Series and Anomaly', $
    position=[.08,.28,.6,.92]
   oplot, x+1, varval, thick=4, color=100
   if(keyword_set(second)) then oplot, x+1, second, thick=6, color=100, lin=2
   if(keyword_set(third))  then oplot, x+1, third, thick=6, color=100, lin=1

;  Plot the climatology
   varval_ = reform(varval,12,xyrs)
   ymin = max([0,0.8*min(varval)])
   if(min(varval) lt 0) then ymin = min(varval)
   ymax = max(varval)
   if(keyword_set(second)) then begin
    ymax = max([ymax,max(second)])
    second_ = reform(second,12,xyrs)
    ymin = min([ymin,min(0.8*second)])
    if(min(varval) lt 0) then ymin = min([0.8*min(varval),0.8*min(second)])
    xmean_ = string(total(second)/xyrs,format='(i5)')
    if(total(second)/xyrs lt 10) then  xmean_ = string(total(second)/xyrs,format='(f6.2)')
    xmean_ = strcompress(xmean_,/rem)
   endif
   if(keyword_set(third)) then begin
    third_ = reform(third,12,xyrs)
    ymin = min([ymin,min(0.8*third)])
    ymax = max([ymax,max(third)])
    xmean__ = string(total(third)/xyrs,format='(i5)')
    if(total(third)/xyrs lt 10) then  xmean__ = string(total(third)/xyrs,format='(f6.2)')
    xmean__ = strcompress(xmean__,/rem)
   endif
   plot, indgen(12)+1, /nodata, /noerase, $
    xrange=[0,13], xticks=13, xminor=1, $
    xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
    yrange=[ymin,ymax], yminor=2, ytitle=ylabel, $
    position=[.68,.1,.98,.92], title='Mean Climatology'
;   polymaxmin, indgen(12)+1, varval_, color=100, fillcolor=200, edge=200
   oplot, indgen(12)+1, varval_, color=100, thick=6
   if(keyword_set(second)) then begin
;    polymaxmin, indgen(12)+1, second_, color=100, fillcolor=240, edge=240, lin=2
    oplot, indgen(12)+1, second_, color=100, thick=6, lin=2
   endif
   if(keyword_set(third)) then begin
    polymaxmin, indgen(12)+1, third_, color=100, fillcolor=160, edge=160, lin=1
   endif

;  Print the total mean emissions
   xmean = string(total(varval)/xyrs,format='(i5)')
   if(total(varval)/xyrs lt 10) then  xmean = string(total(varval)/xyrs,format='(f5.2)')
   y = !y.crange[0]+0.1*(!y.crange[1]-!y.crange[0])
   xyouts, 1, y, 'Mean Annual Total [Tg]: ', /data
   xyouts, 8, y, /data, xmean
   if(keyword_set(second)) then xyouts, 9.5, y, /data, ' ('+xmean_+')'
   if(keyword_set(third)) then xyouts, 11.5, y, /data, '('+xmean__+')'

;  Inset an anomaly plot
   if(not(keyword_set(second))) then begin
    smean = mean(varval_,dim=2)
    for j = 0, xyrs-1 do begin
     varval_[*,j] = varval_[*,j]-smean
    endfor
    varval_ = reform(varval_,12*xyrs)
    ymax = max(abs(varval_))
   endif else begin
    for j = 0, xyrs-1 do begin
     varval_[*,j] = varval_[*,j]-second_[*,j]
    endfor
    varval_ = reform(varval_,12*xyrs)
    ymax = max(abs(varval_))
   endelse
   plot, indgen(nt), /nodata, /noerase, $
    yrange=[-ymax,ymax], yminor=2, ytitle = ylabel, yticks=2, $
    xrange=[0,nt+1], xticks=xticks, xminor=12, xstyle=8, $
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
