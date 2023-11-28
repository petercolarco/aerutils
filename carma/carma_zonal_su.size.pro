; set up size bins
  nbin = 42
  rmrat = 1.9988272
  rmin = 2.2891d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow, masspart
  rhop = 1923.  ; kg m-3

  expid = 'bF_F25b27-pin_testvf'
  yyyy = '1991'
  mm = '11'
  mon = [' ','January','February','March','April','May','June','July', $
         'August','September','October','November','December']
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+yyyy+mm+'.nc4'

; First time
  nc4readvar, filedir+filename, 'su0', su, /template
  nc4readvar, filedir+filename, 'pso4gvolc', pso4g
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat

; Zonal mean
  su      = reform(total(su,1))/144.
  delp    = reform(total(delp,1))/144.
  rhoa    = reform(total(rhoa,1))/144.
  ps      = reform(total(ps,1))/144.
  pso4g   = reform(total(pso4g,1))/144.

  zl = fltarr(91, 73)
  zl[*,0] = 1.
  for iz = 1, 71 do begin
   zl[*,iz] = zl[*,iz-1]+delp[*,iz-1]
  endfor
  zl[*,72] = ps
  z = fltarr(91,72)
  z = zl[*,0:71] + 0.5*delp
  z = z / 100.
  dz = delp/100.

  reff    = fltarr(91,72)
  for iy = 0, 90 do begin
   for iz = 0, 71 do begin
    dndr = su[iy,iz,*]/dr / (4./3.*rhop*r^3.)
    reff[iy,iz] = total(r^3.*dndr*dr) / total(r^2.*dndr*dr)
   endfor
  endfor
  reff = reff*1e6  ; effective radius in um

  loadct, 39
  levels = findgen(10)*.1+.1
  colors = 254. - findgen(10)*25
  set_plot, 'ps'
  device, file='reff.'+filename+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.93], $
        xtitle='latitude', ytitle='pressure [hPa]', $
        title=mon[mm]+' '+yyyy+' Effective radius [!9m!3m], mmr [!9m!3g kg!E-1!N]', $
        xrange=[-90,90], yrange=[1000,1], /ylog, xstyle=9, ystyle=9
  plotgrid, reff, levels, colors, lat, z, 2., dz

  contour, /overplot, total(su,3)*1e9, lat, z, $
           levels=[1,2,5,10,20,50,100,150,200,250,300,400,500], $
           c_label=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

;  contour, /overplot, pso4g*86400.*30.*1e9, lat, z, $
;           levels=[1,2,5,10,20,50,100,150,200,250,300,350,400], $
;           c_label=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], $
;           thick=3, c_lin=2


  xyouts, .15, .11, 'Effective Radius [!9m!3m]', /normal
  makekey, .15, .05, .8, .05, 0., -.035, $
           color=colors, labels=string(levels,format='(f3.1)')

  device, /close

end
