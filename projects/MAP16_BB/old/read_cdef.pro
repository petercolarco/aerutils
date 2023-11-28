; Colarco, July 2018
; Read the Catchment definitions for 0.5 x 0.5 grid
; From Fanwei and file is here:
; /discover/nobackup/fzeng/bcs/Icarus-NL/Icarus-NL_Reynolds/DE_00720x00360_PE_0720x0360/clsm/catchment.def
; Column 1 is tile index
; Column 3 is the minimum longitude of the grid cell
; Column 4 is the maximum longitude of the grid cell
; Column 5 is the minimum latitude of the grid cell
; Column 6 is the maximum latitude of the grid cell

  pro read_cdef, ntile, lnmax, lnmin, ltmax, ltmin

  openr, lun, '/home/colarco/projects/MAP16_BB/catchment.def', /get_lun
  ncnt = 1L
  readf, lun, ncnt
  data = fltarr(7,ncnt)
  readf, lun, data
  free_lun, lun

; rearrange
  data = transpose(data)
  ntile = data[*,0]
  lnmax = data[*,3]
  lnmin = data[*,2]
  ltmax = data[*,5]
  ltmin = data[*,4]

end
