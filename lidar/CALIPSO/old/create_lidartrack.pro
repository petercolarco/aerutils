; Colarco
; September 2, 2008
; Loop over a set of available lidar track files and provide an output
; model extraction of aerosol/met parameters along each track file.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Find the track file location
  trackdir = '/misc/prc08/calipso/CALIPSO_Track/'
  trackfiles = file_search(trackdir+'L2AL05.0z02.01d*ascii')

; Extract the dates the file names
  yy = strmid(trackfiles,strlen(trackdir)+15, 2)
  mm = strmid(trackfiles,strlen(trackdir)+17, 2)
  dd = strmid(trackfiles,strlen(trackdir)+19, 2)
  filetag = strmid(trackfiles,strlen(trackdir),34)
  mon = ['jan','feb','mar','apr','may','jun',$
         'jul','aug','sep','oct','nov','dec']

  outdir = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/lidar/Y2008/
  outdir = './

  a = where( (mm eq '06' and dd eq '23'))

  for ifile = 0, n_elements(a)-1 do begin

; Random seed for the output filename (supports multiple instances in one directory)
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

; Read the trackfile
; Pick a trackfile for the moment
  it = a[ifile]
  trackfile = trackfiles[it]
  read_calipso_track, trackfile, lon, lat, date

  print, 'Doing: ', filetag[it]

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
   printf, lun, 'tdef time 8 linear 00:00z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 6hr'
   free_lun, lun
   filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+'.'+filetag[it]+'.hdf'
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
   printf, lun, 'tdef time 8 linear 00:00z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 6hr'
   free_lun, lun
   filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.inst3d_ext-532nm_v.'+species[isp]+'.'+filetag[it]+'.hdf'
   lidartrack_model, date, lon, lat, ctlFile, varlist, filetocreate=filetocreate
  endfor

skip:
; Do the met track
  ctlFile_eta = 'diag_eta.ctl.'+rnum
  openw, lun, ctlfile_eta, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_dyn_v.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 8 linear 00:00z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 6hr'
  free_lun, lun

  ctlFile_edge = 'diag_edge.ctl.'+rnum
  openw, lun, ctlfile_edge, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_met_e.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 8 linear 00:00z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 6hr'
  free_lun, lun

  ctlFile_sfc = 'diag_sfc.ctl.'+rnum
  openw, lun, ctlfile_sfc, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg2d_met_x.%y4%m2%d2_%h2%n2z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 16 linear 01:30z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 3hr'
  free_lun, lun

  ctlFile_cloud = 'diag_cloud.ctl.'+rnum
  openw, lun, ctlfile_cloud, /get_lun
  printf, lun, 'dset /misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/diag/Y%y4/M%m2/' + $
                     'd5_arctas_02.tavg3d_cld_v.%y4%m2%d2_%h200z.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 8 linear 00:00z'+dd[it]+mon[mm[it]-1]+'20'+yy[it]+' 6hr'
  free_lun, lun

  filetocreate = outdir+'M'+mm[it]+'/d5_arctas_02.met.'+filetag[it]+'.hdf'
  lidartrack_model_met, date, lon, lat, ctlfile_eta, ctlfile_edge, ctlfile_sfc, $
                        ctlfile_cloud, filetocreate=filetocreate

  cmd = '/bin/rm -f *.ctl.'+rnum
  spawn, cmd

endfor
end
