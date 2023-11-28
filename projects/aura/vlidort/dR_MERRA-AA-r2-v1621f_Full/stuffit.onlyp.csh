#!/bin/csh
# Copy OMI L2 file locally and stuff it with model produced radiances

  foreach file (`\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0605*he5`)
   set file_ = $file:t:r.geos5_pressure.he5
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
data = np.load('radiance.dR_MERRA-AA-r2-v1621_aer_L2-${fileend}Full.npz')
x = data['rad_VL'].shape
x = x[0]/60

# Now stuff the surface pressure into the TerrainPressure
data3 = np.load('/misc/prc15/colarco/dR_MERRA-AA-r2-v1621/inst3d_aer_v/Y2007/M06/dR_MERRA-AA-r2-v1621_aer_L2-${fileend}Full.npz')
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields')
v = g.get('TerrainPressure')
v[:,:] = np.reshape(data3['ps']/100,(x,60))

# Now close all
f.flush()
f.close()
EOF

    python ./tmp.py

end


