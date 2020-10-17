attach(Airfares)
dim(Airfares)
str(Airfares)
library(psych)
options(scipen = 999)
summary(Airfares)
corrs <- cor(Airfares[,c(5:6,9:18)])
corrs.matrix <- as.matrix(corrs)
corrplot(corrs.matrix)
corrplot(corrs.matrix, method="number")
corrs <- cor(Airfares[,c(5:6,9:13,16:18)])
corrs.matrix <- as.matrix(corrs)
corrplot(corrs.matrix)
corrplot(corrs.matrix, method="number")
# A ###
##According to the corrolation plot, the biggest numerical predictor for fair is the distance of the flight at r=.75###
Airfares$FARE.bin<- .bincode(Airfares$FARE,,c(5:6,9:13,16:18) )

# B ###
AVS<-lm(FARE~SW)
summary(AVS)
AVV<-lm(FARE~VACATION)
summary(AVV)
aggregate(Airfares$FARE, by=list(Airfares$SW), FUN=mean, na.rm=TRUE)
aggregate(Airfares$FARE, by=list(Airfares$VACATION), FUN=mean, na.rm=TRUE)
aggregate(Airfares$FARE, by=list(Airfares$SLOT), FUN=mean, na.rm=TRUE)
aggregate(Airfares$FARE, by=list(Airfares$GATE), FUN=mean, na.rm=TRUE)

#### The best categorical predictor for Fare is weather or not SW is availible on that route. The difference in the 
#fares when SW is available vs. not available is the greater than the differences in the fares of the other categorical variables 
##


#####c i ####
set.seed(123)
train.dummies<-dummy("VACATION", train)
valid.dummies<-dummy("VACATION", valid)
train.dummies<-dummy("SW", train)
valid.dummies<-dummy("SW", valid)
train.dummies<-dummy("SLOT", train)
valid.dummies<-dummy("GATE", valid)

train<- cbind(train, train.dummies)
valid<- cbind(valid, valid.dummies)

names(valid)
names(train)

TRAIN1<-train.search[,c(-1,-2,-3,-4)]
names(TRAIN1)
VALID1<-valid.search[,c(-1,-2,-3,-4)]
names(VALID1)

train.search<-train[,c(-14,-15)] 
valid.search<-valid[,c(-14,-15)]

#### C ii##
fare.index <- Airfares[order(runif(638)), ]
train <- fare.index[1:510, ]
valid <- fare.index[511:638, ]                            

fare.lm<- lm(FARE~., data=TRAIN1)
summary(fare.lm)

stepreg <- step(fare.lm, direction="both")
summary(stepreg)


## The best estimated model selected is shown as Fare~vacation+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+DISTANCE+PAX+SLOT
#OF the three models produced, this model has the lowest average AIC of the three models. IF we needed to reduce the number
#of predictors, we could rid the model of S_INCOME, E_INCOME, and SLOT, as they have the lowest p values

#C iii###
search <- regsubsets(FARE~.,data=TRAIN1, nbest=1, nvmax=dim(TRAIN1)[2], method="exhaustive")
sum <- summary(search)
sum$which
sum$adjr2
summary(sum)
summary(search)


airfare_lin_exhaust<- lm(FARE~VACATION+SW+HI+DISTANCE+SLOT+GATE)
summary(airfare_lin_exhaust)
airfare_lin_exhaust2<- lm(FARE~VACATION+SW+HI+DISTANCE+SLOT+GATE+PAX)
summary(airfare_lin_exhaust2)

## According to the summary of the search, the best predictors for this exhaustive model include Vacation+SW+HI+Distance+slot+gate
#pax come in a close second, however this variable may be hard/expensive to obtain real-time, and 
#with a low p value it is not as statistically significant, so I would leave it out of my model, as it also brought down the 
##adjusted R square of the model


#C iv ##
library(gains)
##MODEL from ii
airfare_step<-lm(FARE~VACATION+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+DISTANCE+PAX+SLOT)
pred_v <- predict(airfare_step, valid)
accuracy(pred_v, valid$FARE)
summary(airfare_step)
#MODEL ii LIFT
gain.num <-gains(valid$FARE, pred_v, groups=10)

plot(gain.num$depth,gain.num$mean.resp, xlab = "decile", ylab="Mean Response", main = "Decile vs. Mean Response", type = "l")
abline(h=mean(valid$FARE), col="red") #draw a horizontal line showing the naive estimate

barplot(gain.num$mean.resp/mean(valid$FARE), names.arg=gain.num$depth, xlab="Decile", ylab="Mean Response",
        main="Decile-Wise Lift Chart")

