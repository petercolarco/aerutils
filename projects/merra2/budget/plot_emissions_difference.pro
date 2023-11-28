; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  geolimits = [-90,-180,90,180]
;  geolimits = [-10,30,60,140]
  varwant = ['duem']

; OPAC Forcing
  filename = '/misc/prc14/colarco/bF_F25b9-base-v1/tavg2d_carma_x/bF_F25b9-base-v1.tavg2d_carma_x.2011_2050.nc4'
  nc4readvar, filename, varwant, duem0, lon=lon, lat=lat, lev=lev

; OPAC Forcing
  filename = '/misc/prc14/colarco/b_F25b9-base-v1/tavg2d_carma_x/b_F25b9-base-v1.tavg2d_carma_x.2011_2050.nc4'
  nc4readvar, filename, varwant, duem1, lon=lon, lat=lat, lev=lev

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Scale the emissions to g m-2
  duem0 = duem0 * 1000. * 365.*86400.
  duem1 = duem1 * 1000. * 365.*86400.

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]

  set_plot, 'ps'
  device, file='./carma_dust.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0


   xycomp, duem1, duem0, lon, lat, dx, dy, $
           levels=[.1,.2,.5,2.,5.,10.,20.,50.,100.]

;   xyouts, .05, .97, satstr+' Full Swath AOT', /normal
;   xyouts, .05, .65, satstr+' '+sample_title+' AOT', /normal
;   xyouts, .05, .33, diffstr, /normal

   device, /close


end
