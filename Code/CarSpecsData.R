library(dplyr)

carspecs <- read.csv("C:/Users/Chang/Desktop/Classes/MGT 6203/Project/CarSpecs.csv")

carspecs2 <- carspecs %>%
  rename(
    car_year = Car.Year,
    car_make = Car.Make,
    car_model = Car.Model,
    msrp = MSRP,
    msrp_2019 = X2019MSRP,
    epa_class = EPA.Class,
    style = Style.Name,
    drive_train = Drive.Train,
    passenger_capacity = Passenger.Capacity,
    doors = Passenger.Doors,
    body_style = Body.Style,
    transit_speed = Transmittion.Speed,
    base_weight = Base.Curb.Weight,
    wheelbase = Wheelbase,
    height = Height.Overall,
    fuel_tank_cap = Fuel.Tank.Capacity,
    combined_mpg = Combined.Estimate.MPG,
    city_mpg = City.MPG,
    hwy_mpg = Hwy.MPG,
    net_torque = SAE.Net.Torque,
    fuel_system = Fuel.System,
    engine_type = Engine.Type,
    net_hp = SAE.Net.Horsepower,
    transmit_descr = Transmittion.Description,
    brake_type = Brake.Type,
    steer_type = Steering.Type,
    front_tire_size = Front.Tire.Size,
    rear_tire_size = Rear.Tire.Size,
    front_tire_mat = Front.Tire.Material,
    rear_tire_mat = Back.Tire.Material,
    front_sus_type = Suspension.Type.Front,
    rear_sus_type = Suspension.Type.Rear,
    brakes_abs = Brakes.ABS,
    child_locks = Child.Safety.Rear.Door.Locks,
    day_lights = Daytime.Running.Lights,
    trac_control = Traction.Control,
    night_vision = Night.Vision,
    roll_bars = Rollover.Protection.Bars,
    fog_lamps = Fog.Lamps,
    park_aid = Parking.Aid,
    tp_monitor = Tire.Pressure.Monitor,
    backup_cam = BackUp.Camera,
    stable_control = Stability.Control 
  )


carspecs2

print(sapply(carspecs2,class))

carspecs <- carspecs2 %>% mutate_at(c('car_year', 
                                      'msrp',
                                      'msrp_2019',
                                      'passenger_capacity', 
                                      'doors', 
                                      'transit_speed', 
                                      'base_weight', 
                                      'wheelbase', 
                                      'height', 
                                      'fuel_tank_cap', 
                                      'combined_mpg', 
                                      'city_mpg', 
                                      'hwy_mpg', 
                                      'net_torque', 
                                      'net_hp'), as.numeric)

model1 <- lm(formula = msrp_2019 ~ epa_class + drive_train + passenger_capacity + doors + wheelbase + 
               height + fuel_tank_cap + city_mpg + hwy_mpg + net_torque + fuel_system + engine_type +
               net_hp + transmit_descr + brake_type + steer_type, data = carspecs)
summary(model1)

