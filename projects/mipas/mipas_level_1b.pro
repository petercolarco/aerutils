PRO mipas_level_1b, filename, lon=lon, lat=lat, alt=alt, $
                              band_a=band_a, band_b=band_b, bandab=band_ab, $
                              band_c=band_c, band_d=band_d

  ; open the product file. If an error occurred, report it.
  pf = coda_open(filename)
  IF coda_is_error(pf) THEN BEGIN
    print, 'Error while opening the product: ', pf.message
    RETURN
  ENDIF

  ; fetch the MDS; this becomes an array of CODA_DATAHANDLEs.
  mds = coda_fetch(pf, 'mipas_level_1b_mds')
  ads = coda_fetch(pf, 'geolocation_ads')
  nmds = n_elements(mds)

  lon = fltarr(nmds)
  lat = fltarr(nmds)
  alt = fltarr(nmds)

  ; traverse all measurement records.
  FOR i=0,nmds-1 DO BEGIN

    ; fetch data for all bands.

;   Geodetic latitude and geographic longitude of the tangent point geolocation
    loc_2   = coda_fetch(mds[i], "loc_2")
;   Geodetic tangent point geolocation (limb and error)
    loc_1   = coda_fetch(mds[i], "loc_1")

    lon[i] = loc_2.longitude
    lat[i] = loc_2.latitude
    alt[i] = loc_1[0]
;print, loc_2, loc_1[0]
;   Bands
    banda  = coda_fetch(mds[i], "band_a")
    bandab = coda_fetch(mds[i], "band_ab")
    bandb  = coda_fetch(mds[i], "band_b")
    bandc  = coda_fetch(mds[i], "band_c")
    bandd  = coda_fetch(mds[i], "band_d")
    if(i eq 0) then begin
     band_a  = fltarr(n_elements(banda),nmds)
     band_ab = fltarr(n_elements(bandab),nmds)
     band_b  = fltarr(n_elements(bandb),nmds)
     band_c  = fltarr(n_elements(bandc),nmds)
     band_d  = fltarr(n_elements(bandd),nmds)
    endif

    band_a[*,i]  = banda
    band_ab[*,i] = bandab
    band_b[*,i]  = bandb
    band_c[*,i]  = bandc
    band_d[*,i]  = bandd


    ; select which bands to plot.
;    plot_bands = [band_a[*,i], band_b[*,i]]

    ; plot the data
;    plot, plot_bands, /ylog, yrange=[1e-10,1e-4],                   $
;          xtickformat='(I)', xstyle=1, psym=3,                      $
;          title=STRING(format='(%"MIPAS Level-1b MDSR #%d")', i+1), $
;          xtitle='readout number (bands A and B shown)',            $
;          ytitle='log!I10!N(radiance) [W/(cm!E2!N !M. sr !M. cm!E-1!N)]'
  ENDFOR

  ; close the product file.
  dummy = coda_close(pf)
;stop
END
