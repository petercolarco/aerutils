; Calculate layer optical depth (for 1 DU of SO2 and O3 in a layer) for each
; layer at specified wavelengths
; Input:  1) GEOS-5 pressure profile
;         2) GEOS-5 temperature profile
;         3) Pre-convolved SO2, and O3 cross section
; Output: 1) tau_SO2 at each layer (assuming 1 DU partial column amount in the layer
;         2) tau_O3 at each layer (assuming 1 DU partial column amount in the layer 
;         3) tau_ray 

; -------------------------------------------------------------------
; As an example, first read pressure and temperature profiles from GEOS-5
; Note that pressure is for the bottom of each layer
; Temperature is for the center of each layer
infile_GEOS5 = 'GEOS-5_pres_temp_prof.txt'
header = STRARR(1)
data = FLTARR(2,72)
OPENR,lun,infile_GEOS5,/GET_LUN
READF,lun,header
READF,lun,data
FREE_LUN,lun
layer_bot_pres = data[0,*]
layer_mid_temp = data[1,*]
n_layer = N_ELEMENTS(layer_bot_pres)

; ----------------------------------------------------------------------
; Read pre-convolved cross section data
infile_xsec = 'O3_SO2_Ray_xsec_convol_OMPS.sav'
;infile_xsec = 'O3_SO2_Ray_xsec_convol_OMI.sav'
RESTORE,infile_xsec
; Number of wavelengths for optical depth
n_wvlen = N_ELEMENTS(wvlen_OMPS)
PRINT,'OMPS Wavelengths:'
PRINT,wvlen_OMPS
;n_wvlen = N_ELEMENTS(wvlen_OMI)
;PRINT,'OMI Wavelengths:'
;PRINT,wvlen_OMI

; --------------------------------------------------------------------------
; Check temperature if it is over 100 (in Kelvin), if so, convert to celcius
; for calculation of cross section
iF layer_mid_temp[0] GT 100. THEN BEGIN
    layer_mid_temp = layer_mid_temp- 273.15
ENDIF

; --------------------------------------------------------------------------
; Now calculate tau_O3 
tau_O3 = FLTARR(n_wvlen,n_layer)
FOR i_wav = 0,n_wvlen-1 DO BEGIN
    a0_wav = a0_O3_convol[i_wav]
    a1_wav = a1_O3_convol[i_wav]
    a2_wav = a2_O3_convol[i_wav]
    
    FOR i_layer = 0, n_layer-1 DO BEGIN
        ; Temperature for current layer
        T = layer_mid_temp[i_layer]
     
        ; calculate crosssection for all layers for the current wavelength
        xsec = 1.00000E-20 * a0_wav *(1. + a1_wav*T + $
                                  a2_wav*T^2)

        ; If xsec LT 0, assign a very small positive value
        IF xsec LT 0 THEN xsec =  1.00000E-30
        ; Calculate optical depth for 1 DU of SO2 in the layer
        tau_O3[i_wav,i_layer] = xsec * 2.69E16
    ENDFOR
ENDFOR

; --------------------------------------------------------------------------
; Now calculate tau_SO2 
tau_SO2 = FLTARR(n_wvlen,n_layer)
FOR i_wav = 0,n_wvlen-1 DO BEGIN
    a0_wav = a0_SO2_convol[i_wav]
    a1_wav = a1_SO2_convol[i_wav]
    a2_wav = a2_SO2_convol[i_wav]
    
    FOR i_layer = 0, n_layer-1 DO BEGIN
        ; Temperature for current layer
        T = layer_mid_temp[i_layer]
     
        ; calculate crosssection for all layers for the current wavelength
        xsec = 1.00000E-20 * a0_wav *(1. + a1_wav*T + $
                                  a2_wav*T^2)

        ; If xsec LT 0, assign a very small positive value
        IF xsec LT 0 THEN xsec =  1.00000E-30
        ; Calculate optical depth for 1 DU of SO2 in the layer
        tau_SO2[i_wav,i_layer] = xsec * 2.69E16
    ENDFOR
ENDFOR

; --------------------------------------------------------------------------
; Now calculate tau_ray 
tau_Ray = FLTARR(n_wvlen,n_layer)
FOR i_wav = 0,n_wvlen-1 DO BEGIN
    beta_wav = beta_convol[i_wav]
    ; For first layer, from top of model (0.01 hPa to the bottom of first layer)
    ; calculate tau_Ray 
    tau_Ray[i_wav,0] = beta_wav*(layer_bot_pres[0] - 0.01)/1013.25000
    FOR i_layer = 1,n_layer-1 DO BEGIN
        tau_Ray[i_wav,i_layer] = beta_wav*(layer_bot_pres[i_layer] - $
                                           layer_bot_pres[i_layer-1])/1013.25000 
    ENDFOR

ENDFOR 


outfile = 'tau_O3_SO2_Ray_1DU_OMPS.h5'
write_h5_tau,outfile, wvlen_OMPS,layer_bot_pres,layer_mid_temp, $
             tau_SO2, tau_O3, tau_Ray

END 
