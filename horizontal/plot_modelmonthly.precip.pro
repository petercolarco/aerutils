; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = 'R_qfed21_2_3'
  satid = 'MYD04'
  nymd = '20090515'
  nhms = '120000'
  geolimits = [-90,-180,90,180]
  geolimits = [4,65,30,95]
  varwant = [ 'cnprcp','lsprcp','anprcp']

  filetemplate = '/misc/prc11/colarco/'+expid+'/geosgcm_surf/Y%y4/'+ $
                 expid+'.geosgcm_surf.monthly.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, varval, /sum, lon=lon, lat=lat, lev=lev
  varval = varval*86400

  set_plot, 'ps'
  yyyymm = string(nymd/100L,format='(i6)')
  device, file='./output/plots/'+expid+'.precip.'+yyyymm+'.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 1
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   levelArray = findgen(11)*100.
   levelArray[0] = -1000.
   levelArray = findgen(11)*2.
   labelArray = strcompress(string(levelarray,format='(i2)'),/rem)
   labelArray[0] = '0'
   colorArray = 240 - findgen(11)*20

   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, varval, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   titlestr = 'GEOS-5 precipitation [mm day!E-1!N] ('+yyyymm+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

loadct, 39
usersym, 3.*[-1,0,1,0,-1],3.*[0,-1,0,1,0],color=208,/fill
plots, 75, 26, psym=8


   device, /close



end
