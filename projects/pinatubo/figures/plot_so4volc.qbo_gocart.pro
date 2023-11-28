; Colarco
; Plot time series of global mean volcanic SO4

; Experiments
  expid = ['c48Fc_H43_pin15v2+sulf+cerro.tavg2d_aer_x.daily.ddf', $    ; C+sulf, narrow, QBO in phase
           'c48Fc_H43_pin15v2+sulf+cerro_2.tavg2d_aer_x.daily.ddf', $
           'c48Fc_H43_pin15v2+sulf+cerro_3.tavg2d_aer_x.daily.ddf', $
           'c48Fc_H43_pinatubo15.tavg2d_aer_x.daily.ddf', $           ; C, broad             QBO out of phase
           'c48Fc_H43_pinatubo15+sulfate.tavg2d_aer_x.daily.ddf', $   ; C+sulf, broad
           'c48Fc_H43_pinatubo15v2.tavg2d_aer_x.daily.ddf', $         ; C, narrow
           'c48Fc_H43_pinatubo15v2+sulfate.tavg2d_aer_x.daily.ddf', $ ; C+sulf, narrow
           'c180Fc_H43_pin15+sulf+cerro.tavg2d_aer_x.daily.ddf', $    ; c180, C+sulf, narrow
           'c180Fc_H43_pin15v2+sulf+cerro.tavg2d_aer_x.daily.ddf']    ; c180, C+sulf, narrow (QBO in phase)
  nexpid = n_elements(expid)
  for iexpid = 0, nexpid-1 do begin
    print, expid[iexpid]
    filetemplate = expid[iexpid]
    ga_times, filetemplate, nymd, nhms, template=template
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'so4cmassvolc', su, lon=lon, lat=lat
    if(iexpid eq 0) then begin
       nt = n_elements(filename)
       so4v = make_array(nt,nexpid,val=0.)
    endif
    area, lon, lat, nx, ny, dx, dy, area, grid='b'
    if(strpos(filename[0],'c180') ne -1) then area, lon, lat, nx, ny, dx, dy, area, grid='d'
    for it = 0, nt-1 do begin
       so4v[it,iexpid] = total(su[*,*,it]*area)/1.e9 ; Tg
    endfor  
  endfor

  x = findgen(nt)*3.  ; hours since June 1, 01:30z
  ymax = max([so4v])

  set_plot, 'ps'
  device, file='plot_so4volc.qbo_gocart.ps', /helvetica, font_size=14, /color
  !p.font=0

  plot, x, so4v[*,0], /nodata, thick=3, $
   ytitle='Volcanic Sulfate [Tg]', $
   yrange=[0,25], xrange=[0,1464], xstyle=9, ystyle=9, yticks=5, yminor=5, $
   xticks=4, xtickv=[0,120,240,360,488]*3, xtickn=make_array(5,val=' '), $
   position=[.1,.2,.9,.95]
  xyouts, [0,120,240,360,488]*3, -.75, ['June 1','June 15','July 1','July 15','August 1'], $
          /data, orient=300, charsize=.75

  loadct, 0
  oplot, x, so4v[*,0], thick=6, color=120
  oplot, x, so4v[*,1], thick=6, color=120
  oplot, x, so4v[*,2], thick=6, color=120
  oplot, x, so4v[*,8], thick=6, color=120, lin=2
  loadct, 39
  oplot, x, so4v[*,3], thick=6, color=208, lin=1
  oplot, x, so4v[*,4], thick=6, color=208
  oplot, x, so4v[*,5], thick=6, color=84, lin=1
  oplot, x, so4v[*,6], thick=6, color=84
  oplot, x, so4v[*,7], thick=6, color=84, lin=2

  device, /close

end
