; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_misr_all_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=6, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.02+iplot*.33,.0,.02+iplot*.33+.3,1]
  endfor
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.01,.04,.08,.1,.2,.3,.4]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  datafils = ['/science/terra/misr/data/Level3/d/Y2007/MISR_L2.aero_tc8_F12_0022.noqawt.2007.nc4', $
              '/misc/prc14/colarco/c180R_H40_acma/tavg2d_aer_x/c180R_H40_acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48R_H40_acma/tavg2d_aer_x/c48R_H40_acma.tavg2d_aer_x.monthly.clim.ANN.nc4']


  titles   = ['MISR!U1/2!S!Eo!N', $
              'R!U1/2!S!Eo!N', $
              'R!U2!S!Eo!N' ]

; Baseline
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, 'aodtau', duem, lon=lon, lat=lat, lev=lev, /sum
  duem = duem[*,*,2]  ; 550 nm
  a = where(duem gt 1e14 or duem lt -1e14)
  duem[a] = !values.f_nan

  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)'
  loadct, 0
  makekey, .02, .1, .3, .06, 0, -.08, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.01','0.04','0.08','0.1','0.2','0.3','0.4']
  tvlct, red, green, blue
  makekey, .02, .1, .3, .06, 0, -.08, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; DIFFERENCE PLOT
  duem_base = duem
  loadct, 0
  makekey, .42, .1, .5, .06, 0, -.08, align=.5, charsize=.6, $
           color=make_array(11,val=0), label=[' ','-0.1','-0.05','-0.03','-0.02','-0.01','0.01','0.02','0.03','0.05','0.1']
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,191,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .42, .1, .5, .06, 0, -.06, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','','','']

; Get the b-resolution
  datafil = '/science/terra/misr/data/Level3/b/Y2007/MISR_L2.aero_tc8_F12_0022.noqawt.2007.nc4'
  nc4readvar, datafil, 'aodtau', duem_b, lon=lon, lat=lat, lev=lev, /sum
  duem_b = duem_b[*,*,2]  ; 550 nm
  a = where(duem_b gt 1e14 or duem_b lt -1e14)
  duem_b[a] = !values.f_nan
  duem_base_b = duem_b

  for iplot = 1, 2 do begin

   nc4readvar, datafils[iplot], 'totexttau', duem, lon=lon, lat=lat, lev=lev, /sum
   area, lon, lat, nx, ny, dx, dy, area
   if(nx eq 576) then begin
    duem = duem-duem_base
   endif else begin
    duem = duem-duem_base_b
   endelse
   title = titles[iplot]
   plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format='(f6.3)'
  endfor

  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.1,.1,.16,.16,.1], color=0, /normal, thick=2
  plots, [.42,.92,.92,.42,.42], [.1,.1,.16,.16,.1], color=0, /normal, thick=2


  device, /close

end
