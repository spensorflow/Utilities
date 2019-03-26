# Sentiment lexicons
# Load dplyr and tidytext
library(dplyr)
library(tidytext)


# Choose the bing lexicon
get_sentiments("bing")

# Choose the nrc lexicon
get_sentiments("nrc") %>%
  count(sentiment) # Count words by sentiment
  
###############################################################
## Inner join to implement sentiment analysis
# geocoded_tweets has been pre-defined
geocoded_tweets

# Access bing lexicon: bing
bing <- get_sentiments("bing")

# Use data frame with text data
geocoded_tweets %>%
  # With inner join, implement sentiment analysis using `bing`
  inner_join(bing)
  
   
############################################################### 
# Find most common sadness words
tweets_nrc

tweets_nrc %>%
  # Filter to only choose the words associated with sadness
  filter(sentiment == 'sadness') %>%
  # Group by word
  group_by(word) %>%
  # Use the summarize verb to find the mean frequency
  summarize(freq = mean(freq)) %>%
  # Arrange to sort in order of descending frequency
 arrange(desc(freq))
 
 
 ########################################################
 # Find most common joy words
 # tweets_nrc has been pre-defined
tweets_nrc

joy_words <- tweets_nrc %>%
  # Filter to choose only words associated with joy
  filter(sentiment == 'joy') %>%
  # Group by each word
  group_by(word) %>%
  # Use the summarize verb to find the mean frequency
  summarize(freq = mean(freq)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(freq))    

# Load ggplot2
library(ggplot2)

joy_words %>%
  top_n(20) %>%
  mutate(word = reorder(word, freq)) %>%
  # Use aes() to put words on the x-axis and frequency on the y-axis
  ggplot(aes(word, freq)) +
  # Make a bar chart with geom_col()
  geom_col() +
  coord_flip() 
  
 ########################################################
 # common words in different states
 
 # tweets_nrc has been pre-defined
tweets_nrc

tweets_nrc %>%
  # Find only the words for the state of Utah and associated with joy
  filter(state == "utah",
      sentiment == 'joy') %>%
  # Arrange to sort in order of descending frequency
 arrange(desc(freq))

tweets_nrc %>%
  # Find only the words for the state of Louisiana and associated with joy
  filter(state == "louisiana",
      sentiment == 'joy') %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(freq))
 
 
 ########################################################
 # States with most positive twitter users
 # tweets_bing has been pre-defined
tweets_bing

tweets_bing %>% 
  # Group by two columns: state and sentiment
  group_by(state, sentiment) %>%
  # Use summarize to calculate the mean frequency for these groups
  summarize(freq = mean(freq)) %>%
  spread(sentiment, freq) %>%
  ungroup() %>%
  # Calculate the ratio of positive to negative words
  mutate(ratio = positive / negative,
         state = reorder(state, ratio)) %>%
  # Use aes() to put state on the x-axis and ratio on the y-axis
  ggplot(aes(state, ratio)) +
  # Make a plot with points using geom_point()
  geom_point()+
  coord_flip()
  
#######################################################################################################
   # Shakespeare
   
# Pipe the shakespeare data frame to the next line
shakespeare %>% 
  # Use count to find out how many titles/types there are
  count(title,type)
  
##############################################################
# Unnesting text to words
# Load tidytext
library(tidytext)

tidy_shakespeare <- shakespeare %>%
  # Group by the titles of the plays
  group_by(title) %>%
  # Define a new column linenumber
  mutate(linenumber = row_number()) %>%
  # Transform the non-tidy text data to tidy text data
  unnest_tokens(word, text) %>%
  ungroup()

# Pipe the tidy Shakespeare data frame to the next line
tidy_shakespeare %>% 
  # Use count to find out how many times each word is used
 count(word, sort = TRUE)
 
 #############################################################
 # Sentiment analysis of Shakespeare
 shakespeare_sentiment <- tidy_shakespeare %>%
  # Implement sentiment analysis with the "bing" lexicon
  inner_join(get_sentiments('bing') )

shakespeare_sentiment %>%
  # Find how many positive/negative words each play has
  count(title,sentiment)
  
  
  ##########################################
  # Tragedy or Comedy?
  sentiment_counts <- tidy_shakespeare %>%
    # Implement sentiment analysis using the "bing" lexicon
    inner_join(get_sentiments('bing')) %>%
    # Count the number of words by title, type, and sentiment
    count(title,type,sentiment)

