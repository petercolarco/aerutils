; Colarco, April 2011
; Refinement on aot_strip.ocn and aot_strip.lnd
; Given a data base of average regions, show the
; comparison of model and satellite AOT (possibly
; multiple instances of each) as a strip chart
; and then on a separate strip show the model
; (one realization) compositional AOT.

; For now the assumption is that all the fields
; are provided at the same resolution

; head name for plot filename
  expid = 'bR_Fortuna-2_4-b4'

; Array of satellite control files
  ctlfile_sat  = ['MYD04_l3a.lnd.nnr.ctl', $
                  'MOD04_l3a.lnd.nnr.ctl']
  typfile_sat  = ['MODNNR','MODNNR']
  colorarr_sat = [0, 0]
  linesarr_sat = [0, 2]

; Array of model control files
  ctlfile_mod = ['bR_Fortuna-2_4-b4.MYD04_l3a.lnd.nnr.ctl', $
                 'bRnoq_Fortuna-2_4-b4.MYD04_l3a.lnd.nnr.ctl']

  typfile_mod = ['hwl','hwl']
  colorarr_mod = [254,254]
  linesarr_mod = [0,2]

; datewant
  datewant = ['200701','200812']

  colortable = 39

; Get the regions
  getregions,     nreg, ymaxwant, maskwant, $
                  lon0want, lon1want, $
                  lat0want, lat1want, $
                  regtitle
nreg = 38
;ymaxwant[*] = 0.3
  ytitle = 'AOT [550 nm]'


;  Get the lat/lon/time (assume all the same for now)
   nc4readvar, ctlfile_sat[0], '', varout, lon=lon, lat=lat, lev=lev, $
               nymd=nymd, wantnymd=datewant 
   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)
   nt = n_elements(nymd)

   

  plottitle = './output/plots/'+expid+'.lnd.ps'


; Loop over the number of control files
  ctlfile = [ctlfile_sat, ctlfile_mod]
  typfile = [typfile_sat, typfile_mod]
  linarray = [linesarr_sat,linesarr_mod]
  colorarray = [colorarr_sat,colorarr_mod]
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl+5)
  regional_std = fltarr(nt, nreg, nctl+5)
  for ictl = 0, nctl-1 do begin

    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)

    template = 0
    case typfile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', $
                      'bcphobic', 'so4']
               template = 1
               wantlev=5.5e-7
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'hwl'   : begin
               var = ['ssexttau', 'duexttau', 'suexttau', 'bcexttau', 'ocexttau']
               wantlev=-9999
               end
     'diag'  : begin
               var = ['ssexttau', 'duexttau', 'suexttau', 'bcexttau', 'ocexttau']
               wantlev=-9999
               end
     'g5diag': begin
               doshift = 1
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MODNNR': begin
               var = ['tau_']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=558.
               end
    endcase

    nvars = n_elements(var)
    print, ctlfile[ictl]
    datewant_ = datewant
    print, 'Reading vars: ', var
    nc4readvar, ctlfile[ictl], var, varout, lon=lon, lat=lat, $
     wantnymd=datewant_, wantlev=wantlev, template=template, nymd=nymd
    varout = reform(varout)

;   Discard values above some threshold for NAN
    a= where(varout gt 990.)
    if(a[0] ne -1) then varout[a] = !values.f_nan

;   Sum up over components (if present)
    if(nvars gt 1) then inp = total(varout,4) else inp = varout

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
     if(nvars gt 1) then varout = shift(varout,nx/2,0,0,0) else $
                         varout = shift(varout,nx/2,0,0)
    endif

    spawn, 'echo ${BASEDIRAER}', basedir
    case nx of
     576 : begin
           nx = 576
           ny = 361
           maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
           maskvar = 'region_mask'
           end
     288 : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
     144 : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
    endcase

;   Read the regional mask
    ga_getvar, maskfile, maskvar, mask, lon=lon, lat=lat

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     mask = shift(mask,nx/2,0)
    endif

    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0
    a = where(mask gt 0)
    if(a[0] ne -1) then mask[a] = 1

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
    if(ctlfile[ictl] eq ctlfile_mod[0]) then begin
     for isp = 0, 4 do begin

;    integrate over regions
     for it = 0, nt-1 do begin
      for ireg = 0, nreg-1 do begin
       stdreg = 1.
       integrate_region, varout[*,*,it,isp], lon, lat, mask, $
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
    date = strmid(nymd,0,4)+strmid(nymd,5,2)

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
  plot_strip, date, val, ymaxwant[ireg], regtitle[ireg], ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              thick = thick, colortable=colortable, $
              linestyle=linarray, draft=draft, position=position0
  plot_comp_aot, date, comp_aot, ymaxwant[ireg], regtitle[ireg], ytitle, ctlfile, $
                 q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=[76,208,176,0,254], $
                 thick = thick, colortable=colortable, $
                 draft=draft, position=position1, /noerase, $
                 sattrace = val[*,0]


  endfor

  device, /close



end

