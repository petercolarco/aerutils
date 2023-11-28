; Colarco, January 2006
; Modified for calculon on March 2006
; Pass in a desired date and directory path template for the hdf level2
; files.  Scan the files in the directory and verify they are the
; desired date.  Print an error message for files which are not the
; desired date.  Verify that the files read of are one retrieval type
; (i.e., all are F08_0016.hdf.met).

; Procedure to read MISR aerosol optical thickness retrievals from the
; Level 2 HDF file.  Right now this is dumb: all the MISR files are
; assumed to exist in a single directory.  Get a file listing of all the
; desired metadata files (i.e., *F08_0016.hdf.met for that version).
; Parse this listing through awk and search for the string
; '/EquatorCrossingDate/,/END_OBJECT/'.  The resulting string can be
; used to associate the date of the file with the file name (containing
; orbit and path information) and the path of the satellite orbit (needed
; to geolocate the orbit with the AGP files).  The assumption is that the
; AGP files exactly locate the ~ 1.1 x 1.1 km MISR pixels.  The retrievals
; are valid on a 16 x 16 pxiel square, so the assumption is that the
; location of the valid retrieval is the (IDL sense) 7,7 pixel of this
; square.
; Returned are the valid lon, lat, aot, and channels for the requested day.

  pro get_misr, path, yyyymmdd, lon, lat, aot, blocktimeOut, channels, $
   algorithm=algorithm

;  Assume the AGP files are in the same path structure
   agpPath = path+'AGP/'

;  YYYYMMDD is the date in long or string format
   yyyymmdd = strcompress(string(yyyymmdd),/rem)
   yyyy = strmid(yyyymmdd,0,4)
   mm   = strmid(yyyymmdd,4,2)
   dd   = strmid(yyyymmdd,6,2)

;  Path to search through
   pathmisr = path+'/Y'+yyyy+'/M'+mm+'/D'+dd+'/'

;  Find all the matching files in this directory
;  If present, algorithm is a string like "F08_0016" which specifies
;  the version of the aerosol retrieval present.
   if(not keyword_set(algorithm)) then begin
    filelist = findfile(pathmisr+'*.hdf.met')
    algorithm = strmid(filelist,15,8,/reverse_offset)
    algorithm = algorithm[uniq(algorithm)]
    nalg = n_elements(algorithm)
    if(nalg gt 1) then begin
     print, 'More than one algorithm present in directory;'
     print, 'call get_misr with algorithm=choice of:'
     print, algorithm
    endif
   endif else begin
    filelist = findfile(pathmisr+'*'+algorithm+'.hdf.met')
   endelse
   print, 'Getting MISR aerosol algorithm: '+algorithm+' for date '+yyyymmdd

; ----------------------------------------------------------------
;  Now map the MISR files to the date
   nfile = n_elements(filelist)
   files = strarr(nfile)
   dates = strarr(nfile)
   paths = strarr(nfile)
   for i = 0, nfile-1 do begin
    cmd = "cat "+filelist[i]+" | awk '/EquatorCrossingDate/,/END_OBJECT/'"
    spawn, cmd, result
    j = strpos(filelist[i],".met")
    files[i] = strmid(filelist[i],0,j)
    j = strpos(result[2],'"')
    dates[i] = strmid(result[2],j+1,4)+strmid(result[2],j+6,2) $
              +strmid(result[2],j+9,2)
    j = strpos(filelist[i],"AEROSOL_P")
    paths[i] = strmid(filelist[i],j+9,3)
   endfor

;  ----------------------------------------------------------------
;  Do the files match the correct date?  Or are they in the wrong
;  directory?
   a = where(dates eq yyyymmdd)
   if(a[0] eq -1) then begin
    print, 'no misr day for ', yyyymmdd
    stop
   endif
   b = where(dates ne yyyymmdd)
   if(b[0] ne -1) then begin
    print, 'Disregarded files: wrong date and in wrong directory!'
    for ib = 0, n_elements(b)-1 do begin
     print, files[b]+' has date '+dates[b]
    endfor
   endif


;  ----------------------------------------------------------------
;  Now we have our correct list of files to read.  We read the var:
;  MISR Best Estimate Spectral Optical Depth at 446, 558, 672, and 867 nm
   channels = [468., 558., 672., 867.]
   filelist = files[a]
   pathlist = paths[a]

   for j = 0, n_elements(filelist)-1 do begin

