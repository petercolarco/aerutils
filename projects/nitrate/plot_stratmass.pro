  expid = 'c90F_J10p17p0hl'
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

expip = 11

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

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, sum=sum, lev=lev, time=time
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
  area, lon, lat, nx, ny, dx, dy, area
  ext = aave(aod,area)*total(area)/1.e9

; Now make a plot
  set_plot, 'ps'
  device, file='plot_stratmass.'+expid+'.'+varo+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = 2000.+findgen(241)/12.
  plot, x, indgen(241), /nodata, xticks=20, $
   xtickn=string([x[0:240:12]],format='(i4)'), $
   yrange=[0,1], xrange=[2000,2020]

  x = 2000+expip+findgen(n_elements(time))/12.
  oplot, x, ext, thick=6

  device, /close

  endfor

end
