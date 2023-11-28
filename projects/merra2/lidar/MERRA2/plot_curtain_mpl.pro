; File to read
  filename = './output/data/MERRA2.mpl_ft_collins.20140717.nc'

; Read
  depol = 1
  extinction = 1
  aback = 1
  read_curtain, filename, lon, lat, time, z, dz, depol = depol, aback_sfc_tot=aback, extinction_tot = extinction

  datestr = strcompress(string(time[0],format='(i8)'),/rem)

  plotfile = 'mpl_ft_collins.extinction.ps'

  nt = n_elements(time)

  z  = transpose(z) /  1000. ; km
  dz = transpose(dz) / 1000. ; km

; Transpose arrays to be (time,hght)
  depol      = transpose(depol)
  aback = transpose(aback)
  extinction = transpose(extinction)

; Put time into hour of day
  time = (time - long(time[0]))*24.

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
     title = 'GEOS-5 Extinction [km!E-1!N] !C'+ $
             'at Ft. Collins '+datestr, $
             charsize=.75
    loadct, 39
    levelarray = findgen(60)*.001

    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, z, time[1]-time[0], dz
    labelarray = strarr(60)
    labels = [0., 0.01,0.02,0.03,0.04,0.05]
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(f5.3)')
    endfor
    makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
     label=labelarray, $
     align=.5, /no
 
    device, /close


end
