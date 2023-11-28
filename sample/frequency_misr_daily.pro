; Colarco, December 2009
; Provide a data set of swath sampled AOT from the model.
; Read the data sets and determine the daily histogram of
; AOT in predetermined 10x10 degree boxes (outfilehead) and
; the grid averaged, qa-weighted AOT (outfilehead2).

; Procedure call
  pro frequency_misr_daily, resolution

; Histogram features
  histmin=0.
  histmax=1.
  nbins=10


; Dates
  yyyy = ['2009','2008','2007','2006','2005','2004','2003','2002','2001','2000']
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  ndm  = ['31','28','31','30','31','30','31','31','30','31','30','31']

; Models
  outfilehead  = 'MISR_regions.'+resolution+'.freq.daily.'
  outfilehead2 = 'MISR_regions.'+resolution+'.daily.'
  sample = ['misr', 'misr_subpoint']
  typefile = ['MISR','MISR']

; Pick regions based on the mask file
  nxr = 540/15
  nyr = 360/20
  nreg = nxr*nyr
  plottitle = strarr(nxr,nyr)
  lon0want = fltarr(nxr,nyr)
  lon1want = fltarr(nxr,nyr)
  lat0want = fltarr(nxr,nyr)
  lat1want = fltarr(nxr,nyr)
  for ix = 0, nxr-1 do begin
   for iy = 0, nyr-1 do begin
    lon0want[ix,iy] = ix*10.
    lon1want[ix,iy] = lon0want[ix,iy] + 10.
    lat0want[ix,iy] = -90.+iy*10.
    lat1want[ix,iy] = lat0want[ix,iy] + 10.
    xstr = 'x'+strcompress(string(fix(lon0want[ix,iy])),/rem)+'_'+$
               strcompress(string(fix(lon1want[ix,iy])),/rem)+'.'
    latsr = ''
    if(lat0want[ix,iy] lt 0) then latstr = 's'
    if(lat0want[ix,iy] gt 0) then latstr = 'n'
    ystr = latstr+strcompress(string(fix(abs(lat0want[ix,iy]))),/rem)+'_'
    latsr = ''
    if(lat1want[ix,iy] lt 0) then latstr = 's'
    if(lat1want[ix,iy] gt 0) then latstr = 'n'
    ystr = ystr+latstr+strcompress(string(fix(abs(lat1want[ix,iy]))),/rem)+'.'
    ixstr = strcompress(string(ix),/rem)
    if(ix lt 10) then ixstr = '0'+ixstr
    iystr = strcompress(string(iy),/rem)
    if(iy lt 10) then iystr = '0'+iystr
    rstr = 'r'+ixstr+'_'+iystr+'.'
    plottitle[ix,iy] = 'aot.'+rstr+xstr+ystr
   endfor
  endfor  

; Time loop
  nctl = n_elements(sample)
  for iy = 0, n_elements(yyyy)-1 do begin

;  Loop over months
   for im = 0, 11 do begin

;   Create the output files
    for ictl = 0, nctl-1 do begin
     for ireg = 0, nreg-1 do begin
      filename  = $
       './output/tables/'+outfilehead+plottitle[ireg]+sample[ictl]+'.'+yyyy[iy]+mm[im]+'.txt'
      filename2 = $
       './output/tables/'+outfilehead2+plottitle[ireg]+sample[ictl]+'.'+yyyy[iy]+mm[im]+'.txt'
      openw, lun, filename, /get_lun
      printf, lun, filename
      printf, lun, histmin, histmax, nbins
      free_lun, lun
      openw, lun, filename2, /get_lun
      printf, lun, filename2
      free_lun, lun
     endfor
    endfor

    ndm_ = ndm[im]
    if(im eq 1 and (yyyy[iy] eq '2000' or yyyy[iy] eq '2004' or yyyy[iy] eq '2008')) $
     then ndm_ = '29'

;   Loop over the days
    for id = 0, ndm_-1 do begin
     dd = strcompress(string(id+1),/rem)
     if(fix(dd) lt 10) then dd = '0'+dd
     datewant=yyyy[iy]+mm[im]+dd+['00','21']

;    Loop over the number of control files
     for ictl = 0, nctl-1 do begin

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

;     Control file names
      qawtfile = 'MISR_L2.aero_F12_0022.noqawt.'+resolution+'.'+sample[ictl]+'.ctl'
      qaflfile = 'MISR_L2.aero_F12_0022.noqafl.'+resolution+'.'+sample[ictl]+'.ctl'

      print, qawtfile, datewant
      print, qaflfile, datewant

