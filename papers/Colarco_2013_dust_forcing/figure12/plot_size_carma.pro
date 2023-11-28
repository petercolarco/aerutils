; Colarco, February 2013
; Plot a comparison of the simulated CARMA dust particle size
; distribution versus the AERONET climatological retrievals at
; selected sites.

  expid = ['b_F25b9-base-v1',$      ; no forcing
           'bF_F25b9-base-v1', $    ; OPAC-Spheres
           'bF_F25b9-base-v11', $   ; OPAC-Spheroids
           'bF_F25b9-base-v7', $    ; OPAC-Ellipsoids
           'bF_F25b9-base-v6', $    ; Shettle/Fenn-Spheres
           'bF_F25b9-base-v5', $    ; Shettle/Fenn-Spheroids
           'bF_F25b9-base-v8', $    ; OBS (Colarco/Kim) - Spheres
           'bF_F25b9-base-v10' ]    ; OBS (Colarco/Kim) - Ellipsoids

  nexpid = n_elements(expid)
  colorarray=[0, 254,254,254,84,84,208,208]
  linarray  =[0, 0,  1,  2,  0, 2, 0,  1]

  aeronetPath = '/Volumes/bender/prc11/colarco/aerutils/aeronet/output/aeronet2nc/'
  lambdawant = '550'
  yyyyInp = strpad(findgen(20)+1992,1000)
;  yyyyInp = strpad(findgen(4)+2006,1000)

ymax = 1.

  set_plot, 'ps'
  device, file = './plot_size.'+expid[0]+'.eps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=20, yoff=.5, /encap
  !P.font=0
  loadct, 0
  !p.multi=[0,2,2]


  for isite = 0, 3 do begin

; Pick a site
  case isite of
   2: begin
      site = 'Capo_Verde'
      aersite = site
      site_title = 'Cape Verde, Sal Island'
      lon0 = -22.
      lat0 =  16.
      end
   1: begin
      site = 'Ragged_Point'
      aersite = 'Ragged_Point'
      site_title = 'Ragged Point, Barbados'
      lon0 = -59.
      lat0 =  13.
      end
   0: begin
      site = 'La_Parguera'
      aersite = site
      site_title = 'La Parguera, Puerto Rico'
      lon0 = -67.
      lat0 =  17.
      end
   3: begin
      site = 'Tamanrasset_INM'
      aersite = site
      site_title = 'Tamanrasset'
      lon0 =   5.
      lat0 =  22.
      end
  endcase

;  site = 'Bermuda'
;  aersite = site
;  site_title = 'Bermuda'
;  lon0 = -64.
;  lat0 =  32.

;  site = 'Santa_Cruz_Tenerife'
;  aersite = 'Santa_Cruz_Tenerife'
;  site_title = 'Santa Cruz, Tenerife'
;  lon0 = -16.
;  lat0 =  28.

;  site = 'Dahkla'
;  aersite = site
;  site_title = 'Dahkla'
;  lon0 = -15.
;  lat0 =  23.

; Get climatology of AERONET inversions
  print, 'Getting AERONET ', aersite
  read_aeronet_inversions2nc, aeronetPath, aersite, lambdawant, yyyyInp, $
      tauext, tauabs, date, /monthly, r=r, dr=dr, dvdlnr=dvdlnr_
  date = strpad(date,1000000000L)

; Average over all obs in particular month
  a = where(dvdlnr_ lt 0)
  if(a[0] ne -1) then dvdlnr_[a] = !values.f_nan
  a = where(strmid(date,4,2) ge '06' and strmid(date,4,2) le '08')
  dvdlnr = fltarr(22)
  for i = 0, 21 do begin
   b = where(finite(dvdlnr_[i,a]) eq 1,count)
   if(count gt 0) then dvdlnr[i] = total(dvdlnr_[i,a[b]])/count
   if(i eq 0) then print, count
  endfor

  plot, r, dvdlnr, /nodata, $
   xrange=[.05,15], /xlog, xstyle=9, xtitle = 'radius [um]', $
   yrange=[0.001,1], ystyle=9, ytitle = 'dV/d(ln r) [um]', /ylog, $
   title=site_title
  loadct, 0
  usersym, [-1,1,1,-1,-1], [-1,-1,1,1,-1], color=80, /fill
  plots, r, dvdlnr, psym=8, noclip=0


