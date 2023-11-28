  species = 'total'
  sattrack = 'nadir.txt'
  titlestr = 'GEOS-5 Total Aerosol Extinction'
  read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                      surfp, pblh, h, hghte, relhum, t, delp, sattrack=sattrack
  read_lidartrack, species, hyai, hybi, time, date, lon, lat, mmr_du, ssa, tau_du, backscat, $
                   sattrack=sattrack

  datewant = 2007071600L
; Set up the box that you want to look in
  latwant=[9.5,57.4]
  lonwant=[46.,60.9]
  a = where(date eq datewant and $
            lon ge lonwant[0] and lon le lonwant[1] and $
            lat ge latwant[0] and lat le latwant[1])

  set_plot, 'ps'
  device, file='d5_tc4_01.mbl.'+species+'.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=18, ysize=16
  !p.font=0
  loadct, 0

  map_set, limit=[0,30,65,75]
  lonmod = findgen(149)*.666
  latmod = findgen(149)*.5
  array = fltarr(149*149L)
  for i = 0L, 149*149L-1 do begin
   if(i/2 eq i/2.) then array[i] = 1
  endfor
  plotgrid, reform(array,149,149), [0,1], [180,255], lonmod, latmod, .666, .5

  map_continents, thick=3
  map_continents, /countries

  loadct, 39
  plots, lon[a], lat[a], thick=12, color=254

  trackname = ['neg15deg', 'neg10deg', 'neg5deg', '5deg', '10deg', '15deg']
  for i = 0, 5 do begin
   read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                       surfp, pblh, h, hghte, relhum, t, delp, $
                       sattrack=trackname[i]+'.txt'
   plots, lon[a], lat[a], thick=4, color=254
  endfor

  trackname = ['neg15deg', 'neg10deg', 'neg5deg', 'nadir', '5deg', '10deg', '15deg']
  for i = 0, 6 do begin
    read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                         surfp, pblh, h, hghte, relhum, t, delp, $
                         sattrack=trackname[i]+'.txt'
    read_lidartrack, species, hyai, hybi, time, date, lon, lat, mmr_du, ssa, tau_du, backscat, $
                     sattrack=trackname[i]+'.txt'

    time_ = time[a]
    hour_ = (time_ - fix(time_))*24.
    lon_ = lon[a]
    lat_ = lat[a]
    tau_du_ = tau_du[*,a]
    ssa_ = ssa[*,a]
    h_ = h[*,a]
    hghte_ = hghte[*,a]
    dz_ = h_
    for iz = 0, n_elements(h_[*,0])-1 do begin
     dz_[iz,*] = hghte_[iz+1,*]-hghte_[iz,*]
    endfor
    ext_ = tau_du_/dz_*1000.
    tau_ = reform(total(tau_du_,1))

    ext_ = transpose(ext_)
    ssa_ = transpose(ssa_)
    dz_  = transpose(dz_)
    h_   = transpose(h_)

;    b = where(ext_ lt .02)
;    ssa_[b] = 0.

    abs_ = (1.-ssa_)*ext_

;   Set up the x-axis range
    time0   = min(hour_)
    time1   = max(hour_)
;   If the time is less than some minimum value, expand it
    delnn   = (time1-time0)*60.
    if(delnn lt 8.) then begin
     tinc = (8.-delnn)/2./60.
     time0 = time0-tinc
     time1 = time1+tinc
    endif
    hh0     = fix(time0)
    nn0     = (time0-hh0)*60.
    time0   = hh0+fix(nn0)/60.
    hh1     = fix(time1)
    nn1     = (time1-hh1)*60.
    time1   = hh1+fix(nn1+.5)/60.



    contour, ext_, hour_, reform(h_[0,*])/1000., /nodata, $
     yrange=[0,20], ythick=3, ystyle=9, $
     xrange=[time0,time1], xthick=3, xstyle=9, level=levelarray, $
     title='Track '+trackname[i], $
     xtitle = 'hour', ytitle='altitude [km]', $
     position=[.15,.25,.85,.9]

    levelarray = [.01, .05, .1, .2, .3, .4, .5, .6, .8, 1]
    colorarray = [30,64,80,96,144,176,192,199,208,254]
    plotgrid, ext_, levelarray, colorarray, hour_, h_/1000., .000125*24., dz_/1000.

;    levelarray = [.01, .05, .1, .2, .3, .4, .5, .6, .8, 1]/10.
;    colorarray = [30,64,80,96,144,176,192,199,208,254]
;    plotgrid, abs_, levelarray, colorarray, hour_, h_/1000., .000125*24., dz_/1000.

;    levelarray = findgen(10)*.01+.9
;    colorarray = [30,64,80,96,144,176,192,199,208,254]
;    plotgrid, ssa_, levelarray, colorarray, hour_, h_/1000., .000125*24., dz_/1000.

    axis, yaxis=1, yrange=[0,4], ythick=3, /save, ytitle='AOT [532 nm]'
    oplot, hour_, tau_, thick=6

    makekey, .15, .1, .7, .025, 0, -.015, colors=colorarray, $
     label=string(levelarray,format='(f4.2)'), charsize=.5, align=0

  endfor

  device, /close


end
