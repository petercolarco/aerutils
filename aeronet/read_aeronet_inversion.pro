; COlarco, February 2007
; Read the Aeronet inversion retrievals file
; Return some variables
  dateStr = '920801_070217'   ; date string preceeding each filename, needs to be reset as data updated
  site = 'Capo_Verde'
  dataLoc = '/output/colarco/AERONET/INV/DUBOV/'
  monthly = 1
  daymon = 'day'
  dataDir = dataLoc + 'DAILY/'
  if(monthly) then begin
   daymon = 'mon'
   dataDir = dataLoc + 'MONTHLY/'
  endif

  openr, lun, dataDir + dateStr+'_'+site+'.dubovik'+daymon, /get_lun




  str = 'a'
  for i = 0, 2 do begin
   readf, lun, str
   print, str
  endfor
  i = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   split = strsplit(str,',',/extract)

   a = where(split eq 'N/A')
   if(a[0] ne -1) then split[a] = 'NaN'
   if(i eq 0) then begin
    d0 = split[0] 
    d1 = split[1]
    w0 = split[32]
    w1 = split[33]
    w2 = split[34]
    w3 = split[35]
    r0 = split[41]
    r1 = split[42]
    r2 = split[43]
    r3 = split[44]
    i0 = split[45]
    i1 = split[46]
    i2 = split[47]
    i3 = split[48]
    ang = split[31]
    v1 = split[88]
    rm1 = split[90]
    st1 = split[91]
    v2 = split[92]
    rm2 = split[94]
    st2 = split[95]
    psd = split[61:82]
   endif else begin
    d0 = [d0,split[0]]
    d1 = [d1,split[1]]
    w0 = [w0,split[32]]
    w1 = [w1,split[33]]
    w2 = [w2,split[34]]
    w3 = [w3,split[35]]
    r0 = [r0,split[41]]
    r1 = [r1,split[42]]
    r2 = [r2,split[43]]
    r3 = [r3,split[44]]
    i0 = [i0,split[45]]
    i1 = [i1,split[46]]
    i2 = [i2,split[47]]
    i3 = [i3,split[48]]
    ang = [ang,split[31]]
    v1 = [v1,split[88]]
    rm1 = [rm1,split[90]]
    st1 = [st1,split[91]]
    v2 = [v2,split[92]]
    rm2 = [rm2,split[94]]
    st2 = [st2,split[95]]
    psd = [psd,split[61:82]]
   endelse
   i = i+ 1
  endwhile
  free_lun, lun

; PSD properties, handle
  nbin = 22
  rhop = 1.0d
  rmin = 0.05d
  rmax = 15.
  rat = rmax/rmin
  rmrat = (rat^3)^(1./double(nbin-1))
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow, masspart
  psd = reform(psd,22,i)

; Pick off the weighted means
  j = 2  ; 1 for daily means, 2 for weighted
  date = d0[j:i-1:4]
  refr440 = float(r0[j:i-1:4])
  refr670 = float(r1[j:i-1:4])
  refr870 = float(r2[j:i-1:4])
  refr1020 = float(r3[j:i-1:4])
  refi440 = float(i0[j:i-1:4])
  refi670 = float(i1[j:i-1:4])
  refi870 = float(i2[j:i-1:4])
  refi1020 = float(i3[j:i-1:4])
  ssa440 = float(w0[j:i-1:4])
  ssa670 = float(w1[j:i-1:4])
  ssa870 = float(w2[j:i-1:4])
  ssa1020 = float(w3[j:i-1:4])
  angstrom = float(ang[j:i-1:4])
  vmode1 = float(v1[j:i-1:4])
  vmode2 = float(v2[j:i-1:4])
  rmode1 = float(rm1[j:i-1:4])
  rmode2 = float(rm2[j:i-1:4])
  smode1 = float(st1[j:i-1:4])
  smode2 = float(st2[j:i-1:4])
  dvdlnr = float(psd[*,j:i-1:4])

  nt = n_elements(date)
  a = where(strmid(date,5,3) eq 'JUL')

