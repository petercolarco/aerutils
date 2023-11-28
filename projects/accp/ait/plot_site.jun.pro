; Given a list of city sites (from Ali/Melanie?)  

; Define a site
  site = ['Moscow', 'Fairbanks', 'Seattle','New York','Los Angeles','New Delhi', $
          'Mexico City','Manila','Jakarta','Nairobi']
  lon0 = [37.62,-147.72,-122.33,-74.00,-118.24,77.10,-99.13,120.98,106.85,36.82]
  lat0 = [55.76,64.84,47.61,40.71,34.05,28.70,19.43,14.60,-6.21,-1.29]
  ymax = [0.4,.4,.4,0.8,.2,2,.4,.4,1,.4]

  ddf = ['full',$
         'gpm.200km','gpm.750km', 'gpm.1100km','gpm.550km', $
         'gpm045.200km','gpm045.750km', 'gpm045.1100km','gpm045.550km', $
         'gpm050.200km','gpm050.750km', 'gpm050.1100km','gpm050.550km', $
         'gpm055.200km','gpm055.750km', 'gpm055.1100km','gpm055.550km', $
         'ss450_gpm.200km','ss450_gpm.750km', 'ss450_gpm.1100km','ss450_gpm.550km', $
         'ss450_gpm045.200km','ss450_gpm045.750km', 'ss450_gpm045.1100km','ss450_gpm045.550km', $
         'ss450_gpm050.200km','ss450_gpm050.750km', 'ss450_gpm050.1100km','ss450_gpm050.550km', $
         'ss450_gpm055.200km','ss450_gpm055.750km', 'ss450_gpm055.1100km','ss450_gpm055.550km', $
         'ss450.200km','ss450.750km', 'ss450.1100km','ss450.550km',$
         'p07i04b','p04bi04b']

  nsites = 10
  nddf   = 39
  aod    = fltarr(nddf,nsites,365)

  openr, lun, 'plot_aod_site.txt', /get
  readf, lun, nsites, nddf, aod
  free_lun, lun  

; Reduce to June
  aod = aod[*,*,151:180]

  for i = 0, nsites-1 do begin
   sitestr = strcompress(strlowcase(site[i]),/rem)

   set_plot, 'ps'
   device, file='sites/'+sitestr+'.full.jun.ps', /color, font_size=14, /helvetica, $
    xsize=24, ysize=14
   !p.font=0

   x = findgen(30)
   xtickv = indgen(31)
   xtickn = [string(x+1,format='(i2)'),' ']

   plot, indgen(10), /nodata, $
    xrange=[0,max(x)], yrange=[0,ymax[i]], $
    xstyle=9, ystyle=9, $
    xticks=30, xtickv=xtickv, xtickn=xtickn, xminor=2, title=site[i]
   oplot, x, aod[0,i,*], thick=6
   device, /close
  endfor

; Wide-swath GPM and SS450
  for i = 0, nsites-1 do begin
   sitestr = strcompress(strlowcase(site[i]),/rem)

   set_plot, 'ps'
   device, file='sites/'+sitestr+'.wide.jun.ps', /color, font_size=14, /helvetica, $
    xsize=24, ysize=14
   !p.font=0

   plot, indgen(10), /nodata, $
    xrange=[0,max(x)], yrange=[0,ymax[i]], $
    xstyle=9, ystyle=9, $
    xticks=30, xtickv=xtickv, xtickn=xtickn, xminor=2, title=site[i]
   oplot, x, aod[0,i,*], thick=6
   plots, x, aod[35,i,*], psym=sym(1), color=84
   plots, x, aod[3,i,*], psym=sym(1), color=254

