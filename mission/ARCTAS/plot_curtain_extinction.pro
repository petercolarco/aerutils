; Track files location
  trackdir = '/home/liang/DATA/ARCTAS/merge/'
  trackfiles =            ['mrg60_dc8_20080401_R7_thru20080419.ict', $
                           'mrg60_dc8_20080618_R7_thru20080626.ict', $
                           'mrg60_dc8_20080629_R7_thru20080713.ict', $
                           'mrg60_p3b_20080331_R1_thru20080419.ict', $
                           'mrg60_p3b_20080622_R1_thru20080626.ict', $
                           'mrg60_p3b_20080628_R1_thru20080712.ict']
  nfiles = n_elements(trackfiles)

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
   read_dc8_track, trackdir+ trackfiles[ifiles], lon, lat, alt, date, flights
   aircraft = strmid(trackfiles[ifiles],6,3)

;  Possibly the file contains multiple flights, so loop over individual flights
   flightnums = flights[uniq(flights)]
   nflights = n_elements(flightnums)
   for iflights = 0, nflights-1 do begin
    a = where(flights eq flightnums[iflights])
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    inpfile = 'd5_arctas_02.'+aircraft+'.'+datestr+'.nc'
    plotfile = './output/plots/'+inpfile+'.ps'

;   Get the variables
    cdfid = ncdf_open('./output/data/'+inpfile)
     id = ncdf_varid(cdfid,'longitude')
     ncdf_varget, cdfid, id, lon
     id = ncdf_varid(cdfid,'latitude')
     ncdf_varget, cdfid, id, lat
     id = ncdf_varid(cdfid,'time')
     ncdf_varget, cdfid, id, time
     id = ncdf_varid(cdfid,'totext')
     ncdf_varget, cdfid, id, extinction
     id = ncdf_varid(cdfid,'HGHT')
     ncdf_varget, cdfid, id, h
    ncdf_close, cdfid


;   Transpose arrays to be (time,hght)
    nt = n_elements(time)
    extinction = transpose(extinction)
    h = transpose(h) / 1000.  ; km
    dz_ = h[*,0:70]-h[*,1:71]
    dz = fltarr(nt,72)
    dz[*,0:70] = dz_
    dz[*,71]   = dz_[*,70]

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
     title = 'GEOS-5 extinction profile [km-1, 532 nm]!C'+ $
             'along '+strupcase(aircraft)+' track '+datestr, $
             charsize=.75
    loadct, 39
    levelarray = 10.^(-3.+findgen(60)*(alog10(.45)-alog10(.01))/60.)
    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, h, time[1]-time[0], dz
    labelarray = strarr(60)
    labels = [.01, .02, .04, .08, .16, .32]/10
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(f5.3)')
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
     map_set, /noerase, position=[x0,y0,x1,y1], limit=[30,-180,80,-80]
     map_continents, thick=.5
     oplot, lon, lat, thick=6
 
    device, /close

   endfor
  endfor


end
