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
  get_emission, filename, 'nh3em', nh3em, lat=lat, lon=lon, /ave
  get_emission, filename, 'niht', niht, lat=lat, lon=lon, /template, /sum, /ave
  get_emission, filename, 'nipno3aq', nipno3aq, lat=lat, lon=lon, /ave
;  get_emission, filename, 'suem003', so4em, lat=lat, lon=lon, /ave
;  get_emission, filename, 'supso4g', pso4g, lat=lat, lon=lon, /ave
;  get_emission, filename, 'supso4aq', pso4aq, lat=lat, lon=lon, /ave
;  get_emission, filename, 'supso4wt', pso4wt, lat=lat, lon=lon, /ave

; Grid
  area, lon, lat, nx, ny, dx, dy, area

; Setup the outputs
  convfac = 1000.*86400*365.  ; convert kg m-2 s-1 to g m-2 yr-1
  varo = fltarr(nx,ny,6)
  varo[*,*,0] = nh3em*convfac
  varo[*,*,1] = niht*convfac
  varo[*,*,2] = nipno3aq*convfac
;  varo[*,*,3] = so2em*convfac
;  varo[*,*,4] = sug*convfac
;  varo[*,*,5] = suwt*convfac

  title = strarr(6)
  title[0] = 'Ammonia'+ ' [g m!E-2!N yr!E-1!N]'
  title[1] = 'Nitrate (heterogeneous)'+ ' [g m!E-2!N yr!E-1!N]'
  title[2] = 'Nitrate (aqueous)'+ ' [g m!E-2!N yr!E-1!N]'
;  title[3] = 'SO!D2!N'+ ' [g m!E-2!N yr!E-1!N]'
;  title[4] = 'Sulfate (gas production)'+ ' [g m!E-2!N yr!E-1!N]'
;  title[5] = 'Sulfate (wet production)'+ ' [g m!E-2!N yr!E-1!N]'

  colort = intarr(6)
  colort[0] = 61
  colort[1] = 61
  colort[2] = 70
;  colort[3] = 53
;  colort[4] = 53
;  colort[5] = 53

  position = fltarr(4,6)
  position[*,0] = [.025,.72,.475,.967]
  position[*,1] = [.525,.72,.975,.967]
  position[*,2] = [.025,.39,.475,.637]
  position[*,3] = [.525,.39,.975,.637]
  position[*,4] = [.025,.06,.475,.307]
  position[*,5] = [.525,.06,.975,.307]

; Set up the plot
  set_plot, 'ps'
  device, file = './output/plots/plot_emissions_map.nitrate.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=27, yoff=.5
  !P.font=0

  loadct, 0

; Ammonia
  i = 0
  levelarray = [.02,.05,.1,.2,.5,1,2,5]
  labelarray = ['0.02','0.05','0.1','0.2','0.5','1','2','5']
  colorarray = reverse(220-findgen(8)*30.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray

; Nitrate Heterogeneous Production
  i = 1
  levelarray = [.02,.05,.1,.2,.5,1,2,5]
  labelarray = ['0.02','0.05','0.1','0.2','0.5','1','2']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase

; Nitrate Aqueous Loss
  i = 2
  levelarray = [-100,-.5,-.2,-.1,.1,.2,.5]
  labelarray = [' ','-0.5','-0.2','-0.1','0.1','0.2','0.5']
  colorarray = reverse(220-findgen(7)*35.)
  plot_map, varo[*,*,i], position[*,i], colort[i], title[i], lon, lat, $
            levelarray, colorarray, labelarray, /noerase, /align
device, /close
stop

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
