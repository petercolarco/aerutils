; Make a zonal mean plot of the column ozone

; Date you want
  datewant = '199310'

; Get the model fields
  expid = ['c48Fc_H43_pinatubo15',  'c48Fc_H43_pinatubo15+sulfate', $
           'c48Fc_H43_strat', $
           'c48Fc_H43_pinatubo15v2', $
           'c48Fc_H43_pinatubo15v2+sulfate', 'c48Fc_H43_pin15+sulf+cerro']
  color = [254,208,0,254,208,84]
  linst = [1,1,0,0,0,0]

  nexpid = n_elements(expid)
  for iexpid = 0, nexpid-1 do begin
   area, lon, lat, nx, ny, dx, dy, area, grid='b'
;  Get the column ozone
   filetemplate = expid[iexpid]+'.geosgcm_surf.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge datewant+'00')
   nymd = nymd[a[0]]
   filename = filename[a[0]]
   nc4readvar, filename, 'scto3', scto3, lon=lon, lat=lat
   nc4readvar, filename, 'sctto3', sctto3, lon=lon, lat=lat
   scto3 = scto3-sctto3
   nt = n_elements(a)

;  zonal mean
   scto3 = reform(mean(scto3,dimension=1,/nan))

   if(iexpid eq 0) then toto3   = fltarr(ny,nexpid)
   toto3[*,iexpid]     = scto3

  endfor

  set_plot, 'ps'
  device, file='plot_o3col.'+datewant+'.ps', $
    /helvetica, font_size=10, /color, $
    xsize=12, ysize=9, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  plot, lat, toto3[*,0], /nodata, /noerase, $
   xstyle=9, xminor=2, xrange=[-90,-60], $
   xtitle='Latitude', $
   ystyle=9, yrange=[0,400], $
   ytitle = 'Stratospheric Ozone [DU]'
  for iexpid = 0, nexpid-1 do begin
   oplot, lat, toto3[*,iexpid], thick=8, $
   color=color[iexpid], lin=linst[iexpid]
  endfor


  device, /close

end
