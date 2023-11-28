; Plot the size bins used in the ICAP models

  names = ['GEOS/GEFS/AM4','MODELe', 'IFS','SILAM','MONARCH','MASINGER',$
           'UM','NAAPS']
  nbins = [8,8,3,4,8,10,2,1]

  imod = 0
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 1
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,4,8,16]
  xmax=32
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 2
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 3
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 4
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 5
  y = 8-imod
  xmin=[0.2,0.32,0.5,0.8,1.3,2,3.2,5,8,13]
  xmax=20
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'

  imod = 6
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  nbin=nbins[imod]
  print, names[imod]
  str1 = ''
  str2 = ''
  for ibin = 0, nbin-1 do begin
   str0 = string(xmin[ibin]/2.*1.e-6,format='(1e8.2)')
   str1 = str1+'['+str0+','+str0+','+str0+']'
   if(ibin lt nbin-1) then str1 = str1+','
  endfor
  for ibin = 0, nbin-2 do begin
   str0 = string(xmin[ibin+1]/2.*1.e-6,format='(1e8.2)')
   str2 = str2+'['+str0+','+str0+','+str0+']'
   str2 = str2+','
  endfor
  str0 = string(xmax/2.*1.e-6,format='(1e8.2)')
  str2 = str2+'['+str0+','+str0+','+str0+']'
  print, '     "rmin0": ['+str1+'],'
  print, '     "rmax0": ['+str2+'],'


end
