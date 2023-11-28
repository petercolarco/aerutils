; Goal is to make some zonal, monthly plots to compare to OMPS LP ASI
; figures

; Start from monthly pressure level files from Valentina run
  expid = 'G41prcR2010'
  filetemplate = expid+'.tavg3d_aer_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd gt 20120000L)
  filename = filename[a]
  nymd = nymd[a]
  nhms = nhms[a]

; Get the atmosphere profile
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Get a variable
  varwant = 'ocs_jrate'
  nc4readvar, filename, varwant, su, lon=lon, lat=lat, lev=lev
  a = where(su gt 1e14)
  su[a] = !values.f_nan
; zonal mean
  su = mean(su,dimension=1,/nan)

; Interpolate lev to a height
  zu = z/1000.

; Colors
  red   = [0, 246,208,166,103,54,2,1]
  blue  = [0, 239,209,189,169,144,129]
  green = [0, 247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1
  levels = findgen(7)*50+50

; latitudinal
  for iy = 0, 17 do begin

    latmin = -90 +iy*10
    a   = where(lat ge latmin and lat lt latmin+10)
    sup = transpose(mean(su[a,*,*],dimension=1,/nan))

;   Now make a plot
    set_plot, 'ps'
    device, file='ocs_jrate.latmin='+strcompress(string(latmin),/rem)+'.ps', $
      xsize=16, ysize=12, xoff=.6, yoff=.5, /color, /helvetica, font_size=10
    !p.font=0

    x = 2012+findgen(n_elements(filename))/12.
    contour, sup*1e9, x, zu, /cell, $
     xrange=[2012,2015.25], $
     yrange=[0,40], ytitle='Altitude [km]', levels=levels, c_colors=dcolors, $
     title='j!DOCS!N [s!E-1!N], ' $
           +string(latmin,format='(i3)')+'< Lat > '+string(latmin+10,format='(i3)'), $
     position=[.1,.25,.95,.9], xticks=3, xtickv=[2012,2013,2014,2015]
    makekey, .1, .12, .85, .05, 0, -.035, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(i2)')
    makekey, .1, .12, .85, .05, 0, -.035, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

    device, /close

  endfor


end

