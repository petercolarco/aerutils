; Colarco, November 2007
; Based on 'plot_annual.pro', this procedure will make a four quadrant map chart
; that displays an icon (up or down) for a comparison of annual average sfc mass
; from the model with the datasets

  expid = 'bR_Fortuna-2_5-b2'
  yearwant = '2008'
  filename = '/misc/prc11/colarco/'+expid+'/tavg2d_aer_x/Y'+yearwant+'/'+expid+'.tavg2d_aer_x.annual.'+yearwant+'.nc4'
  plot_surfacemap = 1
  read_mon_mean, expid, yearwant, locations, lat, lon, date, $
                     dusmass, sssmass, so4smass, bcsmass, ocsmass, $
                     dusmassStd, sssmassStd, so4smassStd, bcsmassStd, ocsmassStd, $
                     dusm25, dusm25Std, sssm25, sssm25Std, $
                     duaeroce, duaerocestd, ssaeroce, ssaerocestd, $
                     so4emep, so4emepstd, $
                     so4improve, so4improvestd, ssimprove, ssimprovestd, $
                     bcimprove, bcimprovestd, ocimprove, ocimprovestd

; Now massage the fields to come up with an array of annual averages

; dust
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(duaeroce[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     dudata = mean(duaeroce[a,iloc])
     dumod  = mean(dusmass[a,iloc])
     londu  = lon[iloc]
     latdu  = lat[iloc]
     ifirst = 0
    endif else begin
     dudata = [dudata, mean(duaeroce[a,iloc])]
     dumod  = [dumod,  mean(dusmass[a,iloc])]
     londu  = [londu, lon[iloc]]
     latdu  = [latdu, lat[iloc]]
    endelse
   endif
  endfor


; seasalt (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ssimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ssdata_imp = mean(ssimprove[a,iloc])
;     ssmod_imp  = mean(sssm25[a,iloc])
     ssmod_imp  = mean(sssmass[a,iloc])
     ifirst = 0
     lonss_imp  = lon[iloc]
     latss_imp  = lat[iloc]
    endif else begin
     ssdata_imp = [ssdata_imp, mean(ssimprove[a,iloc])]
;     ssmod_imp  = [ssmod_imp,  mean(sssm25[a,iloc])]
     ssmod_imp  = [ssmod_imp,  mean(sssmass[a,iloc])]
     lonss_imp  = [lonss_imp, lon[iloc]]
     latss_imp  = [latss_imp, lat[iloc]]
    endelse
   endif
  endfor

; seasalt (aeroce)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ssaeroce[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ssdata_aeroce = mean(ssaeroce[a,iloc])
     ssmod_aeroce  = mean(sssmass[a,iloc])
     lonss_aeroce  = lon[iloc]
     latss_aeroce  = lat[iloc]
     ifirst = 0
    endif else begin
     ssdata_aeroce = [ssdata_aeroce, mean(ssaeroce[a,iloc])]
     ssmod_aeroce  = [ssmod_aeroce,  mean(sssmass[a,iloc])]
     lonss_aeroce  = [lonss_aeroce, lon[iloc]]
     latss_aeroce  = [latss_aeroce, lat[iloc]]
    endelse
   endif
  endfor

; sulfate (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(so4improve[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     so4data_imp = mean(so4improve[a,iloc])
     so4mod_imp  = mean(so4smass[a,iloc])
     lonsu_imp  = lon[iloc]
     latsu_imp  = lat[iloc]
     ifirst = 0
    endif else begin
     so4data_imp = [so4data_imp, mean(so4improve[a,iloc])]
     so4mod_imp  = [so4mod_imp,  mean(so4smass[a,iloc])]
     lonsu_imp  = [lonsu_imp, lon[iloc]]
     latsu_imp  = [latsu_imp, lat[iloc]]
    endelse
   endif
  endfor

; sulfate (emep)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(so4emep[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     so4data_emep = mean(so4emep[a,iloc])
     so4mod_emep  = mean(so4smass[a,iloc])
     lonsu_emep  = lon[iloc]
     latsu_emep  = lat[iloc]
     ifirst = 0
    endif else begin
     so4data_emep = [so4data_emep, mean(so4emep[a,iloc])]
     so4mod_emep  = [so4mod_emep,  mean(so4smass[a,iloc])]
     lonsu_emep  = [lonsu_emep, lon[iloc]]
     latsu_emep  = [latsu_emep, lat[iloc]]
    endelse
   endif
  endfor

; black carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(bcimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     bcdata = mean(bcimprove[a,iloc])
     bcmod  = mean(bcsmass[a,iloc])
     loncc  = lon[iloc]
     latcc  = lat[iloc]
     ifirst = 0
    endif else begin
     bcdata = [bcdata, mean(bcimprove[a,iloc])]
     bcmod  = [bcmod,  mean(bcsmass[a,iloc])]
     loncc  = [loncc, lon[iloc]]
     latcc  = [latcc, lat[iloc]]
    endelse
   endif
  endfor

; organic carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ocimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ocdata = mean(ocimprove[a,iloc])
     ocmod  = mean(ocsmass[a,iloc])
     ifirst = 0
    endif else begin
     ocdata = [ocdata, mean(ocimprove[a,iloc])]
     ocmod  = [ocmod,  mean(ocsmass[a,iloc])]
    endelse
   endif
  endfor


  set_plot, 'ps'
  device, file = './output/plots/plot_maps.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=18, yoff=.5
  !P.font=0
  position = fltarr(4,4)
  position[*,0] = [.025,.575,.475,.95]
  position[*,1] = [.525,.575,.975,.95]
  position[*,2] = [.025,.125,.475,.5]
  position[*,3] = [.525,.125,.975,.5]

  loadct, 0

; Dust
  map_set, limit=[-80,-180,80,180], position=position[*,0]
  if(plot_surfacemap) then begin
   ga_getvar, filename, 'dusmass', dusmass, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area
   levelarray = [1,2,5,10,20,50,100,200,500]
   colorarray = 220 - findgen(9)*200/9
   plotgrid, dusmass*1e9, levelarray, colorarray, lon, lat, dx, dy, /map
   map_set, limit=[-80,-180,80,180], position=position[*,0], /noerase
   map_continents, thick=1.5, color=160
   makekey, .05, .575, .4, .025, 0, -0.015, $
    color=[255,colorarray], label=[' ',strcompress(string(levelarray),/rem)], $
    charsize=0.75
  endif else begin
   map_continents, thick=1.5, color=160
  endelse
  ratio = dumod/dudata
  plot_ratio, ratio, londu, latdu, color=0, /length
  xyouts, .025, .96, /normal, 'Dust [!Mm!3g m!E-3!N]'
  xyouts, .475, .96, /normal, align=1, 'AEROCE', charsize=.75


; Sea Salt
  map_set, limit=[-80,-180,70,180], position=position[*,1], /noerase
  if(plot_surfacemap) then begin
   ga_getvar, filename, 'sssmass', dusmass, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area
   levelarray = [1,2,5,10,20,50,100,200]
   colorarray = 220 - findgen(8)*200/8
   plotgrid, dusmass*1e9, levelarray, colorarray, lon, lat, dx, dy, /map
   map_set, limit=[-80,-180,80,180], position=position[*,1], /noerase
   map_continents, thick=1.5, color=160
   makekey, .55, .575, .4, .025, 0, -0.015, $
    color=[255,colorarray], label=[' ',strcompress(string(levelarray),/rem)], $
    charsize=0.75
  endif else begin
   map_continents, thick=1.5, color=160
  endelse
; Improve
;  ratio = ssmod_imp/ssdata_imp
;  plot_ratio, ratio, lonss_imp, latss_imp, color=0, /length
; Aeroce
  ratio = ssmod_aeroce/ssdata_aeroce
  plot_ratio, ratio, lonss_aeroce, latss_aeroce, color=0, /length
  xyouts, .525, .96, /normal, 'Sea Salt [!Mm!3g m!E-3!N]'
  xyouts, .975, .96, /normal, align=1, 'AEROCE', charsize=.75
  xyouts, .9, .96, /normal, align=1, 'IMPROVE', color=120, charsize=.75



; Sulfate
  map_set, limit=[-10,-160,70,40], position=position[*,2], /noerase
  if(plot_surfacemap) then begin
   ga_getvar, filename, 'so4smass', dusmass, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area
   levelarray = [0.1,0.2,0.5,1,2]
   colorarray = 220 - findgen(5)*200/5
   plotgrid, dusmass*1e9 / 3., levelarray, colorarray, lon, lat, dx, dy, /map
   map_set, limit=[-10,-160,70,40],  position=position[*,2], /noerase
   map_continents, thick=1.5, color=160
   makekey, .05, .125, .4, .025, 0, -0.015, $
    color=[255,colorarray], label=[' ',strcompress(string(levelarray,format='(f3.1)'),/rem)], $
    charsize=0.75
  endif else begin
   map_continents, thick=1.5, color=160
  endelse
; Improve
;  ratio = so4mod_imp/so4data_imp
;  plot_ratio, ratio, lonsu_imp, latsu_imp, color=0, /length
; Aeroce
;  ratio = ssmod_aeroce/ssdata_aeroce
;  plot_ratio, ratio, lonsu_emep, latsu_emep, color=0, /length
  xyouts, .025, .51, /normal, 'Sulfate'
  xyouts, .475, .51, /normal, align=1, 'EMEP', charsize=.75
  xyouts, .4, .51, /normal, align=1, 'IMPROVE', color=120, charsize=.75


; Carbonaceous
  map_set, limit=[-10,-160,70,0], position=position[*,3], /noerase
  if(plot_surfacemap) then begin
   ga_getvar, filename, 'ocsmass', ocsmass, lon=lon, lat=lat
   ga_getvar, filename, 'bcsmass', bcsmass, lon=lon, lat=lat
   ccsmass = ocsmass+bcsmass
   area, lon, lat, nx, ny, dx, dy, area
   levelarray = [0.1,0.2,0.5,1,2,5]
   colorarray = 220 - findgen(6)*200/6
   plotgrid, ccsmass*1e9, levelarray, colorarray, lon, lat, dx, dy, /map
   map_set, limit=[-10,-160,70,0], position=position[*,3], /noerase
   map_continents, thick=1.5, color=160
   makekey, .55, .125, .4, .025, 0, -0.015, $
    color=[255,colorarray], label=[' ',strcompress(string(levelarray,format='(f3.1)'),/rem)], $
    charsize=0.75
  endif else begin
   map_continents, thick=1.5, color=160
  endelse
; Improve - model already in POM
;  ratio = (ocmod+bcmod)/(1.4*ocdata+bcdata)
;  plot_ratio, ratio, loncc, latcc, color=0, /length
  xyouts, .525, .51, /normal, 'Carbonaceous'
  xyouts, .975, .51, /normal, align=1, 'IMPROVE', charsize=.75, color=0



; If doing length, the plot a scale at the bottom
  length=1
  if(length) then begin
   scale = -4
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .065,.06, psym=8, /normal
   xyouts, .08, .055, /normal, '< 0.01', charsize=.75

   scale = -3
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .165,.06, psym=8, /normal
   xyouts, .18, .055, /normal, '0.01 - 0.1', charsize=.75

   scale = -2
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .265,.06, psym=8, /normal
   xyouts, .28, .055, /normal, '0.1 - 0.2', charsize=.75

   scale = -1
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .365,.06, psym=8, /normal
   xyouts, .38, .055, /normal, '0.2 - 0.5', charsize=.75


   usersym, [-1,1,0,0,0], [0,0,0,1,-1], thick=8
   plots, .485,.06, psym=8, /normal
   xyouts, .5, .055, /normal, '0.5 - 2', charsize=.75


   scale = 4
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .9,.06, psym=8, /normal
   xyouts, .915, .055, /normal, '> 100', charsize=.75

   scale = 3
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .8,.06, psym=8, /normal
   xyouts, .815, .055, /normal, '10 - 100', charsize=.75

   scale = 2
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .7,.06, psym=8, /normal
   xyouts, .715, .055, /normal, '5 - 10', charsize=.75

   scale = 1
   usersym, [-1,0,1,0,0]*scale, [.5,1.5,.5,1.5,-1.5]*scale, thick=8
   plots, .6,.06, psym=8, /normal
   xyouts, .615, .055, /normal, '2 - 5', charsize=.75

  endif


  device, /close


end