sentiment_counts %>%
    # Group by the titles of the plays
    group_by(title) %>%
    # Find the total number of words in each play
    mutate(total = sum(n),
    # Calculate the number of words divided by the total
           percent = n/total) %>%
    # Filter the results for only negative sentiment
    filter(sentiment == 'negative') %>%
    arrange(percent)
    
    #####################################################
    # Most common positive and negative words
    word_counts <- tidy_shakespeare %>%
  # Implement sentiment analysis using the "bing" lexicon
  inner_join(get_sentiments('bing')) %>%
  # Count by word and sentiment
  count(word,sentiment)

top_words <- word_counts %>%
  # Group by sentiment
  group_by(sentiment) %>%
  # Take the top 10 for each sentiment
  top_n(10) %>%
  ungroup() %>%
  # Make word a factor in order of n
  mutate(word = reorder(word, n))

# Use aes() to put words on the x-axis and n on the y-axis
ggplot(top_words, aes(word, n, fill = sentiment)) +
  # Make a bar chart with geom_col()
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free") +  
  coord_flip()
    
  ################################################################
  # Word contributions by play
  tidy_shakespeare %>%
  # Count by title and word
  count(title, word, sort = TRUE) %>%
  # Implement sentiment analysis using the "afinn" lexicon
  inner_join(get_sentiments('afinn')) %>%
  # Filter to only examine the scores for Macbeth that are negative
  filter(title == 'The Tragedy of Macbeth', score < 0)
  
  
  ################################################################
  # Calculating a contribution score
  sentiment_contributions <- tidy_shakespeare %>%
  # Count by title and word
  count(title, word, sort = TRUE) %>%
  # Implement sentiment analysis using the "afinn" lexicon
  inner_join(get_sentiments("afinn")) %>%
  # Group by title
  group_by(title) %>%
  # Calculate a contribution for each word in each title
  mutate(contribution = score * n / sum(n)) %>%
  ungroup()
    
sentiment_contributions

sentiment_contributions %>%
  # Filter for Hamlet
  filter(title == 'Hamlet, Prince of Denmark') %>%
  # Arrange to see the most negative words
  arrange(contribution)

sentiment_contributions %>%
  # Filter for The Merchant of Venice
  filter(title == 'The Merchant of Venice') %>%
  # Arrange to see the most positive words
  arrange(desc(contribution))
  
##########################################################
# Sentiment changes through a play
tidy_shakespeare %>%
  # Implement sentiment analysis using "bing" lexicon
  inner_join(get_sentiments('bing')) %>%
  # Count using four arguments
  count(title,type,index = linenumber %/% 70,sentiment)
  
  #######################################################
  # Calculating net sentiment
  
  # Load the tidyr package
library(tidyr)

tidy_shakespeare %>%
  inner_join(get_sentiments("bing")) %>%
  count(title, type, index = linenumber %/% 70, sentiment) %>%
  # Spread sentiment and n across multiple columns
  spread(sentiment, n, fill = 0) %>%
  # Use mutate to find net sentiment
  mutate(sentiment = positive - negative)
  
  ##############################################################
  # Visualizing Narrative Arcs
  library(tidyr)
# Load the ggplot2 package
library(ggplot2)

