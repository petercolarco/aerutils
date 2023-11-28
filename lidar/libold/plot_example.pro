;  filedir = '/misc/prc10/colarco/tc4/d5_tc4_01/das/lidar/'
;  read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, ssa, tau_du, backscat, $
;                   filetoread=filedir+'d5_tc4_01.inst3d_ext-532nm_v.total.nadir.txt.hdf'
;  read_lidartrack_met, hyai, hybi, lon, lat, time_, date, $
;                       surfp, pblh, h, hghte, relhum, t, delp, $
;                       filetoread=filedir+'d5_tc4_01.met.nadir.txt.hdf'

  filedir = '/misc/prc10/epnowott/d530_tc4_02/tau/Y2007/M07/'
  read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, ssa, tau_du, backscat, $
                   filetoread=filedir+'d530_tc4_02.inst3d_ext-532nm_v.total.er2_track_20070719.txt.hdf'
  read_lidartrack_met, hyai, hybi, lon, lat, time_, date, $
                       surfp, pblh, h, hghte, relhum, t, delp, $
                       filetoread=filedir+'d530_tc4_02.met.er2_track_20070719.txt.hdf'

; select judd's orbit
 a = where(time gt 20070718.05d and time lt 20070718.1d and $
           lat lt 60 and lat gt 0 and lon gt 0 and lon lt 30)

; Transpose arrays to be (time,hght)
  extinction = transpose(extinction[*,a])
  h = transpose(h[*,a]) / 1000.  ; km
  hghte = transpose(hghte[*,a]) / 1000.  ; km
  dz = hghte[*,0:71]-hghte[*,1:72]
  time = time[a]
  lon = lon[a]
  lat = lat[a]

; Put time into fraction of day
  time = time - long(time)

  set_plot, 'ps'
  device, file='example_plot.ps', /helvetica, font_size=14, /color
  !p.font=0

  nt = n_elements(time)
  position = [.15,.2,.95,.9]
  plot, indgen(n_elements(time)), /nodata, $
   xrange=[time[0],time[nt-1]], xtitle='FractionOfDay', $
   yrange=[0,20], ytitle='altitude [km]', $
   position=position, $
   title = 'GEOS-5 extinction profile [km-1, 532 nm]!C'+ $
           'along CALIPSO track 20070718 (TC4, d5_tc4_01)', $
           charsize=.75
  loadct, 39
  levelarray = findgen(10)*.1+.1
  levelarray = levelarray/10.
  colorarray = 254 - findgen(10)*25
  plotgrid, extinction, levelarray, colorarray, $
            time, h, time[1]-time[0], dz
  makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
   label=strcompress(string(levelarray,format='(f4.2)'),/rem), $
   align=0

   loadct, 0
   dxplot = position[2]-position[0]
   dyplot = position[3]-position[1]
   x0 = position[0]+.65*dxplot
   x1 = position[0]+.95*dxplot
   y0 = position[1]+.65*dyplot
   y1 = position[1]+.95*dyplot
   map_set, /noerase, position=[x0,y0,x1,y1]
   map_continents, thick=.5
   oplot, lon, lat, thick=6

  device, /close

end
