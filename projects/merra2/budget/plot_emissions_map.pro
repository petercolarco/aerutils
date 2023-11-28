; Colarco, June 2010
; Plot a 4-panel map of the emissions
;  dust
;  sea salt
;  sulfate
;  carbon

  expid = 'd5124_m2_jan79'
  filename = '/misc/prc13/MERRA2/d5124_m2_jan79/tavg1_2d_aer_Nx/d5124_m2_jan79.tavg1_2d_aer_Nx.monthly.clim.ANN.nc4'
  draft = 0
  draft = 1

; Get the emissions
  nc4readvar, filename, 'duem', duem, lat=lat, lon=lon, /template, /sum
  nc4readvar, filename, 'ssem', ssem, lat=lat, lon=lon, /template, /sum
  nc4readvar, filename, 'suem003', so4em, lat=lat, lon=lon
  nc4readvar, filename, 'supso4g', pso4g, lat=lat, lon=lon
  nc4readvar, filename, 'supso4aq', pso4aq, lat=lat, lon=lon
  nc4readvar, filename, 'supso4wt', pso4wt, lat=lat, lon=lon
  suem = (so4em+pso4g) / 3.  ; SO4 -> S
  suwt = (pso4aq+pso4wt) / 3.  ; SO4 -> S
  nc4readvar, filename, 'ocem0', ocem, lat=lat, lon=lon, /template, /sum
  nc4readvar, filename, 'bcem0', bcem, lat=lat, lon=lon, /template, /sum
  ccem = ocem + bcem

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Set up the plot
  set_plot, 'ps'
  device, file = './output/plots/plot_emissions_map.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=27, yoff=.5
  !P.font=0
  position = fltarr(4,6)
  position[*,0] = [.025,.72,.475,.967]
  position[*,1] = [.525,.72,.975,.967]
  position[*,2] = [.025,.39,.475,.637]
  position[*,3] = [.525,.39,.975,.637]
  position[*,4] = [.025,.06,.475,.307]
  position[*,5] = [.525,.06,.975,.307]

  loadct, 0

; Dust
  convfac = 1000.*86400*365.  ; convert kg m-2 s-1 to g m-2 yr-1
  colorarray = 220-findgen(7)*35.
  colorarray = reverse(colorarray)
  levelarray = [5,10,20,50,100,150,200]
  map_set, limit=[-80,0,80,360], position=position[*,0]
  loadct, 55
  plotgrid, duem*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position[*,0], /noerase
  makekey, 0.025, .695, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['5','10','20','50','100','150','200']
  loadct, 55
  makekey, 0.025, .695, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*duem)*convfac/1.e12
  totstr = string(totem,format='(i4)')+' Tg yr!E-1!N'
  loadct, 0
  xyouts, .025, .975, /normal, 'Dust [g m!E-2!N yr!E-1!N]'
  xyouts, .475, .975, /normal, totstr, align=1

; Sea salt
  loadct, 0
  levelarray = [2,5,10,15,20,30,50]
  map_set, limit=[-70,0,80,360], position=position[*,1], /noerase
  loadct, 57
  plotgrid, ssem*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position[*,1], /noerase
  makekey, 0.525, .695, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['2','5','10','15','20','30','50']
  loadct, 57
  makekey, 0.525, .695, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*ssem)*convfac/1.e12
  totstr = string(totem,format='(i4)')+' Tg yr!E-1!N'
  loadct, 0
  xyouts, .525, .975, /normal, 'Sea Salt [g m!E-2!N yr!E-1!N]'
  xyouts, .975, .975, /normal, totstr, align=1


; Particulate Organic Matter
  loadct, 0
  levelarray = [0.05,.1,.2,.5,1,2,5]
  map_set, limit=[-70,0,80,360], position=position[*,2], /noerase
  loadct, 53
  plotgrid, ocem*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position[*,2], /noerase
  makekey, 0.025, .365, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['0.05','0.1','0.2','0.5','1','2','5']
  loadct, 53
  makekey, 0.025, .365, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*ocem)*convfac/1.e12
  totstr = string(totem,format='(f5.1)')+' Tg yr!E-1!N'
  loadct, 0
  xyouts, .025, .645, /normal, 'Particulate Organic Matter [g m!E-2!N yr!E-1!N]'
  xyouts, .475, .645, /normal, totstr, align=1


; Black Carbon
  loadct, 0
  colorarray = reverse(colorarray)
  levelarray = [0.05,.1,.2,.5,1,2,5]
  map_set, limit=[-70,0,80,360], position=position[*,3], /noerase
  plotgrid, bcem*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  map_continents, thick=1.5
;  map_continents, /countries
  map_set, limit=[-80,0,80,360], position=position[*,3], /noerase
  makekey, 0.525, .365, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['0.05','0.1','0.2','0.5','1','2','5']
  totem = total(area*bcem)*convfac/1.e12
  totstr = string(totem,format='(f5.1)')+' Tg yr!E-1!N'
  loadct, 0
  xyouts, .525, .645, /normal, 'Black Carbon [g m!E-2!N yr!E-1!N]'
  xyouts, .975, .645, /normal, totstr, align=1

; Sulfate - Primary + Gas
  loadct, 0
  colorarray = reverse(colorarray)
  levelarray = [.02,.05,.1,.2,.5,1,2]
  map_set, limit=[-70,0,80,360], position=position[*,4], /noerase
  loadct, 53
  plotgrid, suem*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position[*,4], /noerase
  makekey, 0.025, .035, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['0.02','0.05','0.1','0.2','0.5','1','2']
  loadct, 53
  makekey, 0.025, .035, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*suem)*convfac/1.e12
  totstr = string(totem,format='(f5.2)')+' Tg S yr!E-1!N'
  loadct, 0
  xyouts, .025, .315, /normal, 'Sulfate (E+gas) [g S m!E-2!N yr!E-1!N]'
  xyouts, .475, .315, /normal, totstr, align=1


; Sulfate - wet
  loadct, 0
  levelarray = [0.05,.1,.2,.5,1,2,5]
  map_set, limit=[-70,0,80,360], position=position[*,5], /noerase
  loadct, 57
  plotgrid, suwt*convfac, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position[*,5], /noerase
  makekey, 0.525, .035, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=['0.05','0.1','0.2','0.5','1','2','5']
  loadct, 57
  makekey, 0.525, .035, .45, .02, 0, -0.02, align=0, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*suwt)*convfac/1.e12
  totstr = string(totem,format='(f5.1)')+' Tg S yr!E-1!N'
  loadct, 0
  xyouts, .525, .315, /normal, 'Sulfate (wet) [g m!E-2!N yr!E-1!N]'
  xyouts, .975, .315, /normal, totstr, align=1


  if(draft) then xyouts, .02, .005, expid, /normal, charsize=.75

  device, /close

end
