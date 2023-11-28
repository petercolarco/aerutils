### CAR 4/11/13
### GEOS-5 Data Class
import numpy as np
import scipy.stats as stats
import grads
import os
from utilities import *


### Error objects for GEOS5 objects
class Error(Exception):
    """Base class for exceptions in this module."""
    pass

class InputError(Error):
    """Exception raised for errors in the input.

    Attributes:
        expr -- input expression in which the error occurred
        msg  -- explanation of the error
    """

    def __init__(self, expr, msg):
        self.expr = expr
        self.msg  = msg

class TransitionError(Error):
    """Raised when an operation attempts a state transition that's not
    allowed.

    Attributes:
        prev -- state at beginning of transition
        next -- attempted new state
        msg  -- explanation of why the specific transition is not allowed
    """

    def __init__(self, prev, next, msg):
        self.prev = prev
        self.next = next
        self.msg = msg
        
### GEOS5 object superclass      
class GEOS5(object):

    def __init__(self, expid, path=None, coll=None, numfiles=None, ddf=None, ddfpath=None,
                 ftype=None):
        '''
        Initialize class with (required) expid.
        Three choices for instantiating object:
        (1) Provide path, collection and numfiles followed by makeDDF() and gagetVar().
        (2) Provide a DDF file (ddf) (and possibly ddfpath; default path is current directory).
        (3) Provide a netCDF file (ddf) (and possibley path as ddfpath; default is current directory)
        Will determine filetype ('xdf', 'sdf', or 'ctl') based on file extension if ftype keyword not set.
        Ftype is determined by file extension (or http if OpenDap). Can also be set with keyword.
        Assumes nc4, hdf open with 'sdf'; ddf, ctl, and tabl open with 'xdf', others with 'ctl' or "open".
        Note: If grads control file (ddf) needs to use "open" command set ftype  = 'ctl'
        '''

        ## Mandatory set now
        self.expid    = expid
    
        ## Set file type based on keyword or file extension
        self.ftype = ftype
        if (ddf != None and ftype == None):
            ## Determine last "dot" in ddf string
            try:
                index = ddf.rfind('.')
            except:
                raise InputError('ddf.rfind(".")', 'Unable to determine ftype')
            
            typestr = ddf[index+1:]
            if (typestr == 'nc4' or typestr == 'nc' or typestr == 'hdf'):
                self.ftype = 'sdf'
            elif (typestr == 'ddf' or typestr == 'tabl' or typestr == 'ctl'):
                self.ftype = 'xdf'
            #### Check first four characters if dods
            elif (ddf[0:4] == 'http'):
                self.ftype = 'dods'
            else:
                print 'GEOS5: Trouble determining file type. Setting ftype to "ctl" or "open" command'
                self.ftype = 'ctl'
       
        ## Perhaps set now
        if (ddf == None):
            print 'GEOS5: Use makeDDF() to set the ddf file if opening with GrADS'
            self.ddf      = None
            ## If no ddf specified must provide path, coll, and numFiles
            if (path == None or coll == None or numfiles == None):
                raise InputError('path=None or coll==None or numfiles==None',
                                 'Without a specified DDF, path, coll and numfiles must be specified')
            ## Set path information
            else:
                self.coll     = coll
                self.fullpath = path+expid+'/'+coll+'/'
                self.nt       = numfiles
        ## Set ddf to given value.  Assumes current path if ddfpath not set
        elif (ddf != None):
            if (ddfpath != None and self.getFtype() != 'dods'):
                self.ddf = ddfpath+ddf
            elif (ddfpath == None and self.getFtype() != 'dods'):
                self.ddf = os.path.curdir+'/'+ddf
            elif (self.getFtype() == 'dods'):
                self.ddf = ddf
                
            if (self.testDDF() and self.getFtype() == 'xdf'):
                print 'GEOS5: Default ddf set to: '+self.getDDF()+'. ddf file works!!!'
                self.coll, self.fullpath, self.nt = None, None, None # Not needed
            elif (self.getFtype() == 'sdf' or self.getFtype() == 'dods'):
                print 'GEOS5: File set to: '+self.getDDF()
                self.coll, self.fullpath, self.nt = None, None, None # Not needed
            else:
                raise TransitionError(None, self.getDDF(),
                                      'Specified ddf file('+self.getDDF()+') fails. ddf defaults to None')
        
    def getExpid(self):
        ''' Returns expid'''
        return self.expid

    def getPath(self):
        ''' Returns path to experiment directory'''
        return self.fullpath

    def getColl(self):
        ''' Returns collection'''
        return self.coll

    def getFtype(self):
        ''' Returns ftype'''
        return self.ftype

    def getNt(self):
        ''' Returns number of files/time steps'''
        return self.nt

    def getDDF(self):
        ''' Returns ddf.  Initially defaults to None'''
        return self.ddf
    
    def collExist(self):
        '''
        Returns true if full path to collection directory exists.
        OR returns true if ddf exists and works.
        '''
        if (self.getDDF() != None and self.testDDF()):
            return True
        else:
            return os.path.exists(self.fullpath)

    def testDDF(self):
        '''
        Uses grads to see if we can open the ddf file.
        Returns True if we can, False otherwise.
        '''
        ga = grads.GrADS(Window=False, Echo=False)
        try:
            ga.open(self.getDDF(), ftype='xdf', Quiet=True)
            ga('close 1')
            return True
        except:
            return False

    def makeDDF(self, frequency, yr, mo='jan', dy='01', hr='00:00', nts=None, tymefreq=1,
                sea=None, clim=False, template=True, ddf=None, ddfpath=None, resetDDF=False,
                diurnalpath=True):
        '''
        Checks for existence of a ddf file.  If one exists, sets as default self.ddf
        Oterwise, creates and writes one. Also rewrites if resetDDF == True.
        
        Alternatively, ddf can be specified (assumed to be in self.fullpath
        unless ddfpath specified). This is automatically done when GEOS5V is initiated.

        Assumes each file is one time step unles nts != None; then numfiles*nts is
        total time steps. Numfiles carried in self.nt attribute.
        
        Frequency can be 'monthly', 'daily' or 'diurnal'.
        Files can be single instances or clim averages if clim == True.
        Files can be seasonal averages from monthly or daily data if
        sea = MAM, AMJ, JJA, JAS, ASO, SON, DJF, or ANN.

        yr specifies the first year, mo specifies the first month,
        dy specifies the first day, hr specifies first hour.
        tymefreq specifies the frequency of the monthly, daily, dirural, etc. files (e.g. 3hr or 6hr).
        Default is 1
        If template == True, assumes files are in Y%y4/M%m4 directories under fullpath.
        '''
        ## Set the frequency attribute
        self.frequency = frequency
        
        ## Set number of files/timesteps
        if (self.getNt() != None and nts == None):
            pass ## Will assume one time-step per file
        elif (self.getNt() != None and nts != None):
            self.nt = self.getNt()*nts  # total time steps = numfiles * ntimes/file
            self.t2 = self.getNt()
        elif (self.getNt() == None and nts == None):
            self.nt = 1 ## assume there is only one file
        nt = self.getNt()
            
        ## If a default DDF already exists and works, don't do anything
        if (self.getDDF() != None and self.testDDF() and (not resetDDF)):
            print 'makdDDF: Default ddf is already specified and works!!!'
            return None
        
        ## If ddf is specified, check to make sure it exists and set as default
        if (ddf != None or (ddf != None and resetDDF)):
            if (ddfpath != None):
                ddf = ddfpath+ddf ## ddf in specified ddfpath
            else:
                ddf = os.path.curdir+'/'+ddf # ddf in current directory
                
            if (os.path.exists(ddf)):
                ## Make sure ddf file exists and set ddf attribute
                print 'makeDDF: Setting default ddf file to specified ddf. Setting ftype to "xdf".'
                self.ddf = ddf
                self.ftype = 'xdf'
            else:
                raise InputError('os.path.exists(ddf)', 'Specified ddf file does not exist in ddfpath or fullpath')
                
        ## Otherwise, let's make one
        elif (ddf == None or (ddf == None and resetDDF)):

            ## Make sure this collection exists in the given path! Raise an error if it does not.
            if (not self.collExist()):
                raise InputError('not self.collExist()', 'Collection does not exist in fullpath')
        
            ## If the frequency is seasonally set to proper value
            if (sea == None):
                seastr = ''
                mostr  = mo ## Starting Month (specified on call; default 'jan')
            elif (sea == 'MAM' or sea == 'AMJ' or sea == 'JJA' or sea == 'JAS' or
                  sea == 'ASO' or sea == 'SON' or sea == 'DJF' or sea == 'ANN'):
                seastr = sea+'.'
                if (sea == 'MAM'): mostr = 'mar'
                if (sea == 'AMJ'): mostr = 'apr'
                if (sea == 'JJA'): mostr = 'jun'
                if (sea == 'JAS'): mostr = 'jul'
                if (sea == 'ASO'): mostr = 'aug'
                if (sea == 'SON'): mostr = 'sep'
                if (sea == 'DJF'): mostr = 'dec'
                if (sea == 'ANN'): mostr = 'jan'
            else:
                raise InputError('sea != None', 'Specified season is not a valid season.')
            
            ## If frequency is clim set climstr to proper value
            if (clim == False):
                climstr = ''
                climnme = ''
            elif (clim == True):
                if (sea == None):
                    if (frequency == 'monthly' or frequency == 'diurnal'):
                        climstr = 'clim.M%m2.'
                        climnme = 'clim.'
                    elif (frequency == 'daily'):
                        climstr = 'clim.M%m2%d2.'
                        climnme = 'clim.'
                elif (sea != None):
                    climstr = 'clim.'
                    climnme = 'clim.'

            ## Set time template string if not clim or seasonal
            if (frequency == 'monthly' or frequency == 'daily' or frequency == 'diurnal' or frequency == 'daily'):
                if (frequency == 'monthly'): 
                    timestr, timestpstr    = '%y4%m2.', str(tymefreq)+'mo'
                elif (frequency == 'diurnal'):
                    timestr, timestpstr    = '%y4%m2.', str(tymefreq)+'hr'
                elif (frequency == 'daily'):
                    timestr, timestpstr = '%y4%m2%d2.', str(tymefreq)+'dy'
                elif (frequency == 'hourly'):
                    if (hr[2:] == ':00'):
                        mins = '00'
                    elif (hr[2:]==':30'):
                        mins = '30'
                    timestr, timestpstr = '%y4%m2%d2_%h2'+mins+'z.', str(tymefreq)+'hr'
                if (clim != False or sea != None):
                    timestr=''
            else:
                raise InputError('frequency != monthly, diurnal, daily, or hourly', 'Not a valid frequency.')
           
            ## Is data in templated format (Y%y4/M%m2)?
            if (template == False):
                templatestr = ''
            else:
                if (sea == None):
                    templatestr = '/Y%y4/M%m2/'
                elif (sea != None):
                    templatestr = '/Y%y4/'
                
            ## If no descriptor file is not specified, make one in full path
            if (ddfpath == None):
                print 'makeDDF: No ddfpath provided.  Defaulting to '+os.path.curdir+'/'
                ddf = os.path.curdir+'/'+self.getColl()+'.'+frequency+'.'+climnme+seastr+'ddf'
            elif (ddfpath != None):
                ddf  = ddfpath+self.getColl()+'.'+frequency+'.'+climnme+seastr+'ddf'
            
            ## Check if this ddf already exists.  Make file if it doesn't exist (or if we want to reset it).
            if (not os.path.exists(ddf) or resetDDF):
                
                ## First line of ddf file
                if (diurnalpath == True and frequency == 'diurnal'):
                    dset = 'DSET '+self.getPath()+'/diurnal/'+templatestr
                else:
                    dset = 'DSET '+self.getPath()+templatestr
                filestr = self.getExpid()+'.'+self.getColl()+'.'+frequency+'.'+timestr+climstr+seastr+'nc4\n'
                dset = dset+filestr
                ## Second line
                opt = 'OPTIONS template\n'
                ## Third line
                tdef = 'TDEF time %i LINEAR %sZ%s%s%s %s' % (nt, str(hr), str(dy), mostr, str(yr), str(timestpstr))

                print '-----------------'
                print 'Writing DDF file: ', ddf
                print dset, opt, tdef
                print '-----------------'
                    
                ## Write the file
                try:
                    f = open(ddf, 'w')
                    try:
                        f.writelines((dset,opt,tdef))
                    except:
                        raise InputError(ddf, 'Error writing file!!!')
                    finally:
                        f.close()
                except IOError:
                    raise InputError(ddf, 'Error opening file to write!!!')

                ## Verify that ddf was created. Set this to the default ddf.
                if (os.path.exists(ddf)):
                    self.ddf = ddf
                    if (self.testDDF()):
                        print 'makeDDF: SUCCESSFULLY CREATED WORKING DDF FILE: ', ddf
                        return None
                    else:
                        print 'makeDDF: DDF FILE CREATED BUT DOES NOT WORK!!!'
                        return None
                else:
                    print 'makeDDF: DID NOT CREATE DDF FILE: ', ddf
                    return None

            ## If the ddf already exists, set as the default
            else:
                print 'makeDDF: DDF FILE EXISTS. SETTING AS DEFAULT:', ddf
                self.ddf = ddf

