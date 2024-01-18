load("Team-18/Data/carspecs.RData")

library(dplyr)
library(xgboost)
library(caret)
library(randomForest)
library(xgboost)

# Set randomized seed
set.seed(123)

# Create data frame with only the variables being used in the model
model_data <- carspecs %>% 
  dplyr::select(msrp_2019, epa_class, drive_train, passenger_capacity, doors, 
                wheelbase, height, fuel_tank_cap, city_mpg, hwy_mpg, net_torque,
                fuel_system, engine_type, net_hp, transmit_descr, brake_type,
                steer_type) %>% 
  dplyr::mutate_if(is.character, as.factor) %>% 
  dplyr::mutate_if(is.factor, as.integer)


# Split model into train/validation/test sets
# Takes 60% of entire data set
in_train <- createDataPartition(model_data$msrp_2019, p = 0.6, list = F)
# Create training set that uses 60% of data set
training_set <- model_data[in_train,]
# Data that's not in the training set
holdout <- model_data[-in_train,]
# Create partition that splits remaining data 50/50
partition <- createDataPartition(holdout$msrp_2019, p = 0.5, list = F)
# Validation set
validation_set <- holdout[partition,]
# Test set
test_set <- holdout[-partition,]



##############################################################################
##      Training the models   ##
##############################################################################

# Linear Regression
lr_model <- lm(msrp_2019 ~ ., data = training_set)
summary(lr_model)




# Random Forest
rf_model <- randomForest(formula = msrp_2019 ~ ., data = training_set, 
                                   mtry = 5, importance = TRUE)
summary(rf_model)



# XGBoost
train_x_set <- data.matrix(training_set[,-1])
train_y_set <- data.matrix(training_set[,1])

xgb_training <- xgb.DMatrix(data = train_x_set, label = train_y_set)

xgb_model <- xgboost(data = xgb_training,
                     nrounds = 1500,
                     max_depth = 15,
                     objective = "reg:squarederror",
                     early_stopping_rounds = 5,
                     eta = 0.03)


val_set <- data.matrix(validation_set[,-1])


# Using the models to predict on the validation set
lr_pred <- predict(lr_model, validation_set[,-1])
rf_pred <- predict(rf_model, validation_set[,-1])
xgb_pred <- predict(xgb_model, val_set)




##############################################################################
##      Evaluating the models   ##
##############################################################################

# Function to calc R Squared
rsq <- function(actual, predicted) {
  ssr <- sum((actual - predicted)^2)
  sst <- sum((actual - mean(actual))^2)
  return(1 - ssr/sst)
}

# Combine results of each model into a df with the actual results
model_results <- data.frame(actuals = validation_set$msrp_2019,
                            lr = lr_pred,
                            rf = rf_pred,
                            xgb = xgb_pred)

# Calc R Squared for each model
(validation_r_sq <- data.frame(lr = rsq(model_results$actuals, model_results$lr),
                              rf = rsq(model_results$actuals, model_results$rf),
                              xgb = rsq(model_results$actuals, model_results$xgb)))

# Calc MAPE for each model
(mape_results <- model_results %>% 
  dplyr::mutate(lr_mape = mean(abs((actuals - lr)/actuals)) * 100,
                rf_mape = mean(abs((actuals - rf)/actuals)) * 100,
                xgb_mape = mean(abs((actuals - xgb)/actuals)) * 100) %>% 
  dplyr::distinct(lr_mape, rf_mape, xgb_mape))

##############################################################################
##      Running the models on the test set  ##
##############################################################################

# Running the Random Forest and XG Boost on the test set
rf_test <- predict(rf_model, test_set[-1])

xgb_test_set <- data.matrix(test_set[,-1])

xgb_test <- predict(xgb_model, xgb_test_set)

# Combine actuals and prediction results into df
test_set_results <- data.frame(actuals = test_set$msrp_2019,
                               rf = rf_test,
                               xgb = xgb_test)

# Calc R Squared on test set
(test_r_sq <- data.frame(rf = rsq(test_set_results$actuals, test_set_results$rf),
                         xgb = rsq(test_set_results$actuals, test_set_results$xgb)))

# Calc MAPE on test set
(mape_test_results <- test_set_results %>% 
    dplyr::mutate(rf_mape = mean(abs((actuals - rf)/actuals)) * 100,
                  xgb_mape = mean(abs((actuals - xgb)/actuals)) * 100) %>% 
    dplyr::distinct(rf_mape, xgb_mape))

# Calc MAE on test set
(mae_test_results <- test_set_results %>% 
    dplyr::mutate(rf_mae = mean(abs((actuals - rf))),
                  xgb_mae = mean(abs((actuals - xgb)))) %>% 
    dplyr::distinct(rf_mae, xgb_mae))
