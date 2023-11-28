; Setup the plot
  plotfile = 'figure02.ai_diff_pomi.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=24, xoff=.5, yoff=.5
  !p.font=0


  filetemplate = 'daily_hold.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  filetemplate = 'daily.pomi_hold.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai[a] = !values.f_nan
  ai_omi[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  xycomp, ai, ai_omi, lon, lat, dx, dy, $
          colortable=55, colors=[0,32,80,128,192,208,255], $
          levels=[-.5,0,.5,1,1.5,2.0,2.5], $
          dcolortable=66, dcolors=findgen(12)*21+20, $
          dlevels=[-1000,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25,.5], $
          geolimits=[-60,-180,60,180], $
          labelarray=[' ','0','0.5','1','1.5','2','2.5'], $
          dlabelarray=[' ','-0.25','-0.2','-0.15','-0.1','-0.05','0.05','0.1','0.15','0.2','0.25','0.5'], $
          diff=ai_omi-ai
          

  device, /close






; Setup the plot
  plotfile = 'figure02.ai_diff_pgeo.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=24, xoff=.5, yoff=.5
  !p.font=0


  filetemplate = 'daily_hold.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  filetemplate = 'daily.pgeo_hold.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai[a] = !values.f_nan
  ai_omi[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  xycomp, ai, ai_omi, lon, lat, dx, dy, $
          colortable=55, colors=[0,32,80,128,192,208,255], $
          levels=[-.5,0,.5,1,1.5,2.0,2.5], $
          dcolortable=66, dcolors=findgen(12)*21+20, $
          dlevels=[-1000,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25,.5], $
          geolimits=[-60,-180,60,180], $
          labelarray=[' ','0','0.5','1','1.5','2','2.5'], $
          dlabelarray=[' ','-0.25','-0.2','-0.15','-0.1','-0.05','0.05','0.1','0.15','0.2','0.25','0.5'], $
          diff=ai_omi-ai
          

  device, /close







; Setup the plot
  plotfile = 'figure02.prs_diff.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=24, xoff=.5, yoff=.5
  !p.font=0


  nc4readvar, filename, 'prs', prs, lon=lon, lat=lat
  a = where(prs gt 1e14)
  a = where(ai_omi gt 1e14)
  prs[a] = !values.f_nan
  nc4readvar, filename, 'prso', prso, lon=lon, lat=lat
  a = where(prso gt 1e14)
  a = where(ai_omi gt 1e14)
  prso[a] = !values.f_nan

  xycomp, prs, prso, lon, lat, dx, dy, $
          colortable=55, colors=reverse(findgen(9)*50), $
          levels=600+findgen(9)*50, $
          dcolortable=66, dcolors=findgen(13)*20, $
          dlevels=[-1000,-50,-40,-30,-20,-10,-1,1,10,20,30,40,50], $
          geolimits=[-60,-180,60,180], $
          labelarray=['600','650','700','750','800','850','900','950','1000'], $
          dlabelarray=[' ','-50','-40','-30','-20','-10','-1','1','10','20','30','40','50'], $
          diff=prso-prs
          

  device, /close
end
