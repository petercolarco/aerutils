;  trackdir = '/misc/prc10/colarco/arctas/data/hsrl/ARCTAS1/ARCTAS1_Final_Archive_Reduced_HDF_Files/'
  trackdir = '/misc/prc10/colarco/arctas/data/hsrl/ARCTAS2/ARCTAS2_Final_Archive_Reduced_HDF_Files/'
  trackfiles = file_search(trackdir+'*.hdf')
  yyyy = strmid(trackfiles,strlen(trackdir), 4)
  mm = strmid(trackfiles,strlen(trackdir)+4, 2)
  dd = strmid(trackfiles,strlen(trackdir)+6, 2)
  fl = strmid(trackfiles,strlen(trackdir)+9, 2)
;  b = where(mm eq '04')
  b = where(mm eq '06' or mm eq '07')

;  plotfile = './output/plots/hsrl.april.ps'
  plotfile = './output/plots/hsrl.junjul.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=8, /color, $
   xsize=25, ysize=20, xoff=.5, yoff=25.5, /landscape
  !p.font=0


  for ifile = 0, n_elements(b)-1 do begin

  it = b[ifile]
  dateInp = yyyy[it]+mm[it]+dd[it]
  flightleg = fl[it]
  trackfile = trackdir + dateInp+'_'+flightleg+'_sub.hdf'
  read_hsrl, trackfile, lon, lat, fltalt, date, h, ext532, depol532, ext1064



; Transpose arrays to be (time,hght)
  ext532 = transpose(ext532)
  depol532 = transpose(depol532)
  fltalt = fltalt/1000.
  h = h/1000.
  dz = 30./1000.
  time = (date - long(date[0]))*24.
  nt = n_elements(time)

  position = fltarr(4,9)
  position[*,0]=[.05,.72,.32,.9]
  position[*,1]=[.35,.72,.62,.9]
  position[*,2]=[.65,.72,.92,.9]
  position[*,3]=[.05,.42,.32,.6]
  position[*,4]=[.35,.42,.62,.6]
  position[*,5]=[.65,.42,.92,.6]
  position[*,6]=[.05,.12,.32,.3]
  position[*,7]=[.35,.12,.62,.3]
  position[*,8]=[.65,.12,.92,.3]
  loadct, 39

