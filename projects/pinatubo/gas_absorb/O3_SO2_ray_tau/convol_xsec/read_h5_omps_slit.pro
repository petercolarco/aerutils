; Subroutine for reading the band-pass information from OMPS
PRO read_h5_omps_slit, infile, BPS_delta, Macro_BPS, Macro_CBC 
;infile = 'OMPS_TC_MACRO_CBC_BPS.h5'

fid =H5F_OPEN(infile)
gid = H5G_OPEN(fid,'DATA')
dataid1 = H5D_OPEN(gid,'BPS_Delta')
dataid2 = H5D_OPEN(gid,'Macro_BPS')
dataid3 = H5D_OPEN(gid,'Macro_CBC')
BPS_delta = H5D_READ(dataid1)
Macro_BPS = H5D_READ(dataid2)
Macro_CBC = H5D_READ(dataid3)
H5D_CLOSE,dataid1
H5D_CLOSE,dataid2
H5D_CLOSE,dataid3
H5G_CLOSE,gid
H5F_CLOSE,fid

RETURN
END
