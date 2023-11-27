; Colarco, January 2006
; Read the FVGCM diagnostic (sfc) fields and make monthly plots
; of the emission, deposition, etc. budgets
; Pass in the experiment path, experiment id (name), the desired year,
; and the information about the diagnostic file name.
; For every monthly mean available for that year a plot is made.

  pro plot_budget1, expctl, expid, aertype, year, mm=mm, $
                    wantlon=wantlon, wantlat=wantlat, region=region, $
                    carma=carma

 !quiet = 1l

  regionstr = '.'
  if(keyword_set(region)) then regionstr = '.'+region+'.'

  ndaysmon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  year = strcompress(string(year),/rem)
  if(keyword_set(mm)) then mmstr = strpad(mm,10) else mmstr = 'ann'
  if(keyword_set(mm)) then mm = strpad(mm,10) else mm = ''
  if(fix(year)/4 eq fix(year)/4.) then ndaysmon[1] = 29

  plot_title = 'GEOS ('+expid+') '+aertype+' '
  plot_file = './output/plots/geos_budget.'+expid+regionstr+aertype+'.'+year+mmstr+'.ps'
  cmd = 'mkdir -p ./output/plots'
  spawn, cmd, /sh

  convfac_ = 1000.*86400  ; convert kg m-2 s-1 to g m-2

  case aertype of
   'TOT':  begin
           vars = ['tau','ssa','tauabs']
           end
   'BC':   begin
           vars = ['emis','dep','sed','wet','scav','load','tau','ssa','tauabs','embb','embf','eman']
;           vars = ['emis','dep','wet','scav','load','tau']
           end
   'POM':  begin
           levelarray = [.01,.02,.05,.1,.2,.5,1]
           formcode = '(f5.2)'
           vars = ['emis','dep','wet','scav','load','tau','embb','embf','eman','embg']
;           vars = ['emis','dep','wet','scav','load','tau','embbbo','embbnb']
           end
   'DU':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs']
           end
   'DZ':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25', 'tau']
           end
   'SS':   begin
           vars = ['emis','sed','dep','wet','scav','load','load25','tau']
           end
   'SU':   begin
           vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms', $
                   'emisvolcn', 'emisvolce','tau']
;           vars = ['emis','emisso2','emisdms','dep','depso2','wet',$
;                   'pso4g','pso4liq','pso2','load','loadso2','loaddms','tau']
           end
   'CO':   begin
           vars = ['emis','prod','loss','load']
           end
   'CO2':  begin
           vars = ['emis','load']
           end
  endcase

  npage = n_elements(vars)

; Get the lon/lat for the area calculation (assumes file is global)
  nymd = year+mm+'15'
  if(mm eq '') then nymd = year+'0715'
  nhms = 120000
  filename_ = strtemplate(parsectl_dset(expctl),nymd,nhms)
  filename = filename_[0]
  nc4readvar, filename, '', varval, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  geolimit = [-70,-175,80,175]
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
  device, filename=plot_file, xoff=.5, yoff=.5, $
   xsize=16, ysize=12, /helvetica, font_size=12, /color
  !P.font=0
  position = [.05,.15,.95,.85]

  for ipage = 0, npage-1 do begin
   noerase = 0
   anntot = 0.

   dateWant = year+mm
   rc = 0
   print, 'Getting: '+aertype+' '+vars[ipage]+', '+datewant
   varwant = vars[ipage]
    if(not(keyword_set(carma))) then begin
     read_geos_diag, filename, varWant, varValue, $
                     varTitle, varunits, levelarray, labelarray, formcode, $
                     lon=lon, lat=lat, $
                     wantlon=wantlon, wantlat=wantlat, type=aertype, rc=rc
    endif else begin
     read_carma_diag, filename, varWant, varValue, $
                      varTitle, varunits, levelarray, labelarray, formcode, $
                      lon=lon, lat=lat, $
                      wantlon=wantlon, wantlat=wantlat, type=aertype, rc=rc
    endelse
; Check type for colortable
  loadct, 0
  colorarray = 220-findgen(n_elements(levelarray))*220./n_elements(levelarray)
  noborder = 1
  if(aertype eq 'TOT') then begin
   loadct, 39
   colorarray = findgen(100)*2.5
   noborder=1
  endif


    if(mm eq '') then ndays = total(ndaysmon) else ndays = ndaysmon[mm-1]

    convfac = convfac_*ndays

;   if load2d then don't multiply by days
    if(strmid(vars[ipage],0,4) eq 'load') then convfac = convfac / (ndays*86400.)
    if(strmid(vars[ipage],0,3) eq 'tau')  then convfac = 1.
    if(strmid(vars[ipage],0,3) eq 'ssa')  then convfac = 1.

    map_set, limit=geolimit, position=position, noerase=noerase
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

    plotgrid, varvalue*convfac, levelarray_, colorarray_, lon, lat, dx, dy, map=map
    if(strmid(vars[ipage],0,3) ne 'tau' and strmid(vars[ipage],0,3) ne 'ssa') then begin
     xyouts, position[2],position[3]+.06, /normal, align=1, $
      string(total(varvalue*convfac*area)/(1.e12), $
      format='(f8.2)')+' Tg', charsize=.7
     anntot = anntot + total(varValue*convfac*area)/1.e12
    endif else begin
     xyouts, position[2],position[3]+.06, /normal, align=1, $
      string(total(varvalue*convfac*area)/total(area), $
      format='(f8.4)'), charsize=.7
     anntot = anntot + total(varValue*convfac*area)/total(area)
    endelse
    xyouts, position[0],position[3]+.06, /normal, year+mm, $
     charsize=.7

    map_continents, thick=1.5
    map_continents, /countries
    map_grid, /box
    if(strmid(vars[ipage],0,4) eq 'load') then convfac = convfac * (ndays*86400.)
    if(strmid(vars[ipage],0,3) eq 'tau')  then convfac = convfac_*ndays
    if(strmid(vars[ipage],0,3) eq 'ssa')  then convfac = convfac_*ndays

   if(strmid(vars[ipage],0,4) eq 'load' or strmid(vars[ipage],0,3) eq 'tau' $
                                        or strmid(vars[ipage],0,3) eq 'ssa') then begin
    if(strmid(vars[ipage],0,4) eq 'load') then begin
     titleStr = plot_title + varTitle+ ' [g m!E-2!N]'
    endif else begin
     titleStr = plot_title + varTitle
    endelse
   endif else begin
    titleStr = plot_title + varTitle+ ' [g m!E-2!N]'
   endelse

   xyouts, position[0], .94, /normal, titleStr

   makekey, .05, .075, .9, .025, 0., -0.035, $
   color=colorarray_, label=labelarray, $
   charsize=.7, align=0, noborder=noborder


  endfor

  device, /close  


end
