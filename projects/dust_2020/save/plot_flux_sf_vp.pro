tavg_file = 'merra2.tavg2d_aer_Nx.400.ctl'


mons_ = ['06']
days_ = ['10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30']
hours_ = ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
;hours_ = ['01','04','07','10','13','16','19','22']

nd = n_elements(days_)
nh = n_elements(hours_)

  ga_times, tavg_file, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

for iday=0, nd-1 do begin
   for ih=0, nh-1 do begin

      a = where(strmid(string(nymd),4,4) eq mons_[0]+days_[iday] and $
                strmid(string(nhms),0,2) eq hours_[ih])

      ;first plot vertically integrated 2-d fluxu & fluxv
      ;merra2
      nc4readvar, filename[a], 'dufluxu', dufluxu_, lat=lat, lon=lon, time=time
      ;nc4readvar, tavg_file, 'dufluxv', dufluxv_, wantlon=[-180,180], wantlat=[-90,90], lat=lat, lon=lon, wantnymd=['202006'+days_[iday]], wantnhms=[hours_[ih]+'0000'], time=time

      stop
      
      sf_ = streamfcn(dufluxu_, dufluxv_, lat=lat, lon=lon, velocp=velocp_)
      sf_ = sf_[*,1:359]
      velocp_ = velocp_[*,1:359]
  
      lat_ = lat[1:359]
      lon_ = lon
  
      ;get flow derivatives
      dux_ = deriv_array(velocp_,0)  
      dvy_ = deriv_array(velocp_,1)  
      duy_ = -deriv_array(sf_,1)  
      dvx_ = deriv_array(sf_,0)  

      lats = [-10,50]
      lons = [-90,50]
  
      a = where((lat ge lats[0]) and (lat le lats[1]))
      b = where((lon ge lons[0]) and (lon le lons[1]))
      na = n_elements(a)
      nb = n_elements(b)
  
      lat_ = lat[a[0]:a[na-1]]
      lon_ = lon[b[0]:b[nb-1]]

      set_plot, 'ps'
      device, filename='../plots/MERRA2.VP.202006'+days_[iday]+hours_[ih]+'.ps', /color, /helvetica, font_size=14
      loadct, 39
      !P.font=0
      map_set,/continents,/grid,limit=[lats[0],lons[0],lats[1],lons[1]], position=[0.1,0.15,0.9,0.85], noerase=1
      map_grid, /box_axes
      levels = [-5000,-2000,-1000,-500,-200,200,500,1000,2000]
      labels = ['-5000','-2000','-1000','-500','-200','200','500','1000','2000'] 
      colors =  [40,58,72,88,255,199,207,223,254]
      plotgrid, velocp_[b[0]:b[nb-1],a[0]:a[na-1]], levels, colors, lon_, lat_, .625, .5
      velovect, dux_[b[0]:b[nb-1]:5,a[0]:a[na-1]:5], dvy_[b[0]:b[nb-1]:5,a[0]:a[na-1]:5], lon[b[0]:b[nb-1]:5], lat[a[0]:a[na-1]:5], /overplot, length=4
      makekey, 0.10, .05, .8, .03, 0, -.03, color=colors, label=labels, thick=3 
      map_continents, thick=3
      length = 4.
      maxmag = 60.
      plots, [30., 30.+length], [60.5,60.5], thick=5
      plots, [30.+length, 29.5+length], [55.5,55.3], thick=5
      plots, [30.+length, 29.5+length], [55.5,55.7], thick=5
      xyouts, 31.+length, 55.3, strtrim(string(maxmag/10000., format='(f7.3)'),1)
      xyouts, .4, .92, '2020-06-'+days_[iday]+'T'+hours_[ih]+':30:00', /normal
      device,/close 

      set_plot, 'ps'
      device, filename='../plots/MERRA2.SF.202006'+days_[iday]+hours_[ih]+'.ps', /color, /helvetica, font_size=14
      loadct, 39
      !P.font=0
      map_set,/continents,/grid,limit=[lats[0],lons[0],lats[1],lons[1]], position=[0.1,0.15,0.9,0.85], noerase=1
      map_grid, /box_axes
      levels = [-5000,-2000,-1000,-500,-200,200,500,1000,2000]
      labels = ['-5000','-2000','-1000','-500','-200','200','500','1000','2000'] 
      colors =  [40,58,72,88,255,199,207,223,254]
      ;levels = [-10000, -5000,-2000,-1000,-500,0,500,1000,2000,5000]
      ;labels = ['-10000','-5000','-2000','-1000','-500','500','1000','2000','5000'] 
                                ;colors =  [40,58,72,88,255,199,207,223,254]
      
      plotgrid, sf_[b[0]:b[nb-1],a[0]:a[na-1]], levels, colors, lon_, lat_, .625, .5
      velovect, duy_[b[0]:b[nb-1]:5,a[0]:a[na-1]:5], dvx_[b[0]:b[nb-1]:5,a[0]:a[na-1]:5], lon[b[0]:b[nb-1]:5], lat[a[0]:a[na-1]:5], /overplot, length=4
      makekey, 0.10, .05, .8, .03, 0, -.03, color=colors, label=labels, thick=3 
      map_continents, thick=3
      length = 4.
      maxmag = 250.
      plots, [30., 30.+length], [60.5,60.5], thick=5
      plots, [30.+length, 29.5+length], [55.5,55.3], thick=5
      plots, [30.+length, 29.5+length], [55.5,55.7], thick=5
      xyouts, 31.+length, 55.3, strtrim(string(maxmag/10000., format='(f7.3)'),1)
      xyouts, .4, .92, '2020-06-'+days_[iday]+'T'+hours_[ih]+':30:00', /normal
      device,/close


   endfor
endfor


end
