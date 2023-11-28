PRO GFED4_for_CCM,dodaily=dodaily
  ; process and write GFED4 emissions for the GMI CCM component

  yeari = 2020 ;1999
  yearf = 2020 ;2014
  nyrs = yearf - yeari + 1

  IF not keyword_set(dodaily) THEN dodaily=0
  
  for yy = yeari,yearf do begin
print, yy
     read_GFED4,yy,filen,glons,glats,bbarr ;kg/m2/s

     IF dodaily THEN BEGIN
        
        ; establish dimnesion info
        bbsize = size(bbarr)
        nlons = bbsize[1] & nlats = bbsize[2] & nspec = bbsize[4]
        dayspermo = [31,28,31,30,31,30,31,31,30,31,30,31]
        IF (yy mod 4) eq 0 THEN dayspermo[1] = 29

        ; loop over months
        for mm = 1,12 do begin
           dpermo = dayspermo[mm-1]
           read_daily,filen,mm,nlons,nlats,dpermo,dfracmo

           ; loop over days
           for dd=0,dpermo-1 do begin
              daybb = reform(bbarr[*,*,mm-1,*]) * $
                      rebin(dfracmo[*,*,dd],nlons,nlats,nspec) * dpermo
              write_GFED4_daily,yy,mm,dd+1,glons,glats,daybb
           endfor ;dd

        endfor                  ;mm

     ;   stop
        
     ENDIF ELSE write_GFED4_CCM,yy,glons,glats,bbarr

  endfor                        ;yy

END

;******************************************************************
PRO read_GFED4,year,filen,glons,glats,bbarr
  ; read GFED4 burned area and apply
  ; emission factors to get trace gas emissions

  daysinmo = [31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31.]
  IF (year mod 4) eq 0 THEN daysinmo[1] = 29.
  
  sources = ['SAVA','BORF','TEMF','DEFO','PEAT','AGRI']
  nsources = n_elements(sources)
  
  fpath = '/misc/sas01/emissions/GFED4/'
  fpath = '/misc/prc14/colarco/GFED/
  ystr = string(year,'(I4)')
  filen = fpath + 'GFED4.1s_' + ystr + '.hdf5' 
  facfile = fpath + 'GFED4_Emission_Factors.txt'

  ; read in emission factors
  fldnames = 'FIELD' + string(indgen(7)+1,'(I1)')
  tmpi={version:float(1),datastart:0,delimiter:byte(32),missingvalue:-999 $
        ,commentsymbol:'#',fieldcount:7,fieldtypes:[7,4,4,4,4,4,4] $
        ,fieldnames:['species','factor',fldnames[2:6]] $
        ,fieldlocations:[0,20,29,38,47,56,65],fieldgroups:[0,1,1,1,1,1,1]}
  emfacs = read_ascii(facfile,template=tmpi) ;gSpc/kgDM
  
  ; read coords
  GET_H5_DATASET,lonarr,FILE=filen,NAME='lon' ;1440x720 array
  GET_H5_DATASET,latarr,FILE=filen,NAME='lat' ;1440x720 array
  coordsize = size(lonarr)
  nlons = coordsize[1] & nlats = coordsize[2]
  glons = lonarr[*,10]

  ; gridbox area
  GET_H5_DATASET,aream2,FILE=filen,NAME='ancill/grid_cell_area'
  
  ; loop over months reading emissions
  DMsrcarr = fltarr(nlons,nlats,12,nsources) ;lon x lat x month x source
  for mm=1,12 do begin
     
     IF mm lt 10 THEN mostr = '0' + string(mm,'(I1)') ELSE mostr = $
        string(mm,'(I2)')
     emdir = 'emissions/' + mostr + '/'
     
     ; read DM emissions
     GET_H5_DATASET,em_DM,FILE=filen,NAME=emdir+'DM' ;kg/m2/mo

     ; read source partitioning
     pdir = emdir + 'partitioning/'
     for ss = 0,nsources-1 do begin
        GET_H5_DATASET,sfrac,FILE=filen,NAME=pdir+'DM_'+sources[ss]
        ; store DM from this source (DM emissions * source contribution) 
        DMsrcarr[*,*,mm-1,ss] = em_DM * sfrac ;kg/m2/mo
     endfor  ;ss

  endfor  ;mm

  ; flip the latitudes to make them S-->N
  DMsrcs = reverse(DMsrcarr,2)
  glats = reverse(reform(latarr[0,*]))
  
  ; calculate emissions of each specie
