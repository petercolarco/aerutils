### CAR 3/29/13
### Functions translated from IDL utilities
### Additional utilities as well

import numpy as np
import scipy.stats as stats

###
def shiftdim(x, n=None):
    r""" Matlab's shiftdim in python.
    http://www.python-it.org/forum/index.php?topic=4688.0
    n is None: returns the array with the same number of
    elements as original but with anly leading singleton
    dimensions removed
    n >= 0: Shifts the dimensions to the left and wraps the n
    leading dimensions to the end
    n < 0: Shifts the dimensions to the right and pads
    with singletons
    """

    def no_leading_ones(shape):
        shape = np.atleast_1d(shape)
        if shape[0] == 1:
            shape = shape[1:]
            return no_leading_ones(shape)
        else:
            return shape

    if n is None:
        # returns the array B with the same number of
        # elements as X but with any leading singleton
        # dimensions removed.
        return x.reshape(no_leading_ones(x.shape))
    elif n >= 0:
        # When n is positive, shiftdim shifts the dimensions
        # to the left and wraps the n leading dimensions to the end.
        return x.transpose(np.roll(range(x.ndim), -n))
    else:
        # When n is negative, shiftdim shifts the dimensions
        # to the right and pads with singletons.
        return x.reshape((1,) * -n + x.shape)

