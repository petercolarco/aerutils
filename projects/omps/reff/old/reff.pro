  dtitle= '20140227'
  expid = 'G41prcR2010'
  filedir  = '/misc/prc14/colarco/'+expid+'/'
  filename = expid+'.tavg3d_carma_v.'+dtitle+'_0900z.nc4'
print, filedir+filename
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
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat

; Zonal mean
  su      = reform(total(su,1))/144.
  rhoa    = reform(total(rhoa,1))/144.

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

  reff    = fltarr(91,72)
  for iy = 0, 90 do begin
   for iz = 0, 71 do begin
    dndr = su[iy,iz,*]/dr / (4./3.*rhop*r^3.)*rhoa[iy,iz]
    reff[iy,iz] = total(r^3.*dndr*dr) / total(r^2.*dndr*dr)
;if(iy eq 45 and iz eq 26) then stop
   endfor
  endfor
  su = total(su,3)*1e9 ; ug kg-1

  reff = reff*1e6  ; effective radius in um

; Screen reff where SU < 0.01 ug kg-1
  a = where(su lt .01)
  reff[a] = -999.

  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='reff.'+expid+'.'+dtitle+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        title='Effective radius [!9m!3m], mmr [!9m!3g kg!E-1!N]', $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90
  loadct, 56
  levels = [.05,.1,.15,.2,.25,.3,.4,.5,.7]
  levels = [0.025,0.05,0.075,0.1,0.125,0.15,0.175,0.2,0.25]
  plotgrid, reff, levels, colors, lat, z, 2., delz
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*30-90


  xyouts, .15, .12, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.3)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')


; Overplot the zonal mean SU mixing ratio
  loadct, 0
  contour, su, lat, z, levels=findgen(10)*.2,/over, color=80, c_label=indgen(10)

;  xyouts, .15, .2, dtitle, /normal

  device, /close

end
