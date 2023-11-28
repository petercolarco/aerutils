; Colarco, April 2011
; Refinement on aot_strip.ocn and aot_strip.lnd
; Given a data base of average regions, show the
; comparison of model and satellite AOT (possibly
; multiple instances of each) as a strip chart
; and then on a separate strip show the model
; (one realization) compositional AOT.

; For now the assumption is that all the fields
; are provided at the same resolution

; Pair of YYYYMM dates that you want to span
  datewant = ['20070101','20071231']

; Satellites you want to sample
  satid = ['MYD04']
  ressatid = ['d','d']
  colorarr_sat = [100, 100]
  colortab_sat = [0,0]
  linesarr_sat = [0, 2]

;; MISR
;  satid = ['MISR']
;  ressatid = ['d']
;  colorarr_sat = [100]
;  colortab_sat = [0]
;  linesarr_sat = [0]

;; Model experiments you want to sample
;  expidstr = 'dR_MERRA-AA-r1.NNR'  ; plot string
;  expid = ['dR_MERRA-AA-r1','dR_Fortuna-2-4-b4','cR_Fortuna-2-4-b4','R_QFED_22a1']
;  nnr = 1
;  resmodel = ['d','d','c','b']
;  colorarr_mod = [0,0,75,254]
;  colortab_mod = [39,39,39,39]
;  linesarr_mod = [2,0,0,0]

; Model experiments you want to sample
  expidstr = 'dR_Fortuna-2-4-b4'  ; plot string
  expid = ['dR_Fortuna-2-4-b4','cR_Fortuna-2-4-b4','R_QFED_22a1']
  nnr = 0
  resmodel = ['d','c','b']
  colorarr_mod = [0,75,254]
  colortab_mod = [39,39,39]
  linesarr_mod = [0,0,0]

; Model experiments you want to sample
  expidstr = 'dR_Fortuna-2-4-b4.MISR'  ; plot string
  expid = ['dR_Fortuna-2-4-b4','cR_Fortuna-2-4-b4','R_QFED_22a1']
  nnr = 0
  resmodel = ['d','c','b']
  colorarr_mod = [0,75,254]
  colortab_mod = [39,39,39]
  linesarr_mod = [0,0,0]


; Model experiments you want to sample
  expidstr = 'dR_Fortuna-2_5-b8'  ; plot string
  expid = ['dR_Fortuna-2_5-b8','dR_Fortuna-M-1-1','dR_MERRA-AA-r1']
  nnr = 1
  resmodel = ['d','d','d']
  colorarr_mod = [254,75,0]
  colortab_mod = [39,39,39]
  linesarr_mod = [0,0,0]



; Model control files
  if(nnr) then begin
   ctlmodelocean = expid + '.MYD04_l3a.ocn.nnr.ctl'
   ctlmodelland  = expid + '.MYD04_l3a.lnd.nnr.ctl'
  endif else begin 
   ctlmodelocean = expid + '.MYD04_ocn.qawt.ctl'
   ctlmodelland  = expid + '.MYD04_lnd.qawt3.ctl'
  endelse
  if(satid[0] eq 'MISR') then begin
   ctlmodelocean = expid + '.MISR.ctl'
   ctlmodelland  = ctlmodelocean
   nnr = 0
  endif


; -------------------------------
; Hopefully not modify below here

; Expand the dates
  dateexpand, datewant[0], datewant[1], '120000','120000', nymd, nhms, /monthly
  date = strmid(nymd,0,6)
  yyyy = strmid(nymd,0,4)
  mm   = strmid(nymd,4,2)
  nt = n_elements(nymd)
  nx = 144
  ny = 91

; Get the regions
  getregions,      nreg, ymaxwant, maskwant, $
                   lon0want, lon1want, $
                   lat0want, lat1want, $
                   regtitle
  getregionsocean, nreg_, ymaxwant_, maskwant_, $
                   lon0want_, lon1want_, $
                   lat0want_, lat1want_, $
                   regtitle_
  getregionsland,  nreg__, ymaxwant__, maskwant__, $
                   lon0want__, lon1want__, $
                   lat0want__, lat1want__, $
                   regtitle__
  nreg = nreg+nreg_+nreg__
  ymaxwant = [ymaxwant,ymaxwant_,ymaxwant__]
  maskwant = [maskwant,maskwant_,maskwant__]
  lon0want = [lon0want,lon0want_,lon0want__]
  lon1want = [lon1want,lon1want_,lon1want__]
  lat0want = [lat0want,lat0want_,lat0want__]
  lat1want = [lat1want,lat1want_,lat1want__]
  regtitle = [regtitle,regtitle_,regtitle__]

  ymaxwant[38] = 1.
  ymaxwant[47] = .5
  ymaxwant[48] = .5
  ymaxwant[46] = .25

  ytitle = 'AOT [550 nm]'

