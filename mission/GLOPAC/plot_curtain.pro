; Given a curtain file, plot variable

  pro plot_curtain, inpfile, varname

  varnamesh = strmid(varname,0,2)
  get1d = 0
  scalefac = 1.
  case varnamesh of
   'o3' : begin
          levelarray = findgen(60)*.1
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
       end
   'ep':  begin
          levelarray = findgen(60)*.1 + 1
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(f4.2)')
          labelarray[1:58] = ''
          scalefac = 1.e5
       end
   'co' : begin
          levelarray = findgen(60)*3 + 4
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
       end
   'cf' : begin
          levelarray = findgen(60)*6.5 + 200
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
       end
   'du' : begin
          levelarray = findgen(60)*.5
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
          get1d = 1
          varname1d = 'duexttau'
          yrange=[0,.5]
       end
   'so' : begin
          levelarray = findgen(60)*.05
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
          get1d = 1
          varname1d = 'suexttau'
          yrange=[0,.5]
       end
   'ss' : begin
          levelarray = findgen(60)*.2
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(i3)')
          labelarray[1:58] = ''
          get1d = 1
          varname1d = 'ssexttau'
          yrange=[0,.2]
       end
   'bc' : begin
          levelarray = findgen(60)*.0025
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(f6.4)')
          labelarray[1:58] = ''
          get1d = 1
          varname1d = 'bcexttau'
          yrange=[0,.05]
       end
   'oc' : begin
          levelarray = findgen(60)*.01
          colorarray = findgen(60)*4+16
          labelarray = string(levelarray,format='(f6.4)')
          labelarray[1:58] = ''
          get1d = 1
          varname1d = 'ocexttau'
          yrange=[0,.1]
       end
  endcase
  plotfile = './output/plots/'+inpfile+'.'+varname+'.ps'


;   Get the variables
    cdfid = ncdf_open('./output/data/'+inpfile)
     id = ncdf_varid(cdfid,'longitude')
     ncdf_varget, cdfid, id, lon
     id = ncdf_varid(cdfid,'latitude')
     ncdf_varget, cdfid, id, lat
     id = ncdf_varid(cdfid,'time')
     ncdf_varget, cdfid, id, time
     id = ncdf_varid(cdfid,'pressure')
     ncdf_varget, cdfid, id, lev
     id = ncdf_varid(cdfid,'altitude')
     ncdf_varget, cdfid, id, altitude
     id = ncdf_varid(cdfid,varname)
     ncdf_varget, cdfid, id, varval
     varval = varval*scalefac
     ncdf_attget, cdfid, id, 'long_name', long_name
     ncdf_attget, cdfid, id, 'units', units
     if(get1d) then begin
      id = ncdf_varid(cdfid,varname1d)
      ncdf_varget, cdfid, id, varval1d
      a = where(varval1d gt 1e9)
      if(a[0] ne -1) then varval1d[a] = !values.f_nan
      ncdf_attget, cdfid, id, 'long_name', long_name1d
      ncdf_attget, cdfid, id, 'units', units1d
      long_name1d = string(long_name1d)
      units1d = string(units1d)
     endif

    ncdf_close, cdfid

;   Altitudes
    nz = n_elements(lev)
    z  = fltarr(nz)
    dz = fltarr(nz)
    dz[0:nz-2] = lev[0:nz-2]-lev[1:nz-1]
    dz[nz-1] = lev[nz-1]
    z = lev-dz/2.
  
;   Go from aircraft altitude [km] to pressure [hPa]
    altpres, altitude, altprs, dens, temp, 0.

    long_name = string(long_name)
    units = string(units)
    datestr = string(time[0],format='(i8)')

;   Transpose arrays to be (time,hght)
    nt = n_elements(time)
    varval = transpose(varval)
    a = where(varval gt 1e14)
    if(a[0] ne -1) then varval[a] = !values.f_nan

;   Put time into hour of day
    time = (time - long(time[0]))*24.
    dtime = dblarr(nt)
    dtime[0:nt-2] = time[1:nt-1]-time[0:nt-2]
    dtime[nt-1] = dtime[nt-2]

    set_plot, 'ps'
    device, file=plotfile, /helvetica, font_size=14, /color
    !p.font=0

    position = [.15,.2,.9,.9]
    a = where(time lt time[0])
    if(a[0] ne -1) then time[a] = time[a]+24.
    plot, indgen(n_elements(time)), /nodata, $
     xrange=[time[0],time[nt-1]], xstyle=1, $
     yrange=[1000,10], /ylog, ystyle=9, $
     position=position, charsize=.75
    loadct, 39

    plotgrid, varval, levelarray, colorarray, $
              time, z, dtime, dz, undef=!values.f_nan, /map

    plot, indgen(n_elements(time)), /nodata, /noerase,  $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[1000,10], ytitle='pressure [hPa]', /ylog, ystyle=9, $
     position=position, $
     title = long_name+' ['+units+']!C'+ $
             'GEOS-5 model along Global Hawk track '+datestr, $
             charsize=.75

    oplot, time, altprs, thick=12

;    x = time[110]
;    polyfill, [x-.5,x+.5,x,x-.5], [950,950,750,950], thick=12, color=255, /data, /fill
;    x = time[191]
;    polyfill, [x-.5,x+.5,x,x-.5], [950,950,750,950], thick=12, color=255, /data, /fill

    if(get1d) then begin
     axis, yaxis=1, yrange=yrange, ytitle=long_name1d, /save, ylog=0, charsize=.75
     oplot, time, varval1d, thick=12, color=255
    endif


    makekey, .15, .05, .75, .035, 0, -.035, color=colorarray, $
     label=labelarray, $
     align=.5, /no

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
 
    device, /close

end
