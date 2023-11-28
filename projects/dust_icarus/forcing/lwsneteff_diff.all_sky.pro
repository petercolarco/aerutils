; Colarco, March 2013
; Make a difference plot of the forcing between two simulations

  geolimits = [-15,-100,45,40]

; Get the forcing for first experiment
  expid0 = 'c180F_pI20p1-acma_spher'
  titles = '!4Surface All-Sky LW Forcing Efficiency [W m!E-2!N AOT!E-1!N]!3'
  expti0 = '!4Kok!3'
  difftitle = '!4Kok - Kok (Mie)!3'
  filen = '/misc/prc18/colarco/'+expid0+'/geosgcm_surf/'+expid0+ $
          '.geosgcm_surf.monthly.200807.nc4'

  nc4readvar, filen, 'lws', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'lwsna', swtnetcna, lon=lon, lat=lat
  filen = '/misc/prc18/colarco/'+expid0+'/tavg2d_aer_x/'+expid0+ $
          '.tavg2d_aer_x.monthly.200807.nc4'
  nc4readvar, filen, 'totexttau', aot, lon=lon, lat=lat
  force1 = swtnetc
  force1[*] = !values.f_nan
  a = where(aot gt 0.01)
  force1[a] = ( (swtnetc[a]) - (swtnetcna[a]) )/aot[a]
  cldlo1 = aot
  cldlo1[*] = !values.f_nan
  cldlo1[a] = aot[a]

; Get the forcing for baseline experiment
  expid1 = 'c180F_pI20p1-acma_miet'
  expti1 = '!4Kok (Mie)!3'
  filen = '/misc/prc18/colarco/'+expid1+'/geosgcm_surf/'+expid1+ $
          '.geosgcm_surf.monthly.200807.nc4'
  nc4readvar, filen, 'lws', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'lwsna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'cldlo', cldlo, lon=lon, lat=lat
  filen = '/misc/prc18/colarco/'+expid1+'/tavg2d_aer_x/'+expid1+ $
          '.tavg2d_aer_x.monthly.200807.nc4'
  nc4readvar, filen, 'totexttau', aot, lon=lon, lat=lat
  force2 = swtnetc
  force2[*] = !values.f_nan
  a = where(aot gt 0.01)
  force2[a] = ( (swtnetc[a]) - (swtnetcna[a]) )/aot[a]
  cldlo2 = aot
  cldlo2[*] = !values.f_nan
  cldlo2[a] = aot[a]

; Make a plot
  set_plot, 'ps'
  device, file='lwsneteff_all_sky.'+expid0+'_'+expid1+'.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25, /encap
 !p.font=0


  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levels = [-1000.,1,2,5,10,20,30]
  labelarray = string(levels,format='(f5.1)')
  levels[0] = -1000.
  labelarray[0] = ' '
  colors = [255,84,176,192,208,220,254]

  dlevels = [-100.,-10,-5,-2,-1,-0.5,-0.1,.1,.5,1,2,5,10]
  dlevels[0] = -100.
  dlabels = string(dlevels,format='(f5.1)')
  dlabels[0] = ' '


  xycomp, force1, force2, lon, lat, dx, dy, geolimits=geolimits, $
          levels=levels, labelarray=labelarray, colors=colors, $
          dlevels=dlevels, dlabelarray=dlabels, $
          title0=titles, title1=expti0, title2=expti1, difftitle=difftitle, $
          contour1=cldlo1, contour2=cldlo2

;  title=satid+' (top), '+expid+' (middle), top-middle (bottom)'
;  xyouts, .45, .97, title, align=.5, /normal
;  xyouts, .95, .97, yyyymm, align=.5, /normal

  device, /close

end
