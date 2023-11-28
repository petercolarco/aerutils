; Colarco
; March 2016
; Gather retrieval information a specified region of latitudes and
; longitudes

; goto, jump
  mm = '07'

; July 2007

  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m'+mm+'*vl_rad.geos5_pressure.ext.he5')

  gfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
print, ifile

;   Get the model retrieval
    if(ifile eq 0) then begin
     aaewant = 1
     read_retrieval_ext, files[ifile], lon, lat, $
                         ler388, aod, ssa, $
                         duext, ssext, suext, ocext, bcext, $
                         residue, ai, prs, prso, $
                         rad354, rad388, aae= aaewant
     nxy = n_elements(lon)
     lon = reform(lon,nxy)
     lat = reform(lat,nxy)
     aod = reform(aod,nxy)
     aae = reform(aaewant,nxy)
     duext = reform(duext,nxy)
     suext = reform(suext,nxy)
     ssext = reform(ssext,nxy)
     ocext = reform(ocext,nxy)
     bcext = reform(bcext,nxy)
     ai  = reform(ai,nxy)
     ssa = reform(ssa,nxy)
     rad = reform(rad388,nxy)
     ler = reform(ler388,nxy)
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi
     id = ncdf_varid(cdfid,'ai')
     ncdf_varget, cdfid, id, aiomi
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi
     id = ncdf_varid(cdfid,'rad388')
     ncdf_varget, cdfid, id, radomi
     id = ncdf_varid(cdfid,'ref388')
     ncdf_varget, cdfid, id, refomi
     id = ncdf_varid(cdfid,'ler388')
     ncdf_varget, cdfid, id, leromi
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh
     ncdf_close, cdfid
     aodomi = reform(aodomi,nxy)
     aiomi  = reform(aiomi,nxy)
     ssaomi = reform(ssaomi,nxy)
     leromi = reform(leromi,nxy)
     refomi = reform(refomi,nxy)
     radomi = reform(radomi,nxy)
     aert   = reform(aert,nxy)
     aerh   = reform(aerh,nxy)
    endif else begin
     aaewant = 1
     read_retrieval_ext, files[ifile], lon_, lat_, $
                         ler388_, aod_, ssa_, $
                         duext_, ssext_, suext_, ocext_, bcext_, $
                         residue_, ai_, prs_, prso_, $
                         rad354_, rad388_, aae=aaewant
     nxy_ = n_elements(lon_)
     lon_ = reform(lon_,nxy_)
     lat_ = reform(lat_,nxy_)
     aod_ = reform(aod_,nxy_)
     aae_ = reform(aaewant,nxy_)
     ai_  = reform(ai_,nxy_)
     ssa_ = reform(ssa_,nxy_)
     duext_ = reform(duext_,nxy_)
     suext_ = reform(suext_,nxy_)
     ssext_ = reform(ssext_,nxy_)
     ocext_ = reform(ocext_,nxy_)
     bcext_ = reform(bcext_,nxy_)
     rad388_ = reform(rad388_,nxy_)
     ler388_ = reform(ler388_,nxy_)
     lon = [lon,lon_]
     lat = [lat,lat_]
     aod = [aod,aod_]
     aae = [aae,aae_]
     ai  = [ai,ai_]
     ssa = [ssa,ssa_]
     duext = [duext,duext_]
     suext = [suext,suext_]
     ssext = [ssext,ssext_]
     ocext = [ocext,ocext_]
     bcext = [bcext,bcext_]
     rad   = [rad,rad388_]
     ler   = [ler,ler388_]
     filem = gfilesd+strmid(files[ifile],strpos(files[ifile],'2007m'),21)+'_OMAERUVx_Outputs.nc4'
     cdfid = ncdf_open(filem)
     id = ncdf_varid(cdfid,'aod388')
     ncdf_varget, cdfid, id, aodomi_
     id = ncdf_varid(cdfid,'ai')
     ncdf_varget, cdfid, id, aiomi_
     id = ncdf_varid(cdfid,'ssa388')
     ncdf_varget, cdfid, id, ssaomi_
     id = ncdf_varid(cdfid,'rad388')
     ncdf_varget, cdfid, id, radomi_
     id = ncdf_varid(cdfid,'ref388')
     ncdf_varget, cdfid, id, refomi_
     id = ncdf_varid(cdfid,'ler388')
     ncdf_varget, cdfid, id, leromi_
     id = ncdf_varid(cdfid,'aert')
     ncdf_varget, cdfid, id, aert_
     id = ncdf_varid(cdfid,'aerh')
     ncdf_varget, cdfid, id, aerh_
     ncdf_close, cdfid
     aodomi = [aodomi,reform(aodomi_,nxy_)]
     aiomi  = [aiomi,reform(aiomi_,nxy_)]
     ssaomi = [ssaomi,reform(ssaomi_,nxy_)]
     aert   = [aert,reform(aert_,nxy_)]
     aerh   = [aerh,reform(aerh_,nxy_)]
     refomi = [refomi,reform(refomi_,nxy_)]
     radomi = [radomi,reform(radomi_,nxy_)]
     leromi = [leromi,reform(leromi_,nxy_)]
    endelse
  endfor

