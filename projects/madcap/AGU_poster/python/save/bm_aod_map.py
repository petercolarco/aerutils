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
plt.rcParams["figure.figsize"] = (28,20)  # plot size (inches x inches)
levels = np.arange(0,3.01,0.10)           # Countour levels
ticks = np.arange(0,3.01,0.50)            # Label levels on colorbar
cntr_lon = 150                            # Longitude at center of plot
cntr_lat = 55                             # Latitude at center of plot
variable = 'SUEXTTAU'
units = '$AOD$'

# BUILD FILENAMES
file_132 = geos_io.get_hourly_filenames('/misc/prc10/pcase1/data/', 'volcano_132', \
    'aer_inst_1hr_g1440x721_x1', '2019', '06', '22', '0000z')[0]
file_72 = geos_io.get_hourly_filenames('/misc/prc10/pcase1/data/', 'volcano_72', \
    'aer_inst_1hr_g1440x721_x1', '2019', '06', '22', '0000z')[0]
file_132 = file_132 + '.cmpress'
file_72 = file_72 + '.cmpress'

# FETCH GRID DATA
lon = geos_io.fetch_var(file_132, 'lon')
lat = geos_io.fetch_var(file_132, 'lat')
lon[-1] = 180

# CREATE COLORMAP
ncolors = 256
color_array = plt.get_cmap('GnBu')(range(ncolors))
color_array[:,-1] = np.linspace(0.0,1.0,ncolors)
map_object = LinearSegmentedColormap.from_list(name='gray_alpha',colors=color_array)
plt.register_cmap(cmap=map_object)

# START PLOTTING

# FIND DATE
timetag = file_132[-22:-15]
print(timetag)
time = file_132[-22:-15].replace('_', ' ')
time = time[:2] + '/' + time[2:]
aod_132 = geos_io.fetch_var(file_132, variable)[0]
aod_72 = geos_io.fetch_var(file_72, variable)[0]

# BUILD FIGURE
fig = plt.figure()
gs = GridSpec(1, 2)

# LEFT PLOT
ax_72 = fig.add_subplot(gs[0], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax_72.coastlines()
ax_72.set_global()
ax_72.gridlines(linewidth=0.25)
ax_72.background_img(name='BM', resolution='high')
cf = ax_72.contourf(lon, lat, aod_72, levels, transform=ccrs.PlateCarree(), cmap='gray_alpha', extend='max')
ax_72.set_title('$n_z=72$, t=' + time + 'z', fontsize=40)

# RIGHT PLOT
ax_132 = fig.add_subplot(gs[1], projection=ccrs.Orthographic(cntr_lon, cntr_lat))
ax_132.coastlines()
ax_132.set_global()
ax_132.gridlines(linewidth=0.25)
ax_132.background_img(name='BM', resolution='high')
cf2 = ax_132.contourf(lon, lat, aod_132, levels, transform=ccrs.PlateCarree(), cmap='gray_alpha', extend='max')
ax_132.set_title('$n_z=132$, t=' + time + 'z', fontsize=40)

# COLORBAR
cb = plt.colorbar(cf, ax=(ax_72, ax_132), fraction=0.036, pad=0.05, ticks=ticks, orientation='horizontal', label='Sulfate AOD')
cb.ax.tick_params(labelsize=36)
cb.set_label(label='Sulfate AOD',size=40)
cb.set_alpha(1)
cb.draw_all()

# SAVE AND CLEAR
plt.savefig('plots/aod_map_' + timetag + '.png', dpi=200)
plt.cla()
