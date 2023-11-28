import h5py
import numpy as np
# Open the file to modify and get the radiances
f = h5py.File('OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5',mode='r+')
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('NormRadiance')
# Open the model return and stuff the radiances
data = np.load('radiance.dR_MERRA-AA-r2-v1621_aer_L2-OMAERUV_2007m0605t1407Full.npz')
x = data['rad_VL'].shape
x = x[0]/60
v[:,:,:] = np.reshape(data['rad_VL'],(x,60,3))

# Now get and stuff the "uncorrected" AI (called Residue)
data = np.load('ai.dR_MERRA-AA-r2-v1621_aer_L2-OMAERUV_2007m0605t1407Full.npz')
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
aod = np.reshape(data['AOT'],(x,60,3))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT',data=aod)
ssa = np.reshape(data['SSA'],(x,60,3))
g = f.create_dataset('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA',data=ssa)

# Now get the "corrected" AI and stuff into UVAerosolIndex
g = f.get('HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields')
v = g.get('UVAerosolIndex')
v[:,:] = np.reshape(data['AI_VL'],(x,60))

# Now close all
f.flush()
f.close()
