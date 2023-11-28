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
  get_emission, filename, 'ocembg', ocembg, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'ocem0', ocem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'bcem0', bcem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'nh3em', nh3em, lat=lat, lon=lon, /ave
  get_emission, filename, 'niht', niht, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'nipno3aq', nipno3aq, lat=lat, lon=lon, /ave

  ccem = ocem + bcem ;+ brcem ;+ psoabr+psoaoc
  ocem = ocem-ocembg ; non soa emissions

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Setup the outputs
  convfac = 1000.*86400*365.  ; convert kg m-2 s-1 to g m-2 yr-1
  varo = fltarr(nx,ny,6)
  varo[*,*,0] = ocem*convfac
  varo[*,*,1] = ocembg*convfac
  varo[*,*,2] = bcem*convfac
  varo[*,*,3] = nh3em*convfac
  varo[*,*,4] = niht*convfac
  varo[*,*,5] = nipno3aq*convfac

  title = strarr(6)
  title[0] = 'Primary Organic Material'
  title[1] = 'Biogenic SOA'
  title[2] = 'Black Carbon'
  title[3] = 'Ammonia'
  title[4] = 'Nitrate (heterogeneous)'
  title[5] = 'Nitrate (aqueous)'
  title = title + ' [g m!E-2!N yr!E-1!N]'

  colort = intarr(6)
  colort[0] = 53
  colort[1] = 53
  colort[2] = 0
  colort[3] = 61
  colort[4] = 61
  colort[5] = 70

  position = fltarr(4,6)
  position[*,0] = [.025,.72,.475,.967]
  position[*,1] = [.525,.72,.975,.967]
  position[*,2] = [.025,.39,.475,.637]
  position[*,3] = [.525,.39,.975,.637]
  position[*,4] = [.025,.06,.475,.307]
  position[*,5] = [.525,.06,.975,.307]

; Set up the plot
  set_plot, 'ps'
  device, file = './output/plots/plot_emissions_map.carbon.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=27, yoff=.5
  !P.font=0

  loadct, 0

; Primary organic emissions
  i = 0
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray

; Biogenic
  i = 1
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Black Carbon
  i = 2
  levelarray = [0.005,.01,.02,.05,.1,.2,.5]
  labelarray = ['0.005','0.01','0.02','0.05','0.1','0.2','0.5']
  colorarray = 220-findgen(7)*35.
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Ammonia
  i = 3
  levelarray = [.02,.05,.1,.2,.5,1,2,5]
  labelarray = ['0.02','0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(8)*30.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Nitrate Heterogeneous Production
  i = 4
  levelarray = [.02,.05,.1,.2,.5,1,2,5]
  labelarray = ['0.02','0.05','0.1','0.2','0.5','1','2']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Nitrate Aqueous Loss
  i = 5
  levelarray = [-100,-.5,-.2,-.1,.1,.2,.5]
  labelarray = [' ','-0.5','-0.2','-0.1','0.1','0.2','0.5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /align

  if(draft) then xyouts, .02, .005, expid, /normal, charsize=.75

  device, /close

end
