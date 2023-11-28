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
from matplotlib.colors import BoundaryNorm, ListedColormap
import matplotlib.patches as mpatches
#---------------------------------------------------------------------
def monthlyOMI_mod_obs(yy,mm,EXPID):
        ncfile = "omaeruv.monthly.201609.nc4"
        ncfile = "OMI.monthly.AI.nc"
        if os.path.isfile(ncfile)==True:
	        with Dataset(ncfile,'r') as ncid:
                        lons      = ncid.variables['longitude'][:] # longitude grid points
                        lats      = ncid.variables['latitude'][:] # latitude grid points
                        tau_nnr   = np.squeeze(ncid.variables['ai'][:])
        ncfile = "%s.monthly.AI.nc"%(EXPID)
        if os.path.isfile(ncfile)==True:
                with Dataset(ncfile,'r') as ncid:
                        lonm      = ncid.variables['longitude'][:] # longitude model
                        latm      = ncid.variables['latitude'][:] # latitude model
                        AOD_TOT   = np.squeeze(ncid.variables['ai'][:])
        return tau_nnr, AOD_TOT, lonm, latm

def plotit(map_projection,fig,title,label,plot_tmp_data,levs,colors,plot_lon,plot_lat,pos):
        extent = [-30, 45, -30, 10]
        cmapdiff = ListedColormap(colors,name="cmapdiff")
        normdiff = BoundaryNorm(levs, ncolors=cmapdiff.N, clip=False, extend="both")
        ax3 = fig.add_subplot(pos, projection=map_projection)
        cyclic_data, cyclic_lons = cartopy.util.add_cyclic_point(plot_tmp_data, coord=plot_lon)  #adding cyclic points
        im3 = ax3.pcolormesh(cyclic_lons, plot_lat, cyclic_data,cmap=cmapdiff, norm=normdiff, transform=map_projection)
        ax3.coastlines()
        ax3.add_feature(cfeature.BORDERS, linestyle=':')
        ax3.set_xticks(np.arange(extent[0], extent[1]+5, 15), crs=map_projection)
        ax3.set_yticks(np.arange(extent[2], extent[3]+5, 10),   crs=map_projection)
        ax3.tick_params(axis="x", labelsize=12)
        ax3.tick_params(axis="y", labelsize=12)
        lon_formatter = LongitudeFormatter(zero_direction_label=True)
        lat_formatter = LatitudeFormatter()
        ax3.xaxis.set_major_formatter(lon_formatter)
        ax3.yaxis.set_major_formatter(lat_formatter)
        ax3.set_title(title,fontsize=16)
        ax3.set_extent(extent)
        cbar3=plt.colorbar(im3, ax=ax3,orientation='horizontal', pad=0.1, extendfrac='auto')
        cbar3.ax.tick_params(labelsize=12)
        cbar3.set_label(label=label,size=12)
        return ax3
                
#------------------------------------------------------------------------
yy = 2016
#EXPID="c360R_era5_v10p22p2_aura_loss_bb3_low3"
#EXPID="c360R_era5_v10p22p2_aura_baseline"
#EXPID="GEOS.OAloss+updated_optics"
EXPID="GEOS.baseline"
mm = 9
OMIai, MODai, plot_lon, plot_lat = monthlyOMI_mod_obs(yy,mm,EXPID)
#-----------------------------plotting-----------------------------------
map_projection = ccrs.PlateCarree()
fig = plt.figure(figsize=(15, 5))

colors=["#634295","#8569aa","#5a91be","#68ab4f","#f8f5a3","#e27954","#d43f37","#a96438"]
levs=[-0.5,0,0.5,1,1.5,2,2.5]
ax1=plotit(map_projection,fig,'OMI Aerosol Index %04d%02d'%(yy,mm),'AI',OMIai,levs,colors,plot_lon,plot_lat,131)
#ax2=plotit(map_projection,fig,'GEOS OA-loss+updated optics','AI',MODai,levs,colors,plot_lon,plot_lat,132)
ax2=plotit(map_projection,fig,'GEOS Baseline','AI',MODai,levs,colors,plot_lon,plot_lat,132)

levs=[-2,-1.5,-1,-0.5,-0.1,0.1,0.5]
colors=["#30398f","#5880b5","#97c0d9","#b7dae8","#d6ebf3","#fefec8","#f3b875","#b5322f"]
ax3=plotit(map_projection,fig,'Model - OMI','AI Difference',MODai-OMIai,levs,colors,plot_lon,plot_lat,133)

lat_idx1 = np.argmin(abs(plot_lat-(-25.0)))
lat_idx2 = np.argmin(abs(plot_lat-(0.0)))
lon_idx1 = np.argmin(abs(plot_lon-(-15.0)))
lon_idx2 = np.argmin(abs(plot_lon-20.0))
print(plot_lat[lat_idx1],plot_lat[lat_idx2],plot_lon[lon_idx1],plot_lon[lon_idx2])
OMI_box = OMIai[lat_idx1:lat_idx2, lon_idx1:lon_idx2]
Model_box = MODai[lat_idx1:lat_idx2, lon_idx1:lon_idx2]
mean_bias = np.nanmean(Model_box - OMI_box)
RMSE      = np.sqrt(np.nanmean((Model_box - OMI_box)**2))
print('bias, RMSE =', np.round(mean_bias,3), np.round(RMSE,3))
#ax3.add_patch(mpatches.Rectangle(xy=[-15, -25], width=35, height=30,facecolor='None',edgecolor='k', transform=map_projection))

plt.tight_layout()
#plt.show()
fig.savefig('%s_OMI_%04d%02d.png'%(EXPID,yy,mm))
