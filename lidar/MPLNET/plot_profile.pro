; Colarco
; Stitch together a number of dates

; Get the CARMA black carbon
  file = '/misc/prc11/colarco/dCR_Fortuna-2_4-b5p2/inst3d_carma_v/Y2009/M07' +$
         '/dCR_Fortuna-2_4-b5p2.inst3d_carma_v.20090702_0000z.nc4'
  nc4readvar, file, 'airdens', rhoa, $
              wantlon = [80.], wantlat=[26.5]
  nc4readvar, file, 'bc', bc, $
              wantlon = [80.], wantlat=[26.5], /sum, /template
  bccarma = bc * rhoa * 1e12  ; ng m-3

  files = file_search('./output/data/dR_Fortuna-2-4-b4.kanpur_532nm*nc')
  files = files[31:31]
  pblh = 1.
  bc = 1.
  ssa = 1.
  cloud = 1.
  read_curtain, files, lon, lat, time, z0, z, dz, $
                pblh = pblh, $
                bc = bc, $
                ssa_tot = ssa, $
                cloud = cloud

    datestr = strcompress(string(time[0],format='(i8)'),/rem)

    plotfile = 'dR_Fortuna-2-4-b4.kanpur_532n.bc.ps'

    nt = n_elements(time)
    nz = n_elements(z[0,*])
    z  = transpose(z) / 1000.  ; km
    dz = transpose(dz) / 1000. ; km

;   Transpose arrays to be (time,hght)
    bc  = transpose(bc)
    ssa = transpose(ssa)


;   Put time into hour of day
    time = (time - long(time[0]))*24.

; Kanpur aircraft profile, July 2, 2009
; altitude in km
  altitude = [1.439611, 1.441003, 1.434975, 2.094731, $
              2.091591, 2.094861, 2.092776, 2.097745, $
              2.645734, 2.742839, 2.744062, 2.741976, $
              2.900003, 3.092535, 3.230281, 3.404876, $
              3.417121, 3.438774, 3.4042,   3.565064]

  bcobs    = [84.17879988, 97.52421937, 151.9324681, 116.0024925, $
              70.491,      24.97988777,  56.8035804, 182.0452095, $
              29.08617069, 89.65384377,  61.594,      33.53464385, $
              49.61758529, 34.21902434,  91.36479499, 80.4147072, $
              59.883,      39.35187799,  34.105,      28.858]

  ssaobs   = [0.784726022, 0.833947747, 0.801133549, 0.868557845, $
              0.806270515, 0.872533044, 0.925007937, 0.938969908, $
              0.941363323, 0.913219006, 0.865862442, 0.841469338, $
              0.922281216, 0.898954666, 0.934538737, 0.926925079, $
              0.931628258, 0.899595462, 0.946369036, 0.945093066 ]


    set_plot, 'ps'
    device, file=plotfile, /helvetica, font_size=14, /color
    !p.font=0

    plot, indgen(2), /nodata, thick=3, $
     xrange=[0,400], xstyle=9, xtitle='black carbon [ng m!E-3!N]', $
     yrange=[1,4], ystyle=9, ytitle='altitude [km]'

    oplot, total(bc,1)/24.*1000., z[11,*], thick=6
    oplot, bccarma, z[11,*], thick=6, lin=2
    plots, bcobs, altitude, psym=4





    plot, indgen(2), /nodata, thick=3, $
     xrange=[.75,1], xstyle=9, xtitle='SSA', $
     yrange=[1,4], ystyle=9, ytitle='altitude [km]'

    oplot, total(ssa,1)/24., z[11,*], thick=6
    plots, ssaobs, altitude, psym=4

    device, /close


end
