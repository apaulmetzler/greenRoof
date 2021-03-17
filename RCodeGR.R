########################################################################
###   Green Roof ordination in vegan                               #####
###     ENV 403 Dr. Chaudhary                                      #####
###      h/t also Dr. Naupaka Zimmerman for data/tips/awesomeness  #####
########################################################################
 
#install the vegan package
#install.packages("vegan", dependencies = TRUE)
library(vegan)

# Set the working directory - this will tell R to get files from a specific folder
# you can then avoid having to bring in data using the Rstudio GUI
setwd("/Users/paulmetzler/Documents/DEPAUL/greenRoof") 

#bring in two data files, one file that lists the species abundances and the other that
# indicates environmental information for each plot

GR.otus <- read.csv("GR_otus.csv", row.names = 1, header = TRUE)
GR.meta <- read.csv("gr_data.csv", row.names = 1, header = TRUE)
GR.meta$grsamplingyear <- as.factor(GR.meta$grsamplingyear)
GR.meta$grinocyear <- as.factor(paste(GR.meta$grinoc,GR.meta$grsamplingyear))


## Let's check out this "species" file!
dim(GR.otus)
head(GR.otus[,1:4],20)

# Let's check out this "environmental" file!
head(GR.meta)
summary(GR.meta)
str(GR.meta)
#interesting! 

# Make an ordination of species
# use the bray-curtis dissimilarity/distiance measure

GR.bray.ord <- metaMDS(GR.otus, distance = "bray", k = 2, trymax = 50)

# give the final stress value for this ordination
GR.bray.ord$stress

#create a stress plot for this ordination
stressplot(GR.bray.ord)

#plot the actual ordination displaying only sites ???? SITES??? -- i think limits it to just plotting samples, not species
plot(GR.bray.ord, display = "sites")


#plot the ordination but make the symbols for sites a little bigger
plot(GR.bray.ord, display = "sites", cex=1.5)

#PNW colors
#install.packages("PNWColors")
library(PNWColors)
#names(pnw_palettes)
#pnw_palette("Lake")

# Then you can modifying the display of the points
# with environmental data from MLM.env
#######YEAR/inoculation#############
# Make an ordination with points color coded according to year
colors.vec <- c("cadetblue3", "cadetblue4","deeppink","deeppink3")
# pal <- pnw_palette("Sunset",n=4)
# pal
plot(GR.bray.ord, type = "n")
points(GR.bray.ord, display = "sites", cex=2, pch = 21, 
       bg = colors.vec[GR.meta$grinocyear])
legend(-1.6,1.1, legend = levels(GR.meta$grinocyear), bty = "n",
                       cex = 2,pch = 21, pt.bg = colors.vec)

#####Plant#####
pal <- pnw_palette("Bay",n=4)
#pal
plot(GR.bray.ord, type = "n")
points(GR.bray.ord, display = "sites", cex=2, pch = 21, 
       bg = pal[GR.meta$grplant])
legend(-1.5,1.1, legend = levels(GR.meta$grplant), bty = "n",
       col = pal, cex = 2, pch = 21, pt.bg = pal)
'
#####Inoc####
pal <- pnw_palette("Bay",n=8, type="discrete")
plot(GR.bray.ord, type = "n")
points(GR.bray.ord, display = "sites", cex=2, pch = 21, 
       bg = pal[GR.meta$grinoc])
legend("topright", legend = levels(GR.meta$grinoc), bty = "n",
       col = pal, cex = 1.5,pch = 21, pt.bg = pal)
'
# another option is exporting NMDS axis scores and doing all
# your graphing in ggplot2 with the following code:
# scores(ord)
# write.csv(scores(ord),"scores.csv")


########################################################################
#----------------------------------------------------------------------- 
# test for significance of year, treatment, cover


###Inoc broken down by year#######
colors.vec2 <- c("cadetblue3", "deeppink","cadetblue4","deeppink3")
boxplot(GR.meta$num_OTUs ~ GR.meta$grinoc*GR.meta$grsamplingyear, 
        at = c(1:2, 4:5),
        col = colors.vec2, 
        names = c("Control","Inoculated","Control","Inoculated"),
        ylab = "Number of Unique ASVs", xlab = NULL)
