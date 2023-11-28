; Read the outputs of the time
  files = ['ss450.750km.ddf', 'gpm.750km.ddf', $
           'gpm055.750km.ddf', 'gpm050.750km.ddf', $
           'gpm045.750km.ddf']

;  files = ['gpm.750km.ddf', $
;           'gpm055.750km.ddf', 'gpm050.750km.ddf', $
;           'gpm045.750km.ddf']+'.ss450.750km.ddf'

; Get the nymd compatible
  filetemplate = 'gpm055.750km.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)  
  a = where(nymd gt '20140532' and nymd lt '20141131' and nhms eq '000000')
  filename = filename[a]
  nymd = nymd[a]

  nfile = n_elements(files)

  ntime = n_elements(nymd)
  areas = fltarr(9,ntime,nfile)



  for ifile = 0, nfile-1 do begin
   filename = 'hurricane_region.'+files[ifile]+'.txt'
   openr, lun, filename, /get
   inp = fltarr(9,ntime)
   area = 1.
   readf, lun, area, inp
   free_lun, lun
   areas[*,*,ifile] = inp
  endfor

; Make a plot of the time series of single samples
  position = [ [.025,.55,.225,.9], [.275,.55,.475,.9], [.525,.55,.725,.9], [.775,.55,.975,.9], $
               [.025,.05,.225,.4], [.275,.05,.475,.4], [.525,.05,.725,.4], [.775,.05,.975,.4]   ]
  position = position+.015
  title = ['0 - 3z','3 - 6z','6 - 9z','9 - 12z','12 - 15z','15 - 18z','18 - 21z','21 - 24z']


  for ii = 0, nfile-1 do begin
   set_plot, 'ps'
   device, file='plot_hurricane_region.time.'+files[ii]+'.750km.ps', /color, xsize=30, ysize=14, $
    font_size=10, /helvetica
   !p.font=0

   mm = ' (mean = '+string(mean(areas[0,*,ii]/area),format='(f5.3)')+')'
   plot, areas[0,*,ii]/area, yrange=[0,.6], title=title[0]+mm, position=position[*,0], $
    xtitle='day number', ytitle='fractional area'

   for ij = 1, 7 do begin
     mm = ' (mean = '+string(mean(areas[ij,*,ii]/area),format='(f5.3)')+')'
     plot, areas[ij,*,ii]/area, yrange=[0,.6], title=title[ij]+mm, position=position[*,ij], /noerase, $
      xtitle='day number', ytitle='fractional area'
   endfor

   device, /close

  endfor

  device, /close

end
