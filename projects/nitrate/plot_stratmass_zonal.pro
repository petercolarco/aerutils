  expid = 'c90F_J10p14p1'
; Get the tropopause pressure [Pa]
  filetemplate = expid+'.geosgcm_surf.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'troppb', tropp, lon=lon, lat=lat



  filetemplate = expid+'.tavg3d_aer_p.ctl'
;  filetemplate = 'Icarusr6r6.tavg3d_aer_p.ctl'
;  expid = 'Icarusr6r6'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:108]
  nymd = nymd[0:108]

  vars = ['nicmass', 'totexttau_noni','ssexttau','ccexttau','duexttau', $
          'niexttau','suexttau']

  for ii = 0, 0 do begin

  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(51)*5
  levels = findgen(51)*.05
  ctab = 39

  case varo of
   'ssexttau'  : begin
                  varn = 'ssextcoef'
                  tag  = 'Sea Salt'
                  end
   'nicmass'  : begin
                  varn = 'niconc'
                  tag  = 'Nitrate'
                  end
   'suexttau'  : begin
                  varn = 'suextcoef'
                  tag  = 'Sulfate'
                  end
   'duexttau'  : begin
                  varn = 'duextcoef'
                  tag  = 'Dust'
                  end
   'totexttau' : begin
                 varn =  ['duextcoef','ssextcoef','suextcoef','niextcoef',$
                          'brcextcoef','bcextcoef','ocextcoef']
                 tag  = 'Total'
                 sum = 1
                 levels = findgen(51)*.0005
                 end
   'totexttau_noni' : begin
                 varn =  ['duextcoef','ssextcoef','suextcoef',$
                          'brcextcoef','bcextcoef','ocextcoef']
                 tag  = 'Total (no nitrate)'
                 sum = 1
                 levels = findgen(51)*.0005
                 end
   'ccexttau'  : begin
                  varn =  ['brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Carbonaceous'
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum, lev=lev
  nc4readvar, filename, 'airdens', rhoa, lon=lon, lat=lat, lev=lev
  lev = lev*100.
  nz = n_elements(lev)
; Compute the layer thickness using hydrostatic
  dz = rhoa
  dz[*,*,0,*] = -999.
  for iz = 1, nz-1 do begin
   dz[*,*,iz,*] = (lev[iz]-lev[iz-1])/rhoa[*,*,iz,*]/9.8
  endfor
; Compute the AOD
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(filename)
  aod = fltarr(nx,ny,nt)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    for it = 0, nt-1 do begin
     a = where(lev lt tropp[ix,iy,it])
     aod[ix,iy,it] = total(ext[ix,iy,a+1,it]*dz[ix,iy,a+1,it])
    endfor
   endfor
  endfor
  ext = aod
  ext = transpose(mean(ext,dim=1,/nan))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_stratmass_zonal.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext*1e6, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  contour, ext*1e6, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext*1e6, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  levels = levels[0:50:5]
  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f4.2)'), align=0
  xyouts, .525, .01, Tag+' Load [mg m!E-2!N]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(n_elements(dcolors),val=''), align=.5

  device, /close

  endfor

end
