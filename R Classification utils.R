# kNN (K-Nearest Neighbors) model
## Load the 'class' package
library(class)

## Create a vector of labels
classes <- data$class

## Run k-Nearest Neighbors (knn) classification model on nearest neighbor only(assuming 'class' is first column of training dataset)
data_pred <- knn(train = train_data[-1], test = test_data[-1], cl = classes)

## Run k-Nearest Neighbors (knn) classification model on nearest 10 neighbors (assuming 'class' is first column of training dataset).  Rule of thumb for k is to use square root of observations.
data_pred <- knn(train = train_data[-1], test = test_data[-1], cl = classes, k = 10)

## Evaluation
### Get the "prob" attribute from the predicted classes to identify proportion of 
data_prob <- attr(data_pred, "prob")

### Assessing model fit
# Create a confusion matrix of the predicted versus actual values
data_actual <- test_signs$class
table(data_pred, data_actual)

### Compute the accuracy
mean(data_pred == data_actual)

######################################################
# Naive Bayes model

# Load the naivebayes package
library(naivebayes)

# Build the probabilistic prediction model
model <- naive_bayes(dep_var ~ ind_var, data = train_data)

# Create predictions based on naive bayes model
predict(model, test_data)

# Show predicted probabilities of model test
predict(model, test_data,type = 'prob')

# Create enhanced model which uses Laplace correction to allow for possibility of events that haven't been previously observed
model2 <- naive_bayes(dep_var ~ ind_var, test_data,laplace = 1)

#######################################################
# Logistic Regression model

# Build the donation model
model <- glm(dep_var ~ ind_var, data = train_data, family = "binomial")

# Summarize the model results
summary(donation_model)

# Estimate the probability of "Yes" result
test_data$prob <- predict(model,test_data, type = "response")

# Find the "Yes" probability of the average prospect
mean_yes <-mean(test_data$dep_var)

# Predict a donation if probability of donation is greater than average
test_data$pred <- ifelse(donors$prob > mean_yes, 1, 0)

# Calculate the model's accuracy
mean(test_data$pred == test_data$dep_var)


## Alternatively, use stepwise regression if no subject matter expertise possible
### Specify a null model with no predictors
null_model <- glm(dep_var ~ 1, data = train_data, family = "binomial")

### Use a forward stepwise algorithm to build a parsimonious model
step_model <- step(null_model, scope = list(lower = null_model, upper = full_model), direction = "forward")

## Model Evaluation
# Load the pROC package
library(pROC)

# Create a ROC curve
ROC <- roc(test_data$dep_var,test_data$prob)

# Plot the ROC curve
plot(ROC, col = "blue")

# Calculate the area under the curve (AUC)
auc(ROC)


########################################################

# Decision Trees
## Load packages
library(rpart)
library(rpart.plot)

# Build model
model <- rpart(dep_var ~ ind_var, data = train_data, method = "class", control = rpart.control(cp = 0))

## Make predictions
predict(model, test_data, type = "class")


# Plot the model with default settings
rpart.plot(model)

# Plot the model with customized settings
rpart.plot(model, type = 3, box.palette = c("red", "green"), fallen.leaves = TRUE)

## Control growth of trees to prevent over-complicated models with small subsets
# Grow a tree with maxdepth of 6
loan_model <- rpart(outcome ~ .,loans_train,method = 'class',control = rpart.control(cp = 0,maxdepth = 6))

# Examine the complexity of model plot
plotcp(loan_model)

# Prune tree if needed
model_pruned <- prune(loan_model, cp = 0.0014)

# Random forest approach
# Load the randomForest package
library(randomForest)

# Build a random forest model
model <- randomForest(outcome ~ ., data = train_data)