;   Get the geolocation
    agpFile = agpPath+'MISR_AM1_AGP_P'+pathlist[j]+'_F01_24.hdf'
    if(findfile(agpFile) eq '') then continue
    sdfid = HDF_SD_START(agpFile)
     idx = hdf_sd_nametoindex(sdfid,'GeoLatitude')
     id = hdf_sd_select(sdfid,idx)
     hdf_sd_getdata, id, latMsr
     idx = hdf_sd_nametoindex(sdfid,'GeoLongitude')
     id = hdf_sd_select(sdfid,idx)
     hdf_sd_getdata, id, lonMsr
    hdf_sd_end, sdfid

;   The geometry is available on about a 1 km grid, while the AOT
;   is available on a coarser grid.  Resample the geometry, using
;   every 16th point in retention
    latMsr = reform(latMsr[7:*:16,7:*:16,*])
    lonMsr = reform(lonMsr[7:*:16,7:*:16,*])

;   Get the Aot
    sdfid = HDF_SD_START(filelist[j])
     idx = hdf_sd_nametoindex(sdfid,'RegBestEstimateSpectralOptDepth')
     id = hdf_sd_select(sdfid,idx)
     hdf_sd_getdata, id, aotMsr
     gindex = hdf_sd_attrfind(sdfid,'Start_block')
     hdf_sd_attrinfo, sdfid, gindex, data=start_block
     gindex = hdf_sd_attrfind(sdfid,'End block')
     hdf_sd_attrinfo, sdfid, gindex, data=end_block
    hdf_sd_end, sdfid

;   Get the time vdata from the HDF file
    vdata = hdf_open(filelist[j], /read)
    vdata_ref = hdf_vd_find(vdata,"PerBlockMetadataTime")
    vdata_id  = hdf_vd_attach(vdata, vdata_ref)
    hdf_vd_get, vdata_id, class=class, count=count, fields=fields, $
                interlace=interlace, name=name, nfields=nfields, ref=ref, $
                size=size, tag=tag
    nread = hdf_vd_read(vdata_id,blocktimeMsr)
    hdf_vd_detach, vdata_id
    blocktimeMsr = string(blocktimeMsr)
    hdf_close, vdata
;   I don't really understand this, but in some cases the block time of
;   the starting block is 0000-00etc.  Look for 0000 in the first block and
;   toss out by incrementing start_block by 1
    while(strmid(blocktimemsr[start_block-1],0,4) eq '0000') do begin
     start_block = start_block+1
    endwhile

;   The algorithm here is that start_block-1 specifies the starting of valid
;   blocks and end_block-1 specifies the last valid block.  The array filled
;   in as "blocktime" is from blocks 0 -> end_block-1, with elements
;   0 -> start_block-2 filled with blanks or 00:00 etc.
;   At this point you can recast everything in terms of valid blocks.
    lonmsr = lonmsr[*,*,start_block-1:end_block-1]
    latmsr = latmsr[*,*,start_block-1:end_block-1]
    aotmsr = aotmsr[*,*,*,start_block-1:end_block-1]
    blocktimeMsr = blocktimeMsr[start_block-1:end_block-1]

;   At this point the MISR data is channel,x,y,block, but rearrange
;   putting into block, x, y, channel
    aotMsr = transpose(aotMsr,[3,1,2,0])
    lonMsr = transpose(lonMsr,[2,0,1])
    latMsr = transpose(latMsr,[2,0,1])

;    lonMsr = reform(lonMsr,n_elements(lonMsr))
;    latMsr = reform(latMsr,n_elements(latMsr))
;    aotMsr = reform(aotMsr,n_elements(lonMsr),4)

;   Now assemble into the output array
    if(j eq 0) then begin
     lon = lonMsr
     lat = latMsr
     aot = aotMsr
     blocktime = blocktimeMsr
    endif else begin
     lon = [lon, lonMsr]
     lat = [lat, latMsr]
     aot = [aot, aotMsr]
     blocktime = [blocktime, blocktimeMsr]
    endelse

   endfor

;  sort on ascending blocktime
   blocksort = sort(blocktime)
   blocktime = blocktime[blocksort]
   lon = lon[blocksort,*,*]
   lat = lat[blocksort,*,*]
   aot = aot[blocksort,*,*,*]

;  In order to retain the generality here so that we can throw out the missing
;  retrievals we recast blocktime to have the same dimensionality has lon
   result = size(lon)
   nblock = result[1]
   nx = result[2]
   ny = result[3]
   blocktimeout = make_array(nblock,nx,ny,val='a')
   for ib = 0, nblock-1 do begin
    blocktimeout[ib,*,*] = blocktime[ib]
   endfor

;  Now recast as vectors
   lon = reform(lon,nblock*nx*ny)
   lat = reform(lat,nblock*nx*ny)
   blocktimeout = reform(blocktimeout,nblock*nx*ny)
   aot = reform(aot,nblock*nx*ny,4)

end
