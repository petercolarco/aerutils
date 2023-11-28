; This routine convolves the cross section coefficients 
; of O3, SO2, and Rayleigh cross section at 0.01 nm to
; specified OMPS wavelengths using the standard OMPS
; slit function

; -----------------------------------------------------------------------------
; Note that here we assume the cross track position to be 18
ix = 18

; -----------------------------------------------------------------------------
; Specify OMPS wavelengths
wvlen_OMPS = [312.34, 317.35, 331.06, 339.66, 359.88, 379.95]
n_wvlen_OMPS = N_ELEMENTS(wvlen_OMPS)

; -----------------------------------------------------------------------------
; Read OMPS slit function in HDF5 format
; HDF5 file for the OMPS slit function
infile_omps_slit = 'OMPS_TC_MACRO_CBC_BPS.h5'
; Read OMPS slit function 
read_h5_omps_slit, infile_omps_slit, BPS_delta, MACRO_BPS, MACRO_CBC

; -----------------------------------------------------------------------------
; Read high resolution O3 cross section
infile_O3_xsec = '../xsec/Daumont_O3_xsec_temp_300_400nm.dat'
header = STRARR(20)
data = FLTARR(4,10001)
OPENR,lun,infile_O3_xsec,/GET_LUN
READF,lun,header
READF,lun,data
wvlen_O3_xsec = data[0,*]
a0_O3_xsec = data[1,*]
a1_O3_xsec = data[2,*]
a2_O3_xsec = data[3,*]
FREE_LUN,lun

; -----------------------------------------------------------------------------
; Read high resolution SO2 cross section
infile_SO2_xsec = '../xsec/Bogumil_so2_xsec_tmp_400nm.dat'
header = STRARR(17)
data = FLTARR(4,10001)
OPENR,lun,infile_SO2_xsec,/GET_LUN
READF,lun,header
READF,lun,data
wvlen_SO2_xsec = data[0,*]
a0_SO2_xsec = data[1,*]
a1_SO2_xsec = data[2,*]
a2_SO2_xsec = data[3,*]
FREE_LUN,lun

; -----------------------------------------------------------------------------
; Read high resolution Rayleigh scattering data
infile_Ray_xsec = '../xsec/beta_rho_bremen_grid_400nm.dat'
header = STRARR(1)
data = FLTARR(3,10001)
OPENR,lun,infile_Ray_xsec,/GET_LUN
READF,lun,header
READF,lun,data
wvlen_Ray = data[0,*]
Ray_beta = data[1,*]
Ray_Rho = data[2,*]
FREE_LUN,lun

; ----------------------------------------------------------------------------
; Convolve xsec data to specified OMPS wavelengths
; O3
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_O3_xsec, a0_O3_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a0_O3_convol
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_O3_xsec, a1_O3_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a1_O3_convol
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_O3_xsec, a2_O3_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a2_O3_convol
; SO2
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_SO2_xsec, a0_SO2_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a0_SO2_convol
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_SO2_xsec, a1_SO2_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a1_SO2_convol
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_SO2_xsec, a2_SO2_xsec,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, a2_SO2_convol
; Rayleigh
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_Ray, Ray_beta,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, beta_convol 
convol_omps_slit, n_wvlen_OMPS, wvlen_OMPS, ix, wvlen_Ray, Ray_Rho,   $
                  MACRO_CBC, MACRO_BPS, BPS_delta, Rho_convol

; ----------------------------------------------------------------------------
; Save pre-convolved xsec data
SAVE,wvlen_OMPS,a0_O3_convol,a1_O3_convol,a2_O3_convol,a0_SO2_convol, $
     a1_SO2_convol,a2_SO2_convol,beta_convol,Rho_convol,FILENAME='O3_SO2_Ray_xsec_convol.sav'

END
