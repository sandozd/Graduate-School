RF INJURY CODE:
library(caret)
library(rpart.plot)
library(adabag)
library(uplift)
library(pls)
library(ggplot2)
library(ggrepel)
library(randomForest)

######INJURY RANDOM FORESTS######
attach(Accidents)

#preprocessing into factors
Rush<-as.factor(RUSH_HR)
Alc<- as.factor(ALCOHOL)
Roadalign<-as.factor(ROAD_ALIGN)
Zone<-as.factor(WORK_ZONE)
Week<-as.factor(WEEKDAY)
HWY<-as.factor(INT_HWY)
Light<-as.factor(LIGHT_COND)
Coll<-as.factor(MANCOL)
Pedestrian<-as.factor(PED_CYCLIST)
Int<-as.factor(INTERSTATE)
Road<- as.factor(ROADWAY)
R.Profile<-as.factor(ROAD_PROFILE)
Speed<- as.factor(SPEED_LIMIT)
Conditions<- as.factor(SURFACE_COND)
Traffic.C<- as.factor(TRAFFIC_CTRL)
Traffic.W<- as.factor(TRAFFIC_WAY)
Weather<- as.factor(ADVERSE_WEATHER)
Injury.c<- as.factor(INJURY_CRASH)
Property.d<- as.factor(PROPERTY_DMG)
Area.r <-as.factor(REGION)

Accidents.factors<- data.frame(Rush,Alc,Roadalign,Zone,Week,HWY,Light,Coll,Pedestrian,Int,Road,R.Profile,Speed,Conditions,Traffic.C,Traffic.W,VEH_INVL,Weather,Injury.c,Property.d,Area.r)
Accidents.factors
str(Accidents.factors)


#target variable to front--- INJURY
Injury1<-Accidents.factors[,c(19,1:18,20:21)]
View(Injury1)


# taking out property damage, 
Injury.df<-Injury1[,c(-20,-21,-10,-2,-5,-13)]
View(Injury.df)


trainIndex <- createDataPartition(Injury.df$Injury.c, p = .8,list = FALSE,times = 1)
head(trainIndex)
injury_train.set <- Injury.df[trainIndex,]
injury_validate.set <- Injury.df[-trainIndex,]

RF.model <-randomForest(Injury.c ~.,data=injury_train.set, mtry=3, ntree=500,na.action = na.omit, importance=TRUE) #default to try three predictors at a time and create 500 trees. 
print(RF.model) 
importance(RF.model)  
varImpPlot(RF.model) 


injury_actual<-injury_validate.set$Injury.c 
injury_predicted <-predict(RF.model, injury_validate.set, type="class") 


CM <-confusionMatrix(injury_predicted, injury_actual, positive="1") 
print(CM)
