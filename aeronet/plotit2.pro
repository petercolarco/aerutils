; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

; In this version, plot also the relative mass fraction of different constituents at the site.

  read_mon_mean, 't003_c32.v2', ['2000','2001','2002','2003','2004'], location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                     aotmodeldu=aotmodeldu, aotmodelss=aotmodelss, $
                     aotmodelcc=aotmodelcc, aotmodelsu=aotmodelsu

  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  device, file='./output/plots/aeronet_site_mass.DUhalf.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.1,.6,.55,.95]
  position[*,1] = [.65,.65,.95,.95]
  position[*,2] = [.1,.1,.55,.45]
  position[*,3] = [.65,.1,.95,.4]


  nloc = n_elements(location)
  for iloc = 0, nloc-1 do begin

;  make a plot

   a = where(finite(aotaeronet[*,iloc]) eq 1)
   if(n_elements(a) ge 40) then begin

;  Create a control file to go get the mass concentrations
   filename = '/output/colarco/u000_c32_c/diag/u000_c32_c.chem_diag.sfc.'+location[iloc]+'.%y4.nc'
   spawn, 'echo dset ^'+filename+' > test.ctl'
   spawn, 'echo options template >> test.ctl'
   spawn, 'echo tdef time 1827 linear 12z01jan2000 24hr >> test.ctl'
   ga_getvar, 'test.ctl', 'ducmass', ducmass, wanttime=['20000101', '20041231'], time=time
   ga_getvar, 'test.ctl', 'occmass', occmass, wanttime=['20000101', '20041231'], time=time
   ga_getvar, 'test.ctl', 'bccmass', bccmass, wanttime=['20000101', '20041231'], time=time
   ga_getvar, 'test.ctl', 'so4cmass', so4cmass, wanttime=['20000101', '20041231'], time=time
   ga_getvar, 'test.ctl', 'sscmass', sscmass, wanttime=['20000101', '20041231'], time=time
   tmass = ducmass+occmass+bccmass+so4cmass+sscmass
   nt = n_elements(time)
   time_mod = strarr(nt)
   for it = 0, nt-1 do begin
    time_mod[it] = strmid(time[it],0,4)+strmid(time[it],5,2)+strmid(time[it],8,2)+'12'
   endfor
   nm = n_elements(date)
   fmod = fltarr(4,nm)
   for im = 0, nm-1 do begin
    b = where(strmid(time_mod,0,6) eq strmid(date[im],0,6))
    fmod[0,im] = total(ducmass[b])/total(tmass[b])
    fmod[1,im] = total(sscmass[b])/total(tmass[b])
    fmod[2,im] = total(occmass[b]+bccmass[b])/total(tmass[b])
    fmod[3,im] = total(so4cmass[b])/total(tmass[b])
   endfor


;  Find a suitable maximum value
   ymax = max([max(aotaeronet[a,iloc]+aotaeronetstd[a,iloc]),max(aotmodel[a,iloc]+aotmodelstd[a,iloc])])
   loadct, 0
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='date', ytitle='AOT [550 nm]', title=location[iloc], $
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

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, indgen(nt)+1, aotmodel[*,iloc], psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
    y = aotmodel[i,iloc]
    yf = aotmodelstd[i,iloc]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2
     plots, x+[-.5,.5], y+yf, color=0, thick=2
    endif
   endfor

   loadct, 39
   plot, indgen(nt+1), /nodata, $
         yrange=[0,5], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,1], /noerase, $
         xtitle='date', ytitle='species', $
         yticks=3, yminor=1, ytickv=[1,2,3,4], $
         ytickname=['DU', 'SS', 'CC', 'SO!D4!N'], $
         title='Mass Fraction of Aerosol'
   levelarray=[0.01,0.02,0.05,0.1,0.2,0.3,0.5,0.7,0.8,0.9]
   colorarray=[30,64,80,96,144,176,192,199,208,254]
   dx = 1.
   dy = 1.
   lon = indgen(nt)+1
   plotgrid, reform(transpose(fmod[0,*]),60,1), levelarray, colorarray, lon, 1., dx, dy
   plotgrid, reform(transpose(fmod[1,*]),60,1), levelarray, colorarray, lon, 2., dx, dy
   plotgrid, reform(transpose(fmod[2,*]),60,1), levelarray, colorarray, lon, 3., dx, dy
   plotgrid, reform(transpose(fmod[3,*]),60,1), levelarray, colorarray, lon, 4., dx, dy



   a = where(finite(aotaeronet[*,iloc]) eq 1)
   ymax = max([max(angaeronet[a,iloc]+angaeronetstd[a,iloc]),max(angmodel[a,iloc]+angmodelstd[a,iloc])])
   loadct, 0
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='date', ytitle='!Ma!3!D440-870!N', title=location[iloc], $
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


   loadct, 39
   plot, indgen(nt+1), /nodata, $
         yrange=[0,5], $
         xstyle=8, ystyle=8, $
         xthick=3, ythick=3, $
         position=position[*,3], /noerase, $
         xtitle='date', ytitle='species', $
         yticks=3, yminor=1, ytickv=[1,2,3,4], $
         ytickname=['DU', 'SS', 'CC', 'SO!D4!N'], $
         title='AOT Fraction of Aerosol'
   levelarray=[0.01,0.02,0.05,0.1,0.2,0.3,0.5,0.7,0.8,0.9]
   colorarray=[30,64,80,96,144,176,192,199,208,254]
   dx = 1.
   dy = 1.
   lon = indgen(nt)+1
   fdu = reform(aotmodeldu[*,iloc]/aotmodel[*,iloc],60,1)
   fss = reform(aotmodelss[*,iloc]/aotmodel[*,iloc],60,1)
   fcc = reform(aotmodelcc[*,iloc]/aotmodel[*,iloc],60,1)
   fsu = reform(aotmodelsu[*,iloc]/aotmodel[*,iloc],60,1)
   plotgrid, fdu, levelarray, colorarray, lon, 1., dx, dy
   plotgrid, fss, levelarray, colorarray, lon, 2., dx, dy
   plotgrid, fcc, levelarray, colorarray, lon, 3., dx, dy
   plotgrid, fsu, levelarray, colorarray, lon, 4., dx, dy


   makekey, .65, .495, .3, .035, 0, -0.02, color=colorarray, $
     label=string(levelarray,format='(f4.2)'), charsize=.65, align=0

jump:
  endif

  endfor


  device, /close

end