tidy_shakespeare %>%
  inner_join(get_sentiments("bing")) %>%
  count(title, type, index = linenumber %/% 70, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  # Put index on x-axis, sentiment on y-axis, and map comedy/tragedy to fill
  ggplot(aes(index,sentiment,fill = type)) +
  # Make a bar chart with geom_col()
  geom_col() +
  # Separate panels for each title with facet_wrap()
  facet_wrap(~ title,scales = 'free_x')
  
  
  ###################################################################################################################
  ######### Analyzing TV News ##############
 
# Tidy the text
# Load the tidytext package
library(tidytext)

# Pipe the climate_text dataset to the next line
tidy_tv <- climate_text %>%
    # Transform the non-tidy text data to tidy text data
    unnest_tokens(word,text)

######## Counting totals
tidy_tv %>% 
    anti_join(stop_words) %>%
    # Count by word with sort = TRUE
    count(word,sort = TRUE)
    
tidy_tv %>%
    # Count by station
    count(station) %>%
    # Rename the new column station_total
   rename(station_total = n)
    
    
###################### Sentiment analysis
tv_sentiment <- tidy_tv %>% 
    # Group by station
    group_by(station) %>% 
    # Define a new column station_total
    mutate(station_total = n()) %>%
    ungroup() %>%
    # Implement sentiment analysis with the NRC lexicon
    inner_join(get_sentiments('nrc'))
  

######################################
  # Which stations use the most negative words?
tv_sentiment %>% 
    count(station, sentiment, station_total) %>%
    # Define a new column percent
    mutate(percent = n / station_total) %>%
    # Filter only for negative words
    filter(sentiment == 'negative') %>%
    # Arrange by percent
    arrange(percent)
    
# Now do the same but for positive words
tv_sentiment %>% 
    count(station, sentiment, station_total) %>%
    # Define a new column percent
    mutate(percent = n / station_total) %>%
    # Filter only for negative words
    filter(sentiment == 'positive') %>%
    # Arrange by percent
    arrange(percent)
    
    
 #########################
 ## Contribution to sentiment score
 tv_sentiment %>%
    # Count by word and sentiment
    count(word,sentiment) %>%
    # Group by sentiment
    group_by(sentiment) %>%
    # Take the top 10 words for each sentiment
    top_n(10) %>%
    ungroup() %>%
    mutate(word = reorder(word, n)) %>%
    # Set up the plot with aes()
    ggplot(aes(word,n,fill = sentiment)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ sentiment, scales = "free") +
    coord_flip()
    
    ############## Word choice and TV station
    tv_sentiment %>%
    # Filter for only negative words
    filter(sentiment == 'negative') %>%
    # Count by word and station
    count(word,station) %>%
    # Group by station
    group_by(station) %>%
    # Take the top 10 words for each station
    top_n(10) %>%
    ungroup() %>%
    mutate(word = reorder(paste(word, station, sep = "__"), n)) %>%
    # Set up the plot with aes()
    ggplot(aes(word,n,fill = station)) +
    geom_col(show.legend = FALSE) +
    scale_x_discrete(labels = function(x) gsub("__.+$", "", x)) +
    facet_wrap(~ station, nrow = 2, scales = "free") +
    coord_flip()
    
    ###################### 
    # Visualizing sentiment over time
    # Load the lubridate package
library(lubridate)

sentiment_by_time <- tidy_tv %>%
    # Define a new column using floor_date()
    mutate(date = floor_date(show_date, unit = "6 months")) %>%
    # Group by date
    group_by(date) %>%
    mutate(total_words = n()) %>%
    ungroup() %>%
    # Implement sentiment analysis using the NRC lexicon
    inner_join(get_sentiments('nrc'))

sentiment_by_time %>%
    # Filter for positive and negative words
    filter(sentiment == 'positive' | sentiment == 'negative') %>%
    # Count by date, sentiment, and total_words
    count(date,sentiment,total_words) %>%
    ungroup() %>%
    mutate(percent = n / total_words) %>%
    # Set up the plot with aes()
    ggplot(aes(date,percent,col = sentiment)) +
    geom_line(size = 1.5) +
    geom_smooth(method = "lm", se = FALSE, lty = 2) +
    expand_limits(y = 0)
    
    ###########################
    # Word changes over time
    tidy_tv %>%
    # Define a new column that rounds each date to the nearest 1 month
    mutate(date = floor_date(show_date,unit = 'month')) %>%
    filter(word %in% c("threat", "hoax", "denier",
                       "real", "warming", "hurricane")) %>%
    # Count by date and word
    count(date,word) %>%
    ungroup() %>%
    # Set up your plot with aes()
    ggplot(aes(date,n,col = word)) +
    # Make facets by word
    facet_wrap(~word) +
    geom_line(size = 1.5, show.legend = FALSE) +
    expand_limits(y = 0)
    
    
  ##################################################################################################################
    # Tidying song lyrics
    # Load the tidytext package
library(tidytext)

# Pipe song_lyrics to the next line
tidy_lyrics <- song_lyrics %>% 
  # Transform the lyrics column to a word column
  unnest_tokens(word,lyrics)

# Print tidy_lyrics
tidy_lyrics

####################################################
# Calculating word totals per song
totals <- tidy_lyrics %>%
  # Count by song to find the word totals for each song
  count(song) %>%
  # Rename the new column
  rename(total_words = n)

# Print totals    
totals

lyric_counts <- tidy_lyrics %>%
  # Combine totals with tidy_lyrics using the "song" column
  left_join(totals, by = "song")
  
 ######################################
 # Sentiment analysis of lyrics
 lyric_sentiment <- lyric_counts %>%
    # Implement sentiment analysis with the "nrc" lexicon
    inner_join(get_sentiments('nrc'))

lyric_sentiment %>%
    # Find how many sentiment words each song has
    count(song, sentiment,  sort = TRUE)
    
 ##############################################
 # Most positive and negative songs
 # What songs have the highest proportion of negative words?
lyric_sentiment %>%
    # Count using three arguments
    count(song,sentiment,total_words) %>%
    ungroup() %>%
    # Make a new percent column with mutate 
    mutate(percent = n / total_words) %>%
    # Filter for only negative words
    filter(sentiment == 'negative') %>%
    # Arrange by descending percent
    arrange(desc(percent))

# What songs have the highest proportion of positive words?
lyric_sentiment %>%
    # Count using three arguments
    count(song,sentiment,total_words) %>%
    ungroup() %>%
    # Make a new percent column with mutate 
    mutate(percent = n / total_words) %>%
    # Filter for only positive words
    filter(sentiment == 'positive') %>%
    # Arrange by descending percent
    arrange(desc(percent))
    
    
  #############################################
  # Relationship between sentiment and Billboard rank
  lyric_sentiment %>%
    filter(sentiment == "positive") %>%
    # Count by song, Billboard rank, and the total number of words
    count(song,rank,total_words) %>%
    ungroup() %>%
    # Use the correct dplyr verb to make two new columns
    mutate(percent = n / total_words,
           rank = 10 * floor(rank / 10)) %>%
    ggplot(aes(as.factor(rank), percent)) +
    # Make a boxplot
    geom_boxplot()
    
    #########################################################
    # More on Billboard and sentiment
    lyric_sentiment %>%
    # Filter for only negative words
    filter(sentiment == 'negative') %>%
    # Count by song, Billboard rank, and the total number of words
    count(song,rank,total_words) %>%
    ungroup() %>%
    # Mutate to make a percent column
    mutate(percent = n / total_words,
           rank = 10 * floor(rank / 10)) %>%
    # Use ggplot to set up a plot with rank and percent
    ggplot(aes(as.factor(rank), percent)) +
    # Make a boxplot
    geom_boxplot()
    
    ###########################################################
    # Sentiment scores by year
    # How is negative sentiment changing over time?
lyric_sentiment %>%
    # Filter for only negative words
    filter(sentiment == 'negative') %>%
    # Count by song, year, and the total number of words
    count(song,year,total_words) %>%
    ungroup() %>%
    mutate(percent = n / total_words,
           year = 10 * floor(year / 10)) %>%
    # Use ggplot to set up a plot with year and percent
    ggplot(aes(as.factor(year),percent)) +
    geom_boxplot()
    
# How is positive sentiment changing over time?
lyric_sentiment %>%
    # Filter for only negative words
    filter(sentiment == 'positive') %>%
    # Count by song, year, and the total number of words
    count(song,year,total_words) %>%
    ungroup() %>%
    mutate(percent = n / total_words,
           year = 10 * floor(year / 10)) %>%
    # Use ggplot to set up a plot with year and percent
    ggplot(aes(as.factor(year),percent)) +
    geom_boxplot()

##########################################
# Modeling negative sentiment
negative_by_year <- lyric_sentiment %>%
    # Filter for negative words
    filter(sentiment =='negative') %>%
    count(song, year, total_words) %>%
    ungroup() %>%
    # Define a new column: percent
    mutate(percent = n / total_words)

# Specify the model with percent as the response and year as the predictor
model_negative <- lm(percent ~ year, data = negative_by_year)

# Use summary to see the results of the model fitting
summary(model_negative)

########################################################
# Modeling positive sentiment
positive_by_year <- lyric_sentiment %>%
    filter(sentiment == "positive") %>%
    # Count by song, year, and total number of words
    count(song,year, total_words) %>%
    ungroup() %>%
    # Define a new column: percent
    mutate(percent = n / total_words)

# Fit a linear model with percent as the response and year as the predictor
model_positive <- lm(percent ~ year, data = positive_by_year)

# Use summary to see the results of the model fitting
summary(model_positive)
