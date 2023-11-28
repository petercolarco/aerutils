; Colarco
; For a specified region, compute from the satellite observations the
; areal coverage of aot (or coarse aot) greater than some value.
; Do this for daily statistics

; Initialization
  threshaot = findgen(10)*.1 + .1
  nthresh   = n_elements(threshaot)
  lon0want  = -50.
  lon1want  = 0.
  lat0want  = 10.
  lat1want  = 30.

  nyr   = 11
  years = strpad(indgen(nyr)+2000,1000L)

  for iyr = 0, nyr-1 do begin

  nymd0 = years[iyr]+'0615'
  nhms0 = '120000'
  nymd1 = years[iyr]+'1015'
  nhms1 = '120000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms
  nt = n_elements(nymd)

  aotarea_ = make_array(nt,nthresh,val=!values.f_nan)
  areat_   = make_array(nt,val=0.)

; Get the area array
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  a = where(lon ge lon0want and lon le lon1want)
  b = where(lat ge lat0want and lat le lat1want)
  area = area[a,*]
  area = area[*,b]

; MODIS --------------------
; Read a dataset of daily aot
  for it = 0, nt-1 do begin

   ctlfile  = '/misc/prc10/MODIS/Level3/MOD04/d/GRITAS/Y%y4/M%m2/'+ $
              'MOD04_L2_ocn.aero_tc8_051.qawt.%y4%m2%d2dd.nc4'
   filename = strtemplate(ctlfile,nymd[it],nhms[it])
   print, filename
   nc4readvar, filename, 'aodtau', tau, lev=lev, wantlev=550., $
               wantlon=[lon0want,lon1want], wantlat=[lat0want,lat1want]

;  Check there is some data
   b = where(tau lt 1e14)
   if(b[0] ne -1) then begin
    areat_[it] = total(area[b])/total(area)
    for itr = 0, nthresh-1 do begin
     a = where(tau ge threshaot[itr] and tau lt 1e14)
     if(a[0] ne -1) then aotarea_[it,itr] = total(area[a])/total(area[b]) $
      else aotarea_[it,itr] = 0.
    endfor
   endif
  endfor

  if(iyr eq 0) then aotarea = aotarea_ else aotarea = [aotarea,aotarea_]
  if(iyr eq 0) then areat   = areat_ else areat = [areat,areat_]


  endfor

  aotarea = reform(aotarea,nt,nyr,nthresh)
  areat   = reform(areat,nt,nyr)

jump:
; MODEL --------------------
  nyrm   = 4
  years = strpad(indgen(nyr)+2007,1000L)

  for iyr = 0, nyrm-1 do begin

  nymd0 = years[iyr]+'0615'
  nhms0 = '120000'
  nymd1 = years[iyr]+'1015'
  nhms1 = '120000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms
  nt = n_elements(nymd)

  aotaream_ = make_array(nt,nthresh,val=!values.f_nan)

; Read a dataset of daily aot
  for it = 0, nt-1 do begin

   ctlfile  = '/misc/prc15/colarco/dR_Fortuna-2-4-b4/inst2d_hwl_x/Y%y4/M%m2/'+ $
              'dR_Fortuna-2-4-b4.inst2d_hwl_x.%y4%m2%d2_1200z.nc4'
   filename = strtemplate(ctlfile,nymd[it],nhms[it])
   print, filename
   nc4readvar, filename, 'duexttau', tau, $
               wantlon=[lon0want,lon1want], wantlat=[lat0want,lat1want]

;  Check there is some data
   b = where(tau lt 1e14)
   if(b[0] ne -1) then begin
    for itr = 0, nthresh-1 do begin
     a = where(tau ge threshaot[itr] and tau lt 1e14)
     if(a[0] ne -1) then aotaream_[it,itr] = total(area[a])/total(area[b]) $
      else aotaream_[it,itr] = 0.
    endfor
   endif
  endfor

  if(iyr eq 0) then aotaream = aotaream_ else aotaream = [aotaream,aotaream_]


  endfor

  aotaream = reform(aotaream,nt,nyrm,nthresh)

  set_plot, 'ps'
  !p.font = 0
  loadct, 39

  for itr = 0, nthresh-1 do begin

   device, file='tropatl.thresh='+strpad(itr+1,10)+'.ps', /color
   tmp  = aotarea[*,*,itr]
   tmpm = aotaream[*,*,itr]
   tmpa = areat

;  Smooth (7-day filter)
   for iyr = 0, nyr-1 do begin
    tmp[*,iyr]  = smooth(tmp[*,iyr],7)
    tmpa[*,iyr] = smooth(tmpa[*,iyr],7)
   endfor
   for iyr = 0, nyrm-1 do begin
    tmpm[*,iyr]  = smooth(tmpm[*,iyr],7)
   endfor
   xticks=9
   plot, [0,124], [0,1], /nodata, $
    xstyle=9, ystyle=9, ytitle='fractional area', $
    xticks=8, xminor=1, $
    xtickv=[1,17,31,48,62,79,93,109,123], $
    xtickn=['Jun 15','Jul 1','Jul 15','Aug 1',$
            'Aug 15','Sep 1','Sep 15','Oct 1','Oct 15']
   polymaxmin, indgen(123)+1, tmp, color=255, fillcolor=75
   oplot, indgen(123)+1, total(tmpm,2)/nyrm, thick=6
;   polymaxmin, indgen(123)+1, tmpm, color=255, fillcolor=208
  
   device, /close
  endfor

  end
 
