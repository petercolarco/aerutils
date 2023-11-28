; Colarco, January 2011
; Procedure to create standardized plots of AOD for ICAP effort
; Based on initial code from Walter Sessions, NRL, modified
; for GMAO output

PRO ICAP

; In current instantiation, pulls AOD from saved aerosol file
; rather than opendap
  filename = 'tmpaer.nc4'
  nc4readvar, filename, '', varval, time=time, lon=lon, lat=lat, $
                            nhms=nhms, nymd=nymd

; Construct the base forecast name
  tstr0 = nymd[0]+strmid(nhms[0],0,2)
  tstr1 = nymd   +strmid(nhms,0,2)
  time  = strcompress(string(fix(time)),/rem)
; Pick off only the 0, 6, 12, 18z times
  hh = strmid(tstr1,8,2)
  a = where(hh eq '00' or hh eq '06' or $
            hh eq '12' or hh eq '18')

; ICAP Colors
  set_plot, 'z'
  r = [ 0, .9, 1, 0.0, 0.0, 0.0,  1.,  1.,  1., 1.]
  g = [ 0, .8, 1, 0. ,  .5,  1.,  1., 0.5,  0., 0.]
  b = [ 0, .5, 1, 1. ,  1.,  0.,  0.,  0.,  0., 1.]
  r = BYTE(r*255)
  g = BYTE(g*255)
  b = BYTE(b*255)
  TVLCT, r, g, b

; Contour levels
  levelarray = [0.1, .2, .4, .8, 1.2, 2.5, 5.0] 
  labelarray = ['0.1','0.2','0.4','0.8','1.2','2.5','5.0','9.0']

; Variables
  varlist  = ['totexttau','duexttau','ssexttau','suexttau','ccexttau']
  vartitle = ['Total','Dust','Sea Salt','Sulfate','Carbonaceous']

; Read the data and make the plots
  for i = 0, n_elements(a)-1 do begin

  for n = 0, 4 do begin
   varget_ = varlist[n]
   if(varget_ eq 'totexttau') then varget = ['duexttau','ssexttau','suexttau','bcexttau','ocexttau']
   if(varget_ eq 'ccexttau')  then varget = ['bcexttau','ocexttau']
   if(varget_ ne 'totexttau' and varget_ ne 'ccexttau') then varget = varget_

   wanttime = [nymd[a[i]],nhms[a[i]]]
   outfile  = tstr0+'+'+tstr1[a[i]]
   nc4readvar, 'tmpaer.nc4', varget, aod, lon=lon, lat=lat, /sum, wanttime=wanttime
   out	= varlist[n]+'.'+outfile+'.ps'
 
;  Get range for contours
   valx = MAX(aod, loc)
   valn = MIN(aod)
   valn = MAX([valn, 0])

   nlevs  = N_ELEMENTS(levelarray)
   colors = FINDGEN(nlevs)+3

;  Setup plotting device
   set_plot, 'ps'
   !p.font=0
   device, file=out, /color, font_size=12, /helvetica, $
    xsize=20, ysize=15

   map_set, 0, 0, /CYLINDRICAL, position=[.05,.2,.95,.85], /noborder
;   print, 'LEVS: ',levelarray
;   print, 'MAX: ',valx
;   print, 'MIN: ',valn
;   print, 'LOC: ',loc
;   print, 'MEAN: ', MEAN(aod(WHERE(aod GT 0.0)))
   map_continents, COLOR=1, fill_continents=1
   lonnames = strcompress(string(abs(indgen(19)*20-180)),/rem)
   lonnames = lonnames+'!Eo!N'
   lonnames[0:8] = lonnames[0:8]+'W'
   lonnames[10:18] = lonnames[10:18]+'E'
   latnames = strcompress(string(abs(indgen(9)*20-80)),/rem)
   latnames = latnames+'!Eo!N'
   latnames[0:3] = latnames[0:3]+'S'
   latnames[5:8] = latnames[5:8]+'N'
   CONTOUR, aod[*,*], lon, lat, /OVERPLOT, C_COLORS=colors, LEVELS=levelarray, $
            XSTYLE=5, YSTYLE=5, /CELL_FILL
   map_continents, color=0
   MAP_GRID, /box, COLOR=0, glinestyle=2, charsize=.75, /label, $
            lats=[-90,findgen(9)*20-80,90], lons=findgen(19)*20-180, $
            lonnames=lonnames, latnames=[' ',latnames,' ']
   plots, [.05,.95,.95,.05,.05], [.2,.2,.85,.85,.2], color=0, /normal, thick=2
   xyouts, .05, .95, tstr0+' GEOS-5 Forecast t+'+time[a[i]],/normal, color=0
   xyouts, .05, .92, tstr1[a[i]]+' Valid Time',/normal, color=0
   xyouts, .05, .89, vartitle[n]+' AOD [550 nm]',/normal, color=0

   xs = 0.08
   xe = 0.92
   ys = 0.08
   ye = 0.18
   makekey, .08, .08, .84, .05, 0, -.03, $
            colors=colors, label=labelarray, bcolor=0

   DEVICE, /CLOSE
;  SPAWN, 'display '+out
 
  endfor

  endfor

END
