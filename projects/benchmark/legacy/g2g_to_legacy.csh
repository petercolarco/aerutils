#!/bin/tcsh
# Colarco, 9/27/23
# This starts from a G2G run gocart_internal_rst (named 
# "gocart_internal_rst.original") that just contains 
# non-aerosol fields (e.g., CO)
# Then, from a set of G2G aerosol fields (du, ss, ...)
# they are added to the gocart_internal_rst for a suitable
# legacy-style gocart restart file. Note that I add
# BR+OC = OC to combine the BR and OC
# Initial restarts from c180R_v202_ceds G2G run here:
# /archive/u/pcolarco/GEOS5.0/c180R_v202_ceds/restarts/Y2015/restarts.e20151225_21z.tar

  \cp -f gocart_internal_rst.original gocart_internal_rst

# Add the SU
  ncks -A -v DMS su_internal_rst gocart_internal_rst
  ncks -A -v MSA su_internal_rst gocart_internal_rst
  ncks -A -v SO2 su_internal_rst gocart_internal_rst
  ncks -A -v SO4 su_internal_rst gocart_internal_rst

# Add the NI
  ncks -A -v NH3    ni_internal_rst gocart_internal_rst
  ncks -A -v NH4a   ni_internal_rst gocart_internal_rst
  ncks -A -v NO3an1 ni_internal_rst gocart_internal_rst
  ncks -A -v NO3an2 ni_internal_rst gocart_internal_rst
  ncks -A -v NO3an3 ni_internal_rst gocart_internal_rst

# Add the BC
  ncks -A -v CAphobicCA.bc cabc_internal_rst gocart_internal_rst
  ncks -A -v CAphilicCA.bc cabc_internal_rst gocart_internal_rst
  ncrename -O -v CAphobicCA.bc,BC001 gocart_internal_rst
  ncrename -O -v CAphilicCA.bc,BC002 gocart_internal_rst

# Add the OC
  ncks -A -v CAphobicCA.oc caoc_internal_rst gocart_internal_rst
  ncks -A -v CAphilicCA.oc caoc_internal_rst gocart_internal_rst
  ncrename -O -v CAphobicCA.oc,var1 gocart_internal_rst
  ncrename -O -v CAphilicCA.oc,var2 gocart_internal_rst

# Add the BR
  ncks -A -v CAphobicCA.br cabr_internal_rst gocart_internal_rst
  ncks -A -v CAphilicCA.br cabr_internal_rst gocart_internal_rst
  ncrename -O -v CAphobicCA.br,var3 gocart_internal_rst
  ncrename -O -v CAphilicCA.br,var4 gocart_internal_rst
  ncap2 -s 'var5=(var1+var3)' gocart_internal_rst out1
  ncap2 -s 'var6=(var2+var4)' out1 out2
  ncrename -O -v var5,OC001 -v var6,OC002 out2
  \mv -f out2 gocart_internal_rst
  \rm -f out1
  ncks -x -v var1,var2,var3,var4 gocart_internal_rst out1
  \mv -f out1 gocart_internal_rst

# Deal with dust
  ncks -A -v DU -d unknown_dim1,4 du_internal_rst gocart_internal_rst
  ncrename -O -v DU,DU005 gocart_internal_rst
  ncks -A -v DU -d unknown_dim1,3 du_internal_rst gocart_internal_rst
  ncrename -O -v DU,DU004 gocart_internal_rst
  ncks -A -v DU -d unknown_dim1,2 du_internal_rst gocart_internal_rst
  ncrename -O -v DU,DU003 gocart_internal_rst
  ncks -A -v DU -d unknown_dim1,1 du_internal_rst gocart_internal_rst
  ncrename -O -v DU,DU002 gocart_internal_rst
  ncks -A -v DU -d unknown_dim1,0 du_internal_rst gocart_internal_rst
  ncrename -O -v DU,DU001 gocart_internal_rst

# Deal with sea salt
  ncks -A -v SS -d unknown_dim1,4 ss_internal_rst gocart_internal_rst
  ncrename -O -v SS,SS005 gocart_internal_rst
  ncks -A -v SS -d unknown_dim1,3 ss_internal_rst gocart_internal_rst
  ncrename -O -v SS,SS004 gocart_internal_rst
  ncks -A -v SS -d unknown_dim1,2 ss_internal_rst gocart_internal_rst
  ncrename -O -v SS,SS003 gocart_internal_rst
  ncks -A -v SS -d unknown_dim1,1 ss_internal_rst gocart_internal_rst
  ncrename -O -v SS,SS002 gocart_internal_rst
  ncks -A -v SS -d unknown_dim1,0 ss_internal_rst gocart_internal_rst
  ncrename -O -v SS,SS001 gocart_internal_rst

  ncwa -a unknown_dim1 gocart_internal_rst out
  \mv -f out gocart_internal_rst