; Reduce data set only to points where OMI retrieved
  a = where(aodomi gt 0)
  aodomi = aodomi[a]
  aiomi  = aiomi[a]
  ssaomi = ssaomi[a]
  aert   = aert[a]
  aerh   = aerh[a]
  refomi = refomi[a]
  radomi = radomi[a]
  leromi = leromi[a]
  ler    = ler[a]
  rad    = rad[a]
  ai     = ai[a]
  aod    = aod[a]
  aae    = aae[a]
  ssa    = ssa[a]
  duext  = duext[a]
  suext  = suext[a]
  ssext  = ssext[a]
  ocext  = ocext[a]
  bcext  = bcext[a]
  lon    = lon[a]
  lat    = lat[a]

  save, file='getregions.aae.2007'+mm+'.sav', /all

jump:
  restore, file='getregions.aae.2007'+mm+'.sav'

; Mask a region off
  a = where(lon gt 5 and lon le 20 and lat gt -12 and lat le -6 and $
            aodomi gt 0)
  xrange = [5,20]

; Plot some regional stuff
  set_plot, 'ps'
  device, file='getregion.2007'+mm+'_safrica.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=26
  !p.font=0
  !p.multi = [0,2,5]

; AOD
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,4], $
   xtitle='longitude', ytitle='AOD', $
   title='AOD: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], aod[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], aodomi[a], psym=sym(1), color=84, symsize=.5

; AOD difference
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[-1,2], $
   xtitle='longitude', ytitle='AOD Difference', $
   title='OMAERUV - MERRAero AOD Difference'
  loadct, 39
  plots, lon[a], aodomi[a]-aod[a], psym=sym(1), color=84, symsize=.5


; SSA
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[.7,1], $
   xtitle='longitude', ytitle='SSA', $
   title='SSA: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ssa[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], ssaomi[a], psym=sym(1), color=84, symsize=.5

; SSA difference
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[-.2,.2], $
   xtitle='longitude', ytitle='SSA Difference', $
   title='OMAERUV - MERRAero SSA difference'
  loadct, 39
  plots, lon[a], ssaomi[a]-ssa[a], psym=sym(1), color=84, symsize=.5

; AI
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,5], $
   xtitle='longitude', ytitle='AI', $
   title='AI: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ai[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], aiomi[a], psym=sym(1), color=84, symsize=.5

; LER
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='LER', $
   title='LER388: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ler[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], leromi[a], psym=sym(1), color=84, symsize=.5

; AERH
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,4], $
   xtitle='longitude', ytitle='Aerosol Height [km]', $
   title='OMAERUV aerosol retrieval height'
  loadct, 39
  plots, lon[a], aerh[a], psym=sym(1), color=84, symsize=.5

; AERT
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,3.2], ystyle=1, $
   yticks=3, ytickv=[0,1,2,3], ytickn=[' ','1','2','3'], $
   xtitle='longitude', ytitle='Aerosol Type Flag', $
   title='OMAERUV aerosol type flag'
  loadct, 39
  plots, lon[a], aert[a], psym=sym(1), color=84, symsize=.5
  x = min(xrange)+.02*(max(xrange)-min(xrange))
  n = n_elements(where(aert[a] eq 1))
  xyouts, x, .6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 2))
  xyouts, x, 1.6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 3))
  xyouts, x, 2.6, 'n = '+string(n)

; REF
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Surface Reflectance @ 388', $
   title='OMAERUV Surface Reflectance @ 388 nm'
  loadct, 39
  plots, lon[a], refomi[a], psym=sym(1), color=84, symsize=.5

; RAD
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Radiance @ 388'
   title='Radiance @ 388 nm: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], rad[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], radomi[a], psym=sym(1), color=84, symsize=.5

device, /close

end
