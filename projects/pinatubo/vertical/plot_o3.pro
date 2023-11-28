; Make a plot of the zonal, vertical ozone distribution with some
; other information on it

; Date you want
  datewant = '199310'

; susarea from model is m2 m-3, conversion to um2 cm-3
  facsa = 1.e12/1.e6

; scale ozone to ppmv
  faco3 = 1.e6

; Get the model fields
  expid = ['c48Fc_H43_pinatubo15',  'c48Fc_H43_pinatubo15+sulfate', $
           'c48Fc_H43_strat', $
           'c48Fc_H43_pinatubo15v2', $
           'c48Fc_H43_pinatubo15v2+sulfate', 'c48Fc_H43_pin15+sulf+cerro']
  ipos = [0,1,2,3,4,5]

  nexpid = n_elements(expid)
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  for iexpid = 0, nexpid-1 do begin

;  Get the ozone
   filetemplate = expid[iexpid]+'.geosgcm_prog.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge datewant+'00')
   nymd = nymd[a[0]]
   filename = filename[a[0]]
   nc4readvar, filename, 'o3', o3_, lon=lon, lat=lat, lev=levo3
   o3 = o3_*faco3

;  Get the surface area
   filetemplate = expid[iexpid]+'.tavg3d_carma_p.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge datewant+'00')
   nymd = nymd[a[0]]
   filename = filename[a[0]]
   nc4readvar, filename, 'susarea', sus_, lon=lon, lat=lat, lev=lev
   sus = sus_*facsa

;  Get the column ozone
   filetemplate = expid[iexpid]+'.geosgcm_surf.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge datewant+'00')
   nymd = nymd[a[0]]
   filename = filename[a[0]]
   nc4readvar, filename, 'scto3', scto3, lon=lon, lat=lat
   nc4readvar, filename, 'sctto3', sctto3, lon=lon, lat=lat
   scto3 = scto3-sctto3

   nt = n_elements(a)
   nz = n_elements(lev)

;  throw out bad values
   a = where(sus gt 1e12)
   sus[a] = !values.f_nan
   a = where(o3 gt 1e12)
   o3[a]  = !values.f_nan

;  zonal mean
   sus   = reform(mean(sus,dimension=1,/nan))
   o3    = reform(mean(o3,dimension=1,/nan))
   scto3 = reform(mean(scto3,dimension=1,/nan))

   if(iexpid eq 0) then susarea = fltarr(ny,nz,nexpid)
   if(iexpid eq 0) then o3vmr   = fltarr(ny,nz,nexpid)
   if(iexpid eq 0) then toto3   = fltarr(ny,nexpid)
   susarea[*,*,iexpid] = sus
   o3vmr[*,*,iexpid]   = o3
   toto3[*,iexpid]     = scto3

  endfor

  set_plot, 'ps'
  device, file='plot_o3.'+datewant+'.ps', $
    /helvetica, font_size=10, /color, $
    xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0

; Set up a six-element array of the positions for individual panels
  position = [ [.05,.6,.295,.95], [.375,.6,.62,.95], [.7,.6,.945,.95], $
               [.05,.15,.295,.5], [.375,.15,.62,.5], [.7,.15,.945,.5] ]

  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

  for iexpid = 0, nexpid-1 do begin
print, iexpid
  loadct, 0
  plot, lat, sus[*,0], /nodata, /noerase, $
   position=position[*,ipos[iexpid]], $
   xstyle=1, xminor=2, xrange=[-90,-60], $
   ystyle=9, yrange=[300,5], /ylog, $
   ytitle = 'pressure [hPa]'

  levelsa = [.1,.2,.5,1,2,5,10,15]
  levels = [0,.5,1,2,3,4,5,6]
  colors = reverse(240-findgen(8)*30)

  loadct, 63
  contour, /overplot, o3vmr[*,*,iexpid], lat, levo3, /cell, $
   levels=levels, c_colors=colors
  
  loadct, 0
  
  plot, lat, sus[*,0], /nodata, /noerase, $
   position=position[*,ipos[iexpid]], $
   xstyle=1, xminor=2, xrange=[-90,-60], $
   ystyle=9, yrange=[300,5], /ylog, $
   ytitle = 'pressure [hPa]'

  contour, /overplot, susarea[*,*,iexpid], lat, lev, $
   levels=levelsa, c_labels=make_array(n_elements(levelsa),val=1)

  axis, yaxis=1, yrange=[0,400], ylog=0, /save, $
        ytitle='Stratospheric Ozone [DU]'
  oplot, lat, toto3[*,iexpid], thick=6

  endfor


  makekey, .3, .06, .4, .03, 0., -0.025, color=colors, chars=1.25, $
           labels=string(levels,format='(f4.1)'), align=0
  loadct, 63
  makekey, .3, .06, .4, .03, 0., -0.025, color=colors, chars=1.25, $
           labels=make_array(n_elements(levels),val=' '), align=0

  device, /close

end
