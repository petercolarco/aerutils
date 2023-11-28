; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

  site = 'RaggedPoint'
  site_title = 'Ragged Point, Barbados'
  ymax = 200
  site = 'Bermuda'
  site_title = 'Bermuda'
  ymax=50
  site = 'Miami'
  site_title = 'Miami'
  ymax=80

; Get the lifetimes
  expid = ['b_F25b9-base-v1',$
           'bF_F25b9-base-v1', $
           'bF_F25b9-base-v6', $
           'bF_F25b9-base-v5', $
           'bF_F25b9-base-v8', $
           'bF_F25b9-base-v10' ]

  nexpid = n_elements(expid)
  colorarray=[0, 254,84,84,208,208]
  linarray  =[0, 0,  0, 2,0,2]

  years = strcompress(string(2011 + indgen(40)),/rem)
  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)
  ny = n_elements(years)

  set_plot, 'ps'
  device, file = './plot_dusmass.'+expid[0]+'.'+site+'.ps', /color, /helvetica, $
   font_size=12, xsize=10, xoff=.5, ysize=10, yoff=.5
  !P.font=0
  loadct, 0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Dust
  tdef = 'tdef time 480 linear 12z15jan2011 1mo'
  filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.obs.'+site+'.%y4.nc4'
  nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef
  convfac = 1.e9
  dusmass = reform(dusmass,12,40)*convfac
; Compute the standard deviation
  sdev = stddev(dusmass,dimension=2)
  if(rc eq 0) then begin
   plot, [0,13], [0,ymax], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Dust Surface Mass Concentration [ug m!E-3!N]', title=site_title
   polymaxmin, indgen(12)+1, dusmass[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=6, sdev=sdev
  endif

  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    nyuse = ny
    if(iexpid ge 4) then nyuse = 20
    nt = strpad(nyuse*12,100)
    tdef = 'tdef time '+nt+' linear 12z15jan2011 1mo'
    filename = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'$
               +expid[iexpid]+'.tavg2d_carma_x.obs.'+site+'.%y4.nc4'
    nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef
    dusmass = reform(dusmass,12,nyuse)*convfac
    sdev = stddev(dusmass,dimension=2)
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, dusmass[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=6, sdev=sdev
   endfor
  endif

; Get the AEROCE data
  aerocepath = './output/data/'
  read_aeroce2nc, aerocepath, site, 'DUST', '2000', dudat, date, stdvalue=sdev
  loadct, 0
  usersym, [-1,1,1,-1,-1], [-1,-1,1,1,-1], color=80, /fill
  plots, indgen(12)+1, dudat, psym=8
  for imon = 0,11 do begin
   plots, imon+1+[-1,1,0,0,-1,1]*0.25, dudat[imon]+[-1,-1,-1,1,1,1]*sdev[imon], color=80, noclip=0
  endfor

; Legend hard wired
  loadct, 39
  plots, [1,2.5], 0.950*ymax, thick=6
  plots, [1,2.5], 0.875*ymax, thick=6, color=254
  plots, [7,8.5], 0.950*ymax, thick=6, color=84
  plots, [7,8.5], 0.875*ymax, thick=6, color=84, lin=2
  xyouts, 2.8, 0.940*ymax, 'No Forcing', charsize=.75
  xyouts, 2.8, 0.865*ymax, 'OPAC', charsize=.75
  xyouts, 8.8, 0.940*ymax, 'Levoni', charsize=.75
  xyouts, 8.8, 0.865*ymax, 'Levoni (Ellipse)', charsize=.75

  device, /close  

end