;  bbnames = ['NO','CO','MEK','PRPE','C2H6','C3H8','ALK4','ALD2','CH2O','ACET']
;  g4names = ['NOx','CO','MEK','C3H6','C2H6','C3H8','Higher_Alkanes','C2H4O' $
;             ,'CH2O','C3H6O'] ;GFED names matching model tracer names
  bbnames = ['BC','OC','CO','SO2','CO2','NH3']
  g4names = bbnames
  nbb = n_elements(bbnames)
  bbarr = fltarr(nlons,nlats,12,nbb)
  ; loop over BB species
  for bb = 0,nbb-1 do begin
     ; select emission factor for this specie
     isspc = where(emfacs.SPECIES eq g4names[bb],/NULL)
  ;   print,bbnames[bb],emfacs.SPECIES[isspc]
     emfs = emfacs.FACTOR[*,isspc]
     ; special case of propene
     IF bbnames[bb] eq 'PRPE' THEN BEGIN
        isspc2 = where(emfacs.SPECIES eq 'Higher_Alkenes',/NULL)
        emfs = emfs + emfacs.FACTOR[*,isspc2]
     ENDIF ;prpe
     ; apply for each source
     trcem = DMsrcs[*,*,*,0] * emfs[0] ;gSpec/m2/mo
     for ss = 1,nsources-1 do trcem = trcem + (DMsrcs[*,*,*,ss] * emfs[ss])
     ; store in multi-species array and convert to kg/m2/mo
     bbarr[*,*,*,bb] = trcem * 1.E-3 
  endfor ;bb

  ; convert kg/m2/mo to kg/m2/s
  for mm=0,11 do bbarr[*,*,mm,*] = bbarr[*,*,mm,*] / (daysinmo[mm]*24.* 3.6E3)

;  stop
END

;************************************************************************
PRO read_daily,filen,month,nlons,nlats,dpermo,dfracmo
                                ; read in daily scale factors for
                                ; daily GFED emissions for a given month

  ; initialize array to hold daily fraction maps for month
  dfracmo = fltarr(nlons,nlats,dpermo)
  
  ; read in daily fractions
  IF month lt 10 THEN mostr = '0' + string(month,'(I1)') ELSE mostr = $
        string(month,'(I2)')
  emdir = 'emissions/' + mostr + '/'
  ddir = emdir + 'daily_fraction/'
  for dd = 1,dpermo do begin

     dvar = 'day_' + strtrim(string(dd),2)
     GET_H5_DATASET,dfrac,FILE=filen,NAME=ddir+dvar ;fraction
     ; flip latitudes to be south to north and store this day
     dfracmo[*,*,dd-1] = reverse(dfrac,2)

  endfor                        ;dd

;  stop
END 
     

;************************************************************************
PRO write_GFED4_CCM,year,glons,glats,bbarr

  ; write out GFED4 emissions in CCM format

  ; filename
;  outpath = '/misc/sas01/emissions/GFED4/forCCM/'
  outpath = '/misc/prc14/colarco/GFED/'
  outbase = 'GFED4_BBemiss_'
  fend = '_t12.nc'
  outname = outpath + outbase + string(year,'(I4)') + fend
  cID = ncdf_create(outname,/clobber)

  ; coord info
  times = long(indgen(12)*30.5*24.*60.) ;minutes
  ntimes = 12
  nlons = n_elements(glons)
  nlats = n_elements(glats)

   ; write global attributes
   title = 'GFEDv4.1s ' + string(year,'(I4)') +' Emissions for the CCM'
   source='GFEDv4.1s (http://www.falw.vu/~gwerf/GFED/GFED4/)'
   contact='Sarah Strode USRA NASA GSFC Sarah.A.Strode@nasa.gov'
   history='File written by GFED4_for_CCM.pro'
   ncdf_attput,cID,'Title',title,/global
   ncdf_attput,cID,'Source',source,/global
   ncdf_attput,cID,'Contact',contact,/global
   ncdf_attput,cID,'History',history,/global

   ; define dimensions
   londimID = ncdf_dimdef(cID,'lon',nlons)
   latdimID = ncdf_dimdef(cID,'lat',nlats)
   tdimID = ncdf_dimdef(cID,'time',ntimes)

   ; define variables
   lonID = ncdf_vardef(cID,'lon',londimID,/float)
   latID = ncdf_vardef(cID,'lat',latdimID,/float)
   timeID = ncdf_vardef(cID,'time',tdimID,/long)
