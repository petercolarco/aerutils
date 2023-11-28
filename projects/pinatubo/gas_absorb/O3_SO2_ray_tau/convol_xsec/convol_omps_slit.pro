; Subroutine for convolving a spectrum to OMPS slit function
; Input:
;    1) Arrays including OMPS slit function, and wavelength grid (2-D CCD)
;    2) Row number (0-based)
;    3) Actual OMPS wavelengths (now the same as slit function, but may change
;       in the future) high resolution spectrum will be convolved to
;    4) Wavelength grid of the high-resolution spectrum to be convolved
;    5) Parameter of the high-resolution spectrum to be convolved
; Process:
;    1) For each OMPS wavelength, the corresponding wavelength grid in the 
;       slit function will be found (based on difference between wavelengths)
;    2) The spectrum to be convolved will then be interpolated to the wavelength
;       grid
;    3) Convolution done for the wavelength by numerically integrating the
;       spectrum, TOTAL(slit*par)/TOTAL(slit)

PRO convol_omps_slit, n_wl_omps, wl_omps, ix, wl_par, par, MACRO_CBC, MACRO_BPS, $
                     BPS_delta, par_convol
; First take the subset of the slit function based on 0-based row number ix
wl_slit = REFORM(MACRO_CBC[ix,*])
slit = REFORM(MACRO_BPS[*,ix,*])
n_wl_steps = N_ELEMENTS(BPS_delta)

; For each wavelength in the OMPS wavelength grid, find the wavelength grid in slit
; do the convolution
par_convol = FLTARR(n_wl_omps)
;par_convol_fine = FLTARR(n_wl_omps)

FOR i_wav = 0,n_wl_omps-1 DO BEGIN
    ; Current wavelength
    wl = wl_omps[i_wav]
    ; difference between current wavelength and wavelength grid of slit
    wl_diff = ABS(wl_slit - wl)
    idx_mindiff = WHERE(wl_diff EQ MIN(wl_diff))
    ; index of the slit function for the current wavelength
    idx_slit = idx_mindiff[0]
    ; Now contruct a wavelength grid around the OMPS wavelength
    ; Here assumes that the bandpass values can be used even if there is
    ; a small shift of wavelength between the slit wavelength grid and the OMPS meaurement
    ; wavelength
    wl_grid = wl + BPS_delta 
    ;wl_grid_fine = [wl -(200- INDGEN(200))*0.01, wl, wl+(INDGEN(200)+1)*0.01]
    slit_wl = slit[*,idx_slit]
    ;slit_fine =INTERPOL(slit_wl,wl_grid,wl_grid_fine)
    ; Interpolate parameter to the wavelenghth grid
    par_interp = INTERPOL(par,wl_par,wl_grid)
    
    ;par_interp_fine = INTERPOL(par,wl_par,wl_grid_fine)
    ; Convolution
    par_convol[i_wav] = TOTAL(par_interp*slit_wl)/TOTAL(slit_wl)    
    ;par_convol_fine[i_wav] = TOTAL(par_interp_fine*slit_fine)/TOTAL(slit_fine)    


ENDFOR

RETURN
END