; ------------------------
; Plot the HSRL extinction
  plot, indgen(n_elements(time)), /nodata, $
   xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
   yrange=[0,20], ytitle='altitude [km]', $
   position=position[*,0], $
   title = 'HSRL extinction profile [km-1, 532 nm]'
  levelarray = 10.^(-2.+findgen(60)*(alog10(.45)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, ext532, levelarray, colorarray, $
            time, h, time[1]-time[0], dz
  oplot, time, fltalt, thick=6
  labelarray = strarr(60)
  labels = [.01, .02, .04, .08, .16, .32]
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
    if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(labels[il],format='(f4.2)')
  endfor
     a = where(labelarray eq string(max(labels),format='(f4.2)'))
  labelarray[a] = '>'+labelarray[a]
  makekey, .05+.87/61., .65, .87-.87/61., .02, 0, -.02, color=colorarray, $
   label=labelarray, align=0, /no, charsize=1.25
  makekey, .05, .65, .87/61., .02, 0, -.02, color=[255], $
   label=['ND<',''], align=.5, charsize=1.25
  xyouts, .05, .95, dateInp+' '+flightleg, charsize=1.25, /normal

  dxplot = position[2,0]-position[0,0]
  dyplot = position[3,0]-position[1,0]
  x0 = position[0,0]+.65*dxplot
  x1 = position[0,0]+.95*dxplot
  y0 = position[1,0]+.65*dyplot
  y1 = position[1,0]+.95*dyplot
  map_set, /noerase, position=[x0,y0,x1,y1], limit=[30,-180,80,-80]
  map_continents, thick=.5
  oplot, lon, lat, thick=6, color=254


; ------------------------
; Plot the HSRL depol
  plot, indgen(n_elements(time)), /nodata, /noerase, $
   xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
   yrange=[0,20], $
   position=position[*,1], $
   title = 'HSRL Depolarization Ratio [532 nm]'
  levelarray = 10.^(-2.+findgen(60)*(alog10(.45)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, depol532, levelarray, colorarray, $
            time, h, time[1]-time[0], dz
  oplot, time, fltalt, thick=6

; ------------------------
; Plot the model Extinction
  species_ = ['total','dust','sulfate','oc','bc','seasalt']
  for isp = 0, 5 do begin
    species = species_[isp]
    filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y'+yyyy[it]+'/M'+mm[it]+'/'
    fileaer = 'd5_arctas_02.inst3d_ext-532nm_v.'+species+'.hsrl.'+dateInp+'_'+flightleg+'_sub.hdf.hdf'
    filemet = 'd5_arctas_02.met.hsrl.'+dateInp+'_'+flightleg+'_sub.hdf.hdf'
    read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, $
                     ssa, tau_du, backscat, filetoread=filedir+fileaer
    read_lidartrack_met, hyai, hybi, lon, lat, time_, date, $
                         surfp, pblh, h, hghte, relhum, t, delp, cloud, taucli, tauclw, $
                         filetoread=filedir+filemet

;   Transpose arrays to be (time,hght)
    extinction = transpose(extinction)
    h = transpose(h) / 1000.  ; km
    hghte = transpose(hghte) / 1000.  ; km
    dz = hghte[*,0:71]-hghte[*,1:72]

;   Put time into hour of day
    time = (time - long(time[0]))*24.

    ystr = ''
    if(isp eq 1 or isp eq 4) then ystr = 'altitude [km]'

    plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,isp+2], $
     title = 'GEOS-5 ('+species+') extinction [km-1, 532 nm]'
    levelarray = 10.^(-2.+findgen(60)*(alog10(.45)-alog10(.01))/60.)
    colorarray = findgen(60)*4+16
    if(isp ge 1) then $
     levelarray = 10.^(-3.+findgen(60)*(alog10(.45)-alog10(.01))/60.)

    plotgrid, extinction, levelarray, colorarray, $
              time, h, time[1]-time[0], dz
    oplot, time, fltalt, thick=6

    if(isp eq 1) then begin
     labels = [.01, .02, .04, .08, .16, .32]/10.
     for il = 0, n_elements(labels)-1 do begin
      for ia = n_elements(levelarray)-1, 0, -1 do begin
       if(levelarray[ia] ge labels[il]) then a = ia
      endfor
      labelarray[a] = string(labels[il],format='(f5.3)')
     endfor
     a = where(labelarray eq string(max(labels),format='(f5.3)'))
     labelarray[a] = '>'+labelarray[a]
     makekey, .05+.87/61., .35, .87-.87/61., .02, 0, -.02, color=colorarray, $
      label=labelarray, align=0, /no, charsize=1.25
     makekey, .05, .35, .87/61., .02, 0, -.02, color=[255], $
      label=['<',''], align=.5, charsize=1.25
    endif

    if(isp eq 4) then begin
     labels = [.01, .02, .04, .08, .16, .32]/10.
     for il = 0, n_elements(labels)-1 do begin
      for ia = n_elements(levelarray)-1, 0, -1 do begin
       if(levelarray[ia] ge labels[il]) then a = ia
      endfor
      labelarray[a] = string(labels[il],format='(f5.3)')
     endfor
     a = where(labelarray eq string(max(labels),format='(f5.3)'))
     labelarray[a] = '>'+labelarray[a]
     makekey, .05+.57/61., .05, .57-.57/61., .02, 0, -.02, color=colorarray, $
      label=labelarray, align=0, /no, charsize=1.25
     makekey, .05, .05, .57/61., .02, 0, -.02, color=[255], $
      label=['<',''], align=.5, charsize=1.25
    endif

  endfor

    plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,8], $
     title = 'GEOS-5 cloud fraction'
    levelarray = findgen(50)*.02
    levelarray[0] = .01
    colorarray = findgen(50)*5+6

    plotgrid, transpose(cloud), levelarray, colorarray, $
              time, h, time[1]-time[0], dz
    oplot, time, fltalt, thick=6

    labels = [0.,.2,.4,.6,.8,.9]
    labelarray = strarr(50)
    for il = 0, n_elements(labels)-1 do begin
     for ia = n_elements(levelarray)-1, 0, -1 do begin
      if(levelarray[ia] ge labels[il]) then a = ia
     endfor
     labelarray[a] = string(labels[il],format='(f3.1)')
    endfor

    makekey, .65, .05, .27, .02, 0, -.02, color=colorarray, $
     label=labelarray, align=0, /no, charsize=1.25


  endfor


  device, /close

end
