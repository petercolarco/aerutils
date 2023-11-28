"""Module for GEOS-5 specific data transformations

Author: Parker A. Case
Changelog: Created 2/2/2019
"""
import numpy as np


def grid_area(grid_string=None, nx=None, ny=None, dx=None, dy=None):
    '''
    Takes GEOS-5 grid string ('a', 'b', 'c', 'd', or 'e').
    Returns grid-box area, lat, lon, nx, ny, dx, dy and area string
    OR takes nx, ny, dx, dy and returns
    grid-box area, lat, lon, nx, ny, dx, dy and area string
    Translated from P. Colarco's IDL routine 'area.pro'
    Fixed bug with lats not being centered at lat point.

    e.g.:
    area, lat, lon, nx, ny, dx, dy, 'e' = grid_area('b')
    OR
    area, lat, lon, nx, ny, dx, dy, 'e' = grid_area(nx=144,ny=91,dx=2.5,dy=2)
    OR
    area, lon, lat, nx, ny, dx, dy, res = grid_area(grid_string='c')
    '''

    ## Radius of earth
    Rearth = 6371200.

    if (grid_string != None):
        if (grid_string == 'a'):
            nx, ny, dx, dy = 72, 46, 5., 4.
        elif (grid_string == 'b'):
            nx, ny, dx, dy = 144, 91, 2.5, 2.
        elif (grid_string == 'c'):
            nx, ny, dx, dy = 288, 181, 1.25, 1.
        elif (grid_string == 'd'):
            nx, ny, dx, dy = 576, 361, 0.625, 0.5
        elif (grid_string == 'e'):
            nx, ny, dx, dy = 1152, 721, 0.3125, 0.25
        else:
            print('Invalid GEOS-5 grid: a, b, c, d, e valid')
            return None
    elif (nx != None and ny != None and dx != None and dy != None):
        if (nx == 72 and ny == 46 and dx == 5 and dy == 4):
            grid_string = 'a'
        elif (nx == 144 and ny == 91 and dx == 2.5 and dy == 2):
            grid_string = 'b'
        elif (nx == 288 and ny == 181 and dx == 1.25 and dy == 1):
            grid_string = 'c'
        elif (nx == 576 and ny == 361 and dx == 0.625 and dy == 0.5):
            grid_string = 'd'
        elif (nx == 1152 and ny == 721 and dx == 0.3125 and dy == 0.25):
            grid_string = 'e'
    else:
        print('Must supply GEOS-5 grid resolution or grid parameters')
        return None

    res = grid_string

    ## Compute lat and lon
    lon = np.asarray([-180. + dx*ix for ix in range(0,nx)])
    lat = np.asarray([-90. + dy*iy for iy in range(0,ny)])

    ## Output array
    area = np.zeros((ny,nx), dtype=np.float64)

    ## Compute area #spherical cap = 2*pi*R*(1-sin(lat))
    area[ny-1,:] = 2.*np.pi*(Rearth)**2*(dx/360.)*(1. - np.sin((lat[ny-1]- \
                   (dy/2.))*(np.pi/180.)))
    area[0,:] = area[ny-1,:]
    for iy in range(1, ny-1):
        area[iy,:] = 2.*np.pi*(Rearth)**2*(dx/360.)*(np.sin((lat[iy]+(dy/2.))* \
                     (np.pi/180.)) - np.sin((lat[iy]-(dy/2.))*(np.pi/180.)))
    return area, lon, lat, nx, ny, dx, dy, res


def areamean(data, lat_min=None, lat_max=None, lon_min=None, lon_max=None):
    area, lon, lat, nx, ny, dx, dy, res = grid_area(grid_string='c')
    lat = np.repeat(lat[:,np.newaxis], len(lon), axis=1)
    if lat_min == None or lat_max == None:
        #global weighted mean
        return np.average(data, weights=area)
    elif lat_min != None and lat_max != None:
        #zonal weighted mean between lat_min and lat_max
        return np.average(data[(lat <= lat_max) & (lat >= lat_min)], \
                          weights = area[(lat <= lat_max) & (lat >= lat_min)])
    else:
        print('areamean has failed, returning None')
        return None


