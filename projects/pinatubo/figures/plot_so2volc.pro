; Colarco
; Plot time series of global mean volcanic SO2

; Experiments
  expid = ['c48F_H43_pinatubo15.tavg2d_aer_x.daily.ddf', $            ; G, broad injection
           'c48Fc_H43_pinatubo15.tavg2d_aer_x.daily.ddf', $           ; C, broad injection
           'c48F_H43_pinatubo15+sulfate.tavg2d_aer_x.daily.ddf', $    ; G+sulf, broad
           'c48Fc_H43_pinatubo15+sulfate.tavg2d_aer_x.daily.ddf', $   ; C+sulf, broad
           'c48Fc_H43_pinatubo15v2.tavg2d_aer_x.daily.ddf', $         ; C+sulf, narrow
           'c48Fc_H43_pinatubo15v2+sulfate.tavg2d_aer_x.daily.ddf', $ ; C+sulf, narrow
           'c180Fc_H43_pin15+sulf+cerro.tavg2d_aer_x.daily.ddf']      ; c180, C+sulf, narrow
  nexpid = n_elements(expid)
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for iexpid = 0, nexpid-1 do begin
    print, expid[iexpid]
    filetemplate = expid[iexpid]
    ga_times, filetemplate, nymd, nhms, template=template
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'so2cmassvolc', su, lon=lon, lat=lat
    if(iexpid eq 0) then begin
       nt = n_elements(filename)
       so2v = make_array(nt,nexpid,val=0.)
    endif
;   if last (c180) get updated area
    if(iexpid eq nexpid-1) then area, lon, lat, nx, ny, dx, dy, area, grid='d'
    for it = 0, nt-1 do begin
       so2v[it,iexpid] = total(su[*,*,it]*area)/1.e9 ; Tg
    endfor  
  endfor

  x = findgen(nt)*3.  ; hours since June 1, 01:30z
  ymax = max([so2v])

  set_plot, 'ps'
  device, file='plot_so2volc.ps', /helvetica, font_size=14, /color
  !p.font=0

  plot, x, so2v[*,0], /nodata, thick=3, $
   xtitle='Hours from June 1, 1991', $
   ytitle='Volcanic SO2 [Tg]', $
   yrange=[0,ymax]

  loadct, 0
; plot the e-folding times from about 120 hours out of eruption as
; envelope
  xd  = 360.+indgen(1200)
  y   = 14.5*exp(-0.0021*(xd-360.))  ; 20 day e-folding
  yy  = y[120]*exp(-0.0021*(xd[120:1199]-480.)) ; 25 day e-folding
  yyy = y[120]*exp(-0.0014*(xd[120:1199]-480.)) ; 30 day e-folding
  polymaxmin, xd[120:1199], reform([yy,yyy],1080,2), fillcolor=240, /noave
  
  oplot, x, so2v[*,0], thick=6, color=120
  oplot, x, so2v[*,2], thick=6, color=120, lin=2
  loadct, 39
  oplot, x, so2v[*,1], thick=6, color=254
  oplot, x, so2v[*,3], thick=6, color=254, lin=2
  oplot, x, so2v[*,4], thick=6, color=84
  oplot, x, so2v[*,5], thick=6, color=84, lin=2
  oplot, x, so2v[*,6], thick=6, color=176, lin=2

  oplot, xd[0:119], y, thick=6, color=0

  device, /close

end
