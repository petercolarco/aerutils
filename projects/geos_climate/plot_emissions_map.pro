; Colarco, June 2010
; Plot a 4-panel map of the emissions
;  dust
;  sea salt
;  sulfate
;  carbon

  expid = 'S2S1850CO2x4pl'
  draft = 0
  draft = 1
  ddf = expid+'.ddf'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 19410000L and nymd lt 19510000L)
  filename = filename[a]
  nymd = nymd[a]
  nt = n_elements(filename)

; Get the emissions
  get_emission, filename, 'duem', duem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'ssem', ssem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'suem002', so2em, lat=lat, lon=lon, /ave
  get_emission, filename, 'suem003', so4em, lat=lat, lon=lon, /ave
  get_emission, filename, 'supso4g', pso4g, lat=lat, lon=lon, /ave
  get_emission, filename, 'supso4aq', pso4aq, lat=lat, lon=lon, /ave
  get_emission, filename, 'supso4wt', pso4wt, lat=lat, lon=lon, /ave
  so2em = (so2em); / 2.  ; SO2 -> S
  suem = (so4em); / 3.  ; SO4 -> S
  sug  = pso4g; / 3.  ; SO4 -> S
  suwt = (pso4aq+pso4wt); / 3.  ; SO4 -> S

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Setup the outputs
  convfac = 1000.*86400*365.  ; convert kg m-2 s-1 to g m-2 yr-1
  varo = fltarr(nx,ny,6)
  varo[*,*,0] = duem*convfac
  varo[*,*,1] = ssem*convfac
  varo[*,*,2] = suem*convfac
  varo[*,*,3] = so2em*convfac
  varo[*,*,4] = sug*convfac
  varo[*,*,5] = suwt*convfac

  title = strarr(6)
  title[0] = 'Dust'+ ' [g m!E-2!N yr!E-1!N]'
  title[1] = 'Sea Salt'+ ' [g m!E-2!N yr!E-1!N]'
  title[2] = 'Sulfate'+ ' [g m!E-2!N yr!E-1!N]'
  title[3] = 'SO!D2!N'+ ' [g m!E-2!N yr!E-1!N]'
  title[4] = 'Sulfate (gas production)'+ ' [g m!E-2!N yr!E-1!N]'
  title[5] = 'Sulfate (wet production)'+ ' [g m!E-2!N yr!E-1!N]'
  title = title

  colort = intarr(6)
  colort[0] = 55
  colort[1] = 57
  colort[2] = 53
  colort[3] = 53
  colort[4] = 53
  colort[5] = 53

  position = fltarr(4,6)
  position[*,0] = [.025,.72,.475,.967]
  position[*,1] = [.525,.72,.975,.967]
  position[*,2] = [.025,.39,.475,.637]
  position[*,3] = [.525,.39,.975,.637]
  position[*,4] = [.025,.06,.475,.307]
  position[*,5] = [.525,.06,.975,.307]

; Set up the plot
  set_plot, 'ps'
  device, file = './output/plots/plot_emissions_map.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=27, yoff=.5
  !P.font=0

  loadct, 0

; Dust
  i = 0
  levelarray = [5,10,20,50,100,150,200]
  labelarray = ['5','10','20','50','100','150','200']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray

; Sea Salt
  i = 1
  levelarray = [1,2,5,10,15,20,25]
  labelarray = ['1','2','5','10','15','20','25']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Sulfate
  i = 2
  levelarray = [.02,.05,.1,.2,.5,1,2]
  labelarray = ['0.02','0.05','0.1','0.2','0.5','1','2']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; SO2
  i = 3
  levelarray = [.01,.02,.05,.1,.2,.5,1]
  labelarray = ['0.01','0.02','0.05','0.1','0.2','0.5','1']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Sulfate (gas)
  i = 4
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Sulfate (Wet)
  i = 5
  colorarray = reverse(220-findgen(7)*35.)
  levelarray = [.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

  if(draft) then xyouts, .02, .005, expid, /normal, charsize=.75

  device, /close

end