def areasum(data, lat_min=None, lat_max=None, lon_min=None, lon_max=None):
    area, lon, lat, nx, ny, dx, dy, res = grid_area(grid_string='c')
    lat = np.repeat(lat[:,np.newaxis], len(lon), axis=1)
    if lat_min == None or lat_max == None:
        #global weighted mean
        return np.nansum(data*area)
    elif lat_min != None and lat_max != None:
        #zonal weighted mean between lat_min and lat_max
        return np.nansum(data[(lat <= lat_max) & (lat >= lat_min)] * \
                          area[(lat <= lat_max) & (lat >= lat_min)])
    else:
        print('areasum has failed, returning None')
        return None


def eqvlat(ylat, vort, area=None, n_points=100, planet_radius=6.378e+6, vgrad=None):
    """Compute equivalent latitude, and optionally <...>_Q in Nakamura and Zhu (2010).
    This is an edited form of the github.com/csyhuang/hn2016_falwa
    I've added a way to automatically calculate area and a default resolution
    Parameters
    ----------
    ylat : sequence or array_like
        1-d numpy array of latitude (in degree) with equal spacing in ascending order; dimension = nlat.
    vort : ndarray
        2-d numpy array of vorticity values; dimension = (nlat, nlon).
    area : ndarray
        2-d numpy array specifying differential areal element of each grid point; dimension = (nlat, nlon).
    n_points: int
        Analysis resolution to calculate equivalent latitude.
    planet_radius: float
        Radius of spherical planet of interest consistent with input *area*.
    vgrad: ndarray, optional
        2-d numpy array of laplacian (or higher-order laplacian) values; dimension = (nlat, nlon)
    Returns
    -------
    q_part : ndarray
        1-d numpy array of value Q(y) where latitude y is given by ylat; dimension = (nlat).
    brac : ndarray or None
        1-d numpy array of averaged vgrad in the square bracket.
        If *vgrad* = None, *brac* = None.
    """
    if area is None:
        area, lon, lat, nx, ny, dx, dy, res = grid_area(grid_string='c')

    vort_min = np.min([vort.min(), vort.min()])
    vort_max = np.max([vort.max(), vort.max()])
    q_part_u = np.linspace(vort_min, vort_max, n_points, endpoint=True)
    #dq = q_part_u[2] - q_part_u[1]
    aa = np.zeros(q_part_u.size)  # to sum up area
    vort_flat = vort.flatten()  # Flatten the 2D arrays to 1D
    area_flat = area.flatten()

    if vgrad is not None:
        dp = np.zeros_like(aa)
        vgrad_flat = vgrad.flatten()

    # Find equivalent latitude:
    inds = np.digitize(vort_flat, q_part_u)
    for i in np.arange(0, aa.size):  # Sum up area in each bin
        aa[i] = np.sum(area_flat[np.where(inds == i)])
        if vgrad is not None:
            # This is to avoid the divided-by-zero error
            if aa[i] == 0.:
                continue
            else:
                dp[i] = np.sum(area_flat[np.where(inds == i)] *
                               vgrad_flat[np.where(inds == i)]) / aa[i]

    aq = np.cumsum(aa)
    if vgrad is not None:
        brac = np.zeros_like(aa)
        brac[1:-1] = 0.5 * (dp[:-2] + dp[2:])

    y_part = aq / (2 * np.pi * planet_radius**2) - 1.0
    lat_part = np.rad2deg(np.arcsin(y_part))
    q_part = np.interp(ylat, lat_part, q_part_u)

    if vgrad is not None:
        brac_return = np.interp(ylat, lat_part, brac)
    else:
        brac_return = None

    return q_part, brac_return


def ozone_hole_filter(data, level, latitudes, pv):
    vortex_identification_level = level
    cpv = pv[vortex_identification_level,:,:]
    eq_latitude, brac = eqvlat(latitudes, cpv, n_points=100)
    eq_latitude[latitudes > -70.0] = np.nan
    vortex_edge_idx = np.nanargmax(np.gradient(eq_latitude))
    vortex_edge_pv = eq_latitude[vortex_edge_idx]
    print(vortex_edge_pv)
    data[:, cpv > vortex_edge_pv] = np.nan
    return data


def ozone_hole_area(o3du, area=None, threshold=220):
    if area is None:
        area, lon, lat, nx, ny, dx, dy, res = grid_area(grid_string='c')
    return np.nansum(area[o3du < threshold])*1e-6 # conver to km2

