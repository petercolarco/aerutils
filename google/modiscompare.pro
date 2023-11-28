; Colarco
; Hand stitch two kmz files together after the fact
; 1) generate the model kmz
; 2) generate the satellite kmz for the same times
; 3) unzip both, drop one folder field into other, and rezip

; Averaging time
  date0 = '01:30Z21jul2007'
  date1 = '22:30Z25jul2007'

; grid information
  wantlon = [-140.1,-0.1]
  wantlat = [-40,40]


; compare the modis AOT over the ocean (quantitatively) to the model
  urlmodis = 'MOD04_ocn.ddf'
  urlmodel = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x'
  ga_getvar, urlmodel, '', varval, lon=lon, lat=lat, $
    wantlon=wantlon, wantlat=wantlat, wanttime=[date0,date1], time = time

  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(time ge date0 and time le date1)
  timeswanted = time[a]

  meanaotmodis = fltarr(nx,ny)
  meanaotmodel = fltarr(nx,ny)
  numaot  = intarr(nx,ny)

  nt = n_elements(timeswanted)

  for it = 0, nt-1 do begin

   ga_getvar, urlmodis, ['aodtau'], aotmodis, $
    lon=lon, lat=lat, lev=lev, time=time, $
    wantlon=wantlon, wantlat=wantlat, wantlev=[550], wanttime=timeswanted[it]
   ga_getvar, urlmodel, $
    ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], aotmodel, $
    lon=lon, lat=lat, lev=lev, time=time, $
    wantlon=wantlon, wantlat=wantlat, wantlev=[550], wanttime=timeswanted[it]
   a = where(aotmodis lt 100)
   if(a[0] ne -1) then begin
    numaot[a] = numaot[a]+1
    meanaotmodel[a] = meanaotmodel[a]+aotmodel[a]
    meanaotmodis[a] = meanaotmodis[a]+aotmodis[a]
   endif
  endfor
  a = where(numaot ne 0)
  meanaotmodel[a] = meanaotmodel[a]/numaot[a]
  meanaotmodis[a] = meanaotmodis[a]/numaot[a]


  dir = 'geos5_mod04_sampled.21jul_25jul'
  title = 'GEOS-5 AOT [550 nm]' 
  make_kmz, meanaotmodel, lon, lat, $
      scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr

  dir = 'modis_mod04_sampled.21jul_25jul'
  title = 'MODIS AOT [550 nm]' 
  make_kmz, meanaotmodis, lon, lat, $
      scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr

end
