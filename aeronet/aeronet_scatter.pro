goto, jump
; Read the database of aeronet locations
  openr, lun, 'aeronet_locs.dat', /get_lun
  a = 'a'
  i = 0 
  while(not eof(lun)) do begin
   readf, lun, a
   strparse = strsplit(a,' ',/extract)
   if(strpos(strparse[0],'#') eq -1) then begin
    location_ = strparse[0]
    lat_ = float(strparse[1]) + float(strparse[2])/60. + float(strparse[3])/3600.
    lon_ = float(strparse[4]) + float(strparse[5])/60. + float(strparse[6])/3600.
    ele_ = float(strparse[7])
    if(i eq 0) then begin
     location = location_
     lat = lat_
     lon = lon_
     ele = ele_
    endif else begin
     location = [location,strparse[0]]
     lat = [lat, lat_]
     lon = [lon, lon_]
     ele = [ele, ele_]
    endelse
    i = i+1
   endif
  endwhile
  free_lun, lun
  nlocs = n_elements(location)
  aotaeronet = fltarr(8760,nlocs)
  angaeronet = fltarr(8760,nlocs)
  aotmodel   = fltarr(8760,nlocs)
  angmodel   = fltarr(8760,nlocs)

; From previous run, only these sites are good
  vloc = [ $
   5,  10,  20,  21,  22,  23,  28,  29,  30,  32,  34,  35,  39,  40,  41, $
  49,  50,  51,  53,  56,  59,  60,  67,  68,  69,  70,  73,  78,  80,  83,  85, $
  88,  92,  94,  95,  96, 100, 101, 103, 105, 106, 108, 117, 119, 120, 123, 124, $
 126, 127, 131, 133, 137, 139, 143, 151, 153, 154, 156, 271, 272, 274, 275, 276, $
 279, 285, 287, 290, 295, 297, 298, 300, 301, 303, 304, 310, 312, 314, 318, 319, $
 320, 328, 330, 337, 339, 340, 342, 343, 344, 345, 346, 347, 353, 354, 359, 361, $
 362, 363, 365, 366, 369, 370, 372, 373, 376, 377, 378, 379, 380, 382, 383, 386, $
 389, 392, 393, 394, 395, 398, 400, 401, 406, 415, 420, 421, 424, 427, 430, 431, $
 432, 433, 434, 441, 442, 443, 444, 446, 448, 454, 455, 456, 457, 458, 459, 463, $
 465, 466, 467, 470, 472, 477, 479, 484, 485, 487, 491, 492, 495, 498, 502, 505, $
 506, 507, 509, 512, 513, 514, 515, 516, 518, 521, 524, 526, 529, 532, 534, 535, $
 545, 546, 548, 550, 551, 560, 562, 567, 570, 573, 576, 579, 581, 582, 585, 587, $
 590, 592, 605, 609, 610, 611, 616, 618, 620, 621, 626, 630, 632, 638, 639, 647, $
 651, 657, 660, 661, 662, 666, 667, 668, 670, 672, 673, 674, 677, 679, 682, 684, $
 695, 698, 700, 702, 704, 705, 707, 714, 716, 717, 720, 723, 726, 727, 728, 730, $
 732, 733, 734, 736, 737, 739, 743, 751, 755, 756, 759, 761, 765, 766, 769, 771, $
 772, 773, 774, 775, 776, 778, 780, 790, 792]

  nlocs = n_elements(vloc)

; Now loop over the locations
  YYYY = '2009'
  spawn, 'echo $AERONETDIR', headDir
  aerPath = headDir+'LEV30/'
  lambdabase = '550'
  exppath = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/aeronet/'
  expid   = 'dR_MERRA-AA-r2.inst2d_hwl.aeronet'
  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']
 
  for ii = 0, nlocs-1 do begin
     iloc = vloc[ii]
     print, location[iloc], yyyy, iloc+1, '/', nlocs
     locwant = location[iloc]

;    read in the aeronet aot and angstrom exponents
     angstromaeronetIn = 1.
     angstrommodel = 1.
     read_aeronet2nc, aerPath, locwant, lambdabase, yyyy, aotaeronetIn, dateaeronet, $
                      angpair=1, angstrom=angstromaeronetIn, naot=naotaeronet, $
                      /hourly
     aotaeronet[*,iloc] = aotaeronetIn
     angaeronet[*,iloc] = angstromaeronetIn

     readmodel, exppath, expid, yyyy, locwant, lambdabase, ['totexttau'], aotModelIn, dateModel
     readmodel, exppath, expid, yyyy, locwant, lambdabase, ['totangstr'], angModelIn, dateModel
     aotModel[*,iloc] = aotModelIn
     angModel[*,iloc] = angModelIn

  endfor

  a = where(aotaeronet le 0)
  aotaeronet[a] = !values.f_nan
  aotmodel[a]   = !values.f_nan

  a = where(angaeronet le 0)
  angaeronet[a] = !values.f_nan
  angmodel[a]   = !values.f_nan

  save, /all, filename = 'global_hourly.sav'




jump:
  restore, 'global_hourly.sav'

