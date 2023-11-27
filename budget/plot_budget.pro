; Colarco, January 2006
; Read the FVGCM diagnostic (sfc) fields and make monthly plots
; of the emission, deposition, etc. budgets
; Pass in the experiment path, experiment id (name), the desired year,
; and the information about the diagnostic file name.
; For every monthly mean available for that year a plot is made.

  pro plot_budget, expctl, expid, aertype, year, carma=carma, $
                   wantlon=wantlon, wantlat=wantlat, region=region, $
                   oldscav=oldscav, gocart2g=gocart2g

  regionstr = '.'
  if(keyword_set(region)) then regionstr = '.'+region+'.'

 !quiet = 1l

  ndaysmon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  year = strcompress(string(year),/rem)
  if(fix(year)/4 eq fix(year)/4.) then ndaysmon[1] = 29

  plot_title = 'GEOS ('+expid+') '+aertype+' '
  plot_file = './output/plots/geos_budget.'+expid+regionstr+aertype+'.'+year+'.ps'
  cmd = 'mkdir -p ./output/plots'
  spawn, cmd, /sh

; Note conversion right here to g m-2 day-1
  convfac_ = 1000.*86400  ; convert kg m-2 s-1 to g m-2 day-1

  case aertype of
   'DIAG': begin
           vars = ['precipls','precipcu','precipsno','preciptot','t2m', $
                   'cldtt','cldlo','cldmd','cldhi']
           end
   'TOT':  begin
           vars = ['tau','ssa','tauabs']
           end
   'BC':   begin
           vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman']
;           vars = ['emis','dep','wet','scav','load','tau']
           end
   'POM':  begin
           levelarray = [.01,.02,.05,.1,.2,.5,1]
           formcode = '(f5.2)'
           vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman','embg','psoa']
;           vars = ['emis','dep','wet','scav','load','tau','embbbo','embbnb']
           end
   'BRC':  begin
           levelarray = [.01,.02,.05,.1,.2,.5,1]
           formcode = '(f5.2)'
           vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman','embg','psoa']
           end
   'SM':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
           end
   'DU':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
           end
   'DZ':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
           end
   'SS':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25','tau','ssa','tauabs','taufrac']
           end
   'SU':   begin
           vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms', $
                   'emisvolcn', 'emisvolce','tau','ssa','tauabs','taufrac']
;           vars = ['emis','emisso2','emisdms','dep','depso2','wet',$
;                   'pso4g','pso4liq','pso2','load','loadso2','loaddms','tau']
           end
  'SUV':   begin
           vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms', $
                   'emisvolcn', 'emisvolce','tau','ssa','tauabs','taufrac']
           end
  'NI':    begin
           vars = ['emisnh3','pno3aq','pno3ht','depnh3','depnh4','depno3','sednh4',$
                   'sed','scavnh4','scavno3','wetnh3','wetnh4','wetno3', $
                   'load','tau','ssa','tauabs','taufrac']
           end
   'CO':   begin
           vars = ['emis','prod','loss','load']
           end
  'CO2':   begin
           vars = ['emis','load']
           end
  endcase

  npage = n_elements(vars)


; Default assumption is that we request global fields
  nymd = year+'0115'
  nhms = 120000
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, '', varval, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area

  geolimit = [-70,-180,80,180]
  map = 1
  lona = lon
  lata = lat

; In the case that the requested region is not global, reduce area accordingly
  if(keyword_set(wantlon) or keyword_set(wantlat)) then begin
   nc4readvar, filename, '', varv, lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat
   a = where(lona ge min(lon) and lona le max(lon))
   area = area[a,*]
   a = where(lata ge min(lat) and lata le max(lat))
   area = area[*,a]
   if(max(lat)+dy/2. gt 90. or min(lat)-dy/2. lt -90.) then map=1 else map=0
   if(keyword_set(wantlon) and keyword_set(wantlat)) then $
    geolimit=[min(lat),min(lon),max(lat),max(lon)]
  endif

  set_plot, 'ps'
  device, filename=plot_file, /landscape, xoff=.5, yoff=26, $
   xsize=25, ysize=18, /helvetica, font_size=12, /color
  !P.font=0
  position = fltarr(4,3,4)
  position[*,0,0] = [.075,.725,.35,.9]
  position[*,1,0] = [.375,.725,.65,.9]
  position[*,2,0] = [.675,.725,.95,.9]

  position[*,0,1] = [.075,.5,.35,.675]
  position[*,1,1] = [.375,.5,.65,.675]
  position[*,2,1] = [.675,.5,.95,.675]

  position[*,0,2] = [.075,.275,.35,.45]
  position[*,1,2] = [.375,.275,.65,.45]
  position[*,2,2] = [.675,.275,.95,.45]

  position[*,0,3] = [.075,.05,.35,.225]
  position[*,1,3] = [.375,.05,.65,.225]
  position[*,2,3] = [.675,.05,.95,.225]

  position = reform(position,4,12)  

