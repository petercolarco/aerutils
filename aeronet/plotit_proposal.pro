; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid = 'g4dust_b55r8'
  years = ['1996','1997','1998','1999','2000','2001','2002','2003']

  if(n_elements(years) eq 1) then begin
   yearstr = years[0]
  endif else begin
   yearstr = years[0]+'_'+years[n_elements(years)-1]
  endelse


  read_mon_mean, expid, years, location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd
  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  filename = './output/plots/aeronet_site.'+expid+'.'+yearstr+'.ps'
  device, file=filename, /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.1,.6,.55,.95]
  position[*,1] = [.65,.6,.95,.95]
  position[*,2] = [.1,.1,.55,.45]
  position[*,3] = [.65,.1,.95,.45]


  nloc = n_elements(location)
  locuse = make_array(nloc,val=0)

; setup the tick marks on the x-axis of date
; What is the frequency of tick marks desired (in months)
  nn = 3
  nt = n_elements(date)
  ntick = nt/nn
  while(ntick gt 60) do begin
   nn = nn*4
   ntick = nt/nn
  endwhile
; Default is to fill in every 4th tick
  tickname=replicate(' ', ntick+1)
  for it = 1, ntick, 4 do begin
   tickname[it] = strmid(strcompress(string(date[it*nn+2]),/rem),0,4)
  endfor


  for iloc = 0, nloc-1 do begin

;  make a plot

   a = where(finite(aotaeronet[*,iloc]) eq 1)
   if(n_elements(a) ge 24) then begin

   locuse[iloc] = 1

;  Find a suitable maximum value
   ymax = max([max(aotaeronet[a,iloc]+aotaeronetstd[a,iloc]),max(aotmodel[a,iloc]+aotmodelstd[a,iloc])])
   loadct, 0
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xticks=ntick, xtickv=(indgen(ntick)+1)*nn, xtickname=tickname, $
    position=position[*,0]
   for i = 0, nt-1 do begin
    x = i+1
    y = aotaeronet[i,iloc]
    yf = aotaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=70
   plots, indgen(nt)+1, aotaeronet[*,iloc], psym=-8, thick=4, lin=2, color=70

   oplot, indgen(nt)+1, aotmodel[*,iloc], thick=4
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='date', ytitle='AOT [550 nm]', title=location[iloc], $
    xticks=ntick, xtickv=(indgen(ntick)+1)*nn, xtickname=tickname, $
    position=position[*,0]



   loadct, 0
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,1], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=150, noclip=0
   oplot, indgen(5)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   plots, aotaeronet[*,iloc], aotmodel[*,iloc], psym=8

;; For a seasonal comparison
;;  J-M
;   a = where(fix(strmid(date,4,2)) le 3)
;   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
;   plots, aotaeronet[a,iloc], aotmodel[a,iloc], psym=8
;
;;  A-J
;   a = where(fix(strmid(date,4,2)) gt 3 and fix(strmid(date,4,2)) le 6)
;   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=176
;   plots, aotaeronet[a,iloc], aotmodel[a,iloc], psym=8
;
;;  J-S
;   a = where(fix(strmid(date,4,2)) gt 6 and fix(strmid(date,4,2)) le 9)
;   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=84
;   plots, aotaeronet[a,iloc], aotmodel[a,iloc], psym=8
;
;;  O-D
;   a = where(fix(strmid(date,4,2)) ge 10)
;   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=254
;   plots, aotaeronet[a,iloc], aotmodel[a,iloc], psym=8

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(aotaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, aotaeronet[a,iloc], aotmodel[a,iloc], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif




   a = where(finite(aotaeronet[*,iloc]) eq 1)
   ymax = max([max(angaeronet[a,iloc]+angaeronetstd[a,iloc]),max(angmodel[a,iloc]+angmodelstd[a,iloc])])
   loadct, 0
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xticks=ntick, xtickv=(indgen(ntick)+1)*nn, xtickname=tickname, $
    position=position[*,2], /noerase
   for i = 0, nt-1 do begin
    x = i+1
    y = angaeronet[i,iloc]
    yf = angaeronetstd[i,iloc]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=70
   plots, indgen(nt)+1, angaeronet[*,iloc], psym=-8, thick=4, lin=2, color=70

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt)+1, angmodel[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
    y = angmodel[i,iloc]
    yf = angmodelstd[i,iloc]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2
     plots, x+[-.5,.5], y+yf, color=0, thick=2
    endif
   endfor
   plot, indgen(nt+1), /nodata, /noerase, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='date', ytitle='!Ma!3!D440-870!N', title=location[iloc], $
    xticks=ntick, xtickv=(indgen(ntick)+1)*nn, xtickname=tickname, $
    position=position[*,2]


   loadct, 0
   plot, indgen(5), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,3], /noerase, $
         xtitle='AERONET', ytitle='Model'
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=150, noclip=0
   oplot, indgen(5)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   plots, angaeronet[*,iloc], angmodel[*,iloc], psym=8

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(angaeronet[*,iloc]) eq 1)
    n = n_elements(a)
    statistics, angaeronet[a,iloc], angmodel[a,iloc], $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif

jump:
  endif

  endfor

; Make a map
  loadct, 0
  map_set, /cont
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nloc-1 do begin
   if(locuse[iloc]) then begin
    plots, longitude[iloc], latitude[iloc], psym=8, noclip=0
    label = location[iloc]
    xyouts, longitude[iloc], latitude[iloc]-1, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
   endif
  endfor


  device, /close

end
