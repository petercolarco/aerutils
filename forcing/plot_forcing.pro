; Colarco, January 2006
; Read the FVGCM diagnostic (sfc) fields and make monthly plots
; of the emission, deposition, etc. budgets
; Pass in the experiment path, experiment id (name), the desired year,
; and the information about the diagnostic file name.
; For every monthly mean available for that year a plot is made.

  pro plot_forcing, expctl, expid, year, $
                    wantlon=wantlon, wantlat=wantlat, region=region

  regionstr = '.'
  if(keyword_set(region)) then regionstr = '.'+region+'.'

 !quiet = 1l

  ndaysmon = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  year = strcompress(string(year),/rem)
  if(fix(year)/4 eq fix(year)/4.) then ndaysmon[1] = 29

  plot_title = 'GEOS ('+expid+') '
  plot_file = './output/plots/geos_forcing.'+expid+regionstr+year+'.ps'
  cmd = 'mkdir -p ./output/plots'
  spawn, cmd, /sh

; Define vars
  vars = ['swtoaclr','swsfcclr','swatmclr', $
          'swtoaall','swsfcall','swatmall']

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

  cmd = 'mkdir -p ./output/tables'
  spawn, cmd, /sh
  openw, lun, './output/tables/forcing.'+expid+regionstr+year+'.txt', /get_lun

  for ipage = 0, npage-1 do begin
   noerase = 0
   anntot = 0.

   dateWant = year+['01', '12']
   rc = 0
   print, 'Getting: '+vars[ipage]+', '+datewant

   nmon = 0
   for imon = 0, 11 do begin

;   Determine the filename to read
    mm = strpad(imon+1,10)
    nymd = year+mm+'15'
    nhms = 120000
    filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
    varwant = vars[ipage]
    read_geos_diag, filename, varWant, varValue, $
                    varTitle, varunits, levelarray, labelarray, formcode, $
                    lon=lon, lat=lat, $
                    wantlon=wantlon, wantlat=wantlat, rc=rc

    loadct, 0
    if(strmid(varwant,0,5) eq 'swtoa') then loadct, 39
    colorarray = 250-findgen(n_elements(levelarray))*(250./n_elements(levelarray))
    if(n_elements(levelarray) gt 10) then noborder = 1

;   If the variable not read from the file, still need to write something
;   to the output table.
;   The get out of loop
    if(rc ne 0) then begin
     printf, lun, imon+1, ' 0.0'
     continue
    endif

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

    plotgrid, varvalue, levelarray_, colorarray_, lon, lat, dx, dy, map=map
    xyouts, position[2,imon],position[3,imon]+.01, /normal, align=1, $
      string(total(varvalue*area)/total(area), $
      format='(f8.4)'), charsize=.7
    anntot = anntot + total(varValue*area)/total(area)
    printf, lun, imon+1, total(varValue*area)/total(area)
    xyouts, position[0,imon],position[3,imon]+.01, /normal, year+mm, $
    charsize=.7

    map_continents, thick=1.5
    map_continents, /countries
    nmon = nmon+1


   endfor

;  If variable not available then exit loop
   if(rc ne 0) then begin
    printf, lun, 13, ' 0.0'
    printf, lun, ' '
    continue
   endif

   anntot = anntot/nmon
   anntot = string(anntot,format='(f8.2)')
   titleStr = plot_title + varTitle+ ' [W m!E-2!N], Annual Average: ' +anntot

   printf, lun, 13, ' ', anntot
   printf, lun, ' '

   xyouts, .075, .94, /normal, titleStr

   for ii = 9, 11 do begin $
    makekey, position[0,ii], position[1,ii]-.025, .275, .015, 0., -0.015, $
    color=colorarray_, label=labelarray, $
    charsize=.7, align=0, noborder=noborder
   endfor


  endfor

  free_lun, lun

  device, /close  


end
