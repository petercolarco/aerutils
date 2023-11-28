; Given a list of city sites (from Ali/Melanie?)  

; Define a site
  site = ['Moscow', 'Fairbanks', 'Seattle','New York','Los Angeles','New Delhi', $
          'Mexico City','Manila','Jakarta','Nairobi']
  lon0 = [37.62,-147.72,-122.33,-74.00,-118.24,77.10,-99.13,120.98,106.85,36.82]
  lat0 = [55.76,64.84,47.61,40.71,34.05,28.70,19.43,14.60,-6.21,-1.29]

  ddf = ['full',$
         'gpm.550km', $
         'gpm045.550km', $
         'gpm050.550km', $
         'gpm055.550km', $
         'gpm060.550km', $
         'ss450_gpm.550km']

  nsites = n_elements(site)
  nddf   = n_elements(ddf)
;nsites = 1
  aod    = fltarr(nddf,nsites,365)  ; daily series

;  for iddf = 0, nddf-1 do begin
  for iddf = 1, nddf-1 do begin

  print, ddf[iddf]

; Now we're going to read a time series and accumulate the
; daily area covered for one of our samples
  filetemplate = ddf[iddf]+'.cloud.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;filename = filename[0]
   nc4readvar, filename, 'cldtot', aod_, lon=lon, lat=lat, time=time
   lon2 = 1.
   lat2 = 1.
   nt = n_elements(time)
   area, lon, lat, nx, ny, dx, dy, area, $
         lon2=lon2, lat2=lat2
   a = where(aod_ gt 1e14)
   if(a[0] ne -1) then aod_[a] = !values.f_nan
   aod_ = reform(aod_,nx*1L*ny,nt)

   for isite = 0, nsites-1 do begin

    a = where(lon2 le lon0[isite]+0.5 and lon2 ge lon0[isite]-0.5 and $
              lat2 le lat0[isite]+0.5 and lat2 ge lat0[isite]-0.5)
    aod[iddf,isite,*] = mean(aod_[a,*],/nan,dim=1)

   endfor

  endfor

  openw, lun, 'plot_cloud_site.txt', /get
  printf, lun, nsites, nddf, aod
  free_lun, lun  

save, /variables, filename='plot_aod_site.sav'

  set_plot, 'ps'
  device, file='moscow.ps', /color, font_size=14, /helvetica, $
   xsize=24, ysize=14
  !p.font=0

  x = findgen(365)

  plot, indgen(10), /nodata, $
   xrange=[0,400], yrange=[0,.8]
  oplot, x, aod[0,0,*], thick=6
loadct, 39
oplot, x, aod[1,0,*], thick=3, color=254
oplot, x, aod[2,0,*], thick=3, color=254, lin=2
oplot, x, aod[3,0,*], thick=3, color=84
oplot, x, aod[4,0,*], thick=3, color=84, lin=2
  device, /close


  set_plot, 'ps'
  device, file='moscow.diff.ps', /color, font_size=14, /helvetica, $
   xsize=24, ysize=14
  !p.font=0

  x = findgen(365)

  plot, indgen(10), /nodata, $
   xrange=[0,400], yrange=[-0.2,.2]
;  oplot, x, aod[0,0,*], thick=6
loadct, 39
oplot, x, aod[0,0,*]-aod[1,0,*], thick=3, color=254
oplot, x, aod[0,0,*]-aod[2,0,*], thick=3, color=254, lin=2
oplot, x, aod[0,0,*]-aod[3,0,*], thick=3, color=84
oplot, x, aod[0,0,*]-aod[4,0,*], thick=3, color=84, lin=2
  device, /close



end