gain.num$mean.resp/mean(valid$FARE)
## MODEL ii PREFORMANCE: ME: -2.55, RMSE: 34.23775 MAE: 27.15 Mean response naive estimate ~155, 
#2.04-0.48

##MODEL from iii
pred_v2 <- predict(airfare_lin_exhaust, valid)
accuracy(pred_v2, valid$FARE)
summary(airfare_lin_exhaust)
#MODEL iii LIFT
gain.num2 <-gains(valid$FARE, pred_v2, groups=10)

plot(gain.num2$depth,gain.num2$mean.resp, xlab = "decile", ylab="Mean Response", main = "Decile vs. Mean Response", type = "l")

abline(h=mean(valid$FARE), col="red") #draw a horizontal line showing the naive estimate

barplot(gain.num2$mean.resp/mean(valid$FARE), names.arg=gain.num2$depth, xlab="Decile", ylab="Mean Response",
        main="Decile-Wise Lift Chart")
gain.num2$mean.resp/mean(valid$FARE)

#MODEL iii PREFORMANCE: ME: -1.50 RMSE:35.31 MAE 27.33 Mean response naive estimate ~ 155
#1.93-.54


#COMPAIRING ii (STEPWISE) vs iii (EXHAUSTIVE): 
#ii:Fare~vacation+SW+HI+S_INCOME+E_INCOME+S_POP+E_POP+DISTANCE+PAX+SLOT
#ii preformance: ME: -2.55, RMSE: 34.23775 MAE: 27.15 Mean response naive estimate ~155, 
        #2.04-0.48, adjr^2: .77
#iii:Fare~Vacation+SW+HI+Distance+slot+gate
#iii preformance: ME: -1.50 RMSE:35.31 MAE 27.33 Mean response naive estimate ~ 155
        #1.93-.54, adjr^2: .76
## When comparing these two models there is a lot to account for. I think that the exhaustive model is the best
#out of these two. They both are very close with a >.01 difference in adjusted R^2, ~ $1 difference in RMSE, 
# almost no difference in MAE and their response to naive estimate is approximatly the same. What separates these two
#is the amount of variables that must be accounted for, my exhaustive has less variables, and includes variables that
#can be easily known in order to correctly and cheaply model fares. 

#C v####
#FARE=109-(40.11x0)+(.0085x4442.141)-(47.52x0)+(.08x1976)-(25.06x1)-(26.92x1)=$252.26

#C vi### 
#FARE=109-(40.11x0)+(.0085x4442.141)-(47.52x1)+(.08x1976)-(25.06x1)-(26.92x1)=$204.74
#AVERAGE DIFFERENCE W SW: (-$47.52)

#C vii###
#Variable(s) that would not be able to be predicted before flights include PAX as that data was recorded during a 
#specific timeframe, and would not be sufficient in prediciting current flight fares, this is different than NEW, as
#it is possible to view the new carriers on a route in real-time when lookgin to purchase a ticket. 
#The coupon would be able to be estimated (to a point)
#as it is possible to analyze the data for the need for plane refueling, and also the volume of connecting flights in and 
#out of major hubs. The Herfindahl Index would be able to be estimated as it is calculated in almost real-time.

# C vii### C viii # C x###
#my model only included variables that I thought to be relevent in predicting future fares. In the portion above, each 
#variable that I argued to not be significantly estimated for predicting, is not included in my model, therefore the 
# result is the same as above since the variable values are the same as in C v

##Fare~Vacation+SW+HI+Distance+slot+gate
#FARE=109-(40.11x0)+(.0085x4442.141)-(47.52x0)+(.08x1976)-(25.06x1)-(26.92x1)=$252.26

# D 
#When changing the focus from SouthWest's effect on fares to their effect on the industry, I would take more of a financial
#approach, examining and weighing factors such as the dispersement of market share (HHI), I would analyze the differences
# and the changes in the stock prices, financial activity ratios (i.e. asset turnover),liquidity ratios (cash ratio),
#solvency ratios (debt to equity), and profitability ratios (ROE, ROA) of each individual airline, then compare those changes
#of competitors of Southwests(United) against Southwest's ratios and the industry average, while paying attention to the news 
#and evaluting any responses taken by other airlines. This would allow you to draw wider 
#conclusions about the airline industry as a whole, opposed to just the change in the fares that are derrived from distance,
#cities, and other variables that have a lesser ability to explain Southwests' macro impact. It would still be useful to analyze
#the average fairs and the changes in those averages once Southwest arrives, but these variables tell less about Southwest's
#presence in the industry than do stock prices, HI, and return on assets.

