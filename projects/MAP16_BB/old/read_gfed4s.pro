PRO read_gfed4s, yy, mm, g4lats, g4lons, burn_g4s, cemiss_g4s, part, basis_regions 

path='/nfs3m/archive/sfa_cache06/users/g05/mfcook/GFED4/'
file=path+'GFED4.1s_'+yy+'.hdf5'

;res=H5_PARSE('discoveraq-HSRL_UC12_20110701_R2_L1_sub.h5',/READ_DATA)
;help,res,/structure
;filename='/gpfsm/dnb52/projects/p33/mfcook/HSRL/discoveraq-HSRL_UC12_20110701_R2_L1_sub.h5'

groups=['C_AGRI','C_BORF','C_DEFO','C_PEAT','C_SAVA','C_TEMF']
ng=n_elements(groups)

;xx=1440
;yy=720

file_id=H5F_OPEN(file)
	
data_id=H5D_OPEN(file_id, '/emissions/'+mm+'/C')		;gC/m2/month
cemiss_g4s = h5D_READ(data_id)
H5D_CLOSE, data_id

part=fltarr(1440,720,ng)
FOR jji=0,ng-1 DO BEGIN
	data_id=H5D_OPEN(file_id, '/emissions/'+mm+'/partitioning/'+groups(jji))		
	tpart = h5D_READ(data_id)
	part(*,*,jji)=tpart
	H5D_CLOSE, data_id
ENDFOR

data_id=H5D_OPEN(file_id, '/burned_area/'+mm+'/burned_fraction')
burn_g4s=h5D_READ(data_id)
H5D_CLOSE, data_id

data_id=H5D_OPEN(file_id, '/lat')		
g4lats = h5D_READ(data_id)
H5D_CLOSE, data_id

data_id=H5D_OPEN(file_id, '/lon')		
g4lons = h5D_READ(data_id)
H5D_CLOSE, data_id

data_id=H5D_OPEN(file_id, '/ancill/basis_regions/')
basis_regions = h5D_READ(data_id)
H5D_CLOSE, data_id


;data_id=H5D_OPEN(file_id, '/biosphere/'+mm+'/BB')		;gC/m2/month (this is the same as cemiss)
;cbios_gfed4 = h5D_READ(data_id)
;H5D_CLOSE, data_id

;0: Ocean
;1: BONA
;2: TENA
;3: CEAM 
;4: NHSA
;5: SHSA
;6: EURO
;7: MIDE
;8: NHAF
;9: SHAF
;10: BOAS
;11: CEAS
;12: SEAS
;13: EQAS
;14: AUST



RETURN
END
