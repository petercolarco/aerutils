; Header information
;  plottitlehead = tag that names output files
;  datewant = two-element array of begin and end YYYYMM
;  ctlfile = n-element array of control file names to read
;  typefile = n-element array of type of each control file (tau, diag, MOD04, etc.)
;  colorarray = n_element array of rainbow pallette colors
;  linarray = n-element linestyle array
;  resolution = n-element array of resolution of each data set (b, c)
;  scolorarray = n_element array of grey pallette background colors for std-dev

draft = 0;  suppress printing statistics on plot

; MODIS MYD04
  plottitlehead = 'MYD04.b'
  datewant=['200301','200912']
  ctlfile  = ['MYD04_L2_051.mm.qawt.lnd.b.ctl','MYD04_L2_051.mm.qawt3.lnd.b.ctl', $
              'MYD04_L2_051.mm.noqawt.lnd.b.ctl']
;              'MYD04_L2_051.monthly.qawt.lnd.b.ctl','MYD04_L2_051.monthly.qawt3.lnd.b.ctl', $
;              'MYD04_L2_051.monthly.noqawt.lnd.b.ctl']
  typefile = ['MODIS','MODIS','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [76,254,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]


; Rp_control MYD04
  plottitlehead = 'R_control'
  datewant=['200301','200312']
  ctlfile  = ['MOD04_L2_051.lnd.qawt3.ctl','R_control.MOD04_lnd.qawt3.ctl']
  typefile = ['MODIS','tau','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [0,78,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]
  draft = 1



  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  ymaxwant = float([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
  ymaxwant[*] = 0.5
  ymaxwant[8] = 1.
  ymaxwant[10] = 1.
  ymaxwant[14:15] = 1.
  ytitle = 'AOT [550 nm]'
  maskwant = [2,   -2,  1,   1,   1,  1,  -2,  5,  5,  4,  4,  4,  3,  3,  5,  5]
  lon0want = [0,    0,  0,-100,-130,  0,-179,  0,  0,  0,100,  0,  0,-15,-20,  0]
  lon1want = [359,359,359, -10,-100,360, -10,360,360,360,360,100,360, 30, 10,360]
  lat0want = [-89,-89,  0,  23,  28,  0,  50,-40,  0, 45,  0,-89,-89,  0, 10,-10]
  lat1want = [89,  89, 89,  50,  50, 32,  89,  0, 45, 89, 45, 89, 89, 60, 30,  0]

  title = ['South America', 'Global (Land)', 'North America', $
           'Eastern United States', 'Western United States', 'Central America', $
            'Canada/Alaska/Greenland', $
           'Southern Africa', 'Northern Africa', 'North Asia', 'Southeastern Asia', $
           'Southwestern Asia', 'Europe', 'Western Europe', 'Western North Africa', 'Southern Africa (2)']
  plottitle = 'lnd.'+ ['aot_south.ps', 'aot.ps', 'aot_nam.ps', $
                       'aot_enam.ps', 'aot_wnam.ps', 'aot_centam.ps', $
                       'aot_canada.ps', $
                       'aot_safr.ps', 'aot_nafr.ps', 'aot_nasia.ps', $
                       'aot_sasia.ps', 'aot_india.ps', 'aot_europe.ps', $
                       'aot_europe2.ps', 'aot_nafr2.ps', 'aot_safr2.ps']
; Put into order as in paper
  sortnum = [1,2,0,3,4,7,8,12,9,10,11,5,6,13,14,15]
  ymaxwant=ymaxwant[sortnum]
  maskwant=maskwant[sortnum]
  lon0want=lon0want[sortnum]
  lon1want=lon1want[sortnum]
  lat0want=lat0want[sortnum]
  lat1want=lat1want[sortnum]
  title   =title[sortnum]
  plottitle=plottitle[sortnum]


  plottitle = './output/plots/'+plottitlehead+'.lnd.ps'
  nreg = n_elements(maskwant)



; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  regional_std = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               wantlev=5.5e-7
               template = 1
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
    endcase

    spawn, 'echo ${BASEDIRAER}', basedir
    case resolution[ictl] of
     'd' : begin
           nx = 576
           ny = 361
           maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
           maskvar = 'region_mask'
           end
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
     'b' : begin
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
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant, wantlev=wantlev, template=template
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

; Mask on the monthly basis
if(ictl eq 0) then begin
maskmonth = inp
a=where(maskmonth lt 100.)
maskmonth[a] = 1.
a = where(maskmonth ge 100.)
maskmonth[a] = !values.f_nan
endif
if(ictl ge 2) then begin
inp = inp*maskmonth
endif

    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
      regional_std[it,ireg,ictl] = stdreg
     endfor
    endfor
    lonsave = lon
    latsave = lat
    date = strmid(time,0,4)+strmid(time,5,2)

  endfor

; Plot
  set_plot, 'ps'
  courier=0
  helvetica=1
  if(draft) then begin
   courier=1
   helvetica=0
  endif
  device, file=plottitle, font_size=12, courier=courier, helvetica=helvetica, $
   xsize=20, ysize=10, xoff=.5, yoff=26, /landscape, /color
  !P.font=0

  for ireg = 0, nreg-1 do begin

  print, title[ireg]

  val=reform(regional_val[*,ireg,*])
  std=reform(regional_std[*,ireg,*])
  plot_strip, date, val, ymaxwant[ireg], title[ireg], ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              thick=thick, colortable=colortable, $
              std=std, scolorarray=scolorarray, $
              linestyle=linarray, draft=draft

  endfor

  device, /close

end


