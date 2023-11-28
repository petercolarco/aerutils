  expid1 = 'C90c_HTcntl_clim.monthly'
  filetemplate = expid1+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename1=strtemplate(template,nymd,nhms)

  expid0 = 'C90c_HTerup_clim.monthly'
  filetemplate = expid0+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename0=strtemplate(template,nymd,nhms)

  vars = ['suextcoef']


  for ii = 0, 0 do begin
  varo = vars[ii]
  print, varo
  sum = 0
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000

  wantlev = [10,20.,30.,50.,100.,150.]

  for jj = 0, n_elements(wantlev)-1 do begin

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
   'so4'  : begin
;                  levels = [0.0001,0.0002,0.0003,0.0005,0.001, $
;                            0.002,0.003,0.004,0.005,0.1,0.2]
                  varn = 'so4'
                  tag  = 'Sulfate'
                  ctab = 39
                  end
   'suextcoef'  : begin
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

  nc4readvar, filename1, varn, ext1, lon=lon, lat=lat, sum=sum, wantlev=wantlev[jj], lev=lev
print, wantlev[jj], lev
;  nc4readvar, filename, 'airdens', rhoa, lon=lon, lat=lat, sum=sum, wantlev=wantlev[jj]
  a = where(ext1 gt 1e14)
  if(a[0] ne -1) then ext1[a] = !values.f_nan
;  ext = transpose(mean(ext*rhoa,dim=1,/nan))*1e7*1100. ; ad hoc correction to ext
  ext1 = transpose(mean(ext1,dim=1,/nan))*1e7
; Assume an Angstrom parameter of 2.48 compute the extinction at 870
; from 550 nm as scaling by factor 0.32
  ext1 = ext1*0.32

  nc4readvar, filename0, varn, ext0, lon=lon, lat=lat, sum=sum, wantlev=wantlev[jj], lev=lev
;  nc4readvar, filename, 'airdens', rhoa, lon=lon, lat=lat, sum=sum, wantlev=wantlev[jj]
  a = where(ext0 gt 1e14)
  if(a[0] ne -1) then ext0[a] = !values.f_nan
  ext0 = transpose(mean(ext0,dim=1,/nan))*1e7
; Assume an Angstrom parameter of 2.48 compute the extinction at 870
; from 550 nm as scaling by factor 0.32
  ext0 = ext0*0.32

  ext = ext0 - ext1
  check, ext

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal_vertical_long.diff.'+expid0+'_'+expid1+'.'+varo+ $
   '.'+string(wantlev[jj],format='(i04)')+'hpa.ps', $
   /color, /helvetica, font_size=14, $
   xsize=36, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x0 = 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = make_array(n_elements(nymd),val=' ')
  xtickname[0:xmax:12] = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname = [xtickname,'2025']
  contour, ext, x, lat, /nodata, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xrange=[0,36], xtickname=xtickname, $
   xticks=36, $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'Latitude'

  loadct, ctab
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell


  loadct, 0
  contour, ext, x, lat, /over, levels=0, c_lin=2, c_thick=6, c_color=100
;  contour, h, x, lat, /over, levels=indgen(20)+18, c_label=make_array(20,val=1)
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xrange=[0,36], xtickname=xtickname, $
   xticks=36, $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'Latitude', xtitle='Date'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, Tag+' Extinction @ '+$
    string(wantlev[jj],format='(i-4)')+' hPa [10!E4!N km!E-1!N, 870 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

  endfor

  endfor
end