;   NObbID = ncdf_vardef(cID,'NO_bb',[londimID,latdimID,tdimID],/float)
   CObbID = ncdf_vardef(cID,'CO_bb',[londimID,latdimID,tdimID],/float)
   BCbbID = ncdf_vardef(cID,'BC_bb',[londimID,latdimID,tdimID],/float)
   OCbbID = ncdf_vardef(cID,'OC_bb',[londimID,latdimID,tdimID],/float)
   CO2bbID = ncdf_vardef(cID,'CO2_bb',[londimID,latdimID,tdimID],/float)
   SO2bbID = ncdf_vardef(cID,'SO2_bb',[londimID,latdimID,tdimID],/float)
   NH3bbID = ncdf_vardef(cID,'NH3_bb',[londimID,latdimID,tdimID],/float)
;   MEKbbID = ncdf_vardef(cID,'MEK_bb',[londimID,latdimID,tdimID],/float)
;   PRPEbbID = ncdf_vardef(cID,'PRPE_bb',[londimID,latdimID,tdimID],/float)
;   C2H6bbID = ncdf_vardef(cID,'C2H6_bb',[londimID,latdimID,tdimID],/float)
;   C3H8bbID = ncdf_vardef(cID,'C3H8_bb',[londimID,latdimID,tdimID],/float)
;   ALK4bbID = ncdf_vardef(cID,'ALK4_bb',[londimID,latdimID,tdimID],/float)
;   ALD2bbID = ncdf_vardef(cID,'ALD2_bb',[londimID,latdimID,tdimID],/float)
;   CH2ObbID = ncdf_vardef(cID,'CH2O_bb',[londimID,latdimID,tdimID],/float)
;   ACETbbID = ncdf_vardef(cID,'ACET_bb',[londimID,latdimID,tdimID],/float)

   ; add attributes to the dimension variables
   ncdf_attput,cID,timeID,'long_name','time'
   ncdf_attput,cID,timeID,'units', $
               'minutes since ' + string(year,'(I4)') + '-01-15 12:00:00'
   startdate = long(year*1.D4+0115)
   ncdf_attput,cID,timeID,'time_increment',7320000
   ncdf_attput,cID,timeID,'begin_date',startdate
   ncdf_attput,cID,timeID,'begin_time',120000
   ncdf_attput,cID,latID,'long_name','latitude'
   ncdf_attput,cID,latID,'units','degrees_north'
   ncdf_attput,cID,lonID,'long_name','longitude'
   ncdf_attput,cID,lonID,'units','degrees_east'

   ; add attributes to tracer variables
;   bbnames = ['NO','CO','MEK','PRPE','C2H6','C3H8','ALK4','ALD2','CH2O','ACET']
   bbnames = ['BC','OC','CO','SO2','CO2','NH3']
   trcnames = bbnames + '_bb'
