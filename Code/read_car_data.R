library(data.table)
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)

# Download and read in the data. Note the file has 32,000+ columns and will 
# take a few minutes to read in.
file_loc <- getwd()
url <- "https://drive.google.com/u/0/uc?id=1HnpfG2xj_6EZ7Tgle2QB9Yn_YS7r7uVA&export=download"
download.file(url, paste0(file_loc, "/carspecs.csv"))

cars <- read.csv("carspecs.csv")

# Delete the downloaded file
file.remove("carspecs.csv")

# Transpose data so cols are rows and vice versa
t <- transpose(cars)

# Set the first row as column names
colnames(t) <- t[1,]

# Create uniform column names by removing excess characters. Uses snake_case
car_data <- t
names(car_data) <- tolower(gsub(" ", "_", names(car_data)))
names(car_data) <- gsub(",", "", names(car_data))
names(car_data) <- gsub("-", "", names(car_data))
names(car_data) <- gsub("\\(", "", names(car_data))
names(car_data) <- gsub("\\)", "", names(car_data))

# Create clean list of car names
car_names <- names(cars)
car_names <- gsub("X", "", car_names)
car_names <- gsub("\\.", " ", car_names)

# List of distinct car manufactures/makes
car_make <- c("Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Buick", "Cadillac", "Chevrolet", "Dodge", "Ferrari", 
              "Fiat", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "INFINITI", "Jaguar", "Jeep", "Kia", "Lamborghini", "Land Rover",
              "Lexus", "Lincoln", "Lotus", "Maserati", "Mazda", "McLaren", "Mercedes Benz", "MINI", "Mitsubishi", "Nissan", "Porsche",
              "Ram", "Rolls Royce", "smart", "Subaru", "Tesla", "Toyota", "Volkswagen", "Volvo")


car_data_clean <- car_data %>% 
  dplyr::mutate(make_model = car_names,
                # Extract year from car name
                year = as.numeric(str_extract(make_model, "[0-9]{4}")),
                # Convert msrp to numeric by removing $ and ,
                msrp = as.numeric(stri_replace_all_regex(msrp, c("\\$", ","), replacement = "", vectorize = F)),
                # Converts all columns to numeric
                gas_city = as.numeric(epa_fuel_economy_est__city_mpg),
                gas_hwy = as.numeric(epa_fuel_economy_est__hwy_mpg),
                fuel_economy_estcombined_mpg = as.numeric(fuel_economy_estcombined_mpg),
                passenger_capacity = as.numeric(passenger_capacity),
                passenger_doors = as.numeric(passenger_doors),
                fuel_tank_capacity_approx_gal = as.numeric(fuel_tank_capacity_approx_gal),
                # Extracts just the make and model using regular expresson
                make_model = sub("\\sSpecs", "", str_extract(make_model, "(?<=\\d{4}\\s)\\S+.*(?=\\sSpecs)"))) %>%
  # Filter out data before 2015 and where msrp or gas vars are NA
  dplyr::filter(make_model != "",
                !is.na(msrp),
                !is.na(gas_city),
                !is.na(gas_hwy),
                year >= 2015) %>% 
  dplyr::select(year, make_model, msrp, fuel_economy_estcombined_mpg, gas_city, gas_hwy, engine, epa_class, drivetrain, passenger_capacity, passenger_doors,
                body_style, transmission, fuel_tank_capacity_approx_gal, displacement, front_tire_size,
                rear_tire_size, parking_aid, tire_pressure_monitor, backup_camera)


# Extracts the car make from make_model and creates a `make` var
car_data_clean$make <- sapply(car_data_clean$make_model, function(model) {
  matched_make <- car_make[str_detect(model, car_make)]
  if (length(matched_make) > 0) {
    return(matched_make[1])
  } else {
    return(NA)
  }
})


# Empty vector to store list of regular expressions that removes `make` 
sub_vec <- vector()

for (make in car_make) {
  
  sub_list <- paste0("^", make, "")
  sub_vec <- c(sub_vec, sub_list)
  
}



car_data_final <- car_data_clean %>% 
  # Create column that uses regex to extract model
  dplyr::mutate(model = stri_replace_all_regex(make_model, 
                                               pattern = sub_vec, 
                                               replacement = "", 
                                               vectorize = F)) %>% 
  # Reorder columns
  dplyr::select(year, make_model, make, model, 3:20)

# car_data_final is output as a .RData file called `car_data_final.RData`