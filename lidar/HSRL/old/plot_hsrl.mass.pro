  dateInp = '20080421'
  flightleg = 'L1'

  species = 'dust'

  plotfile = './output/plots/geos5.'+species+'.mass.hsrl.'+dateInp+'.'+flightleg+'.ps'

  mm = strmid(dateInp,4,2)
  yyyy = strmid(dateInp,0,4)

  filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y'+yyyy+'/M'+mm+'/'
  fileaer = 'd5_arctas_02.inst3d_ext-532nm_v.'+species+'.hsrl.'+dateInp+'_'+flightleg+'_sub.hdf.hdf'
  filemet = 'd5_arctas_02.met.hsrl.'+dateInp+'_'+flightleg+'_sub.hdf.hdf'
  read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, $
                   ssa, tau_du, backscat, mass, filetoread=filedir+fileaer
  read_lidartrack_met, hyai, hybi, lon, lat, time_, date, $
                       surfp, pblh, h, hghte, relhum, t, delp, $
                       filetoread=filedir+filemet

; Transpose arrays to be (time,hght)
  mass = transpose(mass)
  h = transpose(h) / 1000.  ; km
  hghte = transpose(hghte) / 1000.  ; km
  dz = hghte[*,0:71]-hghte[*,1:72]

; Put time into hour of day
  time = (time - long(time))*24.

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color
  !p.font=0

  nt = n_elements(time)
  position = [.15,.2,.95,.9]
  plot, indgen(n_elements(time)), /nodata, $
   xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
   yrange=[0,20], ytitle='altitude [km]', $
   position=position, $
   title = 'GEOS-5 mass profile ('+species+') [ppbm]!C'+ $
           'along HSRL track '+dateInp+' '+flightleg, $
           charsize=.75
  loadct, 39
  levelarray = findgen(60)*4/10
  colorarray = findgen(60)*4+16
  plotgrid, mass*1e9, levelarray, colorarray, $
            time, h, time[1]-time[0], dz
  labelarray = strarr(60)
  labels = [0, 50, 100, 150, 200]/10
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
    if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(labels[il],format='(i3)')
  endfor
  makekey, .15, .05, .8, .035, 0, -.035, color=colorarray, $
   label=labelarray, $
   align=.5, /no

   loadct, 0
   dxplot = position[2]-position[0]
   dyplot = position[3]-position[1]
   x0 = position[0]+.65*dxplot
   x1 = position[0]+.95*dxplot
   y0 = position[1]+.65*dyplot
   y1 = position[1]+.95*dyplot
   map_set, /noerase, position=[x0,y0,x1,y1], limit=[30,-180,80,-80]
   map_continents, thick=.5
   oplot, lon, lat, thick=6

  device, /close

end
