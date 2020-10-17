PATH="C:/Users/dsand/OneDrive/Documents/Graduate School/ADM"

fatalities.df<- read.csv(file.path(PATH,"./fatalities_data_accident.csv"), header = TRUE)


fatalities.df.clean<-fatalities.df[c(-1,-2,-3,-4,-7,-10,-11,-12,-13,-14,-15,-18,-20,-21,-24,-25,-26,-27,-28,-29,-32,-34,-35,-38,-39,-41,-42,-52,-53)]
str(fatalities.df.clean)
dim(fatalities.df.clean)



fatalities.df.clean$number_of_fatalities<-factor(fatalities.df.clean$number_of_fatalities)



# Partition Data into training and validation sets using a 70/30 split

set.seed(123)

trainIndex <- createDataPartition(fatalities.df.clean$number_of_fatalities, p = .7, 
                                  list = FALSE, 
                                  times = 1)

fatal.train  <-fatalities.df.clean[ trainIndex,]
fatal.valid  <- fatalities.df.clean[-trainIndex,]


plot(fatal.train$number_of_fatalities, data = fatal.train, pch=ifelse(fatal.train$number_of_fatalities==1,1,3))
legend("topright", c("Acceptor", "non-Acceptor"), pch=c(1,3))
segments(x0=85, x1=45,y0=10,y1=25, col = "red")

lda.model <- linDA(fatal.train[,1:22],fatal.train$number_of_fatalities)
lda.model$functions 
lda.model$scores 
lda.model$classification 


# Making Predictions using the MASS function
# Training model
lda.model.MASS <- lda(number_of_fatalities~.,fatal.train)
lda.model.MASS

#Validation Model
lda.preds <- predict(lda.model.MASS,fatal.valid)
lda.preds$class 
lda.preds$posterior 


#CONFUSION MATRIX

#confusionMatrix using the validation model
# Accuracy = .95
confusionMatrix(lda.preds$class, fatal.valid$number_of_fatalities, positive="1")

