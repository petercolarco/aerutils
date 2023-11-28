; Select the files to average over
!quiet = 1L
  species = ['dust','total','bc','oc','sulfate','seasalt']
  drytag = ['.dry','']
  daynight = ['01d','01n']

  filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/M06/'
  for isp = 0, n_elements(species)-1 do begin
   for idry = 0, n_elements(drytag)-1 do begin
    for idn = 0, n_elements(daynight)-1 do begin
     filetag = species[isp]+'.'+daynight[idn]+drytag[idry]
     trackfiles = file_search(filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.L2AL05.0z02.'+daynight[idn]+'*hdf')
     outstring = filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.zonal_mean.20080601_20080630.'+daynight[idn]
     outstring_met = filedir+'d5_arctas_02.met.zonal_mean.20080601_20080630.'+daynight[idn]
     write_zonal_lidartrack, trackfiles, outstring, outstring_met, 20080615L
    endfor
   endfor
  endfor

  filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/M07/'
  for isp = 0, n_elements(species)-1 do begin
   for idry = 0, n_elements(drytag)-1 do begin
    for idn = 0, n_elements(daynight)-1 do begin
     filetag = species[isp]+'.'+daynight[idn]+drytag[idry]
     trackfiles = file_search(filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.L2AL05.0z02.'+daynight[idn]+'*hdf')
     outstring = filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.zonal_mean.20080701_20080731.'+daynight[idn]
     outstring_met = filedir+'d5_arctas_02.met.zonal_mean.20080701_20080731.'+daynight[idn]
     write_zonal_lidartrack, trackfiles, outstring, outstring_met, 20080715L
    endfor
   endfor
  endfor

  filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/M04/'
  for isp = 0, n_elements(species)-1 do begin
   for idry = 0, n_elements(drytag)-1 do begin
    for idn = 0, n_elements(daynight)-1 do begin
     filetag = species[isp]+'.'+daynight[idn]+drytag[idry]
     trackfiles = file_search(filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.L2AL05.0z02.'+daynight[idn]+'*hdf')
     outstring = filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.zonal_mean.20080401_20080430.'+daynight[idn]
     outstring_met = filedir+'d5_arctas_02.met.zonal_mean.20080401_20080430.'+daynight[idn]
     write_zonal_lidartrack, trackfiles, outstring, outstring_met, 20080415L
    endfor
   endfor
  endfor

  filedir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/M05/'
  for isp = 0, n_elements(species)-1 do begin
   for idry = 0, n_elements(drytag)-1 do begin
    for idn = 0, n_elements(daynight)-1 do begin
     filetag = species[isp]+'.'+daynight[idn]+drytag[idry]
     trackfiles = file_search(filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.L2AL05.0z02.'+daynight[idn]+'*hdf')
     outstring = filedir+'d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+drytag[idry]+'.zonal_mean.20080501_20080531.'+daynight[idn]
     outstring_met = filedir+'d5_arctas_02.met.zonal_mean.20080501_20080531.'+daynight[idn]
     write_zonal_lidartrack, trackfiles, outstring, outstring_met, 20080515L
    endfor
   endfor
  endfor

end