;   longnames = ['Nitric oxide from biomass burning' $
;              ,'Carbon monoxide from biomass burning' $
;              ,'C3 ketones (C4H8O) from biomass burning' $
;              ,'Propene (C3H6+higher alkenes) from biomass burning' $
;              ,'Ethane from biomass burning' $
;              ,'Propane from biomass burning' $
;              ,'C4,5 alkanes (C4H10) from biomass burning' $
;              ,'Acetaldehyde (C2H4O) from biomass burning' $
;              ,'Formalydehyde from biomass burning' $
;              ,'Acetone from biomass burning']
   longnames = ['Black carbon from biomass burning', $
                'Organic carbon from biomass burning', $
                'Carbon monoxide from biomass burning', $
                'Sulfur dioxide from biomass burning', $
                'Carbon dioxide from biomass burning', $
                'Ammonia from biomass burning']
   
   badval = 1.D15
   nemis = n_elements(trcnames)
   for nn = 0,nemis-1 do begin
      ncdf_attput,cID,trcnames[nn],'long_name',longnames[nn]
      ncdf_attput,cID,trcnames[nn],'units','kg m^(-2) s^(-1)'
      ncdf_attput,cID,trcnames[nn],'_FillValue',badval,/float
      ncdf_attput,cID,trcnames[nn],'missing_value',badval,/float
      ncdf_attput,cID,trcnames[nn],'fmissing_value',badval,/float
      ncdf_attput,cID,trcnames[nn],'vmin',badval,/float
      ncdf_attput,cID,trcnames[nn],'vmax',badval,/float
   endfor                       ;nn

   ; write data
   ncdf_control,cID,/endef
   ncdf_varput,cID,timeID,times
   ncdf_varput,cID,lonID,glons
   ncdf_varput,cID,latID,glats
   for nn = 0,nemis-1 do ncdf_varput,cID,trcnames[nn],bbarr[*,*,*,nn]

   ncdf_close,cID

;   stop
END

;************************************************************************
PRO write_GFED4_daily,year,month,day,glons,glats,daybb
  ; write out GFED4 emissions in CCM format

  ; filename
  outpath = '/misc/sas01/emissions/GFED4/forCCM/daily/'
  outbase = 'GFED4_BBemiss_'
  fend = '.nc4'
  IF month lt 10 THEN mostr = '0' + string(month,'(I1)') ELSE mostr = $
     string(month,'(I2)')
  IF day lt 10 THEN daystr = '0' + string(day,'(I1)') ELSE daystr = $
     string(day,'(I2)')
  outname = outpath + outbase + string(year,'(I4)') + mostr + daystr +fend
  cID = ncdf_create(outname,/clobber,/NETCDF4_FORMAT)

  ; coord info
  ntimes = 1
  times = 0
  nlons = n_elements(glons)
  nlats = n_elements(glats)

   ; write global attributes
   title = 'GFEDv4.1s ' + string(year,'(I4)') +' Daily Emissions for the CCM'
   source='GFEDv4.1s (http://www.falw.vu/~gwerf/GFED/GFED4/)'
   contact='Sarah Strode USRA NASA GSFC Sarah.A.Strode@nasa.gov'
   history='File written by GFED4_for_CCM.pro'
   ncdf_attput,cID,'Title',title,/global,/char
   ncdf_attput,cID,'Source',source,/global,/char
   ncdf_attput,cID,'Contact',contact,/global,/char
   ncdf_attput,cID,'History',history,/global,/char

   ; define dimensions
   londimID = ncdf_dimdef(cID,'lon',nlons)
   latdimID = ncdf_dimdef(cID,'lat',nlats)
   tdimID = ncdf_dimdef(cID,'time',/unlimited)

   ; define variables
   lonID = ncdf_vardef(cID,'lon',londimID,/float)
   latID = ncdf_vardef(cID,'lat',latdimID,/float)
   timeID = ncdf_vardef(cID,'time',tdimID,/long)
;   NObbID = ncdf_vardef(cID,'NO_bb',[londimID,latdimID,tdimID],/float)
   CObbID = ncdf_vardef(cID,'CO_bb',[londimID,latdimID,tdimID],/float)
   BCbbID = ncdf_vardef(cID,'BC_bb',[londimID,latdimID,tdimID],/float)
   OCbbID = ncdf_vardef(cID,'OC_bb',[londimID,latdimID,tdimID],/float)
   CO2bbID = ncdf_vardef(cID,'CO2_bb',[londimID,latdimID,tdimID],/float)
   SO2bbID = ncdf_vardef(cID,'SO2_bb',[londimID,latdimID,tdimID],/float)
   NH3bbID = ncdf_vardef(cID,'NH3_bb',[londimID,latdimID,tdimID],/float)
