## Load libraries
library(broom)

## Running and viewing linear regression model results

### Run model
model <- lm(dep_var ~ ind_var1,train_data)

### View summary of regression results
summary(model)

### get fitted values of data
fitted.values(model)

### get residuals of model
residuals <- residuals(model)

### Extract coefficients from model
coefs <- coef(model)

## Use model to make predictions
predict(model,test_data)

## Data vizualization
### Create scatterplot with regression line
ggplot(data = data, aes(x = dep_var, y = ind_var1)) + 
  geom_point() + 
  geom_smooth(method = "lm")
              
### Create scatterplot with slope line
ggplot(data = data, aes(x = dep_var, y = ind_var1)) + 
  geom_point() + 
  geom_abline(data = coefs, 
              aes(intercept = `(Intercept)`, slope = hgt),  
              color = "dodgerblue")


######################################################################

## Model evaluation
              
### Root Mean Squared Error (RMSE) - Good model fit indicated by low RMSE relative to typical dependent variable units
RMSE <- sqrt(sum(residuals(model)^2) / df.residual(model))

### Calculate R-squared
model_tidy %>%
  summarize(var_y = var(wgt), var_e = var(.resid)) %>%
  mutate(R_squared = (1-(var_e/var_y)))

### Outlier identification

### Tidy up model results with broom package by combining with data used to fit model
tidy_model <- augment(model)

### Identify outliers that adversely affected model performance by finding data points with highest leverage and influence.  Leverage is a measure of distance from the mean, and can be pulled from .hat of augment function.Influence is a measure of the distance, in addition to the magniture of residual, and can be pulled from .cooksd "Cook's distance" in augment.  Biggest score represents biggest influence on results.
tidy_model %>%
  arrange(desc(.hat,.cooksd))%>%
  head(10)
  
  ################################################################
  
 ### Run and tidy several models on a particular variable ("country" in the example)
data_coefficients <- data %>%
  nest(-subgroups) %>%
  mutate(model = map(data, ~ lm(dep_var ~ ind_var1, data = .)),
         tidied = map(model, tidy))%>%
  unnest(tidied)

### Per Bonferroni Correction, perform coefficient correction (isolate only significant findings) by pulling out all slope terms (non-intercept), adjusting p.value, and filtering for less than .05
slope_terms <- data_coefficients %>%
  filter(term != "(Intercept)")%>%
  mutate(p.adjusted = p.adjust(p.value))%>%
  filter(p.adjusted < 0.05)
 
