; Colarco
; February 2016
; Four Panel plot of OMAERUV - MERRAero Results

; Panel 3: Read in the individual retrievals for the month, sort into
; a box, and compare model SSA to OMAERUV SSA for dust retrievals
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m07*vl_rad.geos5_pressure.he5')

  gfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
;  for ifile = 0, 24 do begin
print, ifile

;   Get the model retrieval
    if(ifile eq 0) then begin
     read_retrieval, files[ifile], lon, lat, $
                     ler388, aod, ssa, $
                     residue, ai, prs, prso, $
                     rad354, rad388
     nxy = n_elements(lon)
     lon = reform(lon,nxy)
     lat = reform(lat,nxy)
     aod = reform(aod,nxy)
     rad354 = reform(rad354,nxy)
     rad388 = reform(rad388,nxy)
     ai  = reform(ai,nxy)
     ssa = reform(ssa,nxy)
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh
     ncdf_close, cdfid
     aodomi = reform(aodomi,nxy)
     ssaomi = reform(ssaomi,nxy)
     aert   = reform(aert,nxy)
     aerh   = reform(aerh,nxy)
    endif else begin
     read_retrieval, files[ifile], lon_, lat_, $
                     ler388_, aod_, ssa_, $
                     residue_, ai_, prs_, prso_, $
                     rad354_, rad388_
     nxy_ = n_elements(lon_)
     lon_ = reform(lon_,nxy_)
     lat_ = reform(lat_,nxy_)
     aod_ = reform(aod_,nxy_)
     rad354_ = reform(rad354_,nxy_)
     rad388_ = reform(rad388_,nxy_)
     ai_  = reform(ai_,nxy_)
     ssa_ = reform(ssa_,nxy_)
     lon = [lon,lon_]
     lat = [lat,lat_]
     aod = [aod,aod_]
     rad354 = [rad354,rad354_]
     rad388 = [rad388,rad388_]
     ai  = [ai,ai_]
     ssa = [ssa,ssa_]
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi_
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi_
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert_
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh_
     ncdf_close, cdfid
     aodomi = [aodomi,reform(aodomi_,nxy_)]
     ssaomi = [ssaomi,reform(ssaomi_,nxy_)]
     aert   = [aert,reform(aert_,nxy_)]
     aerh   = [aerh,reform(aerh_,nxy_)]
    endelse
  endfor

; Setup the plot
  plotfile = 'plot_radiances.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0
  !p.multi=[0,2,2]


; Mask a region off
; Sahel box
; Sort dust by AI
  a = where(lon gt -5 and lon le 5 and lat gt 12 and lat le 16 and $
            aert eq 2 and aerh gt 0 and aodomi gt 0)

  loadct, 39
  plot, indgen(2), /nodata, $
   xrange=[0.04,.1], xtitle='i388', $
   yrange=[1,1.4], ytitle='i354/i388'
  aicol = aod[a]
  aicol[where(aicol gt 1)] = 1.
  aicol = fix(aicol/1.*254)
  plots, rad388[a], rad354[a]/rad388[a], psym=sym(1), color=aicol, symsize=.5

  plot, indgen(2), /nodata, $
   xrange=[0.04,.1], xtitle='i388', $
   yrange=[1,1.4], ytitle='i354/i388'
  aicol = aodomi[a]
  aicol[where(aicol gt 1)] = 1.
  aicol = fix(aicol/1.*254)
  plots, rad388[a], rad354[a]/rad388[a], psym=sym(1), color=aicol, symsize=.5

; Over ocean
  a = where(lon gt -40 and lon le -30 and lat gt 12 and lat le 16 and $
            aert eq 2 and aodomi gt 0)
  plot, indgen(2), /nodata, $
   xrange=[0.04,.1], xtitle='i388', $
   yrange=[1,1.4], ytitle='i354/i388'
  aicol = aod[a]
  aicol[where(aicol gt 1)] = 1.
  aicol = fix(aicol/1.*254)
  plots, rad388[a], rad354[a]/rad388[a], psym=sym(1), color=aicol

  plot, indgen(2), /nodata, $
   xrange=[0.04,.1], xtitle='i388', $
   yrange=[1,1.4], ytitle='i354/i388'
  aicol = aodomi[a]
  aicol[where(aicol gt 1)] = 1.
  aicol = fix(aicol/1.*254)
  plots, rad388[a], rad354[a]/rad388[a], psym=sym(1), color=aicol


  device, /close

  

end
