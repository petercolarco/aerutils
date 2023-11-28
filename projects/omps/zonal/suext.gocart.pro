; Goal is to make some zonal, monthly plots to compare to OMPS LP ASI
; figures

; Start from monthly pressure level files from Valentina run
  expid = 'G41prcR2010'
  filetemplate = expid+'.tavg3d_aer_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd gt 20120000L)
  filename = filename[a]
  nymd = nymd[a]
  nhms = nhms[a]

; Get the atmosphere profile
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Get a variable
  nc4readvar, filename, ['suextcoefstrat','suextcoefvolc'], su, lon=lon, lat=lat, lev=lev, /sum
  a = where(su gt 1e14)
  su[a] = !values.f_nan
;  su = su*rhoa  ; concentration
; zonal mean
  su = mean(su,dimension=1,/nan)

; Interpolate lev to a height
  iz = interpol(indgen(n_elements(p)),p/100.,lev)
  zu = interpolate(z/1000.,iz)

; Colors
  red   = [0, 246,208,166,103,54,2,1]
  blue  = [0, 239,209,189,169,144,129]
  green = [0, 247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red)-1)+1
  levels = [1,5,10,20,30,40,60]/100.

; latitudinal
  for iy = 0, 17 do begin

    latmin = -90 +iy*10
    a   = where(lat ge latmin and lat lt latmin+10)
    sup = transpose(mean(su[a,*,*],dimension=1,/nan))

;   Now make a plot
    set_plot, 'ps'
    device, file='suext.gocart.latmin='+strcompress(string(latmin),/rem)+'.ps', $
      xsize=16, ysize=8, xoff=.5, yoff=.5, /color, /helvetica, font_size=11
    !p.font=0

    x = 2012+findgen(n_elements(filename))/12.
    contour, sup*1e6, x, zu, /cell, $
     xrange=[2012,2015], xminor=2, xstyle=9, ystyle=9, $
     yrange=[15,40], ytitle='Altitude [km]', levels=levels, c_colors=dcolors, $
     title='Sulfate Extinction (GOCART) [Mm!E-1!N], ' $
           +string(latmin,format='(i3)')+'< Lat > '+string(latmin+10,format='(i3)'), $
     position=[.15,.25,.95,.9], xticks=3, xtickv=[2012,2013,2014,2015]
    makekey, .15, .06, .8, .05, 0, -.05, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
    makekey, .15, .06, .8, .05, 0, -.05, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

    device, /close

  endfor


end