## GEOS5 variable subclass
class GEOS5V(GEOS5):
    '''
    Initialize class with (required) expid and variable name (var).
    If performing a valid grads expression, expression is given in expr along with a name for expressions;
    var must be set to one of variables in the expression.
    
    Three choices for instantiating object:
    (1) Provide path, collection and numfiles followed by makeDDF() and gagetVar().
    (2) Provide a DDF file (ddf) (and possibly ddfpath; default path is current directory).
    (3) Provide a netCDF file (ddf) (and possibley path as ddfpath; default is current directory),
    Ftype is determined by file extension (or http if OpenDap). Can also be set with keyword.
    Assumes nc4, hdf open with 'sdf'; ddf, ctl, and tabl open with 'xdf', others with 'ctl' or "open".
    Note: If grads control file (ddf) needs to use "open" command set ftype  = 'ctl'

    Assumes you will use GrADS (not GFIO) to open unless grads is set to False.

    ts tuple specifies initial and final time. If final time is None assumes self.getNt()
    '''
    ### Initialization
    def __init__(self, expid, var, expr=None, expr_name=None,
                 path=None, coll=None, numfiles=None, ddf=None, ddfpath=None, ts = (1, None),
                 ftype=None, grads=True):

        ## Initialize as a GEOS5 parent object
        ## Parent initializes either ddf (and maybe ddfpath) OR
        ## Path, collection and numfiles (must then call makeDDF) OR single file
        GEOS5.__init__(self, expid, path=path, coll=coll, numfiles=numfiles, ddf=ddf, ddfpath=ddfpath, ftype=ftype)

        ## Set the var.  This is either a single variable you are retrieving or one of the vars in expr
        self.var = var
        if (ts == (1, None)):
            if (self.getNt() != None):
                self.t1, self.t2 = 1, self.getNt()
            else:
                self.t1, self.t2 = 1, None ## Will determine with file
        elif (ts != (1, None)):
            self.t1, self.t2 = ts[0], ts[1]
            self.nt = (self.t2 - self.t1) + 1
        else:
            print 'GEOS5V: Using default time parameters: t = 1, '+str(self.getNt())
        
        ## Set attributes if they exist; make sure we have proper input
        if (expr == None):
            self.expr, self.expr_name = None, None
        if (expr != None):
            if (expr_name == None):
                raise InputError('expr_name == None','Must provide a name for the expression!')
            else:
                self.expr, self.expr_name = expr, expr_name

        ## Initialize attributes to None; set eventually in gagetVar()
        self.area, self.res                = None, None ## Set with grid_area inside gagetVar()
        self.time, self.tyme               = None, None ## Set with gagetVar
        self.lon, self.lat, self.lev       = None, None, None ## Dimensions
        self.nx, self.ny, self.nz          = None, None, None ## Length of dimensions
        self.dx, self.dy                   = None, None ## Grid spacing in horizontal
        self.datatype, self.data           = None, None ## grads, gfio, numpy; actual data
        self.ndims,    self.shape          = None, None ## Total number of dimensions and shape
        self.fill_value                    = None ## Empty value
        self.gavg, self.zavg               = None, None ## Global and zonal averages (set with makeGlobalAvg() and makeZonalAvg())
        self.savg, self.gsavg, self.zsavg  = None, None, None ## Seasonal Averages
        ## If using grads (set with gagetVar)
        self.gradsobj, self.gradsmask, self.gradsinfo, self.gradstats  = None, None, None, None
            
        ## Go ahead and open if ddf file is already specified and works (and we want to use grads)
        ## Also open if it's a single netCDF file and we want to use grads
        if ((self.getDDF() != None and self.testDDF() and grads) or
            (self.getPath() != None and self.getFtype() == 'sdf' and grads)):
            self.gagetVar()
        else:
            if (self.getFtype() == 'sdf' or self.getFtype() == 'dods'):
                print 'GEOS5V: Must call gagetVar() to proceed.'
            else:
                print 'GEOS5V: Must call makeDDF() and gagetVar() to proceed.'
            

    ### Functions to return attributes    
    def getVar(self):
        '''Returns variable or expression  name if it exists'''
        if (self.expr_name == None):
            return self.var
        elif (self.expr_name != None):
            return self.expr_name

    def getExpr(self):
        '''Returns grads expression to evaluate'''
        return self.expr

    def getExprName(self):
        '''Returns the name fo the grads expression being evaluated'''
        return self.expr_name
    
    def getData(self):
        ''' Returns numpy array of data'''
        return self.data
    
    def getType(self):
        '''Returns None, grads, gfio, or numpy'''
        return self.datatype

    def getFill(self):
        ''' Returns fill value that should be replaced by NaN'''
        return self.fill_value
    
    def getT1(self):
        ''' Returns first time'''
        return self.t1

    def getT2(self):
        ''' Returns final time'''
        return self.t2

    def getTime(self):
        '''Returns time stamps'''
        return self.time

    def getTyme(self):
        '''Returns grads datetyme object list'''
        return self.tyme
    
    def getRes(self):
        '''Returns GEOS5 resolution'''
        return self.res

    def getNdims(self):
        '''Returns number of dims'''
        return self.ndims

    def getShape(self):
        '''Returns shape of data'''
        return self.shape

    def getDims(self):
        ''' Returns dimensions as a tuple '''
        return (self.ny, self.nx, self.nz)

    def getGrid(self):
        ''' Returns dx and dy grid spacing as a tuple'''
        return (self.dy, self.dx)

    def getNz(self):
        ''' Returns nz '''
        return self.nz

    def getNx(self):
        ''' Returns nx '''
        return self.nx

    def getNy(self):
        ''' Returns ny '''
        return self.ny

    def getDx(self):
        ''' Returns dx '''
        return self.dx

    def getDy(self):
        ''' Returns dy '''
        return self.dy

    def getArea(self):
        ''' Returns global grid_box area as a numpy array'''
        return self.area
    
    def getYXZ(self):
        ''' Returns lat, lon, lev as a tuple'''
        return (self.lat, self.lon, self.lev)

    def getLat(self):
        ''' Returns latitude'''
        return self.lat

    def getLon(self):
        ''' Returns longitude'''
        return self.lon

    def getLev(self):
        ''' Returns levels'''
        return self.lev

    ### Averaging functions
    def makeSeasonalAvg(self):
        '''
        Returns the seasonal average assuming a monthly-mean timeseries.
        '''
        print 'makeSeasonalAvg: WARNING:  Data must be monthly-mean data!'
        self.savg = mm2seasonal(self.getData(), self.getNt(), m1=self.getTyme()[0].month)
        if (self.getGlobalAvg() != None):
            self.gsavg = mm2seasonal(self.gavg, self.getNt(), m1=self.getTyme()[0].month)
            print 'makeSeasonalAvg: Call getGlobal getGlobalSeasonalAvg for seasonal averages.'
        if (self.getZonalAvg() != None):
            self.zsavg = mm2seasonal(self.getZonalAvg(), self.getNt(), m1=self.getTyme()[0].month)
            print 'makeSeasonalAvg: Call getZonalSeasonalAvg for seasonal averages.'

        
    def getSeasonalAvg(self):
        ''' Returns seasonal average from monthly mean data'''
        return self.savg
    
    def makeGlobalAvg(self, cmpstr='ge', physical=False):
        '''
        Returns global average; uses aave
        Global average is a list.
        If variable is a function of t, length is nt
        If variable is function of z, length of each list element is list of length nz.
        '''
        if (self.getData() != None and self.getNt() <= 1 and self.getNz() <=1):
            ## One time, One value
            gavg = np.zeros(1)
            gavg[:] = aave(self.getData(), self.getFill(), compare_str = cmpstr, physical=physical)
            self.gavg = gavg
        elif (self.getData() != None and self.getNt() <= 1 and self.getNz() > 1):
            ## One time, multiple levels (nz)
            gavg = np.zeros(self.getNz())
            gavg[:] = aave(self.getData(), self.getFill(), compare_str = cmpstr, physical=physical)
            self.gavg = gavg
        elif (self.getData() != None and self.getNt() > 1 and self.getNz() <= 1):
            ## One level, multiple times (nt)
            gavg = np.zeros(self.getNt())
            for it in range(0,self.getNt()):
                gavg[it] = aave(self.getData()[:,:,it], self.getFill(), compare_str = cmpstr, physical=physical)
            self.gavg = gavg
        elif (self.getData() != None and self.getNt() > 1 and self.getNz() > 1):
            ## Multiple levels, multiple times (nz, nt)
            gavg = np.zeros((self.getNz(), self.getNt()))
            for it in range(0,self.getNt()):
                gavg[:,it] = aave(self.getData()[:,:,:,it], self.getFill(), compare_str = cmpstr, physical=physical)
            self.gavg = gavg
        else:
            print 'makeGlobalAvg: Failed to make global average.'
            self.gavg = None
        print 'makeGlobalAvg: Successfully computed global average.'
        
            
    def getGlobalAvg(self):
        ''' Returns global area-average'''
        return self.gavg

    def getGlobalSeasonalAvg(self):
        ''' Returns global seasonal area-averages'''
        return self.gsavg
    
    def makeZonalAvg(self, cmpstr='ge', physical=False):
        '''
        Returns zonal average; uses zonalavg in utilities
        Returns array of size (ny), (ny, nz), (ny, nt), or (ny, nz, nt) depending on input.
        Assumes, unless specified, that values in which data is >= self.fill_value are Nan
        Can change this specification by changing cmpstr to 'lt', 'le', 'eq', or 'gt'.
        '''
        if (self.getData() != None and self.getNt() <= 1 and self.getNz() <=1):
            ## One time, One level (ny)
            zavg = np.zeros(self.getDims()[0])
            zavg[:] = zonalavg(self.getData(), self.getFill(), compare_str = cmpstr, physical=physical)
            self.zavg = zavg
        elif (self.getData() != None and self.getNt() <= 1 and self.getNz() > 1):
            ## One time, multiple levels (ny, nz)
            zavg = np.zeros((self.getDims()[0], self.getNz()))
            zavg[:,:] = zonalavg(self.getData(), self.getFill(), compare_str = cmpstr, physical=physical)
            self.zavg = zavg
        elif (self.getData() != None and self.getNt() > 1 and self.getNz() <= 1):
            ## One level, multiple times (ny, nt)
            zavg = np.zeros((self.getDims()[0], self.getNt()))
            for it in range(0,self.getNt()):
                zavg[:,it] = zonalavg(self.getData()[:,:,it], self.getFill(), compare_str = cmpstr, physical=physical)
            self.zavg = zavg
        elif (self.getData() != None and self.getNt() > 1 and self.getNz() > 1):
            ## Multiple levels, multiple times (ny, nz, nt)
            zavg = np.zeros((self.getDims()[0], self.getNz(), self.getNt()))
            for it in range(0,self.getNt()):
                zavg[:,:,it] = zonalavg(self.getData()[:,:,:,it], self.getFill(), compare_str = cmpstr, physical=physical)
            self.zavg = zavg
        else:
            print 'Failed to make zonal average'
            self.zavg = None
        print 'makeZonalAvg: Successfully computed zonal average.'
        
    def getZonalAvg(self):
        ''' Returns zonal average'''
        return self.zavg

    def getZonalSeasonalAvg(self):
        ''' Returns zonal seasonal average'''
        return self.zsavg
    
    ### Functions to manipulate data
    def fillData(self, cmp_str='ge', physical=False):
        '''
        Uses utility fillNans to get rid of missing and unphysical data.
        Resets data attribut with new data filled with NaNs
        '''
        self.data = fillNans(self.getData(), fill_value=self.getFill(), cmp_str=cmp_str, physical=physical)
        if physical == True:
            print 'fillData: Replaced missing AND unphysical data with NaN.'
        else:
            print 'fillData: Replaced missing data with NaN'
            
    ### Functions if  you're using grads
    def gagetVar(self):
        '''
        Opens single file, OpenDap, or grads template file.
        Tests to see if var is in file.
        Returns grads variable field if it is, Error otherwise.
        Sets the following attributes: area, res, lat, lon, lev, nx, ny, nz, nt, dx, dy
                                       datatype, data, ndims, shape, fill_value
        Sets grads object attributes: gradsobj, gradsmask, gradsinfo, gradstats
        '''
        ## DDF file successfully opens
        if (self.testDDF() or self.getPath != None or self.getFtype() == 'dods'):

            ## If calling for first time and actually making a ddf file
            if (self.getFtype() == None and self.getPath != None):
                self.ftype = 'xdf'
                
            ## Initialize GrADS object
            if (self.getFtype() == 'dods'):
                ga = grads.GaNum(Bin='gradsdap', Echo=False, Window=False)
            else: 
                ga = grads.GrADS(Window=False, Echo=False)

            ## Open the file    
            if (self.getFtype() == 'xdf'):
                ga.open(self.getDDF(), ftype=self.getFtype(), Quiet=True)
            elif (self.getFtype() == 'dods'):
                try:
                    ga.open(self.getDDF(), ftype='sdf', Quiet=True)
                except:
                    raise InputError('ga.open()', 'Failed to open with :'+self.getFtype())
            else:
                ## If a single file to open with sdfopen
                try:
                    ga.open(self.getDDF(), ftype=self.getFtype(), Quiet=True)
                except:
                    raise InputError('ga.open()', 'Failed to open with :'+self.getFtype())
            
            ga('set lon -180 180') ## Africa centric

            ## Query file
            qh = ga.query('file', Quiet=True)
            try:
                ## Get the index of the variable
                iv = qh.vars.index(self.getVar())
            except ValueError:
                ## Check if it's in a different case
                try:
                    iv = qh.vars.index(self.getVar().swapcase())
                except ValueError:
                    raise InputError('gagetVar: qh.vars.index(self.getVar())',
                                      self.getVar()+' and/or '+self.getVar().swapcase()+'not in file')

            ## Query file succeeded. Now can get nz and determine if two- or three-dimensional
            if qh.var_levs[iv] == 0:
                self.nz     = 1
                twoD, fourD = True, False
            else:
                self.nz = qh.var_levs[iv]
                twoD, fourD = False, False
         
            ## Set other attributes based on query if not already set with makeDDF()
            if (self.getNt() == None):
                if (self.getT2() == None):
                    self.nt = qh.nt
                    self.t2 = self.getNt()
                else:
                    self.nt = (self.getT2()-self.getT1())+1
            if (self.getNx() == None):
                self.nx = qh.nx
            if (self.getNy() == None):
                self.ny = qh.ny
           
            #### Grads only will handle up to 3 varying dimensions!!!#######
            ########## 2-dimensional case with t potentially varying########
            if (twoD): # Only vary lon, lat and potentially t
                ## Set time
                ga('set  t  %i %i' % (self.getT1(), self.getT2()))
                try:
                    if (self.getExpr() == None):
                        v = ga.expr(self.getVar()) ## Get the variable
                    elif (self.getExpr() != None):
                        v = ga.expr(self.getExpr()) ## Get the expression
                except:
                    try:
                        if (self.getExpr() == None):
                            v = ga.expr(self.getVar().swapcase()) ## Try swapping cases 
                        elif (self.getExpr() != None):
                            v = ga.expr(self.getExpr().swapcase())
                    except:
                        raise InputError('gagetVar: ga.expr(self.getVar())',
                                          self.getVar()+' and/or '+self.getVar().swapcase()+'not in file')
                finally:
                    ga('close 1') ## Close the file
    
            ############### 3-dimensional case with no time variance##########
            elif (not twoD and self.getNt() == 1): # Vary lon, lat, lev
                ga('set  t  %i %i' % (self.getT1(), self.getT2()))
                ga('set z 1 %i' % self.getNz())
                try:
                     if (self.getExpr() == None):
                         v = ga.expr(self.getVar())
                     elif (self.getExpr() != None):
                         v = ga.expr(self.getExpr())
                except:
                    try:
                        if (self.getExpr() == None):
                            v = ga.expr(self.getVar().swapcase()) ## Try swapping the case if problem
                        elif (self.getExpr() != None):
                            v = ga.expr(self.getExpr().swapcase())
                    except:
                        raise InputError('gagetVar: ga.expr(self.getVar())',
                                         self.getVar()+' and/or '+self.getVar().swapcase()+'not in file')
                finally:
                    ga('close 1') ## Close the file

            ######## 3-dimensional case with time varying (4-d variable) ##########
            elif (not twoD and self.getNt() > 1): # Vary lon, lat, lev, THEN t
            
                fourD = True ## Set 4-d to True
                    
                ## Set up attribute dictionaries and lists looped over time; done later for other cases
                self.gradsinfo = {'ndim':None, 'time':list(), 'tyme':list(),
                                   'lat':None, 'lon':None, 'lev':None}
                self.gradstats = {'mean':list(), 'std':list(), 'min':list(),'max':list(), 'sum':list()}
                self.gradsobj  = list()
                    
                ga('set z 1 %i' % self.getNz())

                ## Loop over times
                for it in range(self.getT1(),self.getT2()+1):
                    ga('set t %i' % it) ## Set the time
                    try:
                        if (self.getExpr() == None):
                            v = ga.expr(self.getVar()) ## Get the variable
                        elif (self.getExpr() != None):
                            v = ga.expr(self.getExpr())
                    except:
                        try:
                            if (self.getExpr() == None):
                                v = ga.expr(self.getVar().swapcase()) ## Try swapcase if fail
                            elif (self.getExpr() != None):
                                v = ga.expr(self.getExpr().swapcase())
                        except:
                            raise InputError('gagetVar: ga.expr(self.getVar())',
                                            self.getVar()+' and/or '+self.getVar().swapcase()+'not in file')
                    if (it == 1):
                        self.fill_value = v.fill_value
                        v2 = shiftdim(shiftdim(shiftdim(v.data,1),-1),1)
                        v3 = shiftdim(shiftdim(shiftdim(v.mask,1),-1),1)
                    elif (it > 1):
                        v2  = np.concatenate((v2,shiftdim(shiftdim(shiftdim(v.data,1),-1),1)), axis=3)
                        v3  = np.concatenate((v3,shiftdim(shiftdim(shiftdim(v.mask,1),-1),1)), axis=3)
                        
                    ## Set non time-varying attributes in dictionaries
                    if (it == 1):
                        ## Lists
                        self.gradsobj.append(v)
                        ## Dictionaries
                        self.gradsinfo['ndim'] = v.ndim
                        self.gradsinfo['lat']  = v.grid.lat
                        self.gradsinfo['lon']  = v.grid.lon
                        self.gradsinfo['lev']  = v.grid.lev
                    ## Dictionaries with list elements
                    self.gradsinfo['time'].append(v.grid.time[0])
                    self.gradsinfo['tyme'].append(v.grid.tyme[0])
                    self.gradstats['mean'].append(v.mean())
                    self.gradstats['std'].append(v.std())
                    self.gradstats['min'].append(v.min())
                    self.gradstats['max'].append(v.max())
                    self.gradstats['sum'].append(v.sum())
                            
                ## Close the file after time loop
                ga('close 1')
                    
                ## Set attributes after all time steps
                self.datatype   = 'grads'
                self.data       = v2
                self.shape      = v2.shape
                self.ndims      = len(v2.shape)
                self.gradsmask  = v3
                

                

            ## Non 4-d variables:
            if (not fourD):
                ## Set attributes
                self.fill_value = v.fill_value
                self.datatype   = 'grads'
                self.gradsobj   = v
                self.shape      = self.gradsobj.shape
                self.data       = self.gradsobj.data
                self.ndims      = self.gradsobj.ndim
                self.gradsmask  = self.gradsobj.mask
                self.gradsinfo  = {'ndim':self.gradsobj.ndim, 'time':self.gradsobj.grid.time,
                                  'tyme':self.gradsobj.grid.tyme,
                                  'lat':self.gradsobj.grid.lat, 'lon':self.gradsobj.grid.lon,
                                  'lev':self.gradsobj.grid.lev}
                self.gradstats  = {'mean':self.gradsobj.mean(), 'std':self.gradsobj.std(),
                                  'min':self.gradsobj.min(),
                                  'max':self.gradsobj.max(), 'sum':self.gradsobj.sum()}

            ## Replace where mask == True with NaN
            isnan = np.where(self.gradsmask == True)
            self.data[isnan] = np.nan
                
            ## Set lon, lat, lev, dx, dy 
            self.lon, self.lat, self.lev = self.gradsinfo['lon'][:-1], self.gradsinfo['lat'], self.gradsinfo['lev']
            self.dx,  self.dy            = self.getLon()[1]- self.getLon()[0], self.getLat()[1]- self.getLat()[0]
                
            ## Change the shape.  Cut off extra lon grads puts in at the end.
            if (self.ndims == 2):
                ## (lat, lon)
                self.data  = self.data[:,:-1]
            elif (self.ndims == 3):
                ## (lat, lon, time) or (lat, lon, lev)
                self.data  = np.rot90(shiftdim(np.rot90(self.data),2))
                self.data  = self.data[:, :-1, :]
            elif (self.ndims == 4):
                ## (time,lev,lat,lon) -> (lon,lat,lev,time)
                self.data  = self.data[:,:-1,:,:]
                
            ### Finally set shape, area, and resolution attributes
            self.time, self.tyme                = self.gradsinfo['time'], self.gradsinfo['tyme']
            self.shape                          = self.data.shape
            area, lon, lat, nx, ny, dx, dy, res = grid_area(nx=self.getNx(), ny=self.getNy(),
                                                            dx=self.getDx(), dy=self.getDy())
            self.area, self.res                 = area, res

            ### Finish up
            if (self.getExpr() == None):
                print 'gagetVar: Successfully opened '+self.getVar()
                print 'gagetVar: Run fillData() to get rid of fill_values and non-physical data'
            else:
                print 'gagetVar: Sucessfully opened '+self.getExprName()+': '+self.getExpr()
                print 'gagetVar: Run fillData() to get rid of fill_values and non-physical data'
        else:
            print 'gagetVar: Testing ddf file ...'
            print 'gagetVar: !!! DDF failed to open. Returning None !!!'
            return None
                
           
