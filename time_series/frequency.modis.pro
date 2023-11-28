; Procedure is to compare different samplings of the model
; Look in a region and come up with the frequency of occurrence of various AOT
; values inside box

; Histogram features
  histmin=0.
  histmax=1.
  nbins=10

; Dates
  yyyy = ['2000','2001','2002','2003','2004','2005','2006']
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  ndm  = ['31','28','31','30','31','30','31','31','30','31','30','31']

; Models
  outfilehead = 'MOD04_regions.d.freq.'
  sample = ['modis','misr','subpoint']
;  sample = ['misr','subpoint']+'.shift'
  ctlfile  = 'MOD04_L2_005.d.ocn.qawt.'+sample+'.hr.ctl'
  typefile = ['MODIS','MODIS','MODIS']
  resolution = ['d','d','d']

; Pick regions based on the mask file
  nreg = 23
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

  i = 0
  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 11'
  plottitle[i] = 'aot.r11.x0_90.s30_0.'
 
  i = 1
  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 12'
  plottitle[i] = 'aot.r12.x90_180.s30_0.'
 
  i = 2
  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 9'
  plottitle[i] = 'aot.r09.x180_270.s30_0.'
 
  i = 3
  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 10'
  plottitle[i] = 'aot.r10.x270_360.s30_0.'
 
  i = 4
  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 7'
  plottitle[i] = 'aot.r07.x0_90.n0_30.'
 
  i = 5
  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 8'
  plottitle[i] = 'aot.r08.x90_180.n0_30.'
 
  i = 6
  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 5'
  plottitle[i] = 'aot.r05.x180_270.n0_30.'
 
  i = 7
  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 6'
  plottitle[i] = 'aot.r06.x270_360.n0_30.'
 
  i = 8
  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 3'
  plottitle[i] = 'aot.r03.x0_90.n30_70.'
 

  i = 9
  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 4'
  plottitle[i] = 'aot.r04.x90_180.n30_70.'
 
  i = 10
  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 1'
  plottitle[i] = 'aot.r01.x180_270.n30_70.'
 
  i = 11
  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 2'
  plottitle[i] = 'aot.r02.x270_360.n30_70.'
 
  i = 12
  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -70. &  lat1want[i] = -30.
  title[i] = 'Region 13'
  plottitle[i] = 'aot.r13.x270_360.s70_30.'
 
  i = 13
  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Region 14'
  plottitle[i] = 'aot.r14.x0_360.s90_n90.'
 
  i = 14
  maskwant[i] = 0
  lon0want[i] = 340. &  lon1want[i] = 345.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x340_345.n0_30.'
 
  i = 15
  maskwant[i] = 0
  lon0want[i] = 335. &  lon1want[i] = 340.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x335_340.n0_30.'
 
  i = 16
  maskwant[i] = 0
  lon0want[i] = 330. &  lon1want[i] = 335.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x330_335.n0_30.'
 
  i = 17
  maskwant[i] = 0
  lon0want[i] = 325. &  lon1want[i] = 330.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x325_330.n0_30.'
 
  i = 18
  maskwant[i] = 0
  lon0want[i] = 320. &  lon1want[i] = 325.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x320_325.n0_30.'
 
  i = 19
  maskwant[i] = 0
  lon0want[i] = 315. &  lon1want[i] = 320.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x315_320.n0_30.'
 
  i = 20
  maskwant[i] = 0
  lon0want[i] = 310. &  lon1want[i] = 315.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x310_315.n0_30.'
 
  i = 21
  maskwant[i] = 0
  lon0want[i] = 305. &  lon1want[i] = 310.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x305_310.n0_30.'
 
  i = 22
  maskwant[i] = 0
  lon0want[i] = 300. &  lon1want[i] = 305.
  lat0want[i] =   0. &  lat1want[i] = 30.
  plottitle[i] = 'aot.tatl.x300_305.n0_30.'

 
 
; Loop over the number of control files
  nctl = n_elements(ctlfile)

  for ictl = 0, nctl-1 do begin

;   Open output text files
    lunreg = lonarr(nreg)
    for ireg = 0, nreg-1 do begin
     filename = './output/tables/'+outfilehead+plottitle[ireg]+sample[ictl]+'.txt'
     openw, lun, filename, /get_lun
     lunreg[ireg] = lun
     printf, lunreg[ireg], filename
     printf, lunreg[ireg], histmin, histmax, nbins
    endfor

    doshift = 0  ; if 0, don't shift longitudes
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               template = 1
               wantlev=5.5e-7
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
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
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
    endcase

    spawn, 'echo ${BASEDIRAER}', basedir
;   Read the regional mask
    case resolution[ictl] of
     'd' : begin
           nx = 540
           ny = 361
           mask = make_array(nx,ny,val=0)
           end
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           ga_getvar, maskfile, 'COMASK', mask, lon=lon, lat=lat
           end
     'b' : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           ga_getvar, maskfile, 'COMASK', mask, lon=lon, lat=lat
           end
    endcase
    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0

;   Loop over yyyymm combo
    for iy = 0, n_elements(yyyy)-1 do begin
    for im = 0, 11 do begin
    ndm_ = ndm[im]
    if(im eq 1 and (yyyy[iy] eq '2000' or yyyy[iy] eq '2004')) then ndm_ = '29'
    datewant=yyyy[iy]+mm[im]+['0100',ndm_+'18']
    ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
    nt = n_elements(time)

;   Now read in the model data
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl], yyyy[iy], mm[im]
    datewant_ = datewant
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant_, wantlev=wantlev, template=template
      varout = reform(varout)
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

;   integrate histogram over regions
    for ireg = 0, nreg-1 do begin
     for it = 0, nt-1 do begin
      mask_region, inp[*,*,it], lon, lat, mask, $
                   maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                   lat0want[ireg], lat1want[ireg], maskedinp
;     histogram
      if(it eq 0) then begin
       histout = histogram(maskedinp,min=histmin,max=histmax, $
                           nbins=nbins,/nan)
      endif else begin
       histout_ = histout
       histout = histogram(maskedinp,min=histmin,max=histmax, $
                           nbins=nbins,/nan,input=histout_)
      endelse
     endfor
     histnorm = histout/total(histout)
     printf, lunreg[ireg], yyyy[iy]+mm[im], histnorm, format='(i6,2x,10(f6.4,1x))'
    endfor
    lonsave = lon
    latsave = lat

;   end time loop
    endfor   ; im
    endfor   ; iy


;  Close the file
   for ireg = 0, nreg-1 do begin
    free_lun, lunreg[ireg]
   endfor

  endfor



end


