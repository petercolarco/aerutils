; Ocean

; For some sampled data sets, plot the histogram of AOT

;  satid = 'MOD04'
  satid = 'MYD04'
  weight = 'num.'

  nymd0 = '20030101'
  nymd1 = '20111231'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /monthly

  ntemplate = 8
  nt = n_elements(nymd)


; PDF binning for analysis
  nbins = 501
  nseason = 5

; cummulative difference bins
  cumbinmin = -.5
  cumbindel = 0.002  
  difbins = findgen(nbins)*cumbindel+cumbinmin

; Table of cummulative differences
  cumdif = fltarr(7,3)


; 5 seasons: 0 = all year, 1 = DJF, 2 = MAM, 3 = JJA, 4 = SON


; Loop over resolution
  for ires = 1,1 do begin
   if(ires eq 0) then resolution = 'd'
   if(ires eq 1) then resolution = 'b'
   if(ires eq 2) then resolution = 'ten'


   aot = fltarr(ntemplate,nt)
   std = fltarr(ntemplate,nt)
   num = fltarr(ntemplate,nt)
   minval = fltarr(ntemplate,nt)
   maxval = fltarr(ntemplate,nt)
   naotbins = lonarr(nbins,ntemplate,nseason)
   ndifbins = lonarr(nbins,ntemplate,nseason)



  spawn, 'echo $MODISDIR', MODISDIR
  fileatemplate =    MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+resolution+'/GRITAS/Y%y4/M%m2' $
                  + ['/'+satid+'_L2_lnd.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.supermisr.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr1.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr2.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr3.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop1.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop2.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop3.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4']
  filentemplate =    MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+resolution+'/GRITAS/Y%y4/M%m2' $
                  + ['/'+satid+'_L2_lnd.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.supermisr.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr1.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr2.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr3.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop1.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop2.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop3.aero_tc8_051.qast3_qafl.%y4%m2.nc4']

  for it = 0, n_elements(nymd)-1 do begin

  mm = strmid(string(nymd[it],format='(i8)'),4,2)

  for itemplate = 0, ntemplate-1 do begin

;  Read the monthly mean files
   filename = strtemplate(fileatemplate[itemplate], nymd[it], nhms[it])
   nc4readvar, filename, 'aot', aot_, lon=lon, lat=lat
   a = where(aot_ ge 1.e15)
   if(a[0] ne -1) then aot_[a] = !values.f_nan

   print, filename

;  Global AOT PDF
method = 1
   case method of
;  Method 1
;   PDF of the 10x10 box values
    1 : arr = histogram(aot_,binsize=.01, min=0., nbins=nbins, /nan)

;  Method 2 (weight)
;   PDF of 10x10 box values weighted by number of obs
    2: begin
       filename = strtemplate(filentemplate[itemplate], nymd[it], nhms[it])
       nc4readvar, filename, 'num', num_, lon=lon, lat=lat
       a = where(num_ ge 1.e15)
       if(a[0] ne -1) then num_[a] = !values.f_nan
       arr = histogram(aot_,binsize=.01, min=0., nbins=nbins, reverse_indices=r, /nan)
       for i = 0, nbins-1 do begin
        if(r[i] ne r[i+1]) then arr[i] = total(aot_[r[r[i]:r[i+1]-1]]*num_[r[r[i]:r[i+1]-1]])
       endfor
       end

   endcase

;  By "season"
   naotbins[*,itemplate,0] = naotbins[*,itemplate,0] + arr
   if(mm eq '12' or mm eq '01' or mm eq '02') then naotbins[*,itemplate,1] = naotbins[*,itemplate,1] + arr
   if(mm eq '03' or mm eq '04' or mm eq '05') then naotbins[*,itemplate,2] = naotbins[*,itemplate,2] + arr
   if(mm eq '06' or mm eq '07' or mm eq '08') then naotbins[*,itemplate,3] = naotbins[*,itemplate,3] + arr
   if(mm eq '09' or mm eq '10' or mm eq '11') then naotbins[*,itemplate,4] = naotbins[*,itemplate,4] + arr


