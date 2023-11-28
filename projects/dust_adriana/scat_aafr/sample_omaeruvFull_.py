#!/usr/bin/env python
#
# Sample GEOS-5 collections at OMI Level 2 orbits.
#

import os
from optparse   import OptionParser 
from pyobs      import OMAERUV_L2, aura

#---------------------------------------------------------------------
def makethis_dir(filename):
    """Creates the relevant directory if necessary."""
    path, filen = os.path.split(filename)
    if path != '':
        rc = os.system('mkdir -p '+path)
        if rc:
            raise IOError, "could not create directory "+path

if __name__ == "__main__":

    expid   = '2011_a2_apport_frland_7'
    out_dir = './'

    # Parse command line options
    # --------------------------
    parser = OptionParser(usage="Usage: %prog [options] omaeruv_filename g5_collection",
                          version='1.0.0' )

    parser.add_option("-o", "--output", dest="npz_fn", default=None,
                      help="output NPZ file name (default=None)")
    
    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose",
                      help="turn on verbosity.")

    parser.add_option("-x", "--expid", dest="expid", default=expid,
                       help="experiment id (default=%s)"\
                           %expid )

    parser.add_option("-F", "--Full", 
                      action="store_true",dest="Full_interp", 
                      help="Interpolation at all OMI obs location(default=%s)")

    parser.add_option("-d", "--dir", dest="out_dir", default=out_dir,
                      help="output directory (default=%s)"\
                           %out_dir )
                    
    (options, args) = parser.parse_args()

    if len(args) == 2:
        omi_fn, g5_fn = args
    else:
        parser.error("must have 2 arguments: omaeruv_filename g5_collection")

    if options.npz_fn is None:
        instr, sat, lev, prod, vtime, orb,ver, ptime, t =aura.parseFilename(omi_fn)
        
        if options.Full_interp:
           options.npz_fn = options.out_dir+'/'+options.expid+'_aer_'+lev+ '-'+\
           prod + '_' + vtime +'Full.npz'    
        else :
           options.npz_fn = options.out_dir+'/'+options.expid+'_aer_'+lev+ '-'+\
           prod + '_' + vtime + '.npz'

    # Read OMI orbit
    # --------------
    omi = OMAERUV_L2(omi_fn)

    onlyVars = ['PS', 'DELP', 'LWI', 'AIRDENS', 'RH',
                'DU001', 'DU002', 'DU003', 'DU004', 'DU005',
                'DU001bafr', 'DU002bafr', 'DU003bafr', 'DU004bafr', 'DU005bafr']

    # Sample g5 collection at OMI orbit
    # ---------------------------------
    if options.Full_interp:
       omi.sampleFile(g5_fn, onlyVars=onlyVars,npzFile=None, Verbose=options.verbose)
       Igood = omi.qa_flag <10         # OMI doc : FinalAlgorithmFlags - 0 - Most reliable( AAOD, SSA, AOD)
       omi.sampleReduce(I=Igood,npzFile=options.npz_fn)
       #omi.sampleFile(g5_fn, onlyVars=onlyVars, npzFile=options.npz_fn, Verbose=options.verbose)
    else:
       omi.sampleFile(g5_fn, onlyVars=onlyVars,npzFile=None, Verbose=options.verbose)
       Igood = omi.qa_flag <1         # OMI doc : FinalAlgorithmFlags - 0 - Most reliable( AAOD, SSA, AOD)
       omi.sampleReduce(I=Igood,npzFile=options.npz_fn)