axis(side = 1, at = c(1.5,4.5), labels = c("2014","2016"), tick = FALSE, padj = 3)


pal <- pnw_palette("Bay",n=8, type="discrete")
colors.vec2 <- c("cadetblue3", "deeppink","cadetblue4","deeppink3")
par(mar=c(7,5,1,1))
par(ann = FALSE)
boxplot(GR.meta$num_OTUs ~ GR.meta$grplant*GR.meta$grinoc*GR.meta$grsamplingyear, 
        col = pal,
        show.names = FALSE,
        ylab = "Number of Unique ASVs", 
        xlab = NULL)
axis(side = 1, at = c(4.5,8.5,12.5), labels = FALSE)
axis(side = 1, at = c(2.5,6.5, 10.5,14.5), labels = c("Control","Inoculated","Control","Inoculated"), tick = FALSE, padj = 0)
axis(side = 1, at = c(4.5, 12.5), labels = c("2014","2016"), tick = FALSE, padj = 3)
legend("topleft", legend = levels(GR.meta$grplant), bty = "n",
       col = pal, cex = 1.5, pch = 21, pt.bg = pal)
?boxplot
?axis
?legend

#####################################################
#Linear model, what factors predict number of ASVs
# test for significance of year, treatment, cover

#install.packages("lme4")
library(lme4)
str(GR.meta)
head(GR.meta)
str(GR.otus)


#####################################################################
#Use this code to find the best variables that explain AMF richness 
#####################################################################


#load package that does AIC and has dredge function
#install.packages("MuMIn")
library(MuMIn)
#########################################################
attach(GR.meta)
head(GR.meta)

###################################################
# multimodel inference using the package MuMIn
#################################################
?get.models
#get models
get.models (ms2)

# get sum of Akaike weights (wi) over all models including that explanatory variable
#response variable = SPORES
?lme

#?#?#?# IDK what the method flag is doing here


fm2 <- lme(num_OTUs~grinoc*grplant*grsamplingyear, random = ~ 1|tray,
           method = "ML")
summary(fm2)


#?#?# Do variables need to be scaled before they are compared?
#?#?# Is it okay that plant cover is not separated into dummy variables?
ms2 <- dredge(fm2)
plot(ms2)
model.avg(ms2, subset = delta < 4)
?model.avg
confset.95p <- get.models(ms2, cumsum(weight) <= .95)
avgmod.95p <- model.avg(confset.95p)
summary(avgmod.95p)
confint(avgmod.95p)
importance (ms2) #why are these values different from above output?




###make the model with the significant terms

mod5 <- lme(num_OTUs~grinoc + grplant + grsamplingyear + grinoc:grsamplingyear, random = ~ 1|tray,
             data = GR.meta, method = "ML")

summary(mod5)
'
mod6 <- lm(num_OTUs~grinoc + grplant + grsamplingyear + grinoc:grsamplingyear,
            data = GR.meta, method = "ML")
mod7 <- lm(num_OTUs~grinoc + grplant + grsamplingyear + grinoc:grsamplingyear,
           data = GR.meta)
mod8 <- lme(num_OTUs~grinoc + grplant + grsamplingyear + grinoc:grsamplingyear, random = ~ 1|tray,
            data = GR.meta)
'

AIC(mod7)
AIC(mod8)
# Scratch paper
?lme

library(nlme)
summary(mod3)
summary(mod4)
AIC(mod2)
AIC(mod3)
BIC(mod2)
BIC(mod3)
help("lmer")
print(mod2, correlation=TRUE)

VarCorr(mod3)
vcov(mod3)
anova(mod4)
mean(subset(GR.meta$num_OTUs, GR.meta$grplant == 'sedum'))
mean(subset(GR.meta$num_OTUs, GR.meta$grplant == 'sandprairie'))
mean(subset(GR.meta$num_OTUs, GR.meta$grplant == 'rockprairie'))
mean(subset(GR.meta$num_OTUs, GR.meta$grplant == 'bare'))











