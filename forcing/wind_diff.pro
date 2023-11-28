; Colarco, March 2013
; Make a difference plot of the forcing between two simulations

  geolimits = [0,-30,40,50]

; Get the source function
  filen = '/share/colarco/fvInput/AeroCom/sfc/gocart.dust_source.v5a_1x1inp.x360_y181.nc'
  nc4readvar, filen, 'du_src', du_src, lon=lon_s, lat=lat_s

; Get the forcing for first experiment
  expid0 = 'b_F25b9-base-v1'
  expti0 = '!4No Forcing Surface Wind Speed [m s!E-1!N]!3'
  difftitle = '!4No Forcing - OPAC-Spheres!3'
  filen = '/misc/prc14/colarco/'+expid0+'/geosgcm_surf/'+expid0+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'

  nc4readvar, filen, 'u10m', u10, lon=lon, lat=lat
  nc4readvar, filen, 'v10m', v10, lon=lon, lat=lat
  wind = sqrt(u10*u10 + v10*v10)

; Get the forcing for baseline experiment
  expid1 = 'bF_F25b9-base-v1'
  expti1 = '!4OPAC-Spheres!3'
  filen = '/misc/prc14/colarco/'+expid1+'/geosgcm_surf/'+expid1+ $
          '.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'u10m', u10b, lon=lon, lat=lat
  nc4readvar, filen, 'v10m', v10b, lon=lon, lat=lat
  windb = sqrt(u10b*u10b + v10b*v10b)

; Make a plot
  set_plot, 'ps'
  device, file='wind_'+expid0+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0


  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levels = [0.1,0.2,0.5,1,2,3,4,5,6,7,8]
  labelarray = string(levels,format='(f4.1)')
  colortable = 39
  colors = findgen(11)*25

  dlevels = findgen(21)*0.2 - 2.
  dlabels = string(dlevels,format='(f4.1)')
  dlevels[0] = -2000.
  dlabels[0] = ' '


  xycomp, wind, windb, lon, lat, dx, dy, geolimits=geolimits, $
          levels=levels, labelarray=labelarray, colors=colors, colortable=colortable, $
          dlevels=dlevels, dlabelarray=dlabels, $
          title1=expti0, title2=expti1, difftitle=difftitle


  speed = sqrt((u10-u10b)^2.+(v10-v10b)^2.)
  create_mad_streamlines,lon,lat,-(u10-u10b),-(v10-v10b)  $
       ,xstream,ystream,nstream,sstream=sstream,/sphere,strength=speed,spacing=1.5 $
       ,thick=20.0,threshold=2.0,color=253,acolor=253

  plot_mad_streamlines,xstream,ystream,nstream,thick=10,strength=sstream $
        ,color=253,acolor=253

;  loadct, 39
;  contour, /overplot, du_src, lon_s, lat_s, thick=3, lev=findgen(8)*.1, color=255

  device, /close

end
