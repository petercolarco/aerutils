; Colarco, August 2013
; Make a three panel plot that shows the wind differences, wind
; variance differences, and emission differences between two
; simulations

  expid = ['bF_F25b9-base-v1','bF_F25b9-base-v8']

  for iexp = 0, 1 do begin

  geolimits = [5,-30,40,50]
  expid0 = expid[iexp]
  expid1 = 'b_F25b9-base-v1'

  title0      = '!4OPAC-Spheres - No Forcing!3'
  difftitle_w = '!9D!4Wind Speed [m s!E-1!N]!3'
  difftitle_v = '!9D!4Wind Speed Variance [m s!E-1!N]!3'
  difftitle_e = '!9D!4Emissions [g m!E-2!N mon!E-1!N]!3'


; Get the source function
  filen = '/Users/pcolarco/sandbox/fvInput/AeroCom/sfc/gocart.dust_source.v5a_1x1inp.x360_y181.nc'
  nc4readvar, filen, 'du_src', du_src, lon=lon_s, lat=lat_s

; Get the forcing for first experiment
  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/geosgcm_surf_save/'+expid0+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'u10m', u10, lon=lon, lat=lat
  nc4readvar, filen, 'v10m', v10, lon=lon, lat=lat
  nc4readvar, filen, 'speed', wind, lon=lon, lat=lat
  nc4readvar, filen, 'var_u10m', v_u10, lon=lon, lat=lat
  nc4readvar, filen, 'var_v10m', v_v10, lon=lon, lat=lat
  nc4readvar, filen, 'var_speed', var, lon=lon, lat=lat
; Comment out below to use "speed" rather than 10-m wind speed
;  wind = sqrt(u10*u10 + v10*v10)
;  var  = sqrt(v_u10*v_u10 + v_v10*v_v10)
  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/tavg2d_carma_x/'+expid0+ $
          '.tavg2d_carma_x.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'duem', emis, lon=lon, lat=lat
  emis = emis*30*86400.*1000.

; Get the forcing for baseline experiment
  filen = '/Volumes/bender/prc14/colarco/'+expid1+'/geosgcm_surf/'+expid1+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'u10m', u10b, lon=lon, lat=lat
  nc4readvar, filen, 'v10m', v10b, lon=lon, lat=lat
  nc4readvar, filen, 'speed', windb, lon=lon, lat=lat
  nc4readvar, filen, 'var_u10m', v_u10b, lon=lon, lat=lat
  nc4readvar, filen, 'var_v10m', v_v10b, lon=lon, lat=lat
  nc4readvar, filen, 'var_speed', varb, lon=lon, lat=lat
; Comment out below to use "speed" rather than 10-m wind speed
;  windb = sqrt(u10b*u10b + v10b*v10b)
;  varb  = sqrt(v_u10b*v_u10b + v_v10b*v_v10b)
  filen = '/Volumes/bender/prc14/colarco/'+expid1+'/tavg2d_carma_x/'+expid1+ $
          '.tavg2d_carma_x.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'duem', emisb, lon=lon, lat=lat
  emisb = emisb*30*86400.*1000.

; Make a plot
  set_plot, 'ps'
  device, file='wind_emis_panel.'+expid0+'.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=14, ysize=27, /encap
 !p.font=0


  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levels = [0.1,0.2,0.5,1,2,3,4,5,6,7,8]
  labelarray = string(levels,format='(f4.1)')
  colortable = 39
  colors = findgen(11)*25

  dlevels = findgen(21)*0.2 - 2.
dlevels = [-2000.,-4,-3.5,-3,-2.5,-2,-1.5,-.5,-.1,.1,.5,1,1.5,2,2.5,3,3.5,4]
  dlabels = string(dlevels,format='(f4.1)')
  dlevels[0] = -2000.
  dlabels[0] = ' '


  x = u10-u10b
  y = v10-v10b
  panel,  wind, windb, var, varb, emis, emisb, x, y, lon, lat, dx, dy, geolimits=geolimits, $
          levels=levels, labelarray=labelarray, colors=colors, colortable=colortable, $
          dlevels=dlevels, dlabelarray=dlabels, /du_src, $
          title0=title0, title1=difftitle_w, title2=difftitle_v, title3=difftitle_e

;  contour, /overplot, du_src, lon_s, lat_s, thick=2, lev=findgen(8)*.1, color=0

  device, /close

  endfor

end
