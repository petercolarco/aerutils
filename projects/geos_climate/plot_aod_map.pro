; Colarco, June 2010
; Plot a 4-panel map of the emissions
;  dust
;  sea salt
;  sulfate
;  carbon

  expid = 'S2S1850nrst'
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
  get_emission, filename, 'duexttau', duext, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'ssexttau', ssext, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'suexttau', suext, lat=lat, lon=lon, /ave
  get_emission, filename, 'bcexttau', bcext, lat=lat, lon=lon, /ave
  get_emission, filename, 'ocexttau', ocext, lat=lat, lon=lon, /ave
  get_emission, filename, 'niexttau', niext, lat=lat, lon=lon, /ave
  get_emission, filename, 'totexttau', totext, lat=lat, lon=lon, /ave

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Setup the outputs
  varo = fltarr(nx,ny,6)
  varo[*,*,0] = duext
  varo[*,*,1] = ssext
  varo[*,*,2] = suext
  varo[*,*,3] = bcext
  varo[*,*,4] = ocext
  varo[*,*,5] = niext

  title = strarr(6)
  title[0] = 'Dust'
  title[1] = 'Sea Salt'
  title[2] = 'Sulfate'
  title[3] = 'Black Carbon'
  title[4] = 'Particulate Organic Matter'
  title[5] = 'Nitrate'
  title = title

  colort = intarr(6)
  colort[0] = 55
  colort[1] = 57
  colort[2] = 53
  colort[3] = 0
  colort[4] = 53
  colort[5] = 61

  position = fltarr(4,6)
  position[*,0] = [.025,.72,.475,.967]
  position[*,1] = [.525,.72,.975,.967]
  position[*,2] = [.025,.39,.475,.637]
  position[*,3] = [.525,.39,.975,.637]
  position[*,4] = [.025,.06,.475,.307]
  position[*,5] = [.525,.06,.975,.307]

; Set up the plot
  set_plot, 'ps'
  device, file = './output/plots/plot_aod_map.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=27, yoff=.5
  !P.font=0

  loadct, 0

; Dust
  i = 0
  levelarray = [5,10,20,50,100,200,500]/1000.
  labelarray = ['0.005','0.01','0.02','0.05','0.1','0.2','0.5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /aod

; Sea Salt
  i = 1
  levelarray = [5,10,20,50,100,150,200]/1000.
  labelarray = ['0.005','0.01','0.02','0.05','0.1','0.15','0.2']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /aod

; Sulfate
  i = 2
  levelarray = [1,2,5,10,20,50,100]/1000.
  labelarray = ['0.001','0.002','0.005','0.011','0.02','0.05','0.1']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /aod

; Black carbon
  i = 3
  levelarray = [1,2,5,10,20,50,100]/1000.
  labelarray = ['0.001','0.002','0.005','0.01','0.02','0.05','0.1']
  colorarray = (220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /aod

; Organic
  i = 4
  levelarray = [1,2,5,10,20,50,100]/1000.
  labelarray = ['0.001','0.002','0.005','0.01','0.02','0.05','0.1']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /aod

; Nitrate
  i = 5
  colorarray = reverse(220-findgen(7)*35.)
  levelarray = [5,10,20,30,40,50,100]/1000.
  labelarray = ['0.005','0.01','0.02','0.03','0.04','0.05','0.1']
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /aod

  if(draft) then xyouts, .02, .005, expid, /normal, charsize=.75

  device, /close

end
