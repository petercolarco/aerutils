; File to read
  lambda = '532'
  version = 'v10'
  filename = './output/data/virginie_reff/dR_MERRA-AA-r2.calipso_'+lambda+'nm-'+version+'.20090715.nc'

; Read
  area = 1
  depol = 1
  read_curtain, filename, lon, lat, time, z, dz, area=area, depol=depol

; select
  a = where(lon lt 0 and lon gt -20 and $
;  a = where(lon lt -20 and lon gt -80 and $
            lat lt 40 and lat gt 0 and $
            time-time[0] lt .5)

  lon = lon[a]
  lat = lat[a]
  time = time[a]
  z  = z[*,a]
  dz = dz[*,a]
  area = transpose(area[*,a])

    datestr = strcompress(string(time[0],format='(i8)'),/rem)

    plotfile = lambda+'nm-'+version+'.area.ps'

    nt = n_elements(time)

    z  = transpose(z) /  1000. ; km
    dz = transpose(dz) / 1000. ; km
    
    

;   Put time into hour of day
    time = (time - long(time))*24.

    set_plot, 'ps'
    device, file=plotfile, /helvetica, font_size=14, /color
    !p.font=0
 

    position = [.15,.2,.95,.9]
    a = where(time lt time[0])
    if(a[0] ne -1) then time[a] = time[a]+24.
    plot, indgen(n_elements(time)), /nodata, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle='altitude [km]', $
     position=position, $
     title = 'GEOS-5 particle area [m!E2!N m!E-3!N] !C'+ $
             'along CALIPSO track '+datestr, $
             charsize=.75
    loadct, 39
    levelarray = findgen(60)*10

    colorarray = findgen(60)*4+16
    plotgrid, area, levelarray, colorarray, $
              time, z, time[1]-time[0], dz
    labelarray = strarr(60)
    labels = [0., 0.05,0.1,0.15,0.2,0.25]*2000
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(i4)')
    endfor
    makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
     label=labelarray, $
     align=.5, /no

     loadct, 0
     dxplot = position[2]-position[0]
     dyplot = position[3]-position[1]
     x0 = position[0]+.65*dxplot
     x1 = position[0]+.95*dxplot
     y0 = position[1]+.65*dyplot
     y1 = position[1]+.95*dyplot
     polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=255, /normal
     map_set, /noerase, position=[x0,y0,x1,y1], limit=[0,-30,40,10]
;     map_set, /noerase, position=[x0,y0,x1,y1], limit=[0,-70,40,-30]
     map_continents, thick=.5
     oplot, lon, lat, thick=6
 
    device, /close


end
