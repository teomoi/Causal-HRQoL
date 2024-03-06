
################################################################################
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
library(BiocManager)
BiocManager::install("Rgraphviz")
library(Rgraphviz)
BiocManager::install("bnlearn")
library(Rgraphviz)

install.packages("bnlearn")
library(bnlearn)
rm(list=ls())
################################################################################

################################################################################
# This is the function that is used for random sample simulation, causal 
# structure estimation using the five constraint-based causal structural 
# learning algorithms, and assessment of the algorithms’ performance.

Estimation<-function(iterations, n, TrueNet, TrueNet.fit){
  SHDestimations<-c(NA)
  HDestimations <-c(NA)
    for(i in 1:iterations){
    print(i)
    sample <- rbn(TrueNet.fit, n)
    #Constraint-Based Learning Algorithm
    #Use each Algorithm separately
    EstimatedNet = pc.stable(sample)
    # EstimatedNet = gs(sample)
    # EstimatedNet = iamb(sample)
    # EstimatedNet = inter.iamb(sample)
    # EstimatedNet = fast.iamb(sample)
    HDestimations[i] <- hamming(EstimatedNet,TrueNet);HDestimations
    SHDestimations[i]<-     shd(EstimatedNet,TrueNet);SHDestimations
    }
  return(list("SHDestimations"=SHDestimations, 
    "number of true arcs"=dim(TrueNet$arcs)[1],
    "mean hamming D"= round(mean(HDestimations),2),
    "Relative mean hamming D"=round(mean(HDestimations)/dim(TrueNet$arcs)[1],2),
    "Sum of 0 HDestimations"= sum(HDestimations==0),
    "mean SHD"      = round(mean(SHDestimations),2),
    "Relative mean SHD"=     round(mean(SHDestimations)/dim(TrueNet$arcs)[1],2),
    "Sum of 0 SHDestimations"= sum(SHDestimations==0)))
}
################################################################################

################################################################################
# Example of usage - DAG 1.

lv = c("1", "2", "3", "4")
cptA = array(c(0.5, 0.2,0.1,0.2), dim = 4, dimnames = list(A = lv));cptA

cptB = array(c(0.1, 0.2,0.1,0.6), dim = 4, dimnames = list(B = lv));cptB

cptC = array(c(0.8,0.1,0.1,0.0,  0.7,0.2,0.1,0.0,  0.3,0.4,0.2,0.1,  0.2,0.3,0.3,0.2,  
               0.75,0.2,0.05,0.0,  0.8,0.1,0.1,0.0,  0.1,0.3,0.5,0.1,  0.1,0.3,0.4,0.2,
               0.2,0.6,0.15,0.05,  0.1,0.4,0.3,0.2,  0.0,0.2,0.7,0.1,  0.0,0.2,0.4,0.4,  
               0.1,0.4,0.4,0.1,  0.1,0.0,0.8,0.1,  0.0,0.1,0.4,0.5,  0.0,0.0,0.1,0.9), 
             dim = c(4, 4, 4),
             dimnames = list(C = lv, A = lv, B = lv) ); cptC

cptD = array(c(0.7,0.2,0.1,0.0,  0.8,0.1,0.1,0.0,  0.2,0.3,0.4,0.1,  0.0,0.0,0.9,0.1), 
             dim = c(4,4), dimnames = list(D = lv, B = lv)); cptD

cptE = array(c(0.7,0.2,0.1,0.0,  0.65,0.25,0.1,0.0,  0.3,0.4,0.2,0.1,  0.2,0.2,0.4,0.2,  
               0.5,0.3,0.2,0.0,  0.75,0.15,0.1,0.0,  0.1,0.3,0.5,0.1,  0.1,0.3,0.4,0.2,
               0.2,0.5,0.2,0.1,  0.1,0.35,0.35,0.2,  0.0,0.3,0.6,0.1,  0.0,0.2,0.3,0.5,  
               0.1,0.4,0.4,0.1,  0.1,0.0,0.75,0.15,  0.0,0.1,0.5,0.4,  0.0,0.0,0.3,0.7), 
             dim = c(4, 4, 4),
             dimnames = list(E = lv, A = lv, B = lv) ); cptE

net1 = model2network("[A][B][D|B][C|A:B][E|A:B]")
graphviz.plot(net1)

cpt = list(A = cptA, B = cptB, C = cptC, D = cptD, E = cptE)
bn1 = custom.fit(net1, cpt, ordinal = c("A", "B", "C", "D", "E"))

# Simulation results.
Estimation100<-  Estimation(1000, 100, net1,bn1);Estimation100
Estimation500<-  Estimation(1000, 500, net1,bn1);Estimation500
Estimation1000<- Estimation(1000, 1000, net1,bn1);Estimation1000
Estimation2000<- Estimation(1000, 2000, net1,bn1);Estimation2000
Estimation5000<- Estimation(1000, 5000, net1,bn1);Estimation5000
Estimation10000<-Estimation(1000, 10000, net1,bn1);Estimation10000
################################################################################






