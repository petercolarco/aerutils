  site = 'miami'
  case site of
   'miami'   : begin
               wantlat=26.
               wantlon=-80.5
               end
   'houston' : begin
               wantlat=29.6
               wantlon=-95.25
               end
  endcase

; Get the PM25
  read_pm25, site+'.pm25.csv', stpm, copm, sipm, latpm, lonpm, datepm, pm25

; Get the dust
  get_dust, site+'.spec.csv', stdu,codu,sidu,latdu,londu,datedu,dust

; Get some model results
  expctl = 'tavg1_2d_aer_Nx.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[where(nymd lt 20160000L)]
  nhms = nhms[where(nymd lt 20160000L)]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  filename = filename[uniq(filename)]
;goto, jump
  print, 'getting MERRA2 dust'
  nc4readvar, filename, ['dusmass25'], $
              dusmass25, lon=lon, lat=lat, /temp, /sum, wantlon=wantlon, wantlat=wantlat, $
              time=time
  print, 'getting MERRA2 sulfate'
  nc4readvar, filename, ['so4smass'], $
              so4smass, lon=lon, lat=lat, /temp, /sum, wantlon=wantlon, wantlat=wantlat, $
              time=time
  print, 'getting MERRA2 other'
  nc4readvar, filename, ['bcsmass','ocsmass','sssmass25'], $
              smass, lon=lon, lat=lat, /temp, /sum, wantlon=wantlon, wantlat=wantlat, $
              time=time
  pm25_ = (smass + 1.375*so4smass+dusmass25 ) * 1e9
  dusmass25_ = dusmass25 * 1e9
; Daily mean
  pm25mod = fltarr(365)
  du25mod = fltarr(365)
  for i = 0, 364 do begin
   pm25mod[i] = mean(pm25_[i*24L:i*24L+23])
   du25mod[i] = mean(dusmass25_[i*24L:i*24L+23])
  endfor
jump:
  nymd = string(nymd[uniq(nymd)],format='(i8)')
  yyyy = strmid(nymd,0,4)
  mm   = strmid(nymd,4,2)
  dd   = strmid(nymd,6,2)
  datemod = julday(mm,dd,yyyy)

; Find sites in common
  siteu = sidu[uniq(sidu)]

  nst = n_elements(siteu)
  jday0 = julday(1,1,2015)-1L
  newplot = 1
  for i = 0, nst-1 do begin
   a = where(siteu[i] eq sipm)
   if(a[0] eq -1) then continue
   if(newplot) then begin
     set_plot, 'ps'
     device, file=site+'.pm25_dust.ps', /color, /helvetica, font_size=14
     !p.font=0
     loadct, 39
     newplot = 0
   endif
   plot, datepm-jday0, pm25, /nodata, $
    xrange=[0,366], xtitle='Day of year 2015', xstyle=9, $
    yrange=[0,50], ytitle='PM25/Dust [!Mm!Ng m!E-3!N]', ystyle=9
   oplot, datepm[a]-jday0, pm25[a], thick=8
   a = where(sidu eq siteu[i])
   oplot, datedu[a]-jday0, dust[a], thick=8, color=254
   plots, [0,366], 35, lin=2
  endfor
  if(not newplot) then device,/close

  set_plot, 'ps'
  device, file=site+'.pm25_dust.merra2.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
  plot, datepm-jday0, pm25, /nodata, $
   xrange=[0,366], xtitle='Day of year 2015', xstyle=9, $
   yrange=[0,100], ytitle='PM25/Dust [!Mm!Ng m!E-3!N]', ystyle=9
  oplot, datemod-jday0, pm25mod, thick=8
  oplot, datemod-jday0, du25mod, thick=8, color=254
  device, /close


end
