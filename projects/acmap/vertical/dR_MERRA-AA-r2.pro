  expid = 'dR_MERRA-AA-r2'
  filetemplate = expid+'.inst3d_ext_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'extinction', su, lon=lon, lat=lat, lev=lev
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Average over zonal
  nx = n_elements(lon)
  su = total(su,1)/nx

; Average in latitude band
  a = where(lat gt 30. and lat le 60.)
  ny = n_elements(a)
  su = total(su[a,*,*],1)/ny

; Make a plot
  set_plot, 'ps'
  device, file=expid+'.ps', $
    xsize=16, ysize=12, xoff=.6, yoff=.5, /color, /helvetica, font_size=10
  !p.font=0
 
  loadct, 39
  colors=indgen(9)*30
  levels=[.001,.002,.005,.01,.02,.05,.1,.2,.5]
  labels=['0.001','0.002','0.005','0.01','0.02','0.05','0.1','0.2','0.5']
  contour, transpose(su)*1e3, indgen(12), z/1000., $
   xrange=[0,11], xticks=11, xstyle=1, xtitle='month', $
   yrange=[15,35], yticks=4, ystyle=1, ytitle='altitude [km]', $
   /cell, levels=levels, c_colors=colors, $
   position=[.1,.25,.95,.9], $
   title=expid+' suextcoef [Mm!E-1!N]'

  makekey, .1, .12, .85, .05, 0, -0.035, $
   colors=colors, labels=labels, align=0

  device, /close

end
