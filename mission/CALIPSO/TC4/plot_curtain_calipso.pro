; Pick a month
  mm = '07'

; Get the trackfiles
;  trackfiles = file_search('../output/data/e530_yotc_01.calipso.2009'+mm+'01.nc')
  trackfiles = file_search('../output/data/tc4.calipso.20070712.nc')
  nfiles = n_elements(trackfiles)

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin

    inpfile = trackfiles[ifiles]
    aircraft = strmid(inpfile,6,3)

;   Get the variables
    cdfid = ncdf_open(inpfile)
     id = ncdf_varid(cdfid,'longitude')
     ncdf_varget, cdfid, id, lon
     id = ncdf_varid(cdfid,'latitude')
     ncdf_varget, cdfid, id, lat
     id = ncdf_varid(cdfid,'time')
     ncdf_varget, cdfid, id, time
     id = ncdf_varid(cdfid,'ps')
     ncdf_varget, cdfid, id, ps
     id = ncdf_varid(cdfid,'totext')
     ncdf_varget, cdfid, id, totext
     id = ncdf_varid(cdfid,'duext')
     ncdf_varget, cdfid, id, duext
     id = ncdf_varid(cdfid,'bcext')
     ncdf_varget, cdfid, id, bcext
     id = ncdf_varid(cdfid,'ocext')
     ncdf_varget, cdfid, id, ocext
     id = ncdf_varid(cdfid,'suext')
     ncdf_varget, cdfid, id, suext
     id = ncdf_varid(cdfid,'ssext')
     ncdf_varget, cdfid, id, ssext
     id = ncdf_varid(cdfid,'phis')
     ncdf_varget, cdfid, id, hsurf
     id = ncdf_varid(cdfid,'delp')
     ncdf_varget, cdfid, id, delp
     id = ncdf_varid(cdfid,'AIRDENS')
     ncdf_varget, cdfid, id, airdens
    ncdf_close, cdfid

    datestr = strcompress(string(time[0],format='(i8)'),/rem)

    plotfile = inpfile+'.extinction.ps'

    nt = n_elements(time)

;   Figure out the height arrays
    dz = transpose(delp/9.8/airdens)
    nz = 72
    h  = fltarr(nt, nz)
    h[*,nz-1] = hsurf + dz[*,nz-1]/2.
    for iz = nz-2,0,-1 do begin
     h[*,iz] = h[*,iz+1] + .5*(dz[*,iz+1]+dz[*,iz])
    endfor
    h = h / 1000. ; km
    dz = dz/1000. ; km
    
    

;   Transpose arrays to be (time,hght)
    totext = transpose(totext)
    duext = transpose(duext)
    bcext = transpose(bcext)
    ocext = transpose(ocext)
    suext = transpose(suext)
    ssext = transpose(ssext)

;   Put time into hour of day
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
             'along CALIPSO track '+datestr, $
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
 
    endfor

    device, /close

  endfor


end
