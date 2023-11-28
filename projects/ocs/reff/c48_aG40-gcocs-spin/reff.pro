  dtitle= '201212'
  expid = 'c48_aG40-gcocs-spin'
  filedir  = '/misc/prc14/colarco/'+expid+'/'
  filename = expid+'.tavg3d_carma_v.monthly.'+dtitle+'.nc4'
; set up size bins
  nbin = 22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow;, masspart
  rhop = 1923.  ; kg m-3


; Get the file
  nc4readvar, filedir+filename, 'su0', su, /template
;  nc4readvar, filedir+filename, 'pso4g', pso4g
;  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat

; Zonal mean
  su      = reform(total(su,1))/144.

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  z = z/1000.
  delz = delz/1000.

  reff    = fltarr(91,72)
  for iy = 0, 90 do begin
   for iz = 0, 71 do begin
    dndr = su[iy,iz,*]/dr / (4./3.*rhop*r^3.)
    reff[iy,iz] = total(r^3.*dndr*dr) / total(r^2.*dndr*dr)
;if(iy eq 45 and iz eq 26) then stop
   endfor
  endfor

  reff = reff*1e6  ; effective radius in um
  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='reff.'+dtitle+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.93], $
        xtitle='latitude', ytitle='Altitude [km]', $
        title='Effective radius [!9m!3m], mmr [!9m!3g kg!E-1!N]', $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9
  loadct, 56
  levels = [.05,.1,.15,.2,.25,.3,.4,.5,.7]
  plotgrid, reff, levels, colors, lat, z, 2., delz
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.93], $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9


  xyouts, .15, .11, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .05, .8, .05, 0., -.035, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .05, .8, .05, 0., -.035, align=0, $
           color=colors, labels=make_array(9,val='')


; Overplot the zonal mean SU mixing ratio
  loadct, 0
  su = total(su,3)*1e9 ; ug kg-1
  contour, su, lat, z, levels=findgen(10)*.2,/over, color=80, c_label=indgen(10)

  xyouts, .15, .2, dtitle, /normal

  device, /close

end
