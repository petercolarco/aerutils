  datewant= '20070722'

  title = 'GEOS-5 CO mixing ratio [ppbv] 16:30z22jul2007 on DC-8 track'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  navfile = dataDir + 'TN'+datewant+'.DC2.txt'

  modelurl = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg3d_chm_p'

  get_dc8_navtrack, datadir, datewant, lonf, latf, levf, prsf, gmt
  get_model_navtrack, modelurl, 'co', dummr, lonf, latf, lev, $
    wanttime=gradsdate(datewant,hrstr='16:30')

  nz = n_elements(lev)
  
; fake out the dy for level array
  dlev = lev
  for iz = 0, nz-2 do begin
   dlev[iz] = lev[iz]-lev[iz+1]
  endfor
  dlev[nz-1] = 10.
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
  device, file='./p'+datewant+'/comr_dc8.'+datewant+'.ps', font_size=18, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=1

  position=[.15,.3,.95,.9]
  contour, dummr, gmt, lev, /nodata, $
   yrange=[1000,200],ythick=3, /ylog, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = 50+indgen(11)*10
  loadct, 39
  colorarray = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, dummr*1e9, levelarray, colorarray, gmt, lev, dgmt, dlev
  contour, dummr, gmt, lev, /nodata, /noerase, $
   yrange=[1000,200], ytitle = 'pressure [mbar]', ythick=3, /ylog, ystyle=9, $
   xstyle=9, xtitle='hours gmt', xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, title, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, $
   color=colorarray, label=strcompress(string(levelarray),/rem)

  device, /close

end
