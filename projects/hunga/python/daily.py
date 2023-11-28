import ompsl3
import numpy as np
from scipy import interpolate
import matplotlib.pyplot as plt
from matplotlib import cm #cm is colormap
import cartopy
from cartopy import util
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.io.shapereader as shapereader
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
from matplotlib.colors import BoundaryNorm

def plot(yy,mm,dd,channel=5,lev=23):


#------------------------------------------------------------------------
# Get data
  ext,lon,lat = ompsl3.readday(yy,mm,dd, channel=5)

#-----------------------------plotting-----------------------------------
# Plot result
  levels=[0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0]
  cmap = plt.get_cmap('Spectral_r')
  cmap.set_over('magenta')
  norm = BoundaryNorm(levels, ncolors=cmap.N, clip=False)
  map_projection = ccrs.PlateCarree()
  fig = plt.figure(figsize=(10,10))
  ax1=fig.add_subplot(111, projection=map_projection)
  plot_tmp_data=ext[lev,:,:]*1.e7
  print(plot_tmp_data.shape)
  print(np.max(plot_tmp_data),np.min(plot_tmp_data))
  cyclic_data, cyclic_lons = cartopy.util.add_cyclic_point(plot_tmp_data, coord=lon)  #adding cyclic points
  im1 = ax1.pcolormesh(cyclic_lons, lat, cyclic_data,cmap='Spectral_r',norm=norm, transform=map_projection)
  ax1.coastlines()
  ax1.set_xticks(np.linspace(-180, 180, 5), crs=map_projection)
  ax1.set_yticks(np.linspace(-90, 90, 5),   crs=map_projection)
  ax1.tick_params(axis="x", labelsize=12)
  ax1.tick_params(axis="y", labelsize=12)
  lon_formatter = LongitudeFormatter(zero_direction_label=True)
  lat_formatter = LatitudeFormatter()
  ax1.xaxis.set_major_formatter(lon_formatter)
  ax1.yaxis.set_major_formatter(lat_formatter)
  ax1.set_title('%04d%02d'%(yy,mm),fontsize=14)
  ax1.set_global()
  cbar1=plt.colorbar(im1, ax=ax1, orientation='horizontal', pad=0.1, extend="max")
  cbar1.ax.tick_params(labelsize=12)
  cbar1.set_label(label='Extinction 869 nm [10^-4 km^-1]',size=12)
  plt.tight_layout()
  plt.show()
  fig.savefig('%04d%02d_modelres.png'%(yy,mm))
  return


def plotzonal(yy,mm,dd,channel=5):

  alt = np.empty(41)
  for k in range(0,41):
    alt[k] = k+0.5
  print(alt)


#------------------------------------------------------------------------
# Get data
  ext,lon,lat = ompsl3.readday(yy,mm,dd, channel=5)
  ext = np.nanmean(ext,axis=2)*1.e7
  troph,lon,lat = ompsl3.readtroph(yy,mm,dd)
  troph = np.nanmean(troph,axis=1)
#-----------------------------plotting-----------------------------------
# Plot result
  levels=[0,2,4,6,8,10,12,14,16,18,20,2000]
  cmap = plt.get_cmap('Spectral_r')
  cmap.set_over('magenta')
  norm = BoundaryNorm(levels, ncolors=cmap.N, clip=False)
  fig = plt.figure(figsize=(10,10))
  ax1=fig.add_subplot(111)
  plot_tmp_data=ext
  im1 = ax1.contourf(lat, alt, ext, levels, cmap='Spectral_r',norm=norm)
  plt.plot(lat,troph,'-k')
  ax1.set_yticks(np.linspace(0,40,5))
  ax1.set_xticks(np.linspace(-90, 90, 5))
  ax1.tick_params(axis="x", labelsize=12)
  ax1.tick_params(axis="y", labelsize=12)
  ax1.set_title('%04d%02d'%(yy,mm),fontsize=14)
  cbar1=plt.colorbar(im1, ax=ax1, orientation='horizontal', pad=0.1, extend="max")
  cbar1.ax.tick_params(labelsize=12)
  cbar1.set_label(label='Extinction 869 nm [10^-4 km^-1]',size=12)
  plt.tight_layout()
  plt.show()
  fig.savefig('%04d%02d_modelres.png'%(yy,mm))
  return
