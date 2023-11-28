; Colarco, January 2006
; Read the FVGCM diagnostic (sfc) fields and make monthly plots
; of the emission, deposition, etc. budgets
; Pass in the experiment path, experiment id (name), the desired year,
; and the information about the diagnostic file name.
; For every monthly mean available for that year a plot is made.

  pro plot_diags, expctl, expid, year, mm, $
                  wantlon=wantlon, wantlat=wantlat, region=region

  regionstr = '.'
  if(keyword_set(region)) then regionstr = '.'+region+'.'

 !quiet = 1l

  ndaysmon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  year = strcompress(string(year),/rem)
  mm   = strpad(mm,10)
  if(fix(year)/4 eq fix(year)/4.) then ndaysmon[1] = 29

  plot_title = 'GEOS ('+expid+') '
  plot_file = './output/plots/geos_diags.'+expid+regionstr+year+mm+'.ps'
  cmd = 'mkdir -p ./output/plots'
  spawn, cmd, /sh

  aertype = 'DIAG'
  vars = ['precipls','precipcu','precipsno','preciptot','t2m', $
          'cldtt','cldlo','cldmd','cldhi','ttau','ttaudu','ttauss', $
          'ttauso','ttaubc','ttauoc']

  npage = n_elements(vars)


; Get the lon/lat for the area calculation (assumes file is global)
  nymd = year+mm+'15'
  nhms = 120000
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
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
  position = [.05,.15,.95,.9]

  loadct, 39
  colorarray = findgen(100)*2 + 40
  noborder=1

  for ipage = 0, npage-1 do begin
   noerase = 0
   anntot = 0.

   dateWant = year+mm
   rc = 0
   print, 'Getting: '+aertype+' '+vars[ipage]+', '+datewant
   varwant = vars[ipage]
   read_geos_diag, filename, varwant, varvalue, $
                   vartitle, varunits, levelarray, labelarray, formcode, $
                   wantlon=wantlon, wantlat=wantlat, rc=rc

    ndays = ndaysmon[mm-1]

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

    plotgrid, varvalue, levelarray_, colorarray_, lon, lat, dx, dy, map=map
    if(strmid(vars[ipage],0,6) eq 'precip' or $
       strmid(vars[ipage],0,3) eq 't2m' or $
       strmid(vars[ipage],0,3) eq 'cld' ) then begin
     xyouts, position[2],position[3]+.01, /normal, align=1, $
      string(total(varvalue*area)/total(area), $
      format='(f8.2)')+' '+varunits, charsize=.7
     anntot = anntot + total(varValue*area)/total(area)
    endif else begin
    endelse
    xyouts, position[0],position[3]+.01, /normal, year+mm, $
     charsize=.7

    map_continents, thick=1.5
    map_continents, /countries

   titlestr = vartitle+varunits
   xyouts, .075, .94, /normal, titleStr

   makekey, .05, .075, .9, .025, 0., -0.035, $
   color=colorarray_, label=labelarray, $
   charsize=.7, align=0, noborder=noborder


  endfor

  device, /close  


end
