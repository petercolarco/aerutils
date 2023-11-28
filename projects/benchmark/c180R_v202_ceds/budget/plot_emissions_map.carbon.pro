; Colarco, June 2010
; Plot a 4-panel map of the emissions
;  dust
;  sea salt
;  sulfate
;  carbon

  expid = 'c180R_v202_ceds'
  draft = 0
  draft = 1
  ddf = expid+'.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  nt = n_elements(filename)

; Get the emissions
  get_emission, filename, 'ocpsoa', psoaoc, lat=lat, lon=lon, /sum, /ave
  get_emission, filename, 'brcpsoa', psoabr, lat=lat, lon=lon, /sum, /ave
  get_emission, filename, 'ocembg', ocembg, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'ocem0', ocem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'brcem0', brcem, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'bcem0', bcem, lat=lat, lon=lon, /template, /sum, /ave

  ccem = ocem + bcem + brcem + psoabr+psoaoc
  ocem = ocem-ocembg ; non soa emissions

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Setup the outputs
  convfac = 1000.*86400*365.  ; convert kg m-2 s-1 to g m-2 yr-1
  varo = fltarr(nx,ny,6)
  varo[*,*,0] = ocem*convfac
  varo[*,*,1] = brcem*convfac
  varo[*,*,2] = psoaoc*convfac
  varo[*,*,3] = psoabr*convfac
  varo[*,*,4] = ocembg*convfac
  varo[*,*,5] = bcem*convfac

  title = strarr(6)
  title[0] = 'Anthropogenic POA'
  title[1] = 'Biomass Burning POA'
  title[2] = 'Anthropogenic SOA'
  title[3] = 'Biomass Burning SOA'
  title[4] = 'Biogenic SOA'
  title[5] = 'Black Carbon'
  title = title + ' [g m!E-2!N yr!E-1!N]'

  colort = intarr(6)
  colort[0] = 53
  colort[1] = 66
  colort[2] = 53
  colort[3] = 66
  colort[4] = 53
  colort[5] = 0

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

; Primary Brown Carbon
  i = 1
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(findgen(7)*18)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Secondary Organic Aerosol (Anthropogenic)
  i = 2
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Secondary Brown Carbon (biomass burning)
  i = 3
  levelarray = [0.005,.01,.02,.05,.1,.2,.5]
  labelarray = ['0.005','0.01','0.02','0.05','0.1','0.2','0.5']
  colorarray = reverse(findgen(7)*18)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Biogenic
  i = 4
  levelarray = [0.05,.1,.2,.5,1,2,5]
  labelarray = ['0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Black Carbon
  i = 5
  levelarray = [0.005,.01,.02,.05,.1,.2,.5]
  labelarray = ['0.005','0.01','0.02','0.05','0.1','0.2','0.5']
  colorarray = 220-findgen(7)*35.
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

  if(draft) then xyouts, .02, .005, expid, /normal, charsize=.75

  device, /close

end
