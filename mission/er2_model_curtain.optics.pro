  dd = '25'
  datewant= '200707'+dd

  title = 'GEOS-5 ~Aerosol Extinction [km!E-1!N] 16:30z'+dd+'jul2007 on ER-2 track'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  navfile = dataDir + 'NR'+datewant+'.ER2.txt'

  modelfile = 'asm_optics.er2.'+datewant+'.nc'

  get_er2_navtrack, datadir, datewant, lonf, latf, levf, prsf, gmt
  read_curtain_optics, modelfile, $
       ps, delp, rh, tau, ssa, g, etob, attback0, attback1, lev, ext

  lev = lev/100.
  delp = delp/100.

  dgmt = gmt[1] - gmt[0]

; convert seconds gmt to hh:mm:ss and figure tick marks
  hh0 = fix(min(gmt/3600.))
  hh1 = fix(max(gmt/3600.))+1
  nmajor = hh1-hh0
  nminor = 2
  hh = strcompress(string(fix(gmt/3600)),/rem)
  nn = strcompress(string(fix((gmt-hh*3600.)/60)),/rem)
  ss = strcompress(string(fix(gmt - hh*3600.-nn*60.)),/rem)
  a = where(hh lt 10)
  if(a[0] ne -1) then hh[a] = '0'+hh[a]
  a = where(nn lt 10)
  if(a[0] ne -1) then nn[a] = '0'+nn[a]
  a = where(ss lt 10)
  if(a[0] ne -1) then ss[a] = '0'+ss[a]
  timearray = hh+':'+nn+':'+ss
  ticklabel = hh0 + indgen(nmajor+1)
  ticklabel = string(ticklabel,format='(i2)')

; Make a plot
  set_plot, 'ps'
  fileps  = './p'+datewant+'/ext_er2.'+datewant+'.ps'
  filepng = './p'+datewant+'/ext_er2.'+datewant+'.png'
  device, file=fileps, font_size=18, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=1

  position=[.15,.3,.95,.9]
  contour, ext, gmt, reform(lev[0,*]), /nodata, $
   yrange=[1000,200],ythick=3, /ylog, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = [1,2,5,10,25,50,100,150,200,250]/1000.
  loadct, 39
  colorarray = [30,64,80,96,144,176,192,199,208,254]
  plotgrid, ext*1000., levelarray, colorarray, gmt, lev, dgmt, delp
  contour, ext, gmt, reform(lev[0,*]), /nodata, /noerase, $
   yrange=[1000,200], ytitle = 'pressure [mbar]', ythick=3, /ylog, ystyle=9, $
   xstyle=9, xtitle='hours gmt', xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, title, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, $
   color=colorarray, label=strcompress(string(levelarray,format='(f5.3)'),/rem)

  device, /close

  cmd = 'convert -density 150 '+fileps+' '+filepng
  spawn, cmd

end
