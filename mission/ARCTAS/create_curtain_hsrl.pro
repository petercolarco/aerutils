; Colarco
; September 2, 2008
; Loop over a set of available lidar track files and provide an output
; model extraction of aerosol/met parameters along each track file.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Find the track file location
  trackdir = '/misc/prc11/colarco/arctas/data/hsrl/ARCTAS1/ARCTAS1_Final_Archive_Reduced_HDF_Files/'
  trackfiles = file_search(trackdir+'*.hdf')
  trackdir = '/misc/prc11/colarco/arctas/data/hsrl/ARCTAS2/ARCTAS2_Final_Archive_Reduced_HDF_Files/'
  trackfiles_ = file_search(trackdir+'*.hdf')
  trackfiles = [trackfiles,trackfiles_]
trackfiles = trackfiles[18]
  fltleg     = strmid(trackfiles,strlen(trackdir)+9, 2)
  yyyy       = strmid(trackfiles,strlen(trackdir), 4)
  mm         = strmid(trackfiles,strlen(trackdir)+4, 2)
  dd         = strmid(trackfiles,strlen(trackdir)+6, 2)
  nfiles = n_elements(trackfiles)

  for ifiles = 0, nfiles-1 do begin
   read_hsrl, trackfiles[ifiles], lon, lat, alt, date, ext532, depol532, ext1064
   datestr = yyyy[ifiles]+mm[ifiles]+dd[ifiles]
   outfile = './output/data/dRAb_arctas.hsrl_532nm.'+datestr+'_'+fltleg[ifiles]+'.nc'
   model_track, outfile, lon, lat, date, vartable='arctas_532nm_table.txt'
  endfor
end
