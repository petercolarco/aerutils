; Colarco
; Stitch together a number of dates
  files = file_search('./output/data/dR_Fortuna-2-4-b4.kanpur_532nm*nc')
  pblh = 1.
  totext = 1.
  cloud = 1.
  read_curtain, files, lon, lat, time, z0, z, dz, $
                pblh = pblh, $
                extinction_tot = totext, $
;                backscat_tot = totext, $
                cloud = cloud

    datestr = strcompress(string(time[0],format='(i8)'),/rem)

    plotfile = 'dR_Fortuna-2-4-b4.kanpur_532n.extinction.ps'

    nt = n_elements(time)
    nz = n_elements(z[0,*])
    z  = transpose(z) / 1000.  ; km
    dz = transpose(dz) / 1000. ; km

;   Transpose arrays to be (time,hght)
    totext = transpose(totext)
;    duext = transpose(duext)
;    bcext = transpose(bcext)
;    ocext = transpose(ocext)
;    suext = transpose(suext)
;    ssext = transpose(ssext)

;   Put time into fractional day of year
    yyyy = long(time)/10000L
    mm   = (long(time)-10000L*yyyy)/100L
    dd   = (long(time)-10000L*yyyy-100L*mm)
    jday = julday(mm,dd,yyyy,0,0,0) - julday(12,31,2008)
    time = jday + (time-long(time))

    set_plot, 'ps'
    device, file=plotfile, /helvetica, font_size=14, /color, $
     xoff=0.5, yoff=.05, xsize=20, ysize=12
    !p.font=0

    for i = 0, 0 do begin
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
     xrange=[time[0],time[nt-1]], xtitle='Day of Year', xstyle=1, $
     yrange=[0,20], ytitle='altitude [km]', $
     position=position, $
     title = 'GEOS-5 '+tag+' aerosol extinction profile [km-1]!C'+ $
;     title = 'GEOS-5 '+tag+' aerosol backscatter profile [km -1 sr-1]!C'+ $
             'at Kanpur '+datestr, $
             charsize=.75
    loadct, 39
    levelarray = 10.^(-3.+findgen(60)*(alog10(10.)-alog10(.01))/60.)
;    levelarray = findgen(60)*.05

    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, z, time[1]-time[0], dz
    oplot, time, pblh / 1000., thick=2
    labelarray = strarr(60)
    labels = [.01, .02, .04, .08, .16, .32, .64, 1.28, 2.56, 5.12]/10
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
    contour, transpose(cloud), time, z[0,*], lev=.3, /over, /cell, color=150, thick=6

;     loadct, 0
;     dxplot = position[2]-position[0]
;     dyplot = position[3]-position[1]
;     x0 = position[0]+.65*dxplot
;     x1 = position[0]+.95*dxplot
;     y0 = position[1]+.65*dyplot
;     y1 = position[1]+.95*dyplot
;     map_set, /noerase, position=[x0,y0,x1,y1], limit=[30,-180,80,-80]
;     map_continents, thick=.5
;     oplot, lon, lat, thick=6
 
    endfor

    device, /close


end
