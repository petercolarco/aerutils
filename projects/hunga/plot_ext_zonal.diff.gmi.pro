  expid0 = 'C90c_HTerup_clim'
  filetemplate = expid0+'.monthly.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename0=strtemplate(template,nymd,nhms)

  expid1 = 'C90c_HTcntl_clim'
  filetemplate = expid1+'.monthly.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename1=strtemplate(template,nymd,nhms)

  a = where(nymd gt 20221300L and nymd lt 20231300L)
  nymd = nymd[a]
  filename0 = filename0[a]
  filename1 = filename1[a]

  vars = ['suextcoef']

  for it = 0, n_elements(nymd)-1 do begin

  for ii = 0, 0 do begin
  varo = vars[ii]
  print, nymd[it]
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
                  varn = 'suextcoef'
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
  endcase

  nc4readvar, filename0[it], varn, ext0, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-90,10]
  a = where(ext0 gt 1e14)
  if(a[0] ne -1) then ext0[a] = !values.f_nan
  ext0 = (mean(ext0,dim=1,/nan))*1e7
; Assume an Angstrom parameter of 2.48 compute the extinction at 870
; from 550 nm as scaling by factor 0.32
  ext0 = ext0*0.32

  nc4readvar, filename1[it], varn, ext1, lon=lon, lat=lat, lev=lev, sum=sum, wantlat=[-90,10]
  a = where(ext1 gt 1e14)
  if(a[0] ne -1) then ext1[a] = !values.f_nan
  ext1 = (mean(ext1,dim=1,/nan))*1e7
; Assume an Angstrom parameter of 2.48 compute the extinction at 870
; from 550 nm as scaling by factor 0.32
  ext1 = ext1*0.32

  ext = ext0 - ext1
  check, ext[*,0:27]

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal.diff.gmi.'+expid0+'_'+expid1+'.'+varo+ $
   '.'+nymd[it]+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=20, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))+12
  xmax = max(x)
  xmax = 59
  contour, ext, lat, lev, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=5, xrange=[-90,10], $
   ystyle=1, yrange=[500,10], /ylog,$
   ytitle = 'altitude [hPa]'

  loadct, ctab
  contour, ext, lat, lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, lat, lev, /over, levels=0, c_color=100, c_thick=6, c_lin=2
  contour, ext, lat, lev, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=5, xrange=[-90,10], $
   ystyle=1, yrange=[500,10], /ylog,$
   ytitle = 'altitude [hPa]'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, Tag+' Extinction @ '+$
    nymd[it]+', [10!E4!N km!E-1!N, 870 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

endfor

endfor
end