; Find sites in region
  a = where(lon ge -100 and lon le 60 and $
            lat ge -20 and lat le 45)
  aotaeronet = aotaeronet[*,a]
  angaeronet = angaeronet[*,a]
  aotmodel = aotmodel[*,a]
  angmodel = angmodel[*,a]
goto, jump2
; And now do a daily average
  n = n_elements(a)
  aotaeronet_ = fltarr(365,n)
  angaeronet_ = fltarr(365,n)
  aotmodel_   = fltarr(365,n)
  angmodel_   = fltarr(365,n)
  dateaeronet_= lonarr(365)
  for i = 0, 364 do begin
   for j = 0, n-1 do begin
    aotaeronet_[i,j] = mean(aotaeronet[i*24:i*24+23,j],/nan)
    angaeronet_[i,j] = mean(angaeronet[i*24:i*24+23,j],/nan)
    aotmodel_[i,j] = mean(aotmodel[i*24:i*24+23,j],/nan)
    angmodel_[i,j] = mean(angmodel[i*24:i*24+23,j],/nan)
    dateaeronet_[i]= dateaeronet[i*24]
   endfor
  endfor
  aotaeronet = aotaeronet_
  angaeronet = angaeronet_
  aotmodel = aotmodel_
  angmodel = angmodel_
  dateaeronet = dateaeronet_

; And now pick off only July
  a = where(dateaeronet/10000L eq 200907L)
  aotaeronet = aotaeronet[a,*]
  angaeronet = angaeronet[a,*]
  aotmodel   = aotmodel[a,*]
  angmodel   = angmodel[a,*]
  dateaeronet= dateaeronet[a]

jump2:
; regional, daily, monthly
;  level = [1,2,3,4,5,6,7,8,10]

; global, hourly, monthly
;  level = [1,2,5,10,20,30,40,50,80]

; global, hourly, annual
  level = [1,2,5,10,20,40,100,200,500]

  set_plot, 'ps'
  device, file='global_daily_annual.ps', /color, font_size=12, /helvetica, $
   xoff=.5, yoff=.5, xsize=30, ysize=12
  !p.font=0

  red   = [0,255,237,199,127,65,29,34,37,8,      0, 255]
  green = [0,255,248,233,205,182,145,94,52,29,   0, 255]
  blue  = [0,217,177,180,187,196,192,168,148,88, 0, 255]
  tvlct, red, green, blue
  dcolors = indgen(9)+1
  iwhite  = n_elements(red)-1
  iblack  = n_elements(red)-2

  x = aotaeronet
  y = aotmodel
  ymax = 1.
  plot, indgen(3), /nodata, $
    xrange=[0,ymax], color=iblack, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='AERONET', ytitle='MERRAero', title='AOD [550 nm]', $
    position=[.075,.1,.4,.925]
  result = hist_2d(x,y,min1=0.,min2=0.,max1=ymax,max2=ymax,bin1=.01,bin2=.01)
  print, total(result), max(result)

  xx = findgen(101)*.01
  plotgrid, result, level, dcolors, xx, xx, .01, .01
  
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2, color=iblack
;   plots, [0,ymax], [0,0.5*ymax], lin=1, thick=2, color=iblack
;   plots, [0,0.5*ymax], [0,ymax], lin=1, thick=2, color=iblack

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(finite(x))
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
;    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0, color=iblack
    n = strcompress(string(n, format='(i7)'),/rem)
    r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.6,.6,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=iwhite, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.75, color=iblack
    xyouts, .05*scale, .85*scale, 'r!E2!N = '+r2, charsize=.75, color=iblack
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.75, color=iblack
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.75, color=iblack
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.75, color=iblack
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
;    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.75, color=iblack
   endif







  x = angaeronet
  y = angmodel
  ymax = 3.
  plot, indgen(3), /nodata, /noerase, $
    xrange=[0,ymax], color=iblack, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='AERONET', ytitle='MERRAero', title='Angstrom Parameter [470 - 870 nm]', $
    position=[.5,.1,.825,.925]
  result = hist_2d(x,y,min1=0.,min2=0.,max1=ymax,max2=ymax,bin1=.03,bin2=.03)
  print, total(result), max(result)

  xx = findgen(101)*.03
  plotgrid, result, level, dcolors, xx, xx, .03, .03
  
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2, color=iblack
;   plots, [0,ymax], [0,0.5*ymax], lin=1, thick=2, color=iblack
;   plots, [0,0.5*ymax], [0,ymax], lin=1, thick=2, color=iblack

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(finite(x))
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
;    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0, color=iblack
    n = strcompress(string(n, format='(i7)'),/rem)
    r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=iwhite, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.75, color=iblack
    xyouts, .05*scale, .85*scale, 'r!E2!N = '+r2, charsize=.75, color=iblack
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.75, color=iblack
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.75, color=iblack
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.75, color=iblack
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
;    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.75, color=iblack
   endif

   makekey, .875, .1, .05, .825, .06, 0, $
    colors=(make_array(n_elements(level),val=iblack)), $
    labels=strcompress(string(level),/rem), orientation=1, align=0
   makekey, .875, .1, .05, .825, .06, 0, $
    colors=dcolors, $
    labels=make_array(n_elements(level),val=' '), orientation=1, align=0

   device, /close

end
