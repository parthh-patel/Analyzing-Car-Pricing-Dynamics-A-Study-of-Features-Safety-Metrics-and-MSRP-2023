# clearing R environment
rm(list = ls())

# importing in the cleaned car specs data
load("Team-18/Data/carspecs.RData")

# Create full model to determine which variables to keep and take out for manual stepwise variable selection
# Removing variables that are duplicates (msrp) or have too many factors to be useful
M1 <- lm(msrp_2019 ~ . -car_year - car_make -car_model -msrp -style -front_tire_size -rear_tire_size,data=carspecs)
summary(M1)

# Looking at the results we can already see some variables that are somewhat significant at the 0.01 significance level
# Those being the car year, epa class, drive train, passenger capacity, doors, transit speed, base weight
# wheelbase, height, fuel tank cap, net torque, fuel system, engine type, transmission, brake type, front tire material,
# front suspension type, brakes abs, child lock, day lights, night vision, roll bars, parking aid, and backup camera.

# Other variables are not at all significant and will be removed from the modeling section
# Those being the body style, combined mpg, city mpg, hwy mpg, net hp, steer type, rear tire material,
# rear suspension type, traction control, tire pressure monitor, and stable control.

# By removing the insignificant variables, we will create M2 with just the significant variables
M2 <- lm(msrp_2019 ~ . -car_year -car_make -car_model -msrp -style -front_tire_size -rear_tire_size -body_style -combined_mpg -city_mpg -hwy_mpg -net_hp -steer_type -rear_tire_mat -rear_sus_type -trac_control -fog_lamps -tp_monitor - stable_control,data=carspecs)
summary(M2)

# From the new model, we can see that some variables remain significant, while new variables have become insignificant at the 0.01 significant level
# The remaining significant variables are epa class, drive train, passenger capacity, base weight, wheelbase, height, fuel tank capacity,
# net torque, engine type, transit description, front suspension, brake abs, child locks, daylights, night vision, rollbars, parking aid,
# and backup camera.

# The insignificant variables are transit speed. We will manually choose to remove brake type due to there being only two choices,
# and one choice is insignificant. We will also remove front suspension as many of the types are insignificant, as well as front tire material.

# By removing the insignificant variables, we will create M3 with just the significant variables
M3 <- lm(msrp_2019 ~ . -car_year -car_make -car_model -msrp -style -front_tire_size -rear_tire_size -body_style -combined_mpg -city_mpg -hwy_mpg -net_hp -steer_type -rear_tire_mat -rear_sus_type -trac_control -fog_lamps -tp_monitor - stable_control -transit_speed -front_tire_mat -front_sus_type,data=carspecs)
summary(M3)

# Not many changes have occured in the significant variables. The only noticeable difference is that transmission description is not as significant.

# We will remove this variable and create M4
M4 <- lm(msrp_2019 ~ . -car_year -car_make -car_model -msrp -style -front_tire_size -rear_tire_size -body_style -combined_mpg -city_mpg -hwy_mpg -net_hp -steer_type -rear_tire_mat -rear_sus_type -trac_control -fog_lamps -tp_monitor - stable_control -transit_speed -front_tire_mat -front_sus_type -transmit_descr,data=carspecs)
summary(M4)

# Based off the final results, we will choose to keep the following variables and for the following reasons:

# EPA Class - most common classification for cars and will serve as a basis for the type of car despite some of the classifications not significant
# Drive Train - one of the more common classifications and has mostly significant variables
# Passenger capacity - significant
# Doors - significant
# Base Weight - significant
# Wheelbase - significant
# Height - significant
# Fuel Tank Cap - significant
# Net Torque - significant
# Fuel System - significant
# Engine Type - most are significant and an important characteristic of cars
# Brake type - significant
# Brakes abs - significant
# Child locks - significant
# Day lights - significant
# Night Vision - significant
# Roll Bars - significant
# Park Aid - significant
# Backup Cam - significant

# Using AIC to determine variables
library(MASS)
stepAIC(M1, direction = "both")

# Using stepAIC for the first model with all variables,
# We can see that the optimal model includes door, stable control, net hp, roll bars, body style,
# brakes, abs, day lights, front tire material, combined mpg, brake type, parking aid, transmission description,
# height, base weight, child locks, fuel system, passenger capacity, backup camera, wheelbase, drive train,
# net torque, epa class, rear suspension type, night vision, fuel tank capacity, front suspension type, and engine type.