; Plot
  set_plot, 'ps'
  device, file='aeronet_inversion.'+site+'.ps', /color, /helvetica, font_size=14
  !p.font=0

  loadct, 39
  plot, indgen(nt), ssa440, /nodata, thick=3, xtitle='month', ytitle='ssa', $
   xrange=[0,nt], yrange=[0.8, 1.1], ystyle=9, xstyle=9
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,2], lin=2, noclip=0
  endfor
  oplot, indgen(nt), ssa440, color=84, thick=6
  oplot, indgen(nt), ssa670, color=176, thick=6
  oplot, indgen(nt), ssa870, color=254, thick=6
  oplot, indgen(nt), ssa1020, color=0, thick=6

  plot, indgen(nt), refi440, /nodata, thick=3, xtitle='month', ytitle='refi', $
   xrange=[0,nt], yrange=[0, 0.02], ystyle=9, xstyle=9
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,2], lin=2, noclip=0
  endfor
  oplot, indgen(nt), refi440, color=84, thick=6
  oplot, indgen(nt), refi670, color=176, thick=6
  oplot, indgen(nt), refi870, color=254, thick=6
  oplot, indgen(nt), refi1020, color=0, thick=6

  plot, indgen(nt), refr440, /nodata, thick=3, xtitle='month', ytitle='refr', $
   xrange=[0,nt], yrange=[1.4,1.6], ystyle=9, xstyle=9
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,2], lin=2, noclip=0
  endfor
  oplot, indgen(nt), refr440, color=84, thick=6
  oplot, indgen(nt), refr670, color=176, thick=6
  oplot, indgen(nt), refr870, color=254, thick=6
  oplot, indgen(nt), refr1020, color=0, thick=6


  plot, indgen(nt), angstrom, /nodata, thick=3, xtitle='month', $
   ytitle='Angstrom 870-440 ext', $
   xrange=[0,nt], yrange=[0,1], ystyle=9, xstyle=9
  oplot, indgen(nt), angstrom, thick=6
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,2], lin=2, noclip=0
  endfor

  plot, indgen(nt), vmode1, /nodata, thick=3, xtitle='month', $
   ytitle='Concentration', $
   xrange=[0,nt], yrange=[0,1], ystyle=9, xstyle=9
  oplot, indgen(nt), vmode1, thick=6
  oplot, indgen(nt), vmode2, thick=6, color=80
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,2], lin=2, noclip=0
  endfor

  plot, indgen(nt), rmode1, /nodata, thick=3, xtitle='month', $
   ytitle='Median Radius', $
   xrange=[0,nt], yrange=[0,3], ystyle=9, xstyle=9
  oplot, indgen(nt), rmode1, thick=6
  oplot, indgen(nt), rmode2, thick=6, color=80
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,3], lin=2, noclip=0
  endfor

  plot, indgen(nt), smode1, /nodata, thick=3, xtitle='month', $
   ytitle='Width', $
   xrange=[0,nt], yrange=[0,3], ystyle=9, xstyle=9
  oplot, indgen(nt), smode1, thick=6
  oplot, indgen(nt), smode2, thick=6, color=80
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[0,3], lin=2, noclip=0
  endfor


; Now make a hovmuller style psd plot
  plot, indgen(nt), smode1, /nodata, thick=3, xtitle='month', $
   ytitle = 'dvdlnr [!Mm!3m!E3!N !Mm!3m!E-2!N]', yrange=[0.05,15], ystyle=9, /ylog, $
   xrange=[0,nt], xstyle=9
  loadct, 3
  levelarray = [.001, .002, .005, .01, .02, .05, .1, .2, .5, 1]
  plotgrid, transpose(dvdlnr), levelarray, 254-indgen(10)*25, indgen(nt), r, 1., dr
  contour, /overplot, transpose(dvdlnr), indgen(nt), r
  for i = 0, n_elements(a)-1 do begin
   plots, a[i],[.05,15], lin=2, noclip=0
  endfor



  device, /close

  imon = 6
  print, mean(ssa440[imon:143:12],/nan), mean(refr440[imon:143:12],/nan), mean(refi440[imon:143:12],/nan)
  print, mean(ssa670[imon:143:12],/nan), mean(refr670[imon:143:12],/nan), mean(refi670[imon:143:12],/nan)
  print, mean(ssa870[imon:143:12],/nan), mean(refr870[imon:143:12],/nan), mean(refi870[imon:143:12],/nan)
  print, mean(ssa1020[imon:143:12],/nan), mean(refr1020[imon:143:12],/nan), mean(refi1020[imon:143:12],/nan)
  print, mean(angstrom[imon:143:12],/nan)
  print, mean(vmode1[imon:143:12],/nan), mean(rmode1[imon:143:12],/nan), mean(exp(smode1[imon:143:12]),/nan)
  print, mean(vmode2[imon:143:12],/nan), mean(rmode2[imon:143:12],/nan), mean(exp(smode2[imon:143:12]),/nan)

end
