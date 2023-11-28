  pro hdfreadvar, modeltemplate, dateinp, varlist, varval

    dateu = strcompress(string(dateinp),/rem)
    openr, lun, modeltemplate, /get_lun
    str = 'a'
    readf, lun, str
    free_lun, lun
    split = strsplit(str,/extract)
    ftmp = strsplit(split[1],'%',/extract)
    yyyy = strmid(dateu,0,4)
    mm   = strmid(dateu,4,2)
    dd   = strmid(dateu,6,2)
    hh   = strmid(dateu,8,2)
    filename = ftmp[0]
    for i = 1, n_elements(ftmp)-1 do begin
     strtag = strmid(ftmp[i],0,2)
     strend = strmid(ftmp[i],2,strlen(ftmp[i])-2)
     case strtag of
      'y4': ftmp[i] = yyyy+strend
      'm2': ftmp[i] = mm  +strend
      'd2': ftmp[i] = dd  +strend
      'h2': ftmp[i] = hh  +strend
     endcase
     filename = filename+ftmp[i]
    endfor
    hdfid = hdf_sd_start(filename)
     idx = hdf_sd_nametoindex(hdfid,varlist)
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, varval
    hdf_sd_end, hdfid

end
