;  expid = 'S2S1850CO2x4pl'
  expid = 'S2S1850nrst'
  filetemplate = expid+'.geosgcm_gocart3d.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[19:131:12]
  nymd = nymd[7]


  vars = ['niextcoef']

;  for it = 0, n_elements(nymd)-1 do begin

  for ii = 0, 0 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000

  case varo of
   'ssextcoef'  : begin
                  varn = 'ssextcoef'
                  tag  = 'Sea Salt'
                  ctab = 57
                  end
   'niextcoef'  : begin
                  varn = 'niextcoef'
                  tag  = 'Nitrate'
                  ctab = 53
                  end
   'suextcoef'  : begin
;                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
;                            0.002,0.003,0.004,0.005,0.1,0.2]
                  varn = 'suextcoef003'
                  tag  = 'Sulfate'
                  ctab = 39
                  end
   'duextcoef'  : begin
                  varn = 'duextcoef'
                  tag  = 'Dust'
                  ctab = 56
                  end
   'totextcoef' : begin
                  varn =  ['duextcoef','ssextcoef','suextcoef','niextcoef',$
                           'brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Total'
                  ctab = 51
                  sum = 1
                  end
   'ccextcoef'  : begin
                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
                            0.002,0.003,0.005,0.1,0.2,0.3]
                  varn =  ['brcextcoef','bcextcoef','ocextcoef']
                  tag  = 'Carbonaceous'
                  ctab = 54
                  sum = 1
                  end
   'ocextcoef'  : begin
                  levels = [0.001,0.002,0.003,0.005,0.1,0.2,0.3,.5,.8,1,2]*10
                  varn =  ['ocextcoef']
                  tag  = 'Organic Aerosol'
                  ctab = 53
                  sum = 1
                  end
  endcase

  nc4readvar, filename, varn, ext, lon=lon, lat=lat, lev=lev, sum=sum
;  if(it eq 0) then begin
;   nc4readvar, filename[it], 'h', h, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-50,10]
;   h = (mean(h,dim=1,/nan))/1000.
;  endif
  a = where(ext gt 1e14)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  ext = mean(ext,dim=4,/nan)
  ext = (mean(ext,dim=1,/nan))*1e7

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal.'+expid+'.'+varo+ $
   '.1941_1950.ps', $
   /color, /helvetica, font_size=12, $
   xsize=20, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
;  xmax = max(x)
;  xmax = 59
  contour, ext, lat, lev, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=6, xrange=[-90,90], $
   ystyle=1, yrange=[1000,5], /ylog,$
   ytitle = 'altitude [hPa]'

  loadct, ctab
  contour, ext, lat, lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
 ; contour, h, lat, lev, /over, levels=indgen(22)+16, c_label=make_array(20,val=1)
  contour, ext, lat, lev, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=6, xrange=[-90,90], $
   ystyle=1, yrange=[1000,5], /ylog,$
   ytitle = 'altitude [hPa]'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, Tag+' Extinction [10!E4!N km!E-1!N, 550 nm], '+$
                     '1941_1950', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

;endfor

endfor
end
