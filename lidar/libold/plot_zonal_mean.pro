  daterange = '20080615_20080630'
  track     = '01d'
  species   = 'total'

  filedir = './'
  read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, ssa, tau, backscat, mass, $
                   filetoread=filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species+$
                              '.zonal_mean.'+daterange+'.'+track+'.hdf'
  read_lidartrack_met, hyai, hybi, lon, lat, time_, date, $
                       surfp, pblh, h, hghte, relhum, t, delp, $
                       filetoread=filedir+'d5_arctas_02.met.zonal_mean.'+$
                                  daterange+'.'+track+'.hdf'

; Transpose arrays to be (time,hght)
  extinction = transpose(extinction)
  h = transpose(h) / 1000.  ; km
  hghte = transpose(hghte) / 1000.  ; km
  dz = hghte[*,0:71]-hghte[*,1:72]

; Put time into fraction of day
  time = time - long(time)

  set_plot, 'ps'
  device, file='./output/plots/d5_arctas_02.inst3d_ext-532nm_v.'+species+ $
               '.zonal_mean.'+daterange+'.'+track+'.ps', /helvetica, font_size=14, /color
  !p.font=0

  nt = n_elements(time)
  position = [.15,.2,.95,.9]
  plot, indgen(n_elements(time)), /nodata, $
   xrange=[-90,90], xtitle='Latitude', xstyle=1, $
   yrange=[0,20], ytitle='altitude [km]', $
   position=position, $
   title = 'GEOS-5 extinction profile ('+species+') [km-1, 532 nm]!C'+ $
           'zonal mean along CALIPSO track '+daterange+' ('+track+')', $
           charsize=.75
  loadct, 39
  levelarray = 10.^(-2.+findgen(60)*(alog10(.45)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, extinction, levelarray, colorarray, $
            lat, h, lat[1]-lat[0], dz
  labelarray = strarr(60)
  levelarray = strcompress(string(levelarray,format='(f5.3)'),/rem)
  labels = strcompress(string([.01, .02, .04, .08, .16, .32],format='(f5.2)'),/rem)
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
    if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(levelarray[a],format='(a4)')
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
   map_set, /noerase, position=[x0,y0,x1,y1]
   map_continents, thick=.5
   oplot, lon, lat, thick=6

  device, /close

end
