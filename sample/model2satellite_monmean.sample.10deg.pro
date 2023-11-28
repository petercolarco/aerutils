; This version regrids from native (0.5 degree) resolution monthly
; mean files from model2satellite_monmean.sample.pro to an analysis 
; 10 degree resolution that preserves the PDF statistics

; Idea is to mimic the model2satellite_monmean.sample.csh
; functionality but to also calculate the pdf of AOT

; Output grid
  nxout = 36
  nyout = 19
  lonout = findgen(nxout)*10 - 180.
  latout = findgen(nyout)*10 - 90.

; Samples
  expid        =    'dR_MERRA-AA-r1'
  filepath     =    '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/'
  samples      =   ['MOD04_L2_ocn.aero_tc8_051.qast.mm', $
                    'MOD04_L2_ocn.misr1.aero_tc8_051.qast.mm',$
                    'MOD04_L2_ocn.misr2.aero_tc8_051.qast.mm',$
                    'MOD04_L2_ocn.caliop1.aero_tc8_051.qast.mm',$
                    'MOD04_L2_ocn.caliop2.aero_tc8_051.qast.mm',$
                    'MOD04_L2_lnd.aero_tc8_051.qast3.mm', $
                    'MOD04_L2_lnd.misr1.aero_tc8_051.qast3.mm',$
                    'MOD04_L2_lnd.misr2.aero_tc8_051.qast3.mm',$
                    'MOD04_L2_lnd.caliop1.aero_tc8_051.qast3.mm',$
                    'MOD04_L2_lnd.caliop2.aero_tc8_051.qast3.mm' ]
  nsamples = n_elements(samples)

; Loop over years
  yyyy  = ['2007','2008','2009','2010']
  yyyy  = ['2009']
  nyr    = n_elements(yyyy)
  for iyr = 0, nyr-1 do begin

; Loop over months
  for imon = 1, 12 do begin
   mm = strpad(imon,10)

; Loop over samples
  for isamples = 0, nsamples-1 do begin

;  Read the monthly mean files
   nymd = yyyy[iyr]+mm+'15'
   filetemplate = filepath+'Y%y4/M%m2/'+expid+'.inst2d_hwl_x.'+samples[isamples]+'.%y4%m2.nc4'
   filename = strtemplate(filetemplate, nymd[0], '120000')
   print, filename
   read_sample, filename, nbin, lon, lat, $
                aot, aotpdf, num, std, minval, maxval
   nx = n_elements(lon)
   ny = n_elements(lat)
   lon_ = fltarr(nx,ny)
   lat_ = fltarr(nx,ny)
   for ix = 0, nx-1 do begin
    lat_[ix,*] = lat
   endfor
   for iy = 0, ny-1 do begin
    lon_[*,iy] = lon
   endfor
   lon = reform(lon_,nx*ny*1L)
   lat = reform(lat_,nx*ny*1L)
   aot = reform(aot,nx*ny*1L)
   pdf = reform(aotpdf,nx*ny*1L,nbin)
   num = reform(num,nx*ny*1L)
   std = reform(std,nx*ny*1L)
   minval = reform(minval,nx*ny*1L)
   maxval = reform(maxval,nx*ny*1L)
   

;  Aggregate to 10 x 10 grid
;  Handle first x separately
   aotout = make_array(nxout,nyout,val=!values.f_nan)
   numout = make_array(nxout,nyout,val=!values.f_nan)
   pdfout = make_array(nxout,nyout,nbin,val=!values.f_nan)
   stdout = make_array(nxout,nyout,val=!values.f_nan)
   maxout = make_array(nxout,nyout,val=!values.f_nan)
   minout = make_array(nxout,nyout,val=!values.f_nan)
   ixout = 0
    for iyout = 0, nyout-1 do begin
     a = where(lon ge lonout[nxout-1]+5. and lon lt lonout[ixout]+5. and $
               lat ge latout[iyout]-5. and lat lt latout[iyout]+5. and num gt 0.)
     if(a[0] eq -1) then continue
     minout[ixout,iyout] = min(minval[a],/nan)
     maxout[ixout,iyout] = max(maxval[a],/nan)
     numout[ixout,iyout] = total(num[a],/nan)
     aotout[ixout,iyout] = total(aot[a]*num[a],/nan) / numout[ixout,iyout]
     stdout[ixout,iyout] = total(std[a]*num[a],/nan) / numout[ixout,iyout]
     for ibin = 0, nbin-1 do begin
      pdfout[ixout,iyout,ibin] = total(pdf[a,ibin]*num[a],/nan) / numout[ixout,iyout]
     endfor
    endfor

   for ixout = 1, nxout-1 do begin
    for iyout = 0, nyout-1 do begin
     a = where(lon ge lonout[ixout]-5. and lon lt lonout[ixout]+5. and $
               lat ge latout[iyout]-5. and lat lt latout[iyout]+5. and num gt 0.)
     if(a[0] eq -1) then continue
     minout[ixout,iyout] = min(minval[a])
     maxout[ixout,iyout] = max(maxval[a])
     numout[ixout,iyout] = total(num[a],/nan)
     aotout[ixout,iyout] = total(aot[a]*num[a],/nan) / numout[ixout,iyout]
     stdout[ixout,iyout] = total(std[a]*num[a],/nan) / numout[ixout,iyout]
     for ibin = 0, nbin-1 do begin
      pdfout[ixout,iyout,ibin] = total(pdf[a,ibin]*num[a],/nan) / numout[ixout,iyout]
     endfor
    endfor
   endfor

  aotout = reform(aotout,nxout,nyout)
  numout = reform(numout,nxout,nyout)
  stdout = reform(stdout,nxout,nyout)
  maxout = reform(maxout,nxout,nyout)
  minout = reform(minout,nxout,nyout)
  pdfout = reform(pdfout,nxout,nyout,nbin)

; Write the output to a file
  filehead = expid+'.inst2d_hwl_x.'+samples[isamples]+'.10deg'
  dx = 10.
  dy = 10
  nt = 1
  nlev = 1
  lev = 550.
  nymd = strmid(nymd,0,6)
  write_sample, filepath, filehead, nxout, nyout, dx, dy, nt, nlev, nbin, nymd, $
                lonout, latout, lev, aotout, pdfout, numout, stdout, minout, maxout, $
                /shave, resolution = 'ten'

  endfor ; samples
  endfor ; month
  endfor ; year

end