; Now plot the model fields
  for iexpid = 0, nexpid-1 do begin
   filename = '/Volumes/bender/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/' + $
              expid[iexpid]+'.tavg2d_carma_x.monthly.clim.JJA.nc4'
   print, 'Getting expid: ', expid[iexpid]
   nc4readvar, filename, 'ducm0', du, /template, wantlon=[lon0], wantlat=[lat0]
   du = du/2650.*1e6  ; column volume per bin um3 um-2
;  Size bins
   nbin = 8
   rmrat = (10.d/.1d)^(3.d/nbin)
   rmin = 0.1d*((1.+rmrat)/2.d)^(1.d/3.)
   carmabins, nbin, rmrat, rmin, 2650., $
              rmass, rmassup, rm, rup, drm, rlow
; print effective radius
  print, total(rm^3.*du/rm^3.)/total(rm^2.*du/rm^3.)

   du = du*rm/drm    ; dvdlnr

;  plot the model result
   loadct, 39
   for ibin = 0, nbin-2 do begin
    plots, [rlow[ibin],rup[ibin]], du[ibin], $
           thick=6, color=colorarray[iexpid], lin=linarray[iexpid], noclip=0
    plots, rup[ibin], [du[ibin],du[ibin+1]], $
           thick=6, color=colorarray[iexpid], lin=linarray[iexpid], noclip=0
   endfor
   ibin = 7
   plots, [rlow[ibin],rup[ibin]], du[ibin], $
          thick=6, color=colorarray[iexpid], lin=linarray[iexpid], noclip=0

  endfor
; Legend hard wired
  if(isite eq 0) then begin
  loadct, 0
  plots, .08, exp(.55*3. -3.), psym=8
  xyouts, .12, exp(0.51*3. -3.), 'AERONET', charsize=.75;

  loadct, 39
  plots, [.06,.11], exp(0.95*3. -3.), thick=6
  plots, [.06,.11], exp(0.85*3. -3.), thick=6, color=254
  plots, [.06,.11], exp(0.75*3. -3.), thick=6, color=254, lin=1
  plots, [.06,.11], exp(0.65*3. -3.), thick=6, color=254, lin=2
  plots, [1,2], exp(0.95*3. -3.), thick=6, color=84
  plots, [1,2], exp(0.85*3. -3.), thick=6, color=84, lin=2
  plots, [1,2], exp(0.75*3. -3.), thick=6, color=208
  plots, [1,2], exp(0.65*3. -3.), thick=6, color=208, lin=1
  xyouts, .12, exp(0.91*3. -3.), 'No Forcing', charsize=.75
  xyouts, .12, exp(0.81*3. -3.), 'OPAC-Spheres', charsize=.75
  xyouts, .12, exp(0.71*3. -3.), 'OPAC-Spheroids', charsize=.75
  xyouts, .12, exp(0.61*3. -3.), 'OPAC-Ellipsoids', charsize=.75
  xyouts, 2.2, exp(0.91*3. -3.), 'SF-Spheres', charsize=.75
  xyouts, 2.2, exp(0.81*3. -3.), 'SF-Ellipsoids', charsize=.75
  xyouts, 2.2, exp(0.71*3. -3.), 'OBS-Spheres', charsize=.75
  xyouts, 2.2, exp(0.61*3. -3.), 'OBS-Spheroids', charsize=.75
  endif
endfor

device, /close
stop
; Plot the Kok PSD
  loadct, 0
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-kok-v1/tavg2d_carma_x/bF_F25b9-kok-v1.tavg2d_carma_x.monthly.clim.JJA.nc4'
  nc4readvar, filename, 'ducm0', du, /template, wantlon=[lon0], wantlat=[lat0]

  du = du/2650.*1e6  ; column volume per bin um3 um-2

; Adjust ad hoc
  du = du/2.

; Size bins
  nbin = 8
  rmrat = (10.d/.1d)^(3.d/nbin)
  rmin = 0.1d*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, rm, rup, drm, rlow
  du = du*rm/drm    ; dvdlnr

  for ibin = 0, nbin-2 do begin
   plots, [rlow[ibin],rup[ibin]], du[ibin], $
           thick=6, color=100, noclip=0
   plots, rup[ibin], [du[ibin],du[ibin+1]], $
          thick=6, color=100, noclip=0
  endfor
  ibin = 7
  plots, [rlow[ibin],rup[ibin]], du[ibin], $
         thick=6, color=100, noclip=0

  device, /close

end