; Check type for colortable
  loadct, 3
  noborder = 0
  if(aertype eq 'TOT' or aertype eq 'DIAG') then begin
   loadct, 39
   noborder=1
  endif

  cmd = 'mkdir -p ./output/tables'
  spawn, cmd, /sh
  openw, lun, './output/tables/budget.'+expid+regionstr+aertype+'.'+year+'.txt', /get_lun

  for ipage = 0, npage-1 do begin
   noerase = 0
   anntot = 0.

   dateWant = year+['01', '12']
   rc = 0
   print, 'Getting: '+aertype+' '+vars[ipage]+', '+datewant

   nmon = 0
;  Greenish
   red   = [246,208,166,103,54,2,1]
   blue  = [239,209,189,169,144,129]
   green = [247,230,219,207,192,138,80]
;  Reddish
   red   = [254,253,253,253,241,217,140]
   green = [237,208,174,141,105,72,45]
   blue  = [222.162,107,60,19,1,4]

   for imon = 0, 11 do begin

;   Determine the filename to read
    mm = strpad(imon+1,10)
    nymd = year+mm+'15'
    nhms = 120000
    filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
    varwant = vars[ipage]
    diverge = 0
    if(not(keyword_set(carma))) then begin
     read_geos_diag, filename, varWant, varValue, $
                     varTitle, varunits, levelarray, labelarray, formcode, $
                     lon=lon, lat=lat, diverge=diverge, $
                     wantlon=wantlon, wantlat=wantlat, type=aertype, $
                     oldscav=oldscav, gocart2g=gocart2g, rc=rc
    endif else begin
     read_carma_diag, filename, varWant, varValue, $
                      varTitle, varunits, levelarray, labelarray, formcode, $
                      lon=lon, lat=lat, $
                      wantlon=wantlon, wantlat=wantlat, type=aertype, rc=rc
    endelse

    colorarray = 220-findgen(n_elements(levelarray))*(220./n_elements(levelarray))
    if(aertype eq 'TOT') then colorarray = findgen(100)*2.5
    if(aertype eq 'DIAG') then colorarray = findgen(100)*2 + 40
    if(n_elements(levelarray) gt 10) then noborder = 1

;   If the variable not read from the file, still need to write something
;   to the output table.
;   The get out of loop
    if(rc ne 0) then begin
     printf, lun, imon+1, ' 0.0'
     continue
    endif

    ndays = ndaysmon[imon]

;   scale monthly mean value by number of days
    convfac = convfac_*ndays

;   if load2d then don't multiply by days
    if(strmid(vars[ipage],0,4) eq 'load') then convfac = convfac / (ndays*86400.)
    if(strmid(vars[ipage],0,3) eq 'tau')  then convfac = 1.
    if(strmid(vars[ipage],0,3) eq 'ssa')  then convfac = 1.
    if(aertype eq 'DIAG') then convfac = 1.

    map_set, limit=geolimit, position=position[*,imon], noerase=noerase
    noerase = 1

;   Check to flip the levelarray
    levelarray_ = levelarray
    colorarray_ = colorarray
    nel = n_elements(levelarray)
    if(levelarray[0] gt levelarray[nel-1]) then begin
     levelarray_ = reverse(levelarray)
     colorarray_ = reverse(colorarray)
    endif
    if(not(keyword_set(labelarray))) then labelarray=string(levelarray_,format=formcode)

;   Override colors for diverging sequence (assume 7 intervals)
    if(diverge) then begin
     red   = [33,103,209,247,253,239,178]
     green = [102,169,229,247,219,138,24]
     blue  = [172,207,240,247,199,98,43]
    endif
    tvlct, red, green, blue
    dcolors=indgen(n_elements(red))
    dcolors_ = dcolors
    if(strmid(vars[ipage],0,3) eq 'ssa') then dcolors_=reverse(dcolors_)
    
    plotgrid, varvalue*convfac, levelarray_, dcolors_, lon, lat, dx, dy, map=map
    loadct, 0
