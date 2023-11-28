; set up size bins
  nbin = 42
  rmrat = 1.9988272
  rmin = 2.2891d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow, masspart
  rhop = 1923.  ; kg m-3

  expid = 'bFc_F25b27-pin_carma'
  yyyy = '1991'
  mm = '08'
  mon = [' ','January','February','March','April','May','June','July', $
         'August','September','October','November','December']
  filedir = '/Volumes/bender/prc14/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+yyyy+mm+'.nc4'

; First time
  nc4readvar, filedir+filename, 'sunuc', sunuc
  nc4readvar, filedir+filename, 'pso4gvolc', pso4g
  nc4readvar, filedir+filename, 'h2so4', h2so4
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat

; Zonal mean
  sunuc   = reform(total(sunuc,1))/144.
  h2so4   = reform(total(h2so4,1))/144.
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

  loadct, 39
  levels = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]
  levels = [1,10,100,1000,10000,1.e5,1.e6,1.e7,1.e8,1.e9]
  colors = 254. - findgen(10)*25
  set_plot, 'ps'
  device, file='sunuc.'+filename+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.93], $
        xtitle='latitude', ytitle='pressure [hPa]', $
        title=mon[mm]+' '+yyyy+' Nucleation Rate, pH!D2!NSO!D4!N [!9m!3g kg!E-1!N]', $
        xrange=[-90,90], yrange=[1000,1], /ylog, xstyle=9, ystyle=9
  plotgrid, sunuc, levels, colors, lat, z, 2., dz

;  contour, /overplot, total(su,3)*1e9, lat, z, $
;           levels=[1,2,5,10,20,50,100,150,200,250,300,400,500], $
;           c_label=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

  contour, /overplot, pso4g*86400.*30.*1e9, lat, z, $
;  contour, /overplot, h2so4*1e12, lat, z, $
           levels=[1,2,5,10,20,50,100,200,500], $
           c_label=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], $
           thick=3, c_lin=2


  xyouts, .15, .11, 'log!D10!N (Nucleation Rate [m!E-3!N s!E-1!N])', /normal
  makekey, .15, .05, .8, .05, 0., -.035, $
           color=colors, labels=string(alog10(levels),format='(i2)')

  device, /close

end
