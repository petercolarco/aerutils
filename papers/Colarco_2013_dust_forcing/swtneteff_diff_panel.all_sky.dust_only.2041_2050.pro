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

; Experiment #1
; Get the forcing for first experiment
  expid0 = 'bF_F25b9-base-v7'
  difftitle0 = '!4OPAC-Ellipsoids - OPAC-Spheres!3'
  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/geosgcm_surf/'+expid0+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force0 = swtnetc
  force0[*] = !values.f_nan
  a = where(aot gt 0.01)
  force0[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]

; Experiment #2
; Get the forcing for second experiment
  expid1 = 'bF_F25b9-base-v11'
  difftitle1 = '!4OPAC-Spheroids - OPAC-Spheres!3'
  filen = '/Volumes/bender/prc14/colarco/'+expid1+'/geosgcm_surf/'+expid1+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force1 = swtnetc
  force1[*] = !values.f_nan
  a = where(aot gt 0.01)
  force1[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]


; Experiment #3
; Get the forcing for third experiment
  expid2 = 'bF_F25b9-base-v8'
  difftitle2 = '!4OBS-Spheres - OPAC-Spheres!3'
  filen = '/Volumes/bender/prc14/colarco/'+expid2+'/geosgcm_surf/'+expid2+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force2 = swtnetc
  force2[*] = !values.f_nan
  a = where(aot gt 0.01)
  force2[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]

; Baseline
; Get the forcing for baseline experiment
  expid3 = 'bF_F25b9-base-v1'
  filen = '/Volumes/bender/prc14/colarco/'+expid3+'/geosgcm_surf/'+expid3+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat
  nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
  nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
  force3 = swtnetc
  force3[*] = !values.f_nan
  a = where(aot gt 0.01)
  force3[a] = ( (swtnetc[a]-swtnetc_ss[a]) - (swtnetcna[a]-swtnetcna_ss[a]) )/aot[a]

; Make a plot
  set_plot, 'ps'
  device, file='swtneteff_panel_du_all_sky_dust_only.'+expid0+'.2041_2050.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=14, ysize=25, /encap
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

  x = -1
  y = -1
  panel,  force0, force3, force1, force3, force2, force3, x, y, lon, lat, dx, dy, geolimits=geolimits, $
          levels=levels, labelarray=labelarray, colors=colors, colortable=colortable, $
          dlevels=dlevels, dlabelarray=dlabels, $
          title1=difftitle0, title2=difftitle1, title3=difftitle2


  device, /close

end
