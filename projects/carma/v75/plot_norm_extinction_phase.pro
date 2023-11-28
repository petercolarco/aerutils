; Plot the extinction profile as a function of QBO phase

; First, pull the winds and compute the phase
  expid = 'c90F_pI33p4_ocs'
  filetemplate = expid+'.geosgcm_prog.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'u', u, lon=lon, lat=lat, lev=lev, wantlev=[30], wantlat=[-2,2]

; zonal mean and transpose
  u = reform(transpose(total(total(u,1)/n_elements(lon),1)/n_elements(lat)))

; Now select on westerly versus easterly phase
  westerly = make_array(n_elements(u),val=0)
  a = where(u gt 5)
  westerly[a] = 1
  a = where(u lt -5)
  westerly[a] = -1
; Now read the extinction fields
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
; Get the westerly fields
  filenames = filename[where(westerly eq 1)]
  nc4readvar, filenames, 'suextcoef', suwest, lon=lon, lat=lat, lev=lev
  filenames = filename[where(westerly eq -1)]
  nc4readvar, filenames, 'suextcoef', sueast, lon=lon, lat=lat, lev=lev
; reset undef values
  suwest[where(suwest gt 1e14)] = !values.f_nan
  sueast[where(sueast gt 1e14)] = !values.f_nan
; zonal mean
  suwest = mean(suwest,dim=1,/nan)
  sueast = mean(sueast,dim=1,/nan)
; Temporal mean
  suwest = mean(suwest,dim=3,/nan)
  sueast = mean(sueast,dim=3,/nan)

; Normalize by pressure
  for iy = 0, n_elements(lat)-1 do begin
   suwest[iy,*] = suwest[iy,*]/lev
   sueast[iy,*] = sueast[iy,*]/lev
endfor

; Get atmosphere for a vertical altitude coordinate
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Interpolate lev to a height
  iz = interpol(indgen(n_elements(p)),p/100.,lev)
  zu = interpolate(z/1000.,iz)


; Now make a plot
  set_plot, 'ps'
  device, file='plot_norm_extinction_phase.westerly.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

;  red   = [0, 246,208,166,103,54,2,1]
;  blue  = [0, 239,209,189,169,144,129]
;  green = [0, 247,230,219,207,192,138,80]
;  tvlct, red, green, blue
;  dcolors=indgen(n_elements(red)-1)+1
;  levels = [1,5,10,20,30,40,60]/100.

  loadct, 52
  levels = findgen(11)*.04
  dcolors = indgen(11)*25

  contour, suwest, lat, zu, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=1, yrange=[15,35], ytitle = ' '

  contour, suwest*1e8, lat, zu, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, suwest, lat, zu, /nodata, /noerase, $
   title = 'Normalized Sulfate Extinction Coefficient [Mm!E-1!N hPa!E-1!N], westerly QBO phase', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=1, yrange=[15,35], ytitle = 'Altitude [km]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
  loadct, 52
  makekey, .1, .05, .8, .04, 0, -.04, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close



; Now make a plot
  set_plot, 'ps'
  device, file='plot_norm_extinction_phase.easterly.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

;  red   = [0, 246,208,166,103,54,2,1]
;  blue  = [0, 239,209,189,169,144,129]
;  green = [0, 247,230,219,207,192,138,80]
;  tvlct, red, green, blue
;  dcolors=indgen(n_elements(red)-1)+1
;  levels = [1,5,10,20,30,40,60]/100.


  contour, sueast, lat, zu, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=1, yrange=[15,35], ytitle = ' '

  contour, sueast*1e8, lat, zu, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, sueast, lat, zu, /nodata, /noerase, $
   title = 'Normalized Sulfate Extinction Coefficient [Mm!E-1!N hPa!E-1!N], easterly QBO phase', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=1, yrange=[15,35], ytitle = 'Altitude [km]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
  loadct, 52
  makekey, .1, .05, .8, .04, 0, -.04, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close

end

