predictPower<-function(nG,ind, grd){
  fit<-loess(data=data.frame(nG, ind), formula=ind~nG, span=1.3,se=F)
  newdata=data.frame(nG=seq(0.05,0.95,by=0.1)*grd)
   newdata$pwr=predict(fit, newdata, se=F)
   if(!is.na(newdata$pwr[1]) & newdata$pwr[1]>0.8)
	   return(0)
 
  fit2<-loess(data=newdata, formula=nG~pwr, span=1.1)
   predict(fit2, newdata=data.frame(pwr=0.8))[[1]] 
}
