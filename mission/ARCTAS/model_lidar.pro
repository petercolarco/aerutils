  trackdir = '/misc/prc11/colarco/arctas/data/hsrl/ARCTAS1/ARCTAS1_Final_Archive_Reduced_HDF_Files/'
;  trackdir = '/misc/prc11/colarco/arctas/data/hsrl/ARCTAS2/ARCTAS2_Final_Archive_Reduced_HDF_Files/'
  trackfiles = file_search(trackdir+'*.hdf')
trackfiles = trackfiles[18]
  yyyy = strmid(trackfiles,strlen(trackdir), 4)
  mm = strmid(trackfiles,strlen(trackdir)+4, 2)
  dd = strmid(trackfiles,strlen(trackdir)+6, 2)
  datestr = yyyy+mm+dd
  fl = strmid(trackfiles,strlen(trackdir)+9, 2)
  b = where(mm eq '03' or mm eq '04')
;  b = where(mm eq '06' or mm eq '07')

  plotfile = './output/plots/model.dR_arctas2.ps'
;  plotfile = './output/plots/hsrl.junjul.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=8, /color, $
   xsize=25, ysize=20, xoff=.5, yoff=25.5, /landscape
  !p.font=0


;  for ifile = 0, n_elements(b)-1 do begin
  for ifile = 0, 0 do begin

  it = b[ifile]
  dateInp = yyyy[it]+mm[it]+dd[it]
  read_hsrl, trackfiles, lon, lat, fltalt, date, h, ext532, depol532, ext1064

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
; Plot the model Extinction

  filename = 'output/data/dR_arctas2.hsrl_532nm.'+datestr[it]+'_'+fl[it]+'.nc'
  extinction = 1.
  ssa        = 1.
  tau        = 1.
  backscat   = 1.
  aback_toa  = 1.
  aback_sfc  = 1.

  read_curtain, filename, lon, lat, time, z, dz, $
                    extinction_tot = extinction, $
                    ssa_tot = ssa, $
                    tau_tot = tau, $
                    backscat_tot = backscat, $
                    aback_toa_tot = aback_toa, $
                    aback_sfc_tot = aback_sfc

; Transpose arrays to be (time,hght)
  z  = transpose(z) / 1000.  ; km
  dz = transpose(dz) / 1000. ; km

; Put time into hour of day
  time = (time - long(time[0]))*24.
  nt = n_elements(time)


; extinction
  extinction = transpose(extinction)
  title = 'Extinction [km-1, 532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,0], $
     title = title
  levelarray = 10.^(-2.+findgen(60)*(alog10(.2)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, extinction, levelarray, colorarray, $
            time, z, time[1]-time[0], dz
  dxplot = position[2,0]-position[0,0]
  dyplot = position[3,0]-position[1,0]
  x0 = position[0,0]+.65*dxplot
  x1 = position[0,0]+.95*dxplot
  y0 = position[1,0]+.65*dyplot
  y1 = position[1,0]+.95*dyplot
  map_set, /noerase, position=[x0,y0,x1,y1], limit=[30,-180,80,-80]
  map_continents, thick=.5
  oplot, lon, lat, thick=6, color=254

; optical depth
  tau = transpose(tau)
; integrate in vertical
  nz = 72
  for iz = nz-1, 1, -1 do begin
   tau[*,iz] = total(tau[*,0:iz],2)
  endfor
  title = 'Optical Depth [532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,1], $
     title = title
  levelarray = 10.^(-2.+findgen(60)*(alog10(.2)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, tau, levelarray, colorarray, $
            time, z, time[1]-time[0], dz

  labelarray = strarr(60)
  labels = [.01, .02, .04, .08, .16]
  for il = 0, n_elements(labels)-1 do begin
      for ia = n_elements(levelarray)-1, 0, -1 do begin
       if(levelarray[ia] ge labels[il]) then a = ia
      endfor
      labelarray[a] = string(labels[il],format='(f5.3)')
  endfor
     a = where(labelarray eq string(max(labels),format='(f5.3)'))
     labelarray[a] = '>'+labelarray[a]
     makekey, .05+.57/61., .65, .57-.57/61., .02, 0, -.02, color=colorarray, $
      label=labelarray, align=0, /no, charsize=1.25
     makekey, .05, .65, .57/61., .02, 0, -.02, color=[255], $
      label=['<',''], align=.5, charsize=1.25


; SSA
  ssa = transpose(ssa)
  title = 'Single-Scatter Albedo [532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,2], $
     title = title
  levelarray = .88 + findgen(60)*.002
  colorarray = reverse(findgen(60)*4+16)
  plotgrid, ssa, levelarray, colorarray, $
            time, z, time[1]-time[0], dz
     labels = [.88,.9,.92,.94,.96,.98]
     labelarray = strarr(60)
     for il = 0, n_elements(labels)-1 do begin
      for ia = n_elements(levelarray)-1, 0, -1 do begin
       if(levelarray[ia] ge labels[il]) then a = ia
      endfor
      labelarray[a] = string(labels[il],format='(f4.2)')
     endfor

     makekey, .65, .65, .27, .02, 0, -.02, color=colorarray, $
      label=labelarray, align=0, /no, charsize=1.25


; Backscatter
  backscat = transpose(backscat)
  title = 'Backscatter [Mm-1 sr-1, 532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,3], $
     title = title
  levelarray = 10.^(-2.+findgen(60)*(alog10(1.)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, backscat*1000., levelarray, colorarray, $
            time, z, time[1]-time[0], dz


; Aback_sfc
  aback_sfc = transpose(aback_sfc)
  title = 'Att. Backscatter (sfc) [Mm-1 sr-1, 532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,4], $
     title = title
  levelarray = 10.^(-2.+findgen(60)*(alog10(1.)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, aback_sfc*1000., levelarray, colorarray, $
            time, z, time[1]-time[0], dz

; Aback_toa
  aback_toa = transpose(aback_toa)
  title = 'Att. Backscatter (TOA) [Mm-1 sr-1, 532 nm]'
  plot, indgen(n_elements(time)), /nodata, /noerase, $
     xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
     yrange=[0,20], ytitle = ystr, $
     position=position[*,5], $
     title = title
  levelarray = 10.^(-2.+findgen(60)*(alog10(1.)-alog10(.01))/60.)
  colorarray = findgen(60)*4+16
  plotgrid, aback_toa*1000., levelarray, colorarray, $
            time, z, time[1]-time[0], dz


  labelarray = strarr(60)
  labels = [.01, .02, .04, .08, .16, .32, .64]
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

  endfor

  device, /close

end
