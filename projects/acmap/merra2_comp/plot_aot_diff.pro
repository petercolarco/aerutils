; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

  expid = 'c180R_H54p3-acma'
  datafil0 = '/misc/prc13/MERRA2/d5124_m2_jan00/Y2008/d5124_m2_jan00/tavg1_2d_aer_Nx/d5124_m2_jan00.tavg1_2d_aer_Nx.monthly.clim.ANN.nc4'
  datafil1 = '/misc/prc18/colarco/'+expid+'/tavg2d_aer_x/'+expid+'.tavg2d_aer_x.monthly.clim.ANN.nc4'

; Setup the plot
  set_plot, 'ps'
  device, file='plot_aot_diff.'+expid+'.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.02+iplot*.33,.5,.02+iplot*.33+.3,1]
  endfor
  for iplot = 3, 5 do begin
   position[*,iplot] = [.02+(iplot-3)*.33,0.07,.02+(iplot-3)*.33+.3,.57]
  endfor
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.01,.02,.04,.07,.1,.2,.4]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  titles   = ['Total AOD', $
              'Dust', $
              'Sea Salt', $
              'POM', $
              'Sulfate', $ 
              'Nitrate']

  varwant = ['totexttau','duexttau','ssexttau','ocexttau','suexttau','niexttau']



; DIFFERENCE PLOT
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), label=[' ','-0.1','-0.05','-0.03','-0.02','-0.01','0.01','0.02','0.03','0.05','0.1']
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,191,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','','','']

  for iplot = 0, 5 do begin

   nc4readvar, datafil0, varwant[iplot], duem0, lon=lon, lat=lat, lev=lev, /sum
   nc4readvar, datafil1, varwant[iplot], duem1, lon=lon, lat=lat, lev=lev, /sum
   area, lon, lat, nx, ny, dx, dy, area
   title = titles[iplot]
   duem = duem1-duem0
   if(iplot eq 5) then duem = duem1
   plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format='(f7.4)'
  endfor

  device, /close

end
