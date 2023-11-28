; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_merraero_all_diff.ps', /color, /helvetica, font_size=12, $
          xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.02+iplot*.33,.5,.02+iplot*.33+.3,1]
  endfor
  for iplot = 3, 5 do begin
   position[*,iplot] = [.02+(iplot-3)*.33,0.07,.02+(iplot-3)*.33+.3,.57]
  endfor

  expid = ['c48R_G41_acma_merra2_noq','c48R_G41_acma_merra2_reg_noq','c48R_G41_acma_noq', $
           'c48R_G41_acma_merra2','c48R_G41_acma_merra2_reg','c48R_G41_acma']
  title = expid


  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  loadct, 0
;  makekey, .25, .07, .5, .03, 0, -.04, align=0, charsize=1, $
;           color=make_array(7,val=0), label=['0.01','0.05','0.1','0.2','0.3','0.5','0.7']

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.01,.05,.1,.2,.3,.5,.7]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

;  makekey, .25, .07, .5, .03, 0, -.02, /noborder, $
;     color=dcolors, label=['','','','','','','','','']

; Get MERRAero
  datafil = '/misc/prc15/colarco/dR_MERRA-AA-r2/tavg2d_aer_x/dR_MERRA-AA-r2.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, 'totexttau', tau_base, lon=lon, lat=lat, lev=lev

; Difference Plot
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.7, $
           color=make_array(11,val=0), label=[' ','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,255,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-.2,-.1,-0.05,-0.02,-.01,.01,0.02,0.05,.1,.2]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1
  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']


  for iplot = 0, 5 do begin
   expid_ = expid[iplot]
   datafil = '/misc/prc14/colarco/'+expid_+'/tavg2d_aer_x/'+expid_+'.tavg2d_aer_x.monthly.clim.ANN.nc4'
   nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
   a = where(lat gt 90 or lat lt -90)
   tau[*,a] = !values.f_nan
   tau[where(tau gt 1e14)] = !values.f_nan
   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]
   title_ = title[iplot]
   plot_map, tau-tau_base, lon, lat, dx, dy, levels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title_
  endfor

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2

  device, /close

end
