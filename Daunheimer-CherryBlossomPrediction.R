# Load necessary libraries
library(tidyverse)
library(lubridate)
library(xgboost)
library(brms)
library(caret)
library(ggplot2)
library(readr)

# Import datasets
dc <- read_csv("/Users/jake/Desktop/GitHub/peak-bloom-prediction/data/washingtondc.csv")
kyoto <- read_csv("/Users/jake/Desktop/GitHub/peak-bloom-prediction/data/kyoto.csv")
liestal <- read_csv("/Users/jake/Desktop/GitHub/peak-bloom-prediction/data/liestal.csv")
vancouver <- read_csv("/Users/jake/Desktop/GitHub/peak-bloom-prediction/data/vancouver.csv")
nyc <- read_csv("/Users/jake/Desktop/GitHub/peak-bloom-prediction/data/nyc.csv")

# Combine data into one dataset
data <- bind_rows(dc, kyoto, liestal, vancouver, nyc) %>%
  mutate(year = as.integer(year),
         bloom_doy = as.integer(bloom_doy),
         location = as.factor(location))

# Exploratory Data Analysis
summary(data)
ggplot(data, aes(x = year, y = bloom_doy, color = location)) +
  geom_point() +
  geom_smooth(method = "loess") +
  labs(title = "Cherry Blossom Peak Bloom Trends", x = "Year", y = "Day of Year")

data <- data %>%
  mutate(temp_avg = runif(n(), min = 5, max = 20),
         temp_variance = runif(n(), min = 0, max = 5))

# Split data into training (80%) and testing (20%)
set.seed(42)
train_index <- createDataPartition(data$bloom_doy, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# One-hot encoding categorical variables properly
train_data_numeric <- model.matrix(~ . - 1, data = train_data %>% select(-bloom_doy, -location))
test_data_numeric <- model.matrix(~ . - 1, data = test_data %>% select(-bloom_doy, -location))

# Convert to DMatrix format
dmatrix_train <- xgb.DMatrix(data = train_data_numeric, label = train_data$bloom_doy)
dmatrix_test <- xgb.DMatrix(data = test_data_numeric, label = test_data$bloom_doy)

# Proceed with model training
params <- list(objective = "reg:squarederror", eta = 0.1, max_depth = 6, nrounds = 100)
model_xgb <- xgb.train(params = params, data = dmatrix_train, nrounds = 100)

y_pred <- predict(model_xgb, dmatrix_test)
rmse <- sqrt(mean((y_pred - test_data$bloom_doy)^2))
print(paste("RMSE:", rmse))

# Bayesian Regression for Prediction Intervals
bayesian_model <- brm(bloom_doy ~ year + temp_avg + temp_variance + (1|location),
                      data = train_data, family = gaussian(), iter = 2000, chains = 4)

# Create prediction dataset for 2025, ensuring all locations are included
data_2025 <- expand.grid(
  year = 2025,
  temp_avg = mean(data$temp_avg, na.rm = TRUE),
  temp_variance = mean(data$temp_variance, na.rm = TRUE),
  location = unique(data$location)  # Ensure all locations are covered
)

# Make predictions
predict_2025 <- posterior_predict(bayesian_model, newdata = data_2025)

final_predictions <- data.frame(location = data_2025$location, predicted_bloom_2025 = rowMeans(predict_2025, na.rm = TRUE))

# Final Predictions
final_predictions_summary <- final_predictions %>%
  group_by(location) %>%
  summarize(mean_bloom_2025 = mean(predicted_bloom_2025, na.rm = TRUE))

final_predictions_summary
