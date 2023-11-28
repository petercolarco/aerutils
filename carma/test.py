from geos5 import *
from utilities import *
import os

path = '/discover/nobackup/projects/gmao/iesa/aerosol/Experiments/'
expid = 'dR_MERRA-AA-r2'
coll  = 'inst2d_hwl_x'
ddf   = coll+'_monthly.ddf'
ddfpath = '/home/crandles/'

#g5 = GEOS5(expid, path=path, coll=coll, numfiles=10)
#g5.makeDDF('monthly', 2003, template=True, ddfpath='/home/crandles/')

ssa = GEOS5V(expid, 'totexttau', expr='(totscatau)/totexttau', expr_name='ssa', ddf=ddf, ddfpath=path+expid+'/')