;  Maintain the PDF differences in AOT
   if(itemplate eq 0) then begin
    aot = aot_
   endif else begin
    arr = histogram(aot-aot_,binsize=cumbindel, min=cumbinmin, nbins=nbins, /nan, loc=loc)
    ndifbins[*,itemplate,0] = ndifbins[*,itemplate,0] + arr
    if(mm eq '12' or mm eq '01' or mm eq '02') then ndifbins[*,itemplate,1] = ndifbins[*,itemplate,1] + arr
    if(mm eq '03' or mm eq '04' or mm eq '05') then ndifbins[*,itemplate,2] = ndifbins[*,itemplate,2] + arr
    if(mm eq '06' or mm eq '07' or mm eq '08') then ndifbins[*,itemplate,3] = ndifbins[*,itemplate,3] + arr
    if(mm eq '09' or mm eq '10' or mm eq '11') then ndifbins[*,itemplate,4] = ndifbins[*,itemplate,4] + arr
   endelse

  endfor

  endfor

; Normalize
  naotbins = float(naotbins)
print, total(naotbins[*,*,0],1)
  for itemplate = 0, ntemplate-1 do begin
   naotbins[*,itemplate,0] = naotbins[*,itemplate,0] / total(naotbins[*,itemplate,0])
   naotbins[*,itemplate,1] = naotbins[*,itemplate,1] / total(naotbins[*,itemplate,1])
   naotbins[*,itemplate,2] = naotbins[*,itemplate,2] / total(naotbins[*,itemplate,2])
   naotbins[*,itemplate,3] = naotbins[*,itemplate,3] / total(naotbins[*,itemplate,3])
   naotbins[*,itemplate,4] = naotbins[*,itemplate,4] / total(naotbins[*,itemplate,4])
  endfor

; Cumulative
  cumbins = fltarr(nbins,ntemplate,nseason)
  for itemplate = 1, ntemplate-1 do begin
   for ibin = nbins-1, 0, -1 do begin
    cumbins[ibin,itemplate,0] = total(ndifbins[0:ibin,itemplate,0])
    cumbins[ibin,itemplate,1] = total(ndifbins[0:ibin,itemplate,1])
    cumbins[ibin,itemplate,2] = total(ndifbins[0:ibin,itemplate,2])
    cumbins[ibin,itemplate,3] = total(ndifbins[0:ibin,itemplate,3])
    cumbins[ibin,itemplate,4] = total(ndifbins[0:ibin,itemplate,4])
   endfor
   cumbins[*,itemplate,0] = cumbins[*,itemplate,0]/total(ndifbins[*,itemplate,0])
   cumbins[*,itemplate,1] = cumbins[*,itemplate,1]/total(ndifbins[*,itemplate,1])
   cumbins[*,itemplate,2] = cumbins[*,itemplate,2]/total(ndifbins[*,itemplate,2])
   cumbins[*,itemplate,3] = cumbins[*,itemplate,3]/total(ndifbins[*,itemplate,3])
   cumbins[*,itemplate,4] = cumbins[*,itemplate,4]/total(ndifbins[*,itemplate,4])
  endfor



; Print the annual cummulative difference in range +/- 0.01 AOT

; threshold range = +/0.01 AOT
  jmax = 254
  jmin = 245

; threshold range = +/0.02 AOT
;  jmax = 259
;  jmin = 240

  
  for i = 0, 6 do begin
   cumdif[i,ires] = (cumbins[jmax,i+1,0]-cumbins[jmin,i+1,0])
  endfor

  endfor

  sample = ['Super-MISR','MISR1','MISR2','MISR3','CALIOP1','CALIOP2','CALIOP3']

  for i = 0, 6 do begin
   print, sample[i], cumdif[i,0], cumdif[i,1], cumdif[i,2], format='(a12,3(2x,f5.3))'
  endfor

end
