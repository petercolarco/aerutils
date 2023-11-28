# EXTERNAL LIBRARIES
import numpy as np
import scipy
import matplotlib.pyplot as plt
plt.style.use('seaborn-poster')
import matplotlib.patches as mpatches
import matplotlib.colors as colors
from matplotlib.colors import LinearSegmentedColormap
from matplotlib.gridspec import GridSpec
import cartopy.crs as ccrs
import os
os.environ["CARTOPY_USER_BACKGROUNDS"] = "/home/pcase1/python/cartopy/BG/"
# LOCAL LIBRARIES
import geos_io
import geos_utils

# PLOT PARAMETERS
#plt.rcParams["figure.figsize"] = (28,20)  # plot size (inches x inches)
plt.rcParams["figure.figsize"] = (14,10)  # plot size (inches x inches)
levels = np.arange(0.01,2.01,0.10)           # Countour levels
ticks = np.arange(0.,2.01,0.50)            # Label levels on colorbar
cntr_lon = 0                              # Longitude at center of plot
cntr_lat = 20                             # Latitude at center of plot
variable = 'totexttau'
units = '$AOD$'

# BUILD FILENAMES
file1 = '/misc/prc19/colarco/c1440_NR/day/gpm.nodrag/c1440_NR.gpm.nodrag.500km.day.cloud.daily.20060605.nc'
file2 = '/misc/prc19/colarco/c1440_NR/day/sunsynch_500km.nodrag/c1440_NR.sunsynch_500km.nodrag.500km.day.cloud.daily.20060605.nc'
file3 = '/misc/prc19/colarco/c1440_NR/day/dual/c1440_NR.dual.500km.day.cloud.daily.20060605.nc4'
file4 = '/misc/prc19/colarco/c1440_NR/day/full/c1440_NR.full.day.cloud.daily.20060605.nc'

# FETCH GRID DATA
lon = geos_io.fetch_var(file1, 'longitude')
lat = geos_io.fetch_var(file1, 'latitude')
lon[-1] = 180

# CREATE COLORMAP
ncolors = 256
color_array = plt.get_cmap('inferno')(range(ncolors))
color_array[:,-1] = np.linspace(.5,1.0,ncolors)
map_object = LinearSegmentedColormap.from_list(name='gray_alpha',colors=color_array)
plt.register_cmap(cmap=map_object)

# START PLOTTING

# FIND DATE
aod1 = geos_io.fetch_var(file1, variable)[0]
aod2 = geos_io.fetch_var(file2, variable)[0]
aod3 = geos_io.fetch_var(file3, variable)[0]
aod4 = geos_io.fetch_var(file4, variable)[0]
aod1[aod1>1000.] = np.nan
aod2[aod2>1000.] = np.nan
aod3[aod3>1000.] = np.nan
aod4[aod4>1000.] = np.nan

# BUILD FIGURE
fig = plt.figure()
gs = GridSpec(2, 2)

# TOP LEFT PLOT
ax1 = fig.add_subplot(gs[0], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax1.coastlines()
ax1.set_global()
ax1.gridlines(linewidth=0.25)
ax1.background_img(name='BM', resolution='high')
cf = ax1.contourf(lon, lat, aod1, levels, cmap='gray_alpha', extend='max', transform=ccrs.PlateCarree())
#cf = ax1.contourf(lon, lat, aod1, levels, extend='max', transform=ccrs.PlateCarree())
ax1.set_title('Inclined, Precessing', fontsize=20)

# TOP RIGHT PLOT
ax2 = fig.add_subplot(gs[1], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax2.coastlines()
ax2.set_global()
ax2.gridlines(linewidth=0.25)
ax2.background_img(name='BM', resolution='high')
cf2 = ax2.contourf(lon, lat, aod2, levels, transform=ccrs.PlateCarree(), cmap='gray_alpha', extend='max')
#cf2 = ax2.contourf(lon, lat, aod2, levels, transform=ccrs.PlateCarree(), extend='max')
ax2.set_title('Polar, Sun-Synchronous', fontsize=20)

# BOTTOM LEFT PLOT
ax3 = fig.add_subplot(gs[2], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax3.coastlines()
ax3.set_global()
ax3.gridlines(linewidth=0.25)
ax3.background_img(name='BM', resolution='high')
cf = ax3.contourf(lon, lat, aod3, levels, cmap='gray_alpha', extend='max', transform=ccrs.PlateCarree())
#cf = ax3.contourf(lon, lat, aod3, levels, extend='max', transform=ccrs.PlateCarree())
ax3.set_title('Constellation', fontsize=20)

# BOTTOM RIGHT PLOT
ax4 = fig.add_subplot(gs[3], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax4.coastlines()
ax4.set_global()
ax4.gridlines(linewidth=0.25)
ax4.background_img(name='BM', resolution='high')
cf4 = ax4.contourf(lon, lat, aod4, levels, transform=ccrs.PlateCarree(), cmap='gray_alpha', extend='max')
#cf4 = ax4.contourf(lon, lat, aod4, levels, transform=ccrs.PlateCarree(), extend='max')
ax4.set_title('Full', fontsize=20)

# COLORBAR
cb = plt.colorbar(cf, ax=(ax3, ax4), fraction=0.036, pad=0.05, ticks=ticks, orientation='horizontal', label='Sulfate AOD')
cb.ax.tick_params(labelsize=18)
cb.set_label(label='AOD',size=20)
cb.set_alpha(1)
cb.draw_all()

# SAVE AND CLEAR
plt.savefig('plots/aod_map.png', dpi=200)
#plt.show()
plt.cla()
