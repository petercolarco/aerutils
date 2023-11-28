; Colarco
; April 1, 2009
; MPLNet locations specified, and extract the lidar profiles in time
  sites = ['GSFC','Trinidad_Head','Monterey']
  lons  = [-76.87, -124.15, -121.85]
  lats  = [39.02,  41.05,   36.58  ]


; Establish the dates to loop over
  yyyy = ['2008']
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  ndm  = ['31','28','31','30','31','30','31','31','30','31','30','31']
  mon  = ['jan','feb','mar','apr','may','jun',$
          'jul','aug','sep','oct','nov','dec']

;  for is = 0, n_elements(sites)-1 do begin
  for is = 0, 0 do begin
  for iy = 0, n_elements(yyyy)-1 do begin
;  for it = 3, 6 do begin
  for it = 5, 6 do begin
  ndm_ = fix(ndm[it])
  if(mm[it] eq '02' and (yyyy[iy] eq 2000 or yyyy[iy] eq 2004 or $
                         yyyy[iy] eq 2008 or yyyy[iy] eq 2012)) then ndm_ = 29
  nt = strcompress(string(ndm_*4),/rem)

  lon  = make_array(nt,val=lons[is])
  lat  = make_array(nt,val=lats[is])
  date = (float(yyyy[iy])*10000.+float(mm[it])*100.+1.d)+findgen(nt)*0.25
  filetag = sites[is]+'.'+yyyy[iy]+mm[it]

  outdir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/

; Random seed for the output filename (supports multiple instances in one directory)
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

  print, 'Doing: ', yyyy[iy], mm[it], sites[is]

; Do the aerosol track
  species = ['total','dust','sulfate','seasalt','bc','oc']
  type = ['','.dust','.su','.ss','.bc','.oc']
  for isp = 0, n_elements(species)-1 do begin
   varlist = ['extinction','tau', 'backscat', 'ext2back', 'aback_sfc', 'aback_toa', 'ssa']
   ctlFile = 'taufile.aerosol.ctl.'+rnum
   openw, lun, ctlfile, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/tau/Y%y4/M%m2/' + $
                      'd5_arctas_02.inst3d_ext-532nm_v.%y4%m2%d2_%h200z.hdf'+type[isp]
   printf, lun, 'options template'
   printf, lun, 'tdef time '+nt+' linear 00:00z01'+mon[mm[it]-1]+yyyy[iy]+' 6hr'
   free_lun, lun
   filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+'.'+filetag+'.hdf'
   lidartrack_model, date, lon, lat, ctlFile, varlist, filetocreate=filetocreate
  endfor

  species = ['total','dust','sulfate','seasalt','bc','oc']+'.dry'
  type = '.dry' + ['','.dust','.su','.ss','.bc','.oc']
  for isp = 0, n_elements(species)-1 do begin
   varlist = ['extinction','tau', 'backscat', 'ext2back', 'aback_sfc', 'aback_toa', 'ssa']
   ctlFile = 'taufile.aerosol.ctl.'+rnum
   openw, lun, ctlfile, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/tau/Y%y4/M%m2/' + $
                      'd5_arctas_02.inst3d_ext-532nm_v.%y4%m2%d2_%h200z.hdf'+type[isp]
   printf, lun, 'options template'
   printf, lun, 'tdef time '+nt+' linear 00:00z01'+mon[mm[it]-1]+yyyy[iy]+' 6hr'
   free_lun, lun
   filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+'.'+filetag+'.hdf'
   lidartrack_model, date, lon, lat, ctlFile, varlist, filetocreate=filetocreate
  endfor

skip:
; Do the met track
  ctlFile_eta = 'diag_eta.ctl.'+rnum
  openw, lun, ctlfile_eta, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_dyn_v.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+nt+' linear 00:00z01'+mon[mm[it]-1]+yyyy[iy]+' 6hr'
  free_lun, lun

  ctlFile_edge = 'diag_edge.ctl.'+rnum
  openw, lun, ctlfile_edge, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_met_e.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+nt+' linear 00:00z01'+mon[mm[it]-1]+yyyy[iy]+' 6hr'
  free_lun, lun

  ctlFile_sfc = 'diag_sfc.ctl.'+rnum
  openw, lun, ctlfile_sfc, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg2d_met_x.%y4%m2%d2_%h2%n2z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+string(2*fix(nt))+' linear 01:30z01'+mon[mm[it]-1]+yyyy[iy]+' 3hr'
  free_lun, lun

  ctlFile_cloud = 'diag_cloud.ctl.'+rnum
  openw, lun, ctlfile_cloud, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_cld_v.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time '+nt+' linear 00:00z01'+mon[mm[it]-1]+yyyy[iy]+' 6hr'
  free_lun, lun

  filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.met.'+filetag+'.hdf'
  lidartrack_model_met, date, lon, lat, ctlfile_eta, ctlfile_edge, ctlfile_sfc, $
                        ctlfile_cloud, filetocreate=filetocreate

  cmd = '/bin/rm -f *.ctl.'+rnum
  spawn, cmd

endfor
endfor
endfor
end
