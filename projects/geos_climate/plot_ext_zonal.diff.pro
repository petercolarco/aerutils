  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'S2S1850nrst'
  filetemplate = expid1+'.geosgcm_gocart3d.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename1 = filename[19:131:12]
  nymd = nymd[7]
  filetemplate = expid2+'.geosgcm_gocart3d.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename2 = filename[19:131:12]
  nymd = nymd[7]


  vars = ['niextcoef']

;  for it = 0, n_elements(nymd)-1 do begin

  for ii = 0, 0 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(13)*20
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000

  case varo of
   'ssextcoef'  : begin
                  varn = 'ssextcoef'
                  tag  = 'Sea Salt'
                  ctab = 57
                  end
   'niextcoef'  : begin
                  levels = [-100,-3,-2,-1,-.5,-.1,-0.01,.01,.1,.5,1,2,3]
                  varn = 'niextcoef'
                  tag  = 'Nitrate'
                  ctab = 67
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
                  levels = [-100,-3,-2,-1,-.5,-.1,-0.01,.01,.1,.5,1,2,3]
                  varn =  ['ocextcoef']
                  tag  = 'Organic Aerosol'
                  ctab = 67
                  sum = 1
                  end
  endcase

  nc4readvar, filename1, varn, ext1, lon=lon, lat=lat, lev=lev, sum=sum
  nc4readvar, filename2, varn, ext2, lon=lon, lat=lat, lev=lev, sum=sum
;  if(it eq 0) then begin
;   nc4readvar, filename[it], 'h', h, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-50,10]
;   h = (mean(h,dim=1,/nan))/1000.
;  endif
  a = where(ext1 gt 1e14)
  if(a[0] ne -1) then ext1[a] = !values.f_nan
  ext1 = mean(ext1,dim=4,/nan)
  a = where(ext2 gt 1e14)
  if(a[0] ne -1) then ext2[a] = !values.f_nan
  ext2 = mean(ext2,dim=4,/nan)
  ext = (mean(ext1,dim=1,/nan)-mean(ext2,dim=1,/nan))*1e7

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal.diff.'+expid1+'_'+expid2+'.'+varo+ $
   '.1941_1950.ps', $
   /color, /helvetica, font_size=12, $
   xsize=20, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
;  xmax = max(x)
  xmax = 59
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

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(13), $
           labels=[' ',string(levels[1:12],format='(f5.2)')], align=.5
  xyouts, .525, .01, Tag+' Extinction @ [10!E4!N km!E-1!N, 550 nm], '+ $
                     '1941-1950', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(13,val=''), align=.5

  device, /close

;endfor

endfor
end
