; Colarco, March 2013
; Make a difference plot of the forcing between two simulations

  geolimits = [-45,-45,15,60]

; Get the forcing for first experiment
  expid = 'bF_F25b9-base-v6'
  filen = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+expid+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'swtnetc', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetcna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force1 = swtnetc
  force1[*] = !values.f_nan
  a = where(aot gt 0.01)
  force1[a] = (swtnetc[a] - swtnetcna[a])/aot[a]

; Get the forcing for baseline experiment
  expid = 'bF_F25b9-base-v1'
  filen = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+expid+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'swtnetc', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetcna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force2 = swtnetc
  force2[*] = !values.f_nan
  a = where(aot gt 0.01)
  force2[a] = (swtnetc[a] - swtnetcna[a])/aot[a]

; Make a plot
  set_plot, 'ps'
  device, file='diff.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  xycomp, force1, force2, lon, lat, dx, dy, geolimits=geolimits, $
          levels=findgen(11)*.1

;  title=satid+' (top), '+expid+' (middle), top-middle (bottom)'
  xyouts, .45, .97, title, align=.5, /normal
  xyouts, .95, .97, yyyymm, align=.5, /normal

  device, /close

end
