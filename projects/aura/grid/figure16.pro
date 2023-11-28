; Colarco
; February 2016
; Four Panel plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure16.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: AOD Plots (July)
  filetemplate = 'monthly.sampled.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.575,.475,.925]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV - MERRAero AOD Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  colors=reverse(20+findgen(9)*30)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  plots, [-5,5,5,-5,-5], [24,24,28,28,24], thick=6, lin=0
  map_continents, thick=3
  map_grid, /box

  makekey, .05, .525, .4, .025, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1']
  loadct, 72
  makekey, .05, .525, .4, .025, 0, -.025, $
   labels=make_array(9,val=' '), $
   colors=colors


; Panel 2: SSA Plots (July)
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)
  filetemplate = 'monthly.sampled.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.575,.975,.925]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV - MERRAero SSA Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  plots, [-5,5,5,-5,-5], [24,24,28,28,24], thick=6, lin=0
  map_continents, thick=3
  map_grid, /box

  makekey, .55, .525, .4, .025, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .55, .525, .4, .025, 0, -.025, $
   labels=make_array(9,val=' '), $
   colors=colors


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
     ai_  = reform(ai_,nxy_)
     ssa_ = reform(ssa_,nxy_)
     lon = [lon,lon_]
     lat = [lat,lat_]
     aod = [aod,aod_]
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

; Mask a region off
; Sahel box
; Sort dust by AI
  a = where(lon gt -5 and lon le 5 and lat gt 24 and lat le 28 and $
            aert eq 2 and aodomi gt 0)
  loadct, 39
  plot, indgen(2), /nodata, /noerase, $
   xrange=[.75,1], yrange=[.75,1], $
   position=[.075,.15,.325,.45], $
   ytitle='MERRAero SSA', xtitle='OMAERUV SSA'
; Normalize the ai for color
  aicol = ai[a]
  aicol[where(aicol gt 2)] = 1.
  aicol[where(aicol lt 0)] = 0.
  aicol = fix(aicol/2.*254)
  plots, ssaomi[a], ssa[a], psym=3, color=aicol
  xyouts, .77, .97, 'n = '+string(n_elements(a))
  xyouts, .075, .455, /normal, charsize=.75, $
   'c) Sorted by MERRAero AI'

; Sort Dust by AOD
  a = where(lon gt -5 and lon le 5 and lat gt 24 and lat le 28 and $
            aert eq 2 and aodomi gt 0)
  loadct, 39
  plot, indgen(2), /nodata, /noerase, $
   xrange=[.75,1], yrange=[.75,1], $
   position=[.4,.15,.65,.45], $
   ytitle=' ', xtitle='OMAERUV SSA'
; Normalize the ai for color
  aicol = aod[a]
  aicol[where(aicol gt 1)] = 1.
  aicol = fix(aicol/1.*254)
  plots, ssaomi[a], ssa[a], psym=3, color=aicol
  xyouts, .77, .97, 'n = '+string(n_elements(a))
  xyouts, .4, .455, /normal, charsize=.75, $
   'd) Sorted by MERRAero AOD'

; Sort Dust by AERH
  a = where(lon gt -5 and lon le 5 and lat gt 24 and lat le 28 and $
            aert eq 2 and aodomi gt 0)
  loadct, 39
  plot, indgen(2), /nodata, /noerase, $
   xrange=[.75,1], yrange=[.75,1], $
   position=[.725,.15,.975,.45], $
   ytitle=' ', xtitle='OMAERUV SSA'
; Normalize the ai for color
  aicol = aerh[a]
  aicol[where(aicol gt 4)] = 4.
  aicol = fix(aicol/4.*254)
  plots, ssaomi[a], ssa[a], psym=3, color=aicol
  xyouts, .77, .97, 'n = '+string(n_elements(a))
  xyouts, .725, .455, /normal, charsize=.75, $
   'e) Sorted by Retrieval Height'


  device, /close

  

end
