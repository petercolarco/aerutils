  species = 'total.v2'
  sattrack = 'nadir.txt'
  titlestr = 'GEOS-5 Total Aerosol Extinction'
  ext = 1.
  read_lidartrack, species, hyai, hybi, time, date, lon, lat, mmr_du, ssa, tau_du, backscat, $
                   sattrack=sattrack, ext=ext
  read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                      surfp, pblh, h, hghte, relhum, t, delp, sattrack=sattrack


; Set up the box that you want to look in
  lonwant=[-100,-50]
  latwant=[0,20]

; break the dataset into unique days
  dateday = date/100L
  uniqday = uniq(dateday)
  nday = n_elements(uniqday)

  set_plot, 'ps'
  device, file='d5_tc4_01.caribbean.'+species+'.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=18, ysize=26
  loadct, 39
  !p.font=0

  for iday = 0, nday-1 do begin
   a = where(date/100L eq dateday[uniqday[iday]] and $
             lon ge lonwant[0] and lon le lonwant[1] and $
             lat ge latwant[0] and lat le latwant[1])

   if(a[0] ne -1) then begin

  !p.multi=[0,2,4]

;  find contiguous chunks of it all
   iestart = a[0]
   for i = 1L, n_elements(a)-1 do begin
    if(a[i] - a[i-1] gt 1) then begin
     iestart = [iestart,a[i]]
     it = n_elements(iestart)-1
     if(it eq 1) then ieend = a[i-1]
     if(it gt 1) then ieend = [ieend,a[i-1]]
    endif
   endfor
   ieend = [ieend,a[n_elements(a)-1]]
   ntracks = n_elements(iestart)

   map_set, limit=[-5,-110,25,-40], $
    position=[.075,.775,.5,.95]
   xyouts, .075, .975, strcompress(string(dateday[uniqday[iday]]), /rem) $
      +', CALIPSO tracks: '+strcompress(string(ntracks),/rem), /normal
   map_continents, thick=3
   map_continents, /countries
;   map_grid, /box, charsize=.5
   for i = 0, ntracks-1 do begin
    lon_ = lon[iestart[i]:ieend[i]]
    lat_ = lat[iestart[i]:ieend[i]]
    coloruse = 254
    if(lat[iestart[i]] gt lat[ieend[i]]) then coloruse = 0
    plots, lon_, lat_, color=coloruse, thick=6
    xyouts, lon[iestart[i]], lat[iestart[i]], strcompress(string(i+1),/rem), color=coloruse
   endfor

   for i = 0, ntracks-1 do begin
    !p.multi=[6-i,2,4]
    time_ = time[iestart[i]:ieend[i]]
    hour_ = (time_ - fix(time_))*24.
    lon_ = lon[iestart[i]:ieend[i]]
    lat_ = lat[iestart[i]:ieend[i]]
    tau_du_ = tau_du[*,iestart[i]:ieend[i]]
    ext_ = ext[*,iestart[i]:ieend[i]]
    h_ = h[*,iestart[i]:ieend[i]]
    hghte_ = hghte[*,iestart[i]:ieend[i]]
    dz_ = h_
    for iz = 0, n_elements(h_[*,0])-1 do begin
     dz_[iz,*] = hghte_[iz+1,*]-hghte_[iz,*]
    endfor

    tau_ = reform(total(tau_du_,1))

    ext_ = transpose(ext_)
    dz_  = transpose(dz_)
    h_   = transpose(h_)

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
     yrange=[0,6], ythick=3, ystyle=9, $
     xrange=[time0,time1], xthick=3, xstyle=9, level=levelarray, $
     title='Track #'+strcompress(string(i+1),/rem), $
     xtitle = 'hour', ytitle='altitude [km]'
    levelarray = [.01, .05, .1, .2, .3, .4, .5, .6, .8, 1]
    
    colorarray = [30,64,80,96,144,176,192,199,208,254]
    plotgrid, ext_, levelarray, colorarray, hour_, h_/1000., .000125*24., dz_/1000.
    axis, yaxis=1, yrange=[0,4], ythick=3, /save, ytitle='AOT [532 nm]'
    oplot, hour_, tau_, thick=3

   endfor

   makekey, .575, .9, .375, .025, 0, -.015, colors=colorarray, $
    label=string(levelarray,format='(f4.2)'), charsize=.5, align=0
   xyouts, .575, .95, titlestr, /normal, charsize=.75
   xyouts, .575, .93, '!Ms!3!D532 nm!N [km!E-1!N], d5_tc4_01', /normal, charsize=.75
   xyouts, .575, .85, 'Night tracks', /normal, charsize=.8
   xyouts, .575, .83, 'Day tracks', /normal, charsize=.8, color=254

  endif

  endfor

  device, /close

end
