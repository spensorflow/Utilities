### Formula for Euclidean Distance
distance <- sqrt( (player1$x - player2$x)^2 + (player1$y - player2$y)^2 )

#########
# Clustering on numeric variables
# Calculate the distance between data points
dist <- dist(two_players)

# When variables are on different scales, they must be normalized to properly calculate distance  
scaled_data <- scale(data)
dist_scaled <- dist(scaled_data)


###########
# Clustering on categorical variables
# Dummify data
dummy_data <- dummy.data.frame(data)

# Calculate the Distance
dist_survey <- dist(dummy_survey,method = 'binary')
