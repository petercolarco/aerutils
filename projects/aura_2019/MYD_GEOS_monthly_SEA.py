import numpy as np
import os.path
from scipy import interpolate
from netCDF4 import Dataset
import matplotlib.pyplot as plt
from matplotlib import cm #cm is colormap
import cartopy
from cartopy import util
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.io.shapereader as shapereader
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
from matplotlib.colors import BoundaryNorm
#---------------------------------------------------------------------
def monthlyAOD_mod_obs(yy,mm,EXPID):
	#path to observations directory on discover
	dir_obs="/discover/nobackup/projects/gmao/iesa/aerosol/data/AeroObs/NNR/MYD04/Y%04d/M%02d/"%(yy,mm)
	MYD_files = os.listdir(dir_obs)
	MYD_files.sort()
	dds = 1#int(MYD_files[0][29:31])
	l = len(MYD_files)
	dde = 30 #int(MYD_files[l-2][-12:-10])
	print("First and Last day of month, where data are available:",dds, dde)
	#path to model files on discover
	dirm="/home/pcolarco/piesa/experiments/colarco/%s/holding/inst2d_hwl_x/201609/"%(EXPID)
	tau_nnrLOD_dd=np.empty((721,1440,dde-dds+1)) # 361 x 720 is the Model resolution (lat x lon)
	Mod_TotAOD_dd=np.empty((721,1440,dde-dds+1))
	tau_nnrLOD_dd[:]=np.nan
	Mod_TotAOD_dd[:]=np.nan
	for dd in range(dds,dde+1):
		tau_nnrLOD=np.empty((721,1440,8)) # 8 is the number of MODIS files per day
		Model_totAOD=np.empty((721,1440,8))
		tau_nnrLOD[:]=np.nan
		Model_totAOD[:]=np.nan
		i=-1
		for t in range(0,24,3):
			i=i+1
			# MODIS has three sets of files for each day: land, ocean and deep blue algorithms
			nc_fileL = dir_obs+ "nnr_003.MYD04_L3a.land.%04d%02d%02d_%02d00z.nc4" %(yy,mm,dd,t)
			nc_fileO = dir_obs+ "nnr_003.MYD04_L3a.ocean.%04d%02d%02d_%02d00z.nc4" %(yy,mm,dd,t)
			nc_fileD = dir_obs+ "nnr_003.MYD04_L3a.deep.%04d%02d%02d_%02d00z.nc4" %(yy,mm,dd,t)
			if os.path.isfile(nc_fileL)==True and os.path.isfile(nc_fileO)==True and os.path.isfile(nc_fileD)==True:
				with Dataset(nc_fileL,'r') as ncid:
					lons      = ncid.variables['lon'][:] # longitude grid points
					lats      = ncid.variables['lat'][:] # latitude grid points
					tau_nnr_L   = np.squeeze(ncid.variables['tau_'][:])
				tau_nnr_L = tau_nnr_L[3,:,:] # 3 is the index corresponding to 550 nm wavelength, MODIS files have multi-wavelength AOD stored
				tau_nnr_L[tau_nnr_L >=999.0]=np.nan # 999 is the fill vale
				with Dataset(nc_fileO,'r') as ncid:
					tau_nnr_O   = np.squeeze(ncid.variables['tau_'][:])
				tau_nnr_O =tau_nnr_O[3,:,:]	
				tau_nnr_O[tau_nnr_O >=999.0]=np.nan
				with Dataset(nc_fileD,'r') as ncid:
					tau_nnr_D   = np.squeeze(ncid.variables['tau_'][:])
				tau_nnr_D = tau_nnr_D[3,:,:]	
				tau_nnr_D[tau_nnr_D >=999.0]=np.nan
				mask1 = np.isnan(tau_nnr_L) #finding the grid that are either not land or no land data is available for
				Merge_tau_nnrLO=np.copy(tau_nnr_L)
				Merge_tau_nnrLO[mask1]=tau_nnr_O[mask1] #replacing no-land data with watever is available from the ocean
				#mask2 = ~np.isnan(tau_nnr_D)
				mask2 = np.isnan(Merge_tau_nnrLO)
				Merge_tau_nnrLOD=np.copy(Merge_tau_nnrLO)
				Merge_tau_nnrLOD[mask2]=tau_nnr_D[mask2] #replacing empty Land pixels with deep blue data
				Merge_tau_nnrLOD[np.isnan(Merge_tau_nnrLOD)]=999.0 #changing back to fill values before interpolating
				Merge_tau_nnrLOD[Merge_tau_nnrLOD<0]=999.0
				#-----------------------------------------------------------------------------		
				nc_fileM = dirm + "%s.inst2d_hwl_x.%04d%02d%02d_%02d00z.nc4"%(EXPID,yy,mm,dd,t)
				with Dataset(nc_fileM,'r') as ncid:
                                        lonm      = ncid.variables['lon'][:] # longitude model
                                        latm      = ncid.variables['lat'][:] # latitude model
                                        AOD_TOT    = np.squeeze(ncid.variables['TOTEXTTAU'][:])

				f = interpolate.interp2d(lons, lats, Merge_tau_nnrLOD, kind='linear') # interpolating MODIS data to model grids
				tau_obs_modelres=f(lonm,latm)
				tau_obs_modelres[tau_obs_modelres >= 100.0]=np.nan # just a large unresonable AOD number to make the fill values as nan
				AOD_TOT[np.isnan(tau_obs_modelres)]=np.nan
				Model_totAOD[:,:,i]= AOD_TOT
				tau_nnrLOD[:,:,i] = tau_obs_modelres			
		Mod_TotAOD_dd[:,:,dd-1]= np.nanmean(Model_totAOD, axis=2) # remember python indexing is zero-based
		tau_nnrLOD_dd[:,:,dd-1]= np.nanmean(tau_nnrLOD, axis=2)	
		print("Processing Day of the Month:",dd)
	tau_nnrLOD_mm=np.nanmean(tau_nnrLOD_dd, axis=2) # monthly mean
	Mod_TotAOD_mm=np.nanmean(Mod_TotAOD_dd, axis=2) # monthly mean
	return tau_nnrLOD_mm, Mod_TotAOD_mm, lonm, latm
