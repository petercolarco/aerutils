#!/bin/csh
# Copy OMI L2 file locally and stuff it with model produced radiances

  foreach file (`\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0617t0[6,7]*he5`)
   set file_ = $file:t:r.vl_rad.he5
   /bin/cp -f $file $file_

   set fileend = `echo $file_ | cut -c 13-34`

# notes for python processing (ipython --pylab)
# This gets the "official" OMI file, opens it and reads the "NormRadiance" and then fills it
# with the values fromt the VLIDORT simulation
# PRC: add on 5/28/15 the "UVAerosolIndex"
cat > tmp.py <<EOF
import h5py
import numpy as np
# Open the file to modify and get the radiances
f = h5py.File('$file_',mode='r+')
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('NormRadiance')
# Open the model return and stuff the radiances
data = np.load('radiance.c90Fc_I10pa3_pin_aer_L2-${fileend}Full.npz')
x = data['rad_VL'].shape
x = x[0]/60
rad_VL = np.reshape(data['rad_VL'],(x,60,11))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/rad_VL',data=rad_VL)

# Now get and stuff the "uncorrected" AI (called Residue)
data = np.load('ai.c90Fc_I10pa3_pin_aer_L2-${fileend}Full.npz')
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('Residue')
v[:,:] = np.reshape(data['residue'],(x,60))

# Now get and stuff the "uncorrected" LER at 388 nm only
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('Reflectivity')
v[:,:,1] = np.reshape(data['refl_VL'],(x,60))

# Now add some new variables
sp = np.reshape(data['spher'],(x,60))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SphericalAlbedo',data=sp)
tr = np.reshape(data['trans'],(x,60))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Transmissivity',data=tr)
ic = np.reshape(data['i388calc'],(x,60))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Radiance388Calc',data=ic)
aod = np.reshape(data['AOT'],(x,60,11))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT',data=aod)
ssa = np.reshape(data['SSA'],(x,60,11))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA',data=ssa)

# Now get the "corrected" AI and stuff into UVAerosolIndex
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('UVAerosolIndex')
v[:,:] = np.reshape(data['AI_VL'],(x,60))

## Now stuff the surface pressure into the TerrainPressure
#data3 = np.load('/misc/prc15/colarco/c90Fc_I10pa3_pin/inst3d_aer_v/Y2007/M06/c90Fc_I10pa3_pin_aer_L2-${fileend}Full.npz')
#g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields')
#v = g.get('TerrainPressure')
#v[:,:] = np.reshape(data3['ps']/100,(x,60))

# Now close all
f.flush()
f.close()
EOF

    python ./tmp.py

end


