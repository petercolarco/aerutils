; Idea is to mimic the model2satellite_monmean.sample.csh
; functionality but to also calculate the pdf of AOT

; PDF bins
  nbins = 51
  dbin  = 0.02
  bins = findgen(nbins)*dbin

; Samples
  expid = 'dR_MERRA-AA-r1'
  filepath = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/'
  samples = ['MOD04_L2_ocn.aero_tc8_051.qast', $
             'MOD04_L2_ocn.misr1.aero_tc8_051.qast',$
             'MOD04_L2_ocn.misr2.aero_tc8_051.qast',$
             'MOD04_L2_ocn.caliop1.aero_tc8_051.qast',$
             'MOD04_L2_ocn.caliop2.aero_tc8_051.qast',$
             'MOD04_L2_lnd.aero_tc8_051.qast3', $
             'MOD04_L2_lnd.misr1.aero_tc8_051.qast3',$
             'MOD04_L2_lnd.misr2.aero_tc8_051.qast3',$
             'MOD04_L2_lnd.caliop1.aero_tc8_051.qast3',$
             'MOD04_L2_lnd.caliop2.aero_tc8_051.qast3' ]
  nsamples = n_elements(samples)

; Loop over years
  yyyy  = ['2007','2008','2009','2010']
  yyyy  = ['2009']
  ndays = [0,31,28,31,30,31,30,31,31,30,31,30,31]
  nyr   = n_elements(yyyy)
  for iyr = 0, nyr-1 do begin

; Loop over months
  for imon = 1, 12 do begin
   mm = strpad(imon,10)
   numdays = ndays[imon]
   if(imon eq 2 and yyyy[iyr] eq '2008') then numdays = 29

; Loop over samples
  for isamples = 0, nsamples-1 do begin

; Read the daily files for the sample/month
  nymd0 = yyyy[iyr]+mm+'01'
  nymd1 = yyyy[iyr]+mm+strpad(numdays,10)
  dateexpand, nymd0, nymd1, '120000', '120000', nymd, nhms
  filetemplate = filepath + 'Y%y4/M%m2/'+expid+'.inst2d_hwl_x.'+$
                 samples[isamples]+'.%y4%m2%d2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'totexttau', aotinp, lon=lon, lat=lat
  a = where(aotinp gt 100)
  aotinp[a] = !values.f_nan

; Compute the mean, min, max, std, and pdf
  nx = n_elements(lon)
  ny = n_elements(lat)
  aotinp = reform(aotinp,nx*ny*1L,numdays)
  aot = make_array(nx*ny*1L,val=!values.f_nan)
  num = make_array(nx*ny*1L,val=!values.f_nan)
  std = make_array(nx*ny*1L,val=!values.f_nan)
  amin = make_array(nx*ny*1L,val=!values.f_nan)
  amax = make_array(nx*ny*1L,val=!values.f_nan)
  pdf = make_array(nx*ny*1L,nbins,val=0)

  for ix = 0L, nx*ny*1L-1L do begin
   a = where(finite(aotinp[ix,*]) eq 1)
   if(a[0] eq -1) then continue
   aot[ix] = mean(aotinp[ix,a])
   num[ix] = n_elements(a)
   amin[ix] = min(aotinp[ix,a])
   amax[ix] = max(aotinp[ix,a])
   if(n_elements(a) ge 3) then std[ix] = stddev(aotinp[ix,a])
   for ib = 0, n_elements(a)-1 do begin
    ibin = max([0,min([nbins-1,fix(aotinp[ix,a[ib]]*(1./dbin))])])
    pdf[ix,ibin] = pdf[ix,ibin]+1
   endfor
  endfor
  aot = reform(aot,nx,ny)
  num = reform(num,nx,ny)
  std = reform(std,nx,ny)
  amax = reform(amax,nx,ny)
  amin = reform(amin,nx,ny)
  pdf  = reform(pdf,nx,ny,nbins)

; Write the output to a file
  filehead = expid+'.inst2d_hwl_x.'+samples[isamples]+'.mm'
  dx = 0.625
  dy = 0.5
  nt = 1
  nlev = 1
  lev = 550.
  nymdout = strmid(nymd0,0,6)
  write_sample, filepath, filehead, nx, ny, dx, dy, nt, nlev, nbins, nymdout, $
                lon, lat, lev, aot, pdf, num, std, amin, amax, $
                /shave, resolution = 'd'

  endfor ; samples
  endfor ; month
  endfor ; year

end
