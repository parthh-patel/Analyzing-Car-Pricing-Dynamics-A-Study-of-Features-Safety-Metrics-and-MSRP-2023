rm(list = ls())

#install packages and library
library(dplyr)
library(FactoMineR)
library(factoextra)

load("Team-18/Data/carspecs.RData")

#narrowing down to 20 variables
carspecs_filter = subset(carspecs, select = c(msrp_2019,
                                              epa_class, 
                                              drive_train, 
                                              passenger_capacity, 
                                              doors, 
                                              base_weight, 
                                              wheelbase,  
                                              height, 
                                              fuel_tank_cap, 
                                              combined_mpg, 
                                              net_torque, 
                                              fuel_system, 
                                              engine_type, 
                                              net_hp,
                                              fuel_system, 
                                              engine_type, 
                                              net_hp, 
                                              brake_type, 
                                              child_locks, 
                                              day_lights, 
                                              night_vision, 
                                              roll_bars, 
                                              park_aid, 
                                              backup_cam))

#creating dummy variables for each categorical variable
non_integer_columns =  sapply(carspecs_filter, function(x) !is.integer(x))
design_matrix = model.matrix(~ . - 1, carspecs_filter[, non_integer_columns])
carspecs_with_dummies = cbind(carspecs_filter, design_matrix)
carspecs_dummy_final = subset(carspecs_with_dummies, select = -c(epa_class,
                                                                 drive_train,
                                                                 fuel_system,
                                                                 engine_type, 
                                                                 fuel_system.1, 
                                                                 engine_type.1,
                                                                 brake_type,
                                                                 child_locks,
                                                                 day_lights,
                                                                 night_vision,
                                                                 roll_bars,
                                                                 park_aid,
                                                                 backup_cam  ))

#pca analysis
pca_result = prcomp(carspecs_dummy_final, scale. = TRUE)

#results and visualizations
eig.val <- get_eigenvalue(pca_result)
eig.val

fviz_eig(pca_result, addlabels = TRUE, ylim = c(0, 50))