#------------------------------------------------------------------------
yy = 2016
EXPID="c360R_era5_v10p22p2_aura_loss_bb3_low3"
mm = 9
tau_nnrLOD_mm, Mod_TotAOD_mm, plot_lon, plot_lat = monthlyAOD_mod_obs(yy,mm,EXPID)
#-----------------------------plotting-----------------------------------
levels=[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8]
cmap = plt.get_cmap('Spectral_r')
cmap.set_over('magenta')
norm = BoundaryNorm(levels, ncolors=cmap.N, clip=False)
map_projection = ccrs.PlateCarree()
fig = plt.figure(figsize=(15, 5))
ax1=fig.add_subplot(131, projection=map_projection)
plot_tmp_data=tau_nnrLOD_mm
cyclic_data, cyclic_lons = cartopy.util.add_cyclic_point(plot_tmp_data, coord=plot_lon)  #adding cyclic points
im1 = ax1.pcolormesh(cyclic_lons, plot_lat, cyclic_data,cmap='Spectral_r',norm=norm, transform=map_projection)
extent = [-30, 45, -30, 10]
ax1.coastlines()
ax1.set_xticks(np.arange(extent[0], extent[1]+5, 15), crs=map_projection)
ax1.set_yticks(np.arange(extent[2], extent[3]+5, 10),   crs=map_projection)
ax1.tick_params(axis="x", labelsize=12)
ax1.tick_params(axis="y", labelsize=12)
lon_formatter = LongitudeFormatter(zero_direction_label=True)
lat_formatter = LatitudeFormatter()
ax1.xaxis.set_major_formatter(lon_formatter)
ax1.yaxis.set_major_formatter(lat_formatter)
ax1.set_title('MODIS NNR (Aqua) %04d%02d'%(yy,mm),fontsize=16)
ax1.set_extent(extent)
cbar1=plt.colorbar(im1, ax=ax1, orientation='horizontal', pad=0.1, extend="max")
cbar1.ax.tick_params(labelsize=12)
cbar1.set_label(label='AOD 550 nm',size=12)
##-------------------------------------------------------------------
ax2 = fig.add_subplot(132, projection=map_projection)
plot_tmp_data=Mod_TotAOD_mm
cyclic_data, cyclic_lons = cartopy.util.add_cyclic_point(plot_tmp_data, coord=plot_lon)  #adding cyclic points
im2 = ax2.pcolormesh(cyclic_lons, plot_lat, cyclic_data,cmap='Spectral_r',norm=norm, transform=map_projection)
ax2.coastlines()
ax2.set_xticks(np.arange(extent[0], extent[1]+5, 15), crs=map_projection)
ax2.set_yticks(np.arange(extent[2], extent[3]+5, 10),   crs=map_projection)
ax2.tick_params(axis="x", labelsize=12)
ax2.tick_params(axis="y", labelsize=12)
lon_formatter = LongitudeFormatter(zero_direction_label=True)
lat_formatter = LatitudeFormatter()
ax2.xaxis.set_major_formatter(lon_formatter)
ax2.yaxis.set_major_formatter(lat_formatter)
ax2.set_title('GEOS OAloss+updated optics',fontsize=16)
ax2.set_extent(extent)
cbar2=plt.colorbar(im2, ax=ax2,orientation='horizontal', pad=0.1, extend="max")
cbar2.ax.tick_params(labelsize=12)
cbar2.set_label(label='AOD 550 nm',size=12)
#-------------------------------------------------------------------------------------
levs=[-0.5,-0.4,-0.3,-0.2,-0.1,0.0,0.1,0.2,0.3,0.4,0.5]
cmapdiff = plt.get_cmap('RdBu_r')
normdiff = BoundaryNorm(levs, ncolors=cmapdiff.N, clip=False)
ax3 = fig.add_subplot(133, projection=map_projection)
plot_tmp_data=Mod_TotAOD_mm - tau_nnrLOD_mm
cyclic_data, cyclic_lons = cartopy.util.add_cyclic_point(plot_tmp_data, coord=plot_lon)  #adding cyclic points
im3 = ax3.pcolormesh(cyclic_lons, plot_lat, cyclic_data,cmap=cmapdiff, norm=normdiff, transform=map_projection)
ax3.coastlines()
ax3.set_xticks(np.arange(extent[0], extent[1]+5, 15), crs=map_projection)
ax3.set_yticks(np.arange(extent[2], extent[3]+5, 10),   crs=map_projection)
ax3.tick_params(axis="x", labelsize=12)
ax3.tick_params(axis="y", labelsize=12)
lon_formatter = LongitudeFormatter(zero_direction_label=True)
lat_formatter = LatitudeFormatter()
ax3.xaxis.set_major_formatter(lon_formatter)
ax3.yaxis.set_major_formatter(lat_formatter)
ax3.set_title('Model – MODIS',fontsize=16)
ax3.set_extent(extent)
cbar3=plt.colorbar(im3, ax=ax3,orientation='horizontal', pad=0.1, extend="both")
cbar3.ax.tick_params(labelsize=12)
cbar3.set_label(label='AOD diff 550 nm',size=12)
plt.tight_layout()
plt.show()
fig.savefig('%s_MYD_%04d%02d.png'%(EXPID,yy,mm))
