import os
import grads
import numpy as np
import matplotlib.pyplot as plt
from utilities import *
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import addcyclic


def getBasemap(proj='mill', res='c', lllon=-180, lllat=-90, urlon=180, urlat=90,
               suppressTicks=True):
    '''
    proj: see Basemap documentation.  Miller Cylindric default
    res: c (crude), l (low), i (intermediate), h (high), f (full) boundaries
    lllon,lllat,urlon,urlat: lower-left lon and lat, upper right lon and lat
    suppress_ticks: suppress automatic drawing of axis ticks and labels
    '''

    m = Basemap(projection=proj, resolution=res,
                llcrnrlon=lllon, llcrnrlat=lllat, urcrnrlon=urlon, urcrnrlat=urlat,
                suppress_ticks=suppressTicks)
    return m


def con(Field, X, Y, proj='mill', res='c',
        Title='', Xlabel='', Ylabel='',
        lllon=-180, lllat=-90, urlon=180,urlat=90, lon0=0, lat0=0,
        Coast=True, Countries=False, Rivers=False, States=False,
        FillContinent=False, LandColor='brown', WaterColor='blue', Clinewidth=1, Flinewidth=1,
        Grid=False,GridStyle=('E/W','N/S'),Paral=np.arange(-90.,91,30),Merid=np.arange(-180.,181.,60.),
        Nofill=False, Nolines=False,
        Autolevs=False, Nocolbar=False,
        Nolinelabels=False, Noaxes=False, 
        Block=False, Left_title=None, Right_title=None, Style=None,
        Positive_style=None, Negative_style=None, Zero_style=None,
        Positive_thick=None, Negative_thick=None, Zero_thick=None,
        Positive_col=None, Negative_col=None, Zero_col=None,
        Nomap=None, Cb_left=None, Cb_right=None, Cb_under=None,
        Cb_alt=None, Cb_width=None, Cb_height=None, Cb_title=None,
        Cb_nvals=None, Cb_nth=None, Cb_nolines=None, Cb_labels=None,
        Cb_vtext=None, Spacing=1, Orientation=None, Orig=None, Cfill=None,
        Img=None, Qp=None, Tol=None, Mask=None):

    '''
    Field: 2-dimensional field (lat, lon) with X=lon and Y=lat
    
    proj: map projection; see Basemap documentation
    
    lon0, lat0: center of plot
    Coast, Countries, Rivers, States draws each of these
    FillContinents with LandColor and WaterColor
    GridStyle: list ('E/W', 'N/S') default.  Can also be ('+/-', '+/-')
    '''

    ## Figure, axes instance
    fig = plt.figure()
    ax  = fig.add_axes()
    
    ## Get Basemap instance
    m = getBasemap()

    ## Add cyclic dimension
    Field, X = addcyclic(Field, X)

    ## Compute map projection coordinates for lat/lon grid
    x, y = m(*np.meshgrid(X,Y))

    ## Make filled or unfilled contour plot
    if (not Nofill):
        cs = m.contourf(x,y,Field)
    elif (Nofill):
        cs = m.contour(x,y,Field)

    ## Draw coastlines
    if (Coast):
        m.drawcoastlines(linewidth=Clinewidth)

    ## Draw countries
    if (Countries):
        m.drawcountries(linewidth=Clinewidth)

    ## Draw rivers
    if (Rivers):
        m.drawrivers(linewidth=Flinewidth)

    ## Draw states
    if (States):
        m.drawstates(linewidth=Clinewidth)

    ## Fill continents
    if (FillContinent):
        m.fillcontinents(color='brown',lake_color='blue')
    
    ## Draw line around map region
    m.drawmapboundary()

    ## Draw parallels
    if (Grid):
        ## Labels [left,right,top,bottom]
        m.drawparallels(Paral, labels=[1,0,0,0], labelstyle=GridStyle[1])
        m.drawmeridians(Merid, labels=[0,0,0,1], labelstyle=GridStyle[0])

    ## Plot title
    plt.title(Title)

    ## Draw colorbar
    #if (not Nocolbar):
    #    cbar = m.colorbar(cs, location='bottom', pad="5%")
    #    cbar.set_label('mm')
        
    ## Show plot
    plt.show()
