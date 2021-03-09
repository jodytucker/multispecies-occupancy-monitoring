### To run: ####################################################################
##   0.) Download/install Program MARK

##   1.) Set working directory
  #setwd("./publications/finals/mmm_power_analysis/r_code/CarnivoreMonitoring-master") 

##   2.) Make sure required packages are installed
  pck<-c('RMark')
  pck<-pck[!(pck %in% installed.packages()[,"Package"])]
  if(length(pck)) install.packages(pck)
  rm(pck)

##   3.) Make sure R scripts are in working directory
  stopifnot(file.exists(c('./Test_Samples.R', 
                          './AnalysisFun.R',
                          './WeaselFun.R',
                          './WeaselerFun.R')))

##   4.) Set scenario number to run
   #(a) Normal runs
  nRuns=5 
  scenarios_to_test=paste0(1:2) # Code for running multiple scenarios
  species_to_test = lapply(1:length(scenarios_to_test), function(x) c('Fisher','Marten')) 
      PList<-list(n_yrs=11,
                n_visits=10,
                n_visit_test=c(3,5,10),                    
                detP_test = c(0.2, 0.7),                              
                grid_sample=c(0.05,0.25,0.5,0.75,0.95), 
                alt_model=c(0))
  FUN<-list("WeaselFun", T)
  addtext='' 
 
  # b - c can be run depending on the scenario - need to change nRuns and scenario # in scenarios_to_test for each
  # option b is code for the reverse grids (i.e. fisher sampled on a marten sized grid and vice versa)
  # option c runs alternate models for sampling every 2 yrs, 3 yrs, or annual sampling with 20% missing observations
   
  #(b) RevGrid
  # nRuns=5
  # scenarios_to_test = paste0(c(2,8,14,20), '_RevGrid')
  # species_to_test = lapply(1:length(scenarios_to_test), function(x) c('Fisher','Marten'))
  #     PList<-list(n_yrs=11,
  #               n_visits=10,
  #               n_visit_test=c(3,5,10),
  #               detP_test = c(0.2, 0.7),
  #               grid_sample=c(0.05,0.25,0.5,0.75,0.95),
  #               alt_model=c(0))
  # FUN<-list("WeaselFun", T)
  # addtext=''
    
   #(c) AltM runs
  # nRuns=5
  # scenarios_to_test=c(paste0(c(1,2)))
  # species_to_test = lapply(1:length(scenarios_to_test), function(x) c('Fisher','Marten'))
  #    PList<-list(n_yrs=11,
  #               n_visits=10,
  #               n_visit_test=c(5),
  #               detP_test = c(0.2, 0.7),
  #               grid_sample=c(0.05,0.25,0.5,0.75,0.95),
  #               alt_model=c(0:3))
  # FUN<-list("WeaselFun2", T)
  # addtext='_altM'

##   5.) Execute entire file to R console  

################################################################################

# Libraries ####################################################################
library(RMark)

source('./Test_Samples.R')
source('./AnalysisFun.R')
source('./WeaselFun.R')
source('./WeaselerFun.R')

MX<-matrix(rbinom(p=0.2, n=1600*11, size=1),1600,11)
################################################################################ 
for(i in 1:length(scenarios_to_test)){   
  sc=scenarios_to_test[i]
   scN<-gsub('^.*Scenario|_.*$','', sc)
  SPP<-species_to_test[[i]]
  SPP<-SPP[sapply(SPP, function(x) any(grepl(x, dir(path=sc))))]
  stopifnot(length(SPP)>0)

            
  for(j in 1:length(SPP)){
    sp<-SPP[j]
    
    iFile<-paste0('rSPACE_sc',scN,'_',sp,'_x')
    oFile<-paste0(sp,'_Scenario', scN,'_results', addtext, '.txt')
    
    set.seed(1)                                                     
                 
    # 1.) Collate encounter histories across individual types
    for(rn in 1:nRuns){
      outputfiles<-dir(path=sc, pattern=paste0(sp,'._x',rn), full.names=T) 
      dta1<-read.table(outputfiles[1], header=T,colClasses="character")[,seq(1,34,by=3)]
        ch1<-strsplit(apply(dta1[,-1],1,paste, collapse=''),'')                              
      dta2<-read.table(outputfiles[2], header=T,colClasses="character")[,seq(1,34,by=3)]
        ch2<-strsplit(apply(dta2[,-1],1,paste, collapse=''),'')
      
      dta<-data.frame(grd=dta1$grd, V1=1:nrow(dta1), V2=NA, ch=sapply(1:nrow(dta1), 
             function(x) paste(as.numeric(grepl('1',ch1[[x]]) | grepl('1',ch2[[x]])),collapse='')))
      write.table(dta, file=gsub(paste0(sp,'.'), sp, outputfiles[1]), row.names=F, col.names=F)
      rm(dta1,dta2,ch1,ch2,dta,outputfiles)
    }
    
    # 2.) Analyze collated data files
    testReplicates(sc, PList, 
                     base.name=iFile, 
                     function_name=FUN[[1]], jttr=FUN[[2]],
                     results.file=oFile,
                     skipConfirm=T, overwrite=T, 
                     sample_matrix=MX, n_runs=nRuns) 

  }}
  
