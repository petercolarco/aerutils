; File to read
  filename = './output/data/dR_Fortuna-M-1-1.glas_532nm.20031009.nc'

; Read
  radiances = 0
  totext = 1.
  bcext  = 1.
  ocext  = 1.
  duext  = 1.
  ssext  = 1.
  suext  = 1.
  read_curtain, filename, lon, lat, time, h, dz, radiances=radiances, $
                    extinction_tot = totext, $
                    extinction_du  = duext, $
                    extinction_su  = suext, $
                    extinction_ss  = ssext, $
                    extinction_oc  = ocext, $
                    extinction_bc  = bcext

  datestr = strcompress(string(time[0],format='(i8)'),/rem)

  plotfile = 'glas_track.extinction.ps'

  nt = n_elements(time)

; Figure out the height arrays
  h  = transpose(h) / 1000.  ; km
  dz = transpose(dz) / 1000. ; km
    
    

; Transpose arrays to be (time,hght)
  totext = transpose(totext)
  duext = transpose(duext)
  bcext = transpose(bcext)
  ocext = transpose(ocext)
  suext = transpose(suext)
  ssext = transpose(ssext)

; Put time into hour of day
  time = (time - long(time))*24.

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color
  !p.font=0

    for i = 0, 5 do begin
     case i of
      0: begin
         extinction = totext
         tag = 'total'
         end
      1: begin
         extinction = duext
         tag = 'dust'
         end
      2: begin
         extinction = bcext
         tag = 'black carbon'
         end
      3: begin
         extinction = ocext
         tag = 'organic carbon'
         end
      4: begin
         extinction = suext
         tag = 'sulfate'
         end
      5: begin
         extinction = ssext
         tag = 'sea salt'
         end
     endcase
 

    position = [.15,.2,.95,.9]
    a = where(time lt time[0])
    if(a[0] ne -1) then time[a] = time[a]+24.
    plot, indgen(n_elements(time)), /nodata, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle='altitude [km]', $
     position=position, $
     title = 'GEOS-5 '+tag+' aerosol extinction profile [km-1]!C'+ $
             'along GLAS track '+datestr, $
             charsize=.75
    loadct, 39
    levelarray = 10.^(-3.+findgen(60)*(alog10(2.56)-alog10(.01))/60.)

    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, h, time[1]-time[0], dz
    labelarray = strarr(60)
    labels = [.01, .02, .04, .08, .16, .32, .64, 1.28]/10
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(f5.3)')
    endfor
    makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
     label=labelarray, $
     align=.5, /no

    endfor

     loadct, 0
     map_set
     map_continents, thick=.5
     oplot, lon, lat, thick=6
 


    device, /close


end