;  Get the statistics
   xx = aod[0,i,*]
   yy = aod[35,i,*]
   n  = n_elements(where(finite(aod[35,i,*]) eq 1))
   statistics, xx, yy, xmean, ymean, xstd, ystd, r, bias, rms, skill, linx, liny
   xyouts, 18, .9*ymax[i], 'Mean  R      B        RMS    SK    N', /data
   xyouts, 18, .85*ymax[i], string(mean(aod[0,i,*]),format='(f5.3)')+$
    '                                          30'
   str = string(ymean,format='(f5.3)') + ' ' + string(r,format='(f6.3)') + ' ' +$
         string(bias,format='(f6.3)') + ' ' + string(rms,format='(f5.3)') + ' '+$
         string(skill,format='(f5.3)')+' ' +string(n,format='(i3)')
   xyouts, 18, .8*ymax[i], str, color=84
   yy = aod[3,i,*]
   n  = n_elements(where(finite(aod[3,i,*]) eq 1))
   statistics, xx, yy, xmean, ymean, xstd, ystd, r, bias, rms, skill, linx, liny
   str = string(ymean,format='(f5.3)') + ' ' + string(r,format='(f6.3)') + ' ' +$
         string(bias,format='(f6.3)') + ' ' + string(rms,format='(f5.3)') + ' '+$
         string(skill,format='(f5.3)')+' ' +string(n,format='(i3)')
   xyouts, 18, .75*ymax[i], str, color=254

   device, /close

; 200km GPM and SS450
   sitestr = strcompress(strlowcase(site[i]),/rem)

   set_plot, 'ps'
   device, file='sites/'+sitestr+'.narrow.jun.ps', /color, font_size=14, /helvetica, $
    xsize=24, ysize=14
   !p.font=0

   plot, indgen(10), /nodata, $
    xrange=[0,max(x)], yrange=[0,ymax[i]], $
    xstyle=9, ystyle=9, $
    xticks=30, xtickv=xtickv, xtickn=xtickn, xminor=2, title=site[i]
   oplot, x, aod[0,i,*], thick=6
   plots, x, aod[33,i,*], psym=sym(1), color=84
   plots, x, aod[1,i,*], psym=sym(1), color=254

;  Get the statistics
   xx = aod[0,i,*]
   yy = aod[33,i,*]
   n  = n_elements(where(finite(aod[33,i,*]) eq 1))
   statistics, xx, yy, xmean, ymean, xstd, ystd, r, bias, rms, skill, linx, liny
   xyouts, 18, .9*ymax[i], 'Mean  R      B        RMS    SK    N', /data
   xyouts, 18, .85*ymax[i], string(mean(aod[0,i,*]),format='(f5.3)')+$
    '                                          30'
   str = string(ymean,format='(f5.3)') + ' ' + string(r,format='(f6.3)') + ' ' +$
         string(bias,format='(f6.3)') + ' ' + string(rms,format='(f5.3)') + ' '+$
         string(skill,format='(f5.3)')+' ' +string(n,format='(i3)')
   xyouts, 18, .8*ymax[i], str, color=84
   yy = aod[1,i,*]
   n  = n_elements(where(finite(aod[1,i,*]) eq 1))
   statistics, xx, yy, xmean, ymean, xstd, ystd, r, bias, rms, skill, linx, liny
   str = string(ymean,format='(f5.3)') + ' ' + string(r,format='(f6.3)') + ' ' +$
         string(bias,format='(f6.3)') + ' ' + string(rms,format='(f5.3)') + ' '+$
         string(skill,format='(f5.3)')+' ' +string(n,format='(i3)')
   xyouts, 18, .75*ymax[i], str, color=254

   device, /close

   set_plot, 'ps'
   device, file='sites/'+sitestr+'.diff.jun.ps', /color, font_size=14, /helvetica, $
    xsize=24, ysize=14
   !p.font=0

   plot, indgen(10), /nodata, $
    xrange=[0,max(x)], yrange=[-0.5,0.5], $
    xstyle=9, ystyle=9, $
    xticks=30, xtickv=xtickv, xtickn=xtickn, xminor=2, title=site[i]
   loadct, 39
   plots, x, aod[3,i,*]-aod[0,i,*], psym=sym(1), color=254
   plots, x, aod[35,i,*]-aod[0,i,*], psym=sym(1), color=84
   oplot, x, aod[1,i,*]-aod[0,i,*], psym=sym(3), color=254, lin=2
   oplot, x, aod[33,i,*]-aod[0,i,*], psym=sym(3), color=84, lin=2
   device, /close
  endfor


end
