# Analyzing Car Pricing Dynamics: A Study of Features, Safety Metrics, and MSRP

**This project analyzed over 30,000 vehicle records to identify factors influencing MSRP using R and Python. By refining regression models and employing dimension reduction techniques, we were able to create models explaining 98.4% of the variance. We also compared various machine learning models, including Random Forest and XGBoost, through hyperparameter tuning and cross-validation to optimize accuracy.**

<div align="center">
  
| [Final Report](https://github.com/parthh-patel/Analyzing-Car-Pricing-Dynamics-A-Study-of-Features-Safety-Metrics-and-MSRP-2023/blob/main/Group%2018%20Final%20Project%20Submission.pdf) | [Project Code Folder](https://github.com/parthh-patel/Analyzing-Car-Pricing-Dynamics-A-Study-of-Features-Safety-Metrics-and-MSRP-2023/tree/main/Code) |
|---|---|

</div>

___


# Team-18
 Team 18's group project GitHub repository for MGT 6203 (Data Analytics for Business) Fall 2023 semester.

 ## Group Members: 
 Parth Patel, Evan Boyle, Changui Han, Shekinah Jacob, & Austin Pesina 

 ## Code:
 R/R Markdown code files of the group's progress.

### Requirements:

See [requirements.txt](https://github.gatech.edu/MGT-6203-Fall-2023-Canvas/Team-18/blob/main/requirements.txt) for package list and compatability.

### Data Prep:

- **read_car_data** is the script that reads in and cleans the data from a post on Reddit's r/datasets located [here](https://www.reddit.com/r/datasets/comments/b6rcwv/i_scraped_32000_cars_including_the_price_and_115/).
- **iihs_pdf_scrape** scrapes a [PDF](https://www.iihs.org/api/datastoredocument/status-report/pdf/55/2) from the Insurance Institute of Highway Safety that provides death rates by vehicle (pg 4-5).

### Variable Selection:

- **PCA analysis** - A principal component analysis performed to reduce the dimensionality of the data sets.
- **Multicollinearity_DataFinal** - Checking for multicolinearity to help remove variables.
- **stepwise_AIC** - A stepwise selection method is used to determine which variables will be kept for the models.
- **CarSpecsData** - The final script for variable selection. The output of this script is used for creating and validating the models.

### Model Building and Evaluation:

- **MGT 6203_Project_Linear Regression** - A linear regression model and the results of how the model performed.
- **Random Forest Model** - A random forest model and the results of how the model performed.
- **FINAL_Model_Evaluations** - An XG Boost model and the results of how the model performed. This script also adds in the linear regression and random forest models for comparison.

## Data:

 The data folder contains .RData files for each data set and shows the progress the group made.

- **car_data_final** is cleaned up version of the main, raw data set.
- **crash_data** is the data from the IIHS regarding deadly car crashes.
- **carspecs** is the final data set used for modeling.

## Visualizations: 
R Markdown and Word doc files that generate the images used in the report.

