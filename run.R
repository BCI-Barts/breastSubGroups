#------------------------------------------------------
library(GSVA)
library(ggplot2)
library(reshape2)
#------------------------------------------------------
emat<-read.table("exprs.txt",header=T,row.names=1)
pheno<-read.table("groups.txt",header=T)
#------------------------------------------------------
means<-apply(emat,1,mean)
sd<-apply(emat,1,sd)
#------------------------------------------------------
emat.norm<-emat-means
#------------------------------------------------------
load("immGen.Rda")
#------------------------------------------------------
orig.gsva<-t(gsva(as.matrix(emat),immGenENSG,abs.ranking=F,method="gsva"))
orig.ssgsea<-t(gsva(as.matrix(emat),immGenENSG,abs.ranking=F,method="ssgsea"))
#------------------------------------------------------
norm.gsva<-t(gsva(as.matrix(emat.norm),immGenENSG,abs.ranking=F,method="gsva"))
norm.ssgsea<-t(gsva(as.matrix(emat.norm),immGenENSG,abs.ranking=F,method="ssgsea"))
#------ calculate group means -------------------------
group.means.orig.gsva<-NULL
group.means.orig.ssgsea<-NULL
for(i in 1:max(pheno$Cluster)){ 
                                m<-match(rownames(pheno)[which(pheno$Cluster==i)],colnames(emat))
                                group.means.orig.gsva<-cbind(group.means.orig.gsva,apply(norm.gsva[m,],2,mean))
                                group.means.orig.ssgsea<-cbind(group.means.ssgsea,apply(norm.ssgsea[m,],2,mean))
                              }
#--------------------------------------------------------
rownames(group.means.orig.gsva)<-names(immGenENSG)
colnames(group.means.orig.ssgsea)<-paste("Cluster",i,sep="")
write.table(group.means.orig.gsva,file="group_means_orig_gsva.txt",quote=F,row.names=F,sep="\t")
write.table(group.means.orig.ssgsea,file="group_means_orig_ssgsea.txt",quote=F,row.names=F,sep="\t")
#------------------------------------------------------
results<-melt(norm.gsva)
results<-cbind(results,melt(orig.gsva))
results<-cbind(results,melt(orig.ssgsea))
results<-cbind(results,melt(norm.ssgsea))
results<-cbind(results,pheno$Cluster)
results<-results[,c(1:2,grep("value",ignore.case=T,colnames(results)))]
write.table(results,file="all_results.txt",quote=F,row.names=F,sep="\t")
#------------------------------------------------------
plotdata<-as.data.frame(results)
plotdatanorm<-apply(plotdatanorm,1,mean)
#------------------------------------------------------
save.image(file="results.Rda")
#------------------------------------------------------