;   MEKbbID = ncdf_vardef(cID,'MEK_bb',[londimID,latdimID,tdimID],/float)
;   PRPEbbID = ncdf_vardef(cID,'PRPE_bb',[londimID,latdimID,tdimID],/float)
;   C2H6bbID = ncdf_vardef(cID,'C2H6_bb',[londimID,latdimID,tdimID],/float)
;   C3H8bbID = ncdf_vardef(cID,'C3H8_bb',[londimID,latdimID,tdimID],/float)
;   ALK4bbID = ncdf_vardef(cID,'ALK4_bb',[londimID,latdimID,tdimID],/float)
;   ALD2bbID = ncdf_vardef(cID,'ALD2_bb',[londimID,latdimID,tdimID],/float)
;   CH2ObbID = ncdf_vardef(cID,'CH2O_bb',[londimID,latdimID,tdimID],/float)
;   ACETbbID = ncdf_vardef(cID,'ACET_bb',[londimID,latdimID,tdimID],/float)

   ; add attributes to the dimension variables
   ncdf_attput,cID,timeID,'long_name','time',/char
   ncdf_attput,cID,timeID,'units', $
      'minutes since ' + string(year,'(I4)') + '-' + mostr + '-' + daystr $
              + ' 12:00:00',/char
   startdate = long(year*1.D4+month*1.D2 + day)
   ncdf_attput,cID,timeID,'time_increment',240000
   ncdf_attput,cID,timeID,'begin_date',startdate
   ncdf_attput,cID,timeID,'begin_time',120000
   ncdf_attput,cID,latID,'long_name','latitude',/char
   ncdf_attput,cID,latID,'units','degrees_north',/char
   ncdf_attput,cID,lonID,'long_name','longitude',/char
   ncdf_attput,cID,lonID,'units','degrees_east',/char

   ; add attributes to tracer variables
;   bbnames = ['NO','CO','MEK','PRPE','C2H6','C3H8','ALK4','ALD2','CH2O','ACET']
   bbnames = ['BC','OC','CO','SO2','CO2','NH3']
   trcnames = bbnames + '_bb'
;   longnames = ['Nitric oxide from biomass burning' $
;              ,'Carbon monoxide from biomass burning' $
;              ,'C3 ketones (C4H8O) from biomass burning' $
;              ,'Propene (C3H6+higher alkenes) from biomass burning' $
;              ,'Ethane from biomass burning' $
;              ,'Propane from biomass burning' $
;              ,'C4,5 alkanes (C4H10) from biomass burning' $
;              ,'Acetaldehyde (C2H4O) from biomass burning' $
;              ,'Formalydehyde from biomass burning' $
;              ,'Acetone from biomass burning']
   longnames = ['Black carbon from biomass burning', $
                'Organic carbon from biomass burning', $
                'Carbon monoxide from biomass burning', $
                'Sulfur dioxide from biomass burning', $
                'Carbon dioxide from biomass burning', $
                'Ammonia from biomass burning']
   
   badval = 1.D15
   nemis = n_elements(trcnames)
   for nn = 0,nemis-1 do begin
      ncdf_attput,cID,trcnames[nn],'long_name',longnames[nn],/char
      ncdf_attput,cID,trcnames[nn],'units','kg m^(-2) s^(-1)',/char
      ncdf_attput,cID,trcnames[nn],'_FillValue',badval,/float
      ncdf_attput,cID,trcnames[nn],'missing_value',badval,/float
      ncdf_attput,cID,trcnames[nn],'fmissing_value',badval,/float
      ncdf_attput,cID,trcnames[nn],'vmin',badval,/float
      ncdf_attput,cID,trcnames[nn],'vmax',badval,/float
   endfor                       ;nn

   ; write data
   ncdf_control,cID,/endef
   ncdf_varput,cID,timeID,times
   ncdf_varput,cID,lonID,glons
   ncdf_varput,cID,latID,glats
   for nn = 0,nemis-1 do ncdf_varput,cID,trcnames[nn],daybb[*,*,nn]

   ncdf_close,cID

 ;  stop
END
