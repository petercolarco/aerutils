; Colarco
; Stitch together a number of dates
; Read the Kanpur MPLNET data
  filename = '/misc/prc10/MPLNET/mplnet-15a_grid_extinction_2009_v2.cdf'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'height')
  ncdf_varget, cdfid, id, height
  id = ncdf_varid(cdfid,'sites')
  ncdf_varget, cdfid, id, sites
  id = ncdf_varid(cdfid,'grid_extinction')
  ncdf_varget, cdfid, id, extinction
  ncdf_close, cdfid
; Kanpur is site 4
  extinction = transpose(extinction[*,*,4])
  height = height[*,4]

  a = where(time ge 151.5 and time le 213.)
  time = time[a]
  extinction = extinction[a,*]

    set_plot, 'ps'
    device, file='mplnet.kanpur.extinction.ps', /helvetica, font_size=14, /color, $
     xoff=0.5, yoff=.05, xsize=20, ysize=12
    !p.font=0

    position = [.15,.2,.95,.9]

    plot, indgen(n_elements(time)), /nodata, $
     xrange=[151.5,213], xtitle='Day of Year', xstyle=1, $
     yrange=[0,20], ytitle='altitude [km]', $
     position=position, $
     title = 'MPLNET aerosol extinction profile [km-1]!C'+ $
             'at Kanpur', $
             charsize=.75
    loadct, 39
    levelarray = 10.^(-3.+findgen(60)*(alog10(10.)-alog10(.01))/60.)
;    levelarray = findgen(60)*.05

    colorarray = findgen(60)*4+16
    plotgrid, extinction, levelarray, colorarray, $
              time, height, time[1]-time[0], .075
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

    device, /close


end