;   For DIAG case
    if(aertype eq 'DIAG') then begin
     xyouts, position[2,imon],position[3,imon]+.01, /normal, align=1, $
      string(total(varvalue*area)/total(area), $
      format='(f8.2)')+' '+varunits, charsize=.7
     anntot = anntot + total(varValue*area)/total(area)
     printf, lun, imon+1, total(varvalue*area)/total(area)
    endif else begin
;    For all cases but AOT and SSA
     if(strmid(vars[ipage],0,3) ne 'tau' and strmid(vars[ipage],0,3) ne 'ssa') then begin
      xyouts, position[2,imon],position[3,imon]+.01, /normal, align=1, $
       string(total(varvalue*convfac*area)/(1.e12), $
       format='(f8.2)')+' Tg', charsize=.7
      anntot = anntot + total(varValue*convfac*area)/1.e12
      printf, lun, imon+1, total(varValue*convfac*area)/1.e12
     endif else begin
;    For case of AOT and SSA
      xyouts, position[2,imon],position[3,imon]+.01, /normal, align=1, $
       string(total(varvalue*convfac*area)/total(area), $
       format='(f8.4)'), charsize=.7
      anntot = anntot + total(varValue*convfac*area)/total(area)
      printf, lun, imon+1, total(varValue*convfac*area)/total(area)
     endelse
    endelse
    xyouts, position[0,imon],position[3,imon]+.01, /normal, year+mm, $
    charsize=.7

    map_continents, thick=1.5
    map_continents, /countries
    map_set, limit=geolimit, position=position[*,imon], noerase=noerase
    if(strmid(vars[ipage],0,4) eq 'load') then convfac = convfac * (ndays*86400.)
    if(strmid(vars[ipage],0,3) eq 'tau')  then convfac = convfac_*ndays
    if(strmid(vars[ipage],0,3) eq 'ssa')  then convfac = convfac_*ndays
    nmon = nmon+1


   endfor

;  If variable not available then exit loop
   if(rc ne 0) then begin
    printf, lun, 13, ' 0.0'
    printf, lun, ' '
    continue
   endif

   if(strmid(vars[ipage],0,4) eq 'load' or strmid(vars[ipage],0,3) eq 'tau' $
                                        or strmid(vars[ipage],0,3) eq 'ssa') then begin
    anntot = anntot/nmon
    if(strmid(vars[ipage],0,4) eq 'load') then begin
     anntot = string(anntot,format='(f8.2)')
     titleStr = plot_title + varTitle+' [g m!E-2!N], Annual Average: ' +anntot+' Tg'
    endif else begin
     anntot = string(anntot,format='(f8.4)')
     titleStr = plot_title + varTitle+ ', Annual Average: ' +anntot
    endelse
   endif else begin
    anntot = string(anntot,format='(f8.2)')
    titleStr = plot_title + varTitle+ ' [g m!E-2!N], Annual Total: ' +anntot+' Tg'
   endelse

   if(aertype eq 'DIAG') then begin
    anntot = anntot/float(nmon)
    anntot = string(anntot,format='(f8.2)')
    titleStr = plot_title + varTitle+' Annual Average: '+anntot+' '+varunits
   endif

   printf, lun, 13, ' ', anntot
   printf, lun, ' '

   xyouts, .075, .94, /normal, titleStr

   for ii = 9, 11 do begin
    loadct, 0
    makekey, position[0,ii], position[1,ii]-.025, .275, .015, 0., -0.015, $
    color=make_array(n_elements(dcolors),val=0), label=labelarray, $
    charsize=.7, align=0, noborder=noborder
    if(aertype eq 'NI') then begin
     scalestr = ''
     if(strmid(vars[ipage],0,6) eq 'pno3aq') then scalestr = 'x10!E-3!N'
     xyouts, position[0,ii]+.275, position[1,ii]-0.04, scalestr, align=1, charsize=.7, /normal
    endif
    tvlct, red, green, blue
    dcolors=indgen(n_elements(red))
    makekey, position[0,ii], position[1,ii]-.025, .275, .015, 0., -0.015, $
    color=dcolors, label=make_array(n_elements(labelarray),val=''), $
    charsize=.7, align=0, noborder=noborder
   endfor


  endfor

  free_lun, lun

  device, /close  

end