##
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
    '''

    ## Radius of earth
    Rearth = long(6370000)
   
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
            print 'Invalid GEOS-5 grid: a, b, c, d, e valid'
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
        print 'Must supply GEOS-5 grid resolution or grid parameters'
        return None

    res = grid_string
    
    ## Compute lat and lon
    lon = [-180. + dx*ix for ix in range(0,nx)]
    lat = [-90. + dy*iy for iy in range(0,ny)]
    
    ## Output array
    area = np.zeros((ny,nx), dtype=np.float64)
    
    ## Compute area
    area[ny-1,:] = 2.*np.pi*(Rearth)**2*(dx/360.)*(1. - np.sin((lat[ny-1]-(dy/2.))*(np.pi/180.))) #spherical cap = 2*pi*R*(1-sin(lat))
    area[0,:]    = area[ny-1,:]
    for iy in range(1, ny-1):
        area[iy,:] = 2.*np.pi*(Rearth)**2*(dx/360.)*(np.sin((lat[iy]+(dy/2.))*(np.pi/180.))- np.sin((lat[iy]-(dy/2.))*(np.pi/180.)))

    return area, lon, lat, nx, ny, dx, dy, res

##

def aave(inval, emptyVal=None, compare_str=None, minlon=None, minlat=None, maxlon=None, maxlat=None,
         mask=None,  physical=False):
    '''
    Computes area average of inval with gridbox_area().
    Replaces emptyVal with nan based on compare_str (gt, ge, lt, le, eq).
    Only averages subset if minlon, maxlon, minlat, maxlat provided.
    If a 2-d (nx,ny) mask is given, returns average of gridboxes where mask is 1 (and not NaN).
    Input can be 2-d or 3-d; if 2d returns single value; if 3-d returns array of size nz.
    Assumes input is of size (ny, nx) or (ny, nx, nz).
    physical=True replaces all values < 0 with NaN; default behaviour does not do this.
    '''

    ## Make copies of input and area; make them numpy arrays
    inval_ = inval.copy()
    
    ## Determine dimensions of input
    invalshape = inval_.shape
    if (len(invalshape) == 2):
        ny, nx = invalshape[0], invalshape[1]
    elif (len(invalshape) == 3):
        ny, nx, nz = invalshape[0], invalshape[1], invalshape[2]
    else:
        print 'aave: Not a valid GEOS-5 grid shape (y, x, z)'
        return None
    
    ## Get all dimensions, lat, lon, and area_
    if (nx == 72 and ny == 46):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('a')
    elif (nx == 144 and ny == 91):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('b')
    elif (nx == 288 and ny == 181):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('c')
    elif (nx == 576 and ny == 361):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('d')
    elif (nx == 1152 and ny == 721):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('e')
    else:
        print 'aave: Not a valid GEOS-5 grid'
        return None

    ## Make a copy of the mask if given
    if (mask != None):
        mask_ = mask.copy()
        maskshape = mask_.shape
        my, mx = maskshape[0], maskshape[1]
        if (mx != nx or my != ny):
            print 'Mask must be same shape (%i, %i) as input (%i %i)' % (mx, my, nx, ny)
            return None
    
    ## If 3-d, tile area_ to same size as inval_
    if (len(invalshape) == 3):
        area_ = shiftdim(np.tile(area_, (nz, 1, 1)), 1)
        ## Also tile mask file if it exists
        if (mask != None):
            mask_ = shiftdim(np.tile(mask_, (nz, 1, 1)), 1)

    ## Check if physical
    if (physical == True):
        isphysical = np.where(inval_ < 0)

        ## Replace emptyVal with nan
        yphysical, xphysical = isphysical[0], isphysical[1]
        if (len(invalshape) == 3):
            zphysical = isphysical[2]
            inval_[yphysical,xphysical,zphysical] = np.nan
            area_[yphysical,xphysical,zphysical] = np.nan
            if (mask != None):
                mask_[yphysical,xphysical,zphysical] = np.nan
        elif (len(invalshape) == 2):
            inval_[yphysical,xphysical] = np.nan
            area_[yphysical, xphysical] = np.nan
            if (mask != None):
                mask_[yphysical,xphysical] = np.nan
                
    ## Fill in empty vals with nan based on compare_str
    if (emptyVal != None and emptyVal != ''):
        ## Default compare string
        if (compare_str =='' or compare_str == None):
            print 'Using default compare_str "eq"'
            compare_str = 'eq'
        
        ## Valid compare strings
        if (compare_str == 'eq'):
            isempty = np.where(inval_ == emptyVal)
        elif (compare_str == 'gt'):
            isempty = np.where(inval_ > emptyVal)
        elif (compare_str == 'ge'):
            isempty = np.where(inval_ >= emptyVal)
        elif (compare_str == 'lt'):
            isempty = np.where(inval_ < emptyVal)
        elif (compare_str == 'le'):
            isempty = np.where(inval_ <= emptyVal)
        else:
            print 'Not a valid compare string.'
            return None

        ## Replace emptyVal with nan
        yempty, xempty = isempty[0], isempty[1]
        if (len(invalshape) == 3):
            zempty = isempty[2]
            inval_[yempty,xempty,zempty] = np.nan
            area_[yempty,xempty,zempty] = np.nan
            if (mask != None):
                mask_[yempty,xempty,zempty] = np.nan
        elif (len(invalshape) == 2):
            inval_[yempty,xempty] = np.nan
            area_[yempty, xempty] = np.nan
            if (mask != None):
                mask_[yempty,xempty] = np.nan
        
    ## Subset if wanted
    if (minlon != None and maxlon != None and minlat != None and maxlat != None):
        ## Get indices
        if (lat.count(minlat) != 0 and lat.count(maxlat) != 0 and lon.count(minlon) != 0 and lon.count(maxlon) != 0):
            iminlon, imaxlon, iminlat, imaxlat = lon.index(minlon), lon.index(maxlon), lat.index(minlat), lat.index(maxlat)
        else:
            print 'Not valid lat/lon on this grid; no interpolation possible. Return global average'
            iminlon, imaxlon, iminlat, imaxlat = 0, nx - 1, 0, ny - 1
        
        ## Subset
        if (len(invalshape) == 2):
            inval_ = inval_[iminlat:imaxlat+1, iminlon:imaxlon+1]
            area_  = area_[iminlat:imaxlat+1, iminlon:imaxlon+1]
        elif (len(invalshape) == 3):
            inval_ = inval_[iminlat:imaxlat+1, iminlon:imaxlon+1, :]
            area_  = area_[iminlat:imaxlat+1, iminlon:imaxlon+1, :]
            
    ## Apply mask if it exists
    if (mask != None):
        inval_ = inval_*mask_
        area_  = area_*mask_
        
    ## Calculate average
    if (len(invalshape) == 2):
        inave = np.nansum(inval_*area_)/np.nansum(area_)
    elif (len(invalshape) == 3):
        inave = np.zeros(nz)
        for iz in range(0,nz):
            inave[iz] = np.nansum(inval_[:,:,iz]*area_[:,:,iz])/np.nansum(area_[:,:,iz])
    
    return inave
            

##
def zonalavg(inval, emptyVal=None, compare_str=None, minlon=None, minlat=None, maxlon=None, maxlat=None,
             mask=None, physical=False):
    '''
    Computes zonal area average of inval and gridbox_area().
    Replaces emptyVal with nan based on compare_str (gt, ge, lt, le, eq).
    Only averages subset if minlon, maxlon, minlat, maxlat provided.
    If a 2-d (nx,ny) mask is given, returns average of gridboxes where mask is 1 (and not NaN).
    Input can be 2-d or 3-d; if 2d returns single value; if 3-d returns list of nz values.
    Assumes input is of size (ny, nx) or (ny, nx, nz).
    physical=True replaces negative values with NaN; default behaviour does not do this.
    '''
    
    ## Make copies of input and area; make them numpy arrays
    inval_ = inval.copy()

    ## 1 where data is there, 0 otherwise
    counts_ = np.ones(inval_.shape)
    
    ## Determine dimensions of input
    invalshape = inval_.shape
    if (len(invalshape) == 2):
        ny, nx = invalshape[0], invalshape[1]
    elif (len(invalshape) == 3):
        ny, nx, nz = invalshape[0], invalshape[1], invalshape[2]
    else:
        print 'aave: Not a valid GEOS-5 grid shape (x, y, z)'
        return None
    
    ## Get all dimensions, lat, lon, and area_
    if (nx == 72 and ny == 46):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('a')
    elif (nx == 144 and ny == 91):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('b')
    elif (nx == 288 and ny == 181):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('c')
    elif (nx == 576 and ny == 361):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('d')
    elif (nx == 1152 and ny == 721):
        area_, lon, lat, nx, ny, dx, dy, res =  grid_area('e')
    else:
        print 'aave: Not a valid GEOS-5 grid'
        return None

    ## Make a copy of the mask if given
    if (mask != None):
        mask_ = mask.copy()
        maskshape = mask_.shape
        my, mx = maskshape[0], maskshape[1]
        if (mx != nx or my != ny):
            print 'Mask must be same shape (%i, %i) as input (%i %i)' % (mx, my, nx, ny)
            return None
    
    ## If 3-d, tile area_ to same size as inval_
    if (len(invalshape) == 3):
        area_ = shiftdim(np.tile(area_, (nz, 1, 1)), 1)
        ## Also tile mask file if it exists
        if (mask != None):
            mask_ = shiftdim(np.tile(mask_, (nz, 1, 1)), 1)
    
    ## Check if physical
    if (physical == True):
        isphysical = np.where(inval_ < 0)

        ## Replace emptyVal with nan
        yphysical, xphysical = isphysical[0], isphysical[1]
        if (len(invalshape) == 3):
            zphysical = isphysical[2]
            inval_[yphysical,xphysical,zphysical] = np.nan
            area_[yphysical,xphysical,zphysical] = np.nan
            counts_[yphysical,xphysical,zphysical] = 0
            if (mask != None):
                mask_[yphysical,xphysical,zphysical] = np.nan
        elif (len(invalshape) == 2):
            inval_[yphysical,xphysical]  = np.nan
            area_[yphysical, xphysical]  = np.nan
            counts_[yphysical,xphysical] = 0
            if (mask != None):
                mask_[yphysical,xphysical] = np.nan
                
    ## Fill in empty vals with nan based on compare_str
    if (emptyVal != None and emptyVal != ''):
        ## Default compare string
        if (compare_str =='' or compare_str == None):
            print 'Using default compare_str "eq"'
            compare_str = 'eq'
        
        ## Valid compare strings
        if (compare_str == 'eq'):
            isempty = np.where(inval_ == emptyVal)
        elif (compare_str == 'gt'):
            isempty = np.where(inval_ > emptyVal)
        elif (compare_str == 'ge'):
            isempty = np.where(inval_ >= emptyVal)
        elif (compare_str == 'lt'):
            isempty = np.where(inval_ < emptyVal)
        elif (compare_str == 'le'):
            isempty = np.where(inval_ <= emptyVal)
        else:
            print 'Not a valid compare string.'
            return None

        ## Replace emptyVal with nan
        yempty, xempty = isempty[0], isempty[1]
        if (len(invalshape) == 3):
            zempty = isempty[2]
            inval_[yempty,xempty,zempty] = np.nan
            area_[yempty,xempty,zempty] = np.nan
            counts_[yempty,xempty,zempty] = 0
            if (mask != None):
                mask_[yempty,xempty,zempty] = np.nan
        elif (len(invalshape) == 2):
            inval_[yempty,xempty] = np.nan
            area_[yempty, xempty] = np.nan
            counts_[yempty,xempty] = 0
            if (mask != None):
                mask_[yempty,xempty] = np.nan
        
    ## Subset if wanted
    if (minlon != None and maxlon != None and minlat != None and maxlat != None):
        ## Get indices
        if (lat.count(minlat) != 0 and lat.count(maxlat) != 0 and lon.count(minlon) != 0 and lon.count(maxlon) != 0):
            iminlon, imaxlon, iminlat, imaxlat = lon.index(minlon), lon.index(maxlon), lat.index(minlat), lat.index(maxlat)
        else:
            print 'Not valid lat/lon on this grid; no interpolation possible. Return global average'
            iminlon, imaxlon, iminlat, imaxlat = 0, nx - 1, 0, ny - 1
        
        ## Subset
        if (len(invalshape) == 2):
            inval_ = inval_[iminlat:imaxlat+1, iminlon:imaxlon+1]
            area_  = area_[iminlat:imaxlat+1, iminlon:imaxlon+1]
            counts_= counts_[iminlat:imaxlat+1,iminlon:imaxlon+1]
        elif (len(invalshape) == 3):
            inval_ = inval_[iminlat:imaxlat+1, iminlon:imaxlon+1, :]
            area_  = area_[iminlat:imaxlat+1, iminlon:imaxlon+1, :]
            counts_= counts_[iminlat:imaxlat+1,iminlon:imaxlon+1, :]
            
    ## Apply mask if it exists; Assumes mask is 1 or np.nan
    if (mask != None):
        inval_ = inval_*mask_
        area_  = area_*mask_
        isempty = np.where(np.isnan(inval_) == True)
        yempty, xempty = isempty[0], isempty[1]
        counts_[yempty, xempty] = 0
        
    ## Calculate average
    if (len(invalshape) == 2):
        zave = np.zeros(ny)
        zave[:] = np.nansum(inval_,1)/np.nansum(counts_,1)
    elif (len(invalshape) == 3):
        zave = np.zeros((ny,nz))
        for iz in range(0,nz):
            zave[:,iz] = np.nansum(inval_[:,:,iz],1)/np.nansum(counts_[:,:,iz],1)
    
    return zave

##
def testDims(inval, nt):
    '''
    Function for testing dimensions of an time-series array to see if they are GEOS-5 compatible.
    Must specify the array to be tested and the number of times in the timeseries (nt).
    Assumes nt is the last index of the array.
    Returns ny, nx, nz, and tindex (the index of time; the last index of the array).
    '''
    ## Make a copy of input array
    inval_ = inval.copy()

    ## Determine dimensions of input
    invalshape = inval_.shape
    if (len(invalshape) == 1): ## dimensions nt
        n1, tindex = invalshape[0], 0
        nx, ny, nz = 0, 0, 0
        if (n1 != nt):
            print 'testDims: 1-d timeseries dimension should match nt!'
            return None
    elif (len(invalshape) == 2): ## dimensions ny, nt OR nx, nt OR nz, nt
        n1, n2, tindex = invalshape[0],invalshape[1], 1
        if (n2 != nt):
            print 'testDims: 2-d timeseries 2nd dimension should match nt!'
            return None
        if (n1 == 46 or n1 == 91 or n1 == 181 or n1 == 361 or n1 == 721):
            nx, ny, nz = 0, n1, 0
        elif (n1 == 72 or n1 == 144 or n1 == 288 or n1 == 576 or n1 == 1152):
            nx, ny, nz = n1, 0, 0
        elif (n1 == 42 or n1 == 72):
            nx, ny, nz = 0, 0, n1
        else:
            print 'testDims: 2-d timeseries 1st dimension should be valid GEOS-5 nx, ny or nz!'
            return None
    elif (len(invalshape) == 3): ## dimensions ny, nx, nt OR ny, nz, nt OR nx, nz, nt
        n1, n2, n3, tindex = invalshape[0], invalshape[1], invalshape[2], 2
        if (n3 != nt):
            print 'testDims: 3-d timeseries 3rd dimension should match nt!'
            return None
        if (n1 == 46 or n1 == 91 or n1 == 181 or n1 == 361 or n1 == 721):
            ny, nx = n1, 0
        elif (n1 == 72 or n1 == 144 or n1 == 288 or n1 == 576 or n1 == 1152):
            ny, nx = 0, n1
        else:
            print 'testDims: 3-d timeseries 1st dimension should be valid GEOS-5 nx or ny!'
            return None
        
        if (nx == 0 and (n2 == 72 or n2 == 144 or n2 == 288 or n2 == 576 or n2 == 1152)):
            nx, nz = n2, 0
        elif (n2 == 72 or n2 == 42):
            nz = n2
        else:
            print 'testDims: 3-d timeseries 2nd dimension should be valid GEOS-5 nx or nz!'
            return None
    elif (len(invalshape) == 4): ## dimensions ny, nx, nz, nt
        ny, nx, nz, n, tindex = invalshape[0], invalshape[1], invalshape[2], invalshape[3], 3
        print (ny,nx)
        if (n != nt):
            print 'testDims: 4-d timeseries 3rd dimension should match nt!'
            return None
        if ((ny,nx) != (46,72) and (ny,nx) != (91,144) and (ny,nx) != (181,288) and (ny,nx)!= (361,576) and (ny,nx) !=(721,1152)):
            print 'testDims: 4-d timeseries nx, ny not valid GEOS-5 grid'
            return None
        if (nz != 42 and nz != 72):
            print 'testDims: 4-d timeseries nz not a valid GEOS-5 grid'
            return None

    return ny, nx, nz, nt, tindex
##
def fillNans(inval, fill_value=None, cmp_str='ge', physical=False):
    '''
    Replaces data instances where (data cmp_str fill_value) with NaN.
    Replaces data < 0 with NaN if physical set to True.
    '''
    
    ## Make a copy of input
    inval_ = inval.copy()
    
    ## Check if physical
    if (physical == True):
        isphysical = np.where(inval_ < 0)

        if (len(isphysical) == 1):
            inval_[isphysical[0]] = np.nan
        elif (len(isphysical) == 2):
            inval_[isphysical[0],isphysical[1]] = np.nan
        elif (len(isphysical) == 3):
            inval_[isphysical[0],isphysical[1],isphysical[2]] = np.nan
        elif (len(isphysical) == 4):
            inval_[isphysical[0],isphysical[1],isphysical[2],isphysical[3]] = np.nan
        else:
            print 'fillNaNs: Must be 1, 2, 3, or 4-dimensional array'
            return None

    if (fill_value != None):
        if (cmp_str == 'gt'):
            isnan = np.where(inval_ > fill_value)
        elif (cmp_str == 'ge'):
            isnan = np.where(inval_ >= fill_value)
        elif (cmp_str == 'lt'):
            isnan = np.where(inval_ < fill_value)
        elif (cmp_str == 'le'):
            isnan = np.where(inval_ <= fill_value)
        elif (cmp_str == 'eq'):
            isnan = np.where(inval_ == fill_value)
        else:
            print 'fillNaNs: Not a valid compare string.'
            return None

        if (len(isnan) == 1):
            inval_[isnan[0]] = np.nan
        elif (len(isnan) == 2):
            inval_[isnan[0],isnan[1]] = np.nan
        elif (len(isnan) == 3):
            inval_[isnan[0],isnan[1],isnan[2]] = np.nan
        elif (len(isnan) == 4):
            inval_[isnan[0],isnan[1],isnan[2],isnan[3]] = np.nan
        else:
            print 'fillNaNs: Must be 1, 2, 3, or 4-dimensional array'
            return None
            
    return inval_
              
##
def mm2seasonal(inval, nt, m1 = 'JAN'):

    '''
    Makes seasonal and annual means assuming array timseries of monthly data.
    Must specify the input array (1, 2, 3, or 4 dimensional array with last dimension being time).
    Must specify the number of monthly means in the timeseries (nt).
    If the first month in the timeseries is not January, specify m1 to a month other than "JAN".
    Weights the average by the total number of months.
    Capable of handling data that includes NaNs.
    Returns dictionary containing seasonal means, medians, standard deviations, and a list noting the
    number of each of the months going into these statistics.  
    '''
    
    ## Make copies of input
    inval_ = inval.copy()

    ny, nx, nz, n, tindex = testDims(inval, nt)
    print 'mm2seasonal: Time series dimensions are (ny,nx,nz,nt): ', (ny, nx, nz, nt)        
    
    ## Names and abbreviations for months and seasons    
    mname = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV']
    mabb  = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D']
    mnum  = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
    sea   = ['MAM', 'AMJ', 'JJA', 'JAS', 'ASO', 'SON', 'DJF', 'ANN']
    seam  = [(3,4,5), (4,5,6), (6,7,8), (7,8,9), (8,9,10), (9,10,11), (12,1,2), (1,2,3,4,5,6,7,8,9,10,11,12)]
    
    ## In case first month given as an interger, make it a string as in mnum
    if (type(m1) == int):
        if (m1 < 10):
            m1 = '0'+str(m1)
        else:
            m1 = str(m1)

    ## Find index of first month based on if it's a string of numbers or a month
    if (mname.count(m1) > 0):
        m1index = mname.index(m1)
    elif (mnum.count(m1) > 0):
        m1index = mnum.index(m1)
    elif (mnum.count(m1).swapcase() > 0):
        m1index = mnum.index(m1)
    print 'mm2seasonal:  First month is: ', mname[m1index]
    
    ## Make an array starting on first month and going to end of timeseries
    monthlist = np.zeros(nt)
    for it in range(0, nt):
        if (m1index > len(mnum) - 1):
            m1index = 0
        monthlist[it] = str(mnum[m1index])
        m1index += 1

    seasonal = {} # we're going to output seasonal averages as a dictionary
    for isea in range(0, len(sea)): ## All but annual mean

        print 'mm2seasonal: Averaging: ', sea[isea]

        if isea != len(sea) - 1:
            ## Indices of the months in the season
            indexm1 = np.where(monthlist == seam[isea][0])[0]
            indexm2 = np.where(monthlist == seam[isea][1])[0]
            indexm3 = np.where(monthlist == seam[isea][2])[0]
            nm1, nm2, nm3 = len(indexm1), len(indexm2), len(indexm3)
            nmth         = (nm1,nm2,nm3)
            monthindices = (indexm1, indexm2, indexm3)
        else:
            monthindices = list()
            nmth         = list()
            for im in range(1,13):
                monthindices.append(np.where(monthlist == im)[0])
                nmth.append(len(monthindices[im-1]))

        ## Calculate the denominator
        ntot = 0
        for nm in nmth:
            ntot = ntot + nm
            
        ## Only make a seasonal average if all 3 months available
        if (isea != len(sea) - 1 and (nm1 == 0 or nm2 == 0 or nm3 == 0)):
            print 'mm2seasonal: Cannot compose seasonal average for '+sea[isea]
        elif (isea == len(sea) - 1 and ntot < 12):
            print 'mm2seasonal: Cannot calculate annual average without at least 1 full year!'
        else:
            for im, mindex in enumerate(monthindices):
                ## Make sure to account for NaNs in making the monthly average.
                ## Method 1
                ## mavg    = np.squeeze(np.nansum(inval_[mindex], axis=tindex)/np.sum(~np.isnan(inval_[mindex]),axis=tindex))
                ## Method 2
                ## numnans = np.isnan(inval_[mindex])
                ## invalm  = np.ma.masked_array(inval_[mindex],np.isnan(inval_[mindex]))
                ## mavg2   = np.mean(invalm,axis=tindex)
                ## if (len(inval_[mindex][numnans]) != 0):
                ##    mavg3   = mavg2.filled(np.nan)
                ## else:
                ##    mavg3 = mavg2.copy()
                ## Method 3
                if (tindex == 0): ## 1-d
                    inval__ = inval_[mindex]
                elif (tindex == 1): ## 2-d
                    inval__ = inval_[:,mindex]
                elif (tindex == 2): ## 3-d
                    inval__ = inval_[:,:,mindex]
                elif (tindex == 3): ## 4-d
                    inval__ = inval_[:,:,:,mindex]
                ## Monthly mean average    
                mavg = np.array(stats.nanmean(inval__,axis=tindex))
                if (im == 0):
                    seavg = nmth[im]*mavg.copy()## Weight by the number of months
                    seas  = inval__.copy()
                else:
                    seavg = seavg + nmth[im]*mavg
                    np.append(seas, inval__.copy(), axis=tindex)
                    
            ## Calculate seasonal average and other statistics; put in a dictionary
            seasonal[sea[isea]] = {'Nmth':nmth,'Mean':seavg/ntot, 'Median':stats.nanmedian(seas,axis=tindex),'Std':stats.nanstd(seas,axis=tindex)}

    return seasonal
       
    

  
            
            
            
                

    
