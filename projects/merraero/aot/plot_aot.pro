; Colarco Aug. 2014
; make a global plot of aot (or aaot)

  pro plot_aot, filename, varwant, varwant2=varwant2, $
                iplot=iplot, tplot=tplot, aaot=aaot

  if(not(keyword_set(aaot))) then aaot = 0
  if(not(keyword_set(iplot))) then iplot = 1
  if(not(keyword_set(tplot))) then tplot = 1
  iplot = iplot -1 

  if(tplot ne 1 and tplot ne 2 and tplot ne 4) then stop

  case tplot of
   1: begin
      position = [.05,.2,.95,.9]
      xsize=12
      ysize=10
      noerase = 0
      lstr = ''
      end
   2: begin
      position = [ [.025,.2,.475,.9], $
                   [.525,.2,.975,.9] ]
      xsize=24
      ysize=10
      noerase = 0
      if(iplot eq 0) then lstr = '!4(a)!3 '
      if(iplot eq 1) then lstr = '!4(b)!3 '
      if(iplot gt 0) then noerase = 1
      end
   4: begin
      position = [ [.025,.6,.475,.95], $
                   [.525,.6,.975,.95], $
                   [.025,.15,.475,.475], $
                   [.525,.15,.975,.475] ]
      xsize=24
      ysize=20
      noerase = 0
      if(iplot eq 0) then lstr = '!4(a)!3 '
      if(iplot eq 1) then lstr = '!4(b)!3 '
      if(iplot eq 2) then lstr = '!4(c)!3 '
      if(iplot eq 3) then lstr = '!4(d)!3 '
      if(iplot gt 0) then noerase = 1
      end
   endcase

  varwantu = varwant
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  if(keyword_set(varwant2)) then begin
   oper = '+'
   varwant2_ = varwant2
   if(strmid(varwant2,0,1) eq '-' or $
      strmid(varwant2,0,1) eq '+' or $
      strmid(varwant2,0,1) eq '*' or $
      strmid(varwant2,0,1) eq '/' ) then begin
     oper = strmid(varwant2,0,1)
     varwant2_ = strmid(varwant2,1,strlen(varwant2)-1)
   endif
   nc4readvar, filename, varwant2_, var2
   if(oper eq '-') then aoto = aoto-var2
   if(oper eq '+') then aoto = aoto+var2
   if(oper eq '*') then aoto = aoto*var2
   if(oper eq '/') then aoto = aoto/var2
   varwantu = varwantu+varwant2
  endif


  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

  if(iplot eq 0) then begin
   set_plot, 'ps'
   filen = './'+varwantu+'.eps'
   device, file=filen, $
           /color, /helvetica, font_size=9, $
           xoff=.5, yoff=.5, xsize=xsize, ysize=ysize, /encap
   !p.font=0
  endif

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  map_set, p0, p1, position=position[*,iplot], /noborder, $
           limit=geolimits, noerase=noerase, /hammer, /iso

; plot missing data as light shade
  loadct, 0
  plotgrid, aoto, [-.1], [220], lon, lat, dx, dy, /map, /missing
; plot data
  levels = findgen(11)*.05
  nformat = '(f4.2)'
  red   = [255,255,255,254,254,254,236,204,153,102,0]
  green = [255,255,247,227,196,153,112,76,52,37,0]
  blue  = [255,229,188,145,79,41,20,2,4,6,0]
  tvlct, red, green, blue
  ncolor=n_elements(levels)
  dcolors=indgen(ncolor)

  if(aaot) then begin
   levels = [0,.001,.002,.005,.01,.02,.05,.1]
   nformat = '(f5.3)'
   red   = [255,255,254,254,204,153,102,0]
   green = [255,247,196,153,76,52,37,0]
   blue  = [255,188,79,41,2,4,6,0]
   tvlct, red, green, blue
   ncolor=n_elements(levels)
   dcolors=indgen(ncolor)
  endif

  plotgrid, aoto, levels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=0, thick=1
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,iplot], /noborder, limit=geolimits, $
   /hammer, /iso, /horizon, /grid, glinestyle=0, color=160, glinethick=.5

  title = ' '
  xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2

  if(tplot eq 1) then begin
    loadct, 0
    makekey, .1, .125, .8, .05, 0, -.035, color=make_array(ncolor,val=0), $
     align=0, label=string(levels,format=nformat)
    tvlct, red, green, blue
    dcolors=indgen(ncolor)
    makekey, .1, .125, .8, .05, 0, -.035, color=dcolors, $
    align=0, label=make_array(ncolor,val='')
    loadct, 0
    plots, [.1,.9,.9,.1,.1], [.125,.125,.175,.175,.125], thick=1, color=0, /normal
  endif
  if(iplot eq 0 and tplot eq 2) then begin
    title = 'AOT [550 nm]'
    xyouts, .5, .16, title, /normal, charsize=1.2, align=.5
    loadct, 0
    makekey, .1, .07, .8, .05, 0, -.035, color=make_array(ncolor,val=0), $
     align=0, label=string(levels,format=nformat)
    tvlct, red, green, blue
    dcolors=indgen(ncolor)
    makekey, .1, .07, .8, .05, 0, -.035, color=dcolors, $
     align=0, label=make_array(ncolor,val='')
    loadct, 0
    plots, [.1,.9,.9,.1,.1], [.07,.07,.12,.12,.07], thick=1, color=0, /normal
  endif
  if(iplot eq 0 and tplot eq 4) then begin
    title = 'AOT [550 nm]'
    xyouts, .5, .08, title, /normal, charsize=1.2, align=.5
    loadct, 0
    makekey, .1, .035, .8, .035, 0, -.025, color=make_array(ncolor,val=0), $
     align=0, label=string(levels,format=nformat)
    tvlct, red, green, blue
    dcolors=indgen(ncolor)
    makekey, .1, .035, .8, .035, 0, -.025, color=dcolors, $
     align=0, label=make_array(ncolor,val='')
  endif
  if(iplot eq tplot-1) then device, /close


end
