; Plot the zonal mean, polar cap stratospheric ozone
  expid = ['c48Fc_H43_strat', $
           'c48Fc_H43_pin15v2+sulf', $
           'c48Fc_H43_pin15v2+sulf_2', $
           'c48Fc_H43_pin15v2+sulf_3', $
           'c48Fc_H43_pin15v2+sulf+cerro', $
           'c48Fc_H43_pin15v2+sulf+cerro_2', $
           'c48Fc_H43_pin15v2+sulf+cerro_3']
  nexpid = n_elements(expid)
  latr = [-90,-30]

; Get the ozone
  for iexpid = 0, nexpid-1 do begin
     print, iexpid+1, '/', nexpid
     filetemplate = expid[iexpid]+'.geosgcm_surf.ddf'
print, filetemplate
     ga_times, filetemplate, nymd, nhms, template=template
     filename=strtemplate(template,nymd,nhms)
     a = where(nymd ge '19910500' and nymd le '19931000')
     nymd = nymd[a]
     filename = filename[a]
     nt = n_elements(a)
     if(iexpid eq 0) then o3 = make_array(nt,nexpid,val=0.)
     nc4readvar, filename, 'scto3', scto3, lon=lon, lat=lat
     nc4readvar, filename, 'sctto3', sctto3, lon=lon, lat=lat
     scto3 = scto3-sctto3
     if(strpos(filetemplate,'c48') ne -1) then area, lon, lat, nx, ny, dx, dy, area, grid='b'
     if(strpos(filetemplate,'c180') ne -1) then area, lon, lat, nx, ny, dx, dy, area, grid='d'
     a = where(lat ge latr[0] and lat le latr[1])
     for it = 0, nt-1 do begin
      o3[it,iexpid] = total(scto3[*,a,it]*area[*,a])/total(area[*,a])
     endfor
  endfor

  for iexpid = 0, nexpid-1 do begin
     print, iexpid+1, '/', nexpid
     filetemplate = expid[iexpid]+'.tavg2d_carma_x.ddf'
     ga_times, filetemplate, nymd, nhms, template=template
     filename=strtemplate(template,nymd,nhms)
     a = where(nymd ge '19910500' and nymd le '19931000')
     nymd = nymd[a]
     filename = filename[a]
     nt = n_elements(a)
     if(iexpid eq 0) then su = make_array(nt,nexpid,val=0.)
     nc4readvar, filename, 'suexttau', suexttau, lon=lon, lat=lat
     if(strpos(filetemplate,'c48') ne -1) then area, lon, lat, nx, ny, dx, dy, area, grid='b'
     if(strpos(filetemplate,'c180') ne -1) then area, lon, lat, nx, ny, dx, dy, area, grid='d'
     a = where(lat ge latr[0] and lat le latr[1])
     for it = 0, nt-1 do begin
      su[it,iexpid] = total(suexttau[*,a,it]*area[*,a])/total(area[*,a])
     endfor
  endfor

  set_plot, 'ps'
  device, file='plot_o3.ps', $
   /color, /helvetica, font_size=12, $
   xsize=18, ysize=10, xoff=.5, yoff=.5
  !p.font=0

  x = indgen(29)
  xmax = 28
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

  loadct, 39
  plot, x, o3[*,0], /nodata, $
   position=[.15,.2,.9,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[200,325], $
   yticks=5, ytitle = 'Stratospheric O!D3!N [DU]'
;  oplot, x, o3[*,0], thick=8
  oplot, x, o3[*,1], thick=8, color=208
  oplot, x, o3[*,4], thick=8, color=84
  oplot, x, mean(o3[*,1:3],dim=2), thick=8, color=254
  oplot, x, mean(o3[*,4:6],dim=2), thick=8, color=48
;  oplot, x, o3[*,3], thick=8, color=84, lin=1
;  oplot, x, o3[*,4], thick=8, color=84, lin=2

  axis, yaxis=1, yrange=[0,.7], yticks=7, yminor=5, ytitle='AOD', /save
  oplot, x, su[*,1], thick=4, color=208, lin=2
  oplot, x, su[*,4], thick=4, color=84, lin=2
  oplot, x, mean(su[*,1:3],dim=2), thick=4, color=254, lin=2
  oplot, x, mean(su[*,4:6],dim=2), thick=4, color=48, lin=2
;  oplot, x, su[*,3], thick=4, color=84, lin=2
;  oplot, x, su[*,4], thick=4, color=84, lin=2

  device, /close

end

