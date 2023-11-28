  expid = 'c48Fc_H43_pinatubo15+sulfate'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, ['swtnet','swtnetna'], su1, lon=lon, lat=lat
  nt = n_elements(a)

  expid = 'c48F_H43_pinatubo15+sulfate'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, ['swtnet','swtnetna'], su2, lon=lon, lat=lat
  nt = n_elements(a)

; Do the difference
  su1 = su1[*,*,*,0]-su1[*,*,*,1]
  su2 = su2[*,*,*,0]-su2[*,*,*,1]

  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

; zonal mean and transpose
  su = transpose(total(su2-su1,1)/n_elements(lon))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_swtnet_diff.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=18, ysize=7.2, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su, x, lat, /nodata, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  dred   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
  dgreen = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
  dblue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
  dlevels = [-2000,-4.,-2,-1,-.5,-.2,-0.1,-.05,.05,0.1,.2,.5,1]
  dlabels = [' ','-4','-2','-1','-0.5','-0.2','-0.1','-0.05','0.05','0.1','0.2','0.5','1']
  tvlct, dred, dgreen, dblue
  dcolors=indgen(n_elements(dlevels))
  igrey  = n_elements(dred)-2
  iblack = n_elements(dred)-1

  contour, su, x, lat, /over, $
   levels=dlevels, c_color=dcolors, /cell
  contour, su, x, lat, /over, $
   levels=dlevels, c_color=iblack

  loadct, 0
  contour, su, x, lat, /nodata, noerase=1, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
;  xyouts, .15, .92, 'Sulfate AOT (Pinatubo)', /normal

  makekey, .15, .06, .8, .04, 0., -0.05, align=.5, $
           color=make_array(n_elements(dlabels),val=0), label=dlabels

  tvlct, dred, dgreen, dblue
  dcolors=indgen(n_elements(dlevels))
  makekey, .15, .06, .8, .04, 0., -0.05, align=.5, /noborder, $
           color=dcolors, label=make_array(n_elements(dlables)+1,val='')

  device, /close

end