; Set up the output arrays
  nsat = n_elements(satid)
  nmod = n_elements(expid)
  linarray = [linesarr_sat[0:nsat-1],linesarr_mod[0:nmod-1]]
  colorarray = [colorarr_sat[0:nsat-1],colorarr_mod[0:nmod-1]]
  colortable = [colortab_sat[0:nsat-1],colortab_mod[0:nmod-1]]
  nctl = nsat+nmod
  regional_val = fltarr(nt, nreg, nctl+5)
  regional_std = fltarr(nt, nreg, nctl+5)

; Get the satellite data
  for isat = 0, nsat-1 do begin

    res = ressatid[isat]
    getmask, res, nx, ny, mask, lon, lat

    read_aot, aot, lon, lat, yyyy, mm, satid=satid[isat], res=ressatid[isat], old = 1-nnr

    ndims = size(aot)
    ndims = ndims[0]
    inp = fltarr(nx,ny,nt)
    q = fltarr(nx,ny,nreg)

;   Discard values above some threshold for NAN
    a= where(aot gt 990.)
    if(a[0] ne -1) then aot[a] = !values.f_nan

;   Sum up over components (if present)
    if(ndims ge 4) then inp = total(aot,4) else inp = aot

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
     if(ndims ge 4) then aot = shift(aot,nx/2,0,0,0) else $
                         aot = shift(aot,nx/2,0,0)
    endif

;   integrate over regions
    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg,  $
                        q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,isat] = intreg
      regional_std[it,ireg,isat] = stdreg
     endfor
    endfor

  endfor

; Now do the model
  for imod = 0, nmod-1 do begin
print, imod
    ictl = nsat + imod

    res = resmodel[imod]
    getmask, res, nx, ny, mask, lon, lat

    read_aot, aot, lon, lat, yyyy, mm, res=res, /model, $
              ctlmodelo=ctlmodelocean[imod], ctlmodell=ctlmodelland[imod]
    ndims = size(aot)
    ndims = ndims[0]

    inp = fltarr(nx,ny,nt)
    q = fltarr(nx,ny,nreg)

;   Discard values above some threshold for NAN
    a= where(aot gt 990.)
    if(a[0] ne -1) then aot[a] = !values.f_nan

;   Sum up over components (if present)
    if(ndims ge 4) then inp = total(aot,4) else inp = aot

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
     if(ndims ge 4) then aot = shift(aot,nx/2,0,0,0) else $
                         aot = shift(aot,nx/2,0,0)
    endif

;   integrate over regions
    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg,  $
                        q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
      regional_std[it,ireg,ictl] = stdreg
     endfor
    endfor

;   If doing the first model control file, do speciated AOT
    if(imod eq 0) then begin
     for isp = 0, 4 do begin

;    integrate over regions
     for it = 0, nt-1 do begin
      for ireg = 0, nreg-1 do begin
       stdreg = 1.
       integrate_region, aot[*,*,it,isp], lon, lat, mask, $
                         maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                         lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback, std=stdreg
       q[*,*,ireg] = qback
       regional_val[it,ireg,nctl+isp] = intreg
       regional_std[it,ireg,nctl+isp] = stdreg
      endfor
     endfor

     endfor
    endif
jump:
    lonsave = lon
    latsave = lat

  endfor

; Plot
  set_plot, 'ps'
  courier=0
  helvetica=1
  draft = 0
  if(draft) then begin
   courier=1
   helvetica=0
  endif
  plottitle = './output/plots/'+expidstr+'.ps'
  device, file=plottitle, font_size=12, courier=courier, helvetica=helvetica, $
   xsize=16, ysize=20, xoff=.5, yoff=.5, /color
  !P.font=0
  position0=[.1,.55,.95,.95]
  position1=[.1,.05,.95,.45]

  for ireg = 0, nreg-1 do begin

  print, regtitle[ireg]

  val=reform(regional_val[*,ireg,0:nctl-1])
  std=reform(regional_std[*,ireg,0:nctl-1])
  comp_aot = reform(regional_val[*,ireg,nctl:nctl+4])
  plot_strip, date, val, ymaxwant[ireg], regtitle[ireg], ytitle, [satid,expid], $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              colortable=colortable, $
              linestyle=linarray, draft=draft, position=position0
  plot_comp_aot, date, comp_aot, ymaxwant[ireg], regtitle[ireg], ytitle, [satid,expid], $
                 q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=[208,76,254,0,176], $
                 colortable=39, $
                 draft=draft, position=position1, /noerase, $
                 sattrace = val[*,0]


  endfor

  device, /close



end

