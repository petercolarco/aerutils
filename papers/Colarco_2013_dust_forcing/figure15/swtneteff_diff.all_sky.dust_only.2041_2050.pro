; Colarco, March 2013
; Make a difference plot of the forcing between two simulations

; First, read in from the offline calculation the SS aerosol forcing
   filen = '/Volumes/bender/prc14/colarco/bF_F25b9-base-v11/inst2d_surf_x_v1_ss'+$
           '/bF_F25b9-base-v11.inst2d_surf_x_v1_ss.monthly.clim.JJA.nc4'
   nc4readvar, filen, 'swtnet', swtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetna', swtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnet', swgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetna', swgnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'ttauss', aot_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olr', lwtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olrna', lwtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lws', lwgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lwsna', lwgnetcna_ss, lon=lon, lat=lat

  geolimits = [-15,-100,45,40]

; Get the forcing for first experiment
  expid0 = 'bF_F25b9-base-v6'
  titles = '!4TOA All-Sky SW Forcing Efficiency [W m!E-2!N AOT!E-1!N]!3'
  expti0 = '!4SF-Spheres!3'
  difftitle = '!4SF-Spheres - OPAC-Spheres!3'
  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/geosgcm_surf/'+expid0+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'cldlo', cldlo, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force1 = swtnetc
  force1[*] = !values.f_nan
  a = where(aot gt 0.01)
  force1[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]
  cldlo1 = cldlo
  cldlo1[*] = !values.f_nan
  cldlo1[a] = cldlo[a]

; Get the forcing for baseline experiment
  expid1 = 'bF_F25b9-base-v1'
  expti1 = '!4OPAC-Spheres!3'
  filen = '/Volumes/bender/prc14/colarco/'+expid1+'/geosgcm_surf/'+expid1+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'cldlo', cldlo, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force2 = swtnetc
  force2[*] = !values.f_nan
  a = where(aot gt 0.01)
  force2[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]
  cldlo2 = cldlo
  cldlo2[*] = !values.f_nan
  cldlo2[a] = cldlo[a]

; Make a plot
  set_plot, 'ps'
  device, file='swtneteff_du_all_sky_dust_only.'+expid0+'.2041_2050.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25, /encap
 !p.font=0


  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levels = [-1000.,-60,-40,-25,-10,-5,-1,1,5,10,25]
  labelarray = string(levels,format='(i3)')
  levels[0] = -1000.
  labelarray[0] = ' '
  colors = [30,64,80,96,144,176,255,192,208,220,254]

  dlevels = findgen(21)*2-22
  dlevels[0] = -100.
  dlabels = string(dlevels,format='(i3)')
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