;     Now read the satellite QASUM values
      if(ictl eq 0) then begin
       ga_getvar, qaflfile, 'qasum', qasum, lon=lon, lat=lat, lev=lev, time=time, $
                  wanttime=datewant, /noprint
       qasum=reform(qasum)
       a = where(qasum gt 1.e14)
       if(a[0] ne -1) then qasum[a] = !values.f_nan
       nx = n_elements(lon)
       ny = n_elements(lat)
       nt = n_elements(time)
       mask = make_array(nx,ny,val=0.)
       if(min(lon) lt 0) then qasum = shift(qasum,nx/2,0,0)
      endif

;     Now read the satellite AOT value
      nvars = n_elements(var)
      inp = fltarr(nx,ny,nt)
      date = strarr(nt)
      q = fltarr(nx,ny,nreg)
      datewant_ = datewant
      for ivar = 0, nvars-1 do begin
        print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
        ga_getvar, qawtfile, var[ivar], varout, lon=lon, lat=lat, lev=lev, $
         wanttime=datewant_, wantlev=wantlev, template=template
        varout = reform(varout)
        inp = inp + varout
      endfor

;     possibly shift the result
      if(min(lon) lt 0) then begin
       lon = lon + 180.
       inp = shift(inp,nx/2,0,0)
      endif

;     Mask fill values
      a = where(inp ge 1e14)
      if(a[0] ne -1) then inp[a] = !values.f_nan

;     create the 2d lon/lat array
      lon2d = fltarr(nx,ny)
      lat2d = fltarr(nx,ny)
      for ix_ = 0, nx-1 do begin
       lat2d[ix_,*] = lat
      endfor
      for iy_ = 0, ny-1 do begin
       lon2d[*,iy_] = lon
      endfor

;     integrate histogram over regions
      maskwant = 0
      inp = reform(inp,long(nx)*long(ny),nt)
      qasum_ = reform(qasum,1L*nx*ny,nt)
      inp_ = reform(inp,1L*nx*ny,nt)
      a = where(finite(inp_) eq 0 or inp_ ge 1e15)
      if(a[0] ne -1) then inp_[a] = !values.f_nan
      if(a[0] ne -1) then qasum_[a] = !values.f_nan

      for ireg = 0, nreg-1 do begin
       maskedinp = make_array(long(nx)*long(ny),nt,value=!values.f_nan)
       a = where(mask eq maskwant and $
                 lon2d gt lon0want[ireg] and lon2d le lon1want[ireg] and $
                 lat2d gt lat0want[ireg] and lat2d le lat1want[ireg] )
       
       if(a[0] ne -1) then maskedinp[a,*] = inp[a,*]

       num = 0L
       histnorm = make_array(nbins,val=0L)

       a = where(finite(maskedinp) eq 1)
       if(a[0] ne -1) then begin
        histout = histogram(maskedinp[a],min=histmin,max=histmax, $
                            nbins=nbins,/nan)
        histnorm = histout/total(histout)
        num = total(histout)
       endif
       filename = $
        './output/tables/'+outfilehead+plottitle[ireg]+sample[ictl]+'.'+yyyy[iy]+mm[im]+'.txt'
       openw, lun, filename, /append
       printf, lun, yyyy[iy]+mm[im]+dd, histnorm, num, format='(i8,2x,10(f6.4,1x),2x,i8)'
       free_lun, lun
      endfor

;     QA-weighted daily average of AOT (per gridbox)
      qasum__ = fltarr(nx,ny)
      aot = fltarr(nx,ny)
      for i = 0L, long(nx)*ny-1 do begin
       atmp = reform(inp_[i,*])
       qtmp = reform(qasum_[i,*])
       aot[i] = total(atmp*qtmp,/nan)/total(qtmp,/nan)
       qasum__[i] = total(qtmp,/nan)
      endfor

;     integrate histogram over regions
      for ireg = 0, nreg-1 do begin
       std = 1.
       num = 1
       maskwant = 0
       integrate_region, aot[*,*], lon, lat, mask, $
                         maskwant, lon0want[ireg], lon1want[ireg], $
                         lat0want[ireg], lat1want[ireg], varout, /avg, $
                         std = std, num=num, weight=qasum__
       filename2 = $
        './output/tables/'+outfilehead2+plottitle[ireg]+sample[ictl]+'.'+yyyy[iy]+mm[im]+'.txt'
       openw, lun, filename2, /append
       printf, lun, yyyy[iy]+mm[im]+dd, varout, std, num, format='(i8,2x,2(f6.4,1x),1e12.6)'
       free_lun, lun
      endfor
      lonsave = lon
      latsave = lat

     endfor

;  end time loop
   endfor   ; id
   endfor   ; im
   endfor   ; iy



end


