  dd = '19'
  datewant= '200707'+dd

  title = 'GEOS-5 Dust mmr [ppbm] 16:30z'+dd+'jul2007'
;  title = 'GEOS-5 All aerosol mmr [ppbm] 16:30z21jul2007'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  navfile = dataDir + 'NR'+datewant+'.ER2.txt'

  modelurl = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg3d_aer_p'
;  modelurl = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/inst3d_aer_v'

; Read the Nav file for the flight path
  ex_rd1001, navfile, xname=xname, xvalues=xvals $
             , vname=vname, data=dat, vmiss=vmiss $
             , aname=aname, auxdat=auxdat, amiss=amiss $
             , n_dimens=n_dimens, nauxv=nauxv, err=err $
             , oname=oname,sname=sname,org=org,mname=mname $
             , date=date, mod_date=mod_date $
             , spec_comments=scom, norm_comments=ncom
  latf = dat[*,17]
  lonf = dat[*,18]
  gmt  = xvals

; degrade the nav data to about 1x minute
  nx = n_elements(gmt)
  latf = latf[0:nx-1:60]
  lonf = lonf[0:nx-1:60]
  gmt  = gmt[0:nx-1:60]
  nx = n_elements(gmt)


; Get the model profile
  lon0 = min(lonf)-1.
  lon1 = max(lonf)+1.
  lat0 = min(latf)-1.
  lat1 = max(latf)+1.
;  ga_getvar, modelurl, ['du','oc','bc','ss','so4'], dummr_, lon=lon, lat=lat, lev=lev, $
  ga_getvar, modelurl, ['du'], dummr_, lon=lon, lat=lat, lev=lev, $
   wantlat=[lat0,lat1], wantlon=[lon0,lon1], wanttime=gradsdate(datewant,hrstr='16:30')
;  ga_getvar, modelurl, 'delp', delp_, lon=lon, lat=lat, lev=lev, $
;   wantlat=[lat0,lat1], wantlon=[lon0,lon1], wanttime=gradsdate(datewant,hrstr='16:30')
;  ga_getvar, modelurl, 'ps', ps_, lon=lon, lat=lat, $
;   wantlat=[lat0,lat1], wantlon=[lon0,lon1], wanttime=gradsdate(datewant,hrstr='16:30')
  a = where(dummr_ eq 1e15)
  if(a[0] ne -1) then dummr_[a] = !values.f_nan

; Now interpolate the model to the flight tracks
  ix = interpol(indgen(n_elements(lon)),lon,lonf)
  iy = interpol(indgen(n_elements(lat)),lat,latf)
  nz = n_elements(lev)
  dummr = fltarr(nx,nz)
  delp  = fltarr(nx,nz)
  ps    = fltarr(nx)
  for iz = 0, nz-1 do begin
   dummr[*,iz] = interpolate(dummr_[*,*,iz],ix,iy)
  endfor
  
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
  psfile = 'dummr_er2.'+datewant+'.ps'
  pngfile = 'dummr_er2.'+datewant+'.png'
  set_plot, 'ps'
;  device, file='allmmr_er2.'+datewant+'.ps', font_size=18, /helvetica, $
  device, file=psfile, font_size=18, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=1

  position=[.15,.3,.95,.9]
  contour, dummr, gmt, lev, /nodata, $
   yrange=[1000,200],ythick=3, /ylog, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = [1,2,5,10,20,50,100]
  loadct, 39
  colorarray = indgen(7)*30+60
  plotgrid, dummr*1e9, levelarray, colorarray, gmt, lev, dgmt, dlev
  contour, dummr, gmt, lev, /nodata, /noerase, $
   yrange=[1000,200], ytitle = 'pressure [mbar]', ythick=3, /ylog, ystyle=9, $
   xstyle=9, xtitle='hours gmt', xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, title, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, $
   color=colorarray, label=strcompress(string(levelarray),/rem)

  device, /close


  cmd = 'convert -density 150 '+psfile+' '+pngfile
  spawn, cmd

end