stepAIC(M4, direction = "both")

# Using stepAIC for the fourth model with all variables,
# we can see that all of the variables that we have chose are considered as significant using AIC variable selection.

# We can see the significant variables in our step wise vs AIC common chosen variables are epa class, drive train, passenger capacity, doors, base weight,
# wheelbase, height, fuel tank cap, net torque, fuel system, engine type, brake type, brakes abs, child locks, day lights, night vision, roll bars, parking aid, and backup camera. 

# The step AIC suggested that stable control, net hp, body style, front tire mat, combined mpg, transmission description, rear suspension type, and front suspension type are significant. 
# As a result, we will reintroduce each variables into the model to determine if they should be kept.

# Model 5 with stable control
M5 <- lm(msrp_2019 ~ stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M5)
# stable control appears to be significant in this smaller model, thus it will be added to the list of significant variables

# Model 6 with net_hp
M6 <- lm(msrp_2019 ~ net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M6)
# net_hp also appears to be significant in this smaller model, thus it will be added to the list of significant variables

# Model 7 with body style
M7 <- lm(msrp_2019 ~ body_style + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M7)
# body style has some significant variables, but the majority is not significant. Therefore, we will not add it to the list of significant variables.

# Model 8 with front tire material
M8 <- lm(msrp_2019 ~ front_tire_mat + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M8)
# same scenario here with front tire material as with the body style. It has some significant variables, but the majority is not significant. Therefore, we will not add it to the list of significant variables.

# Model 9 with combined mpg
M9 <- lm(msrp_2019 ~ combined_mpg + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M9)
# combined mpg also appears to be significant in this smaller model, thus it will be added to the list of significant variables

# Model 10 with transmission description
M10 <- lm(msrp_2019 ~ transmit_descr + combined_mpg + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M10)
# Neither categories of transmission description are significant. Therefore, we will not add it to the list of significant variables.

# Model 11 with rear_sus_type
M11 <- lm(msrp_2019 ~ rear_sus_type + combined_mpg + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M11)
# Rear suspension type has some significant variables, but the the majority are not significant. Therefore, we will not add it to the list of significant variables.

# Model 12 with front_sus_type
M12 <- lm(msrp_2019 ~ front_sus_type + combined_mpg + net_hp + stable_control + wheelbase + brakes_abs+ passenger_capacity + base_weight + day_lights + roll_bars + backup_cam + brake_type + child_locks + doors + park_aid + height + fuel_system + drive_train + epa_class + fuel_tank_cap + night_vision + net_torque + engine_type,data=carspecs)
summary(M12)
# Front suspension type has some significant variables, but the the majority are not significant. Therefore, we will not add it to the list of significant variables.

# Looking at the data set as a whole, we see that there are few cars that have a response of "No" for both the Brakes ABS and Stability control categories. As a result, we removed these variables as they are not material to our data.

# From the manual and StepAIC function to determine significant variables, we have determined the following variables to be significant.
# 1. EPA Class - - significant
# 2. Drive Train - - significant
# 3. Passenger capacity - significant
# 4. Doors - significant
# 5. Base Weight - significant
# 6. Wheelbase - significant
# 7. Height - significant
# 8. Fuel Tank Cap - significant
# 9. Combined MPG - significant
# 10. Net Torque - significant
# 11. Fuel System - significant
# 12.Engine Type - significant
# 13.Net Hp - significant
# 14.Brake type - significant
# 15.Child locks - significant
# 16.Day lights - significant
# 17.Night Vision - significant
# 18.Roll Bars - significant
# 19.Park Aid - significant
# 20.Backup Cam - significant


# Final model with all significant variables
Model_final <- lm(msrp_2019 ~ epa_class + drive_train + passenger_capacity + doors + base_weight + wheelbase + height + fuel_tank_cap + combined_mpg + net_torque + fuel_system + engine_type + net_hp + fuel_system + engine_type + net_hp + brake_type + child_locks + day_lights + night_vision + roll_bars + park_aid + backup_cam,data=carspecs)
summary(Model_final)

