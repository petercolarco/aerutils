; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = 'cR_qfed21_2_3'
  expid = 'dR_qfed21_2_3'
  expid = 'e540_fp'
  satid = 'MISR'
  nymd = '20090515'
  nymd = '20100715'
  nhms = '120000'
  geolimits = [-90,-180,90,180]
  geolimits = [-10,30,60,140]
  geolimits = [-60,-180,80,180]
  varwant = [ 'du001', 'du002', 'du003', 'du004', 'du005', $
              'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
              'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'SO4' ]
  varwant = [ 'duexttau','ssexttau','ocexttau','bcexttau','suexttau']

  filetemplate = '/misc/prc11/colarco/'+expid+'/tavg2d_ext_x/Y%y4/M%m2/'+ $
                 expid+'.tavg2d_ext_x.'+satid+'_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  filetemplate = '/misc/prc11/colarco/'+expid+'/tavg2d_aer_x/Y%y4/M%m2/'+ $
                 expid+'.tavg2d_aer_x.'+satid+'_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  filetemplate = '/misc/prc11/dao_ops/'+expid+'/das/Y%y4/M%m2/'+ $
                 expid+'.inst1_2d_hwl_Nx.'+satid+'_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, aotsat, /sum, lon=lon, lat=lat, lev=lev

; Now average results together
  a = where(aotsat gt 1.e14)
  aotsat[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

  set_plot, 'ps'
  yyyymm = string(nymd/100L,format='(i6)')
  device, file='./output/plots/'+expid+'_'+satId+'.aodtau550.'+yyyymm+'.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   titlestr = 'GEOS-5 (MISR sampled) AOT [550 nm] ('+yyyymm+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
