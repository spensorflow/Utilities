# Most frequent terms
# Load qdap
library(qdap)

# Print new_text to the console
new_text

# Find the 10 most frequent terms: term_count
term_count <- freq_terms(new_text,10)

# Plot term_count
plot(term_count)

######################################################################
## Loading Text
# Import text data
tweets <- read.csv(coffee_data_file,stringsAsFactors=FALSE)

# View the structure of tweets
str(tweets)

# Isolate text from tweets: coffee_tweets
coffee_tweets <- tweets$text

######################################################################
# Make a VCorpus object
# Load tm
library(tm)

# Make a vector source: coffee_source
coffee_source <- VectorSource(coffee_tweets)

# Make a volatile corpus: coffee_corpus
coffee_corpus <- VCorpus(coffee_source)

# Print out coffee_corpus
coffee_corpus

# Print the 15th tweet in coffee_corpus
coffee_corpus[[15]]

# Print the contents of the 15th tweet in coffee_corpus
coffee_corpus[[15]][1]

# Now use content to review plain text
content(coffee_corpus[[15]])

######################################################################
# Make a VCorpus object from a dataframe
# Create a DataframeSource: df_source
df_source <- DataframeSource(example_text)

# Convert df_source to a corpus: df_corpus
df_corpus <- VCorpus(df_source)

# Examine df_corpus
df_corpus

# Examine df_corpus metadata
meta(df_corpus)

# Compare the number of documents in the vector source
vec_corpus

# Compare metadata in the vector corpus
meta(vec_corpus)

######################################################################
# Common cleaning functions from tm
# Create the object: text
text <- "<b>She</b> woke up at       6 A.M. It\'s so early!  She was only 10% awake and began drinking coffee in front of her computer."

# Make lowercase
tolower(text)

# Remove punctuation
removePunctuation(text)

# Remove numbers
removeNumbers(text)

# Remove whitespace
stripWhitespace(text)

######################################################################
# Cleaning with qdp
# Remove text within brackets
bracketX(text)

# Replace numbers with words
replace_number(text)

# Replace abbreviations
replace_abbreviation(text)

# Replace contractions
replace_contraction(text)

# Replace symbols with words
replace_symbol(text)

######################################################################
# Handling stop words
# List standard English stop words
stopwords("en")

# Print text without standard stop words
removeWords(text, stopwords("en"))

# Add "coffee" and "bean" to the list: new_stops
new_stops <- c("coffee", "bean", stopwords("en"))

# Remove stop words from text
removeWords(text, new_stops)

######################################################################
# Word stemming
# Create complicate
complicate <- c('complicated','complication','complicatedly')

# Perform word stemming: stem_doc
stem_doc <- stemDocument(complicate)

# Create the completion dictionary: comp_dict
comp_dict <- 'complicate'

# Perform stem completion: complete_text 
complete_text <- stemCompletion(stem_doc,comp_dict)

# Print complete_text
complete_text


######################################################################
# Word stemming and stem completion on sentences
# Remove punctuation: rm_punc
rm_punc <- removePunctuation(text_data)

# Create character vector: n_char_vec
n_char_vec <- unlist(strsplit(rm_punc, split = " "))

# Perform word stemming: stem_doc
stem_doc <- stemDocument(n_char_vec)

# Print stem_doc
stem_doc

# Re-complete stemmed document: complete_doc
complete_doc <- stemCompletion(stem_doc,comp_dict)

# Print complete_doc
complete_doc

######################################################################
# Apply preprocessing steps to a corpus
## Create clean_corpus function
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "coffee", "mug"))
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(tweet_corp)

# Print out a cleaned up tweet
clean_corp[[227]][1]

# Print out the same tweet in original form
tweets$text[227]

######################################################################
# Make a document term matrix
# Create the dtm from the corpus: coffee_dtm
coffee_dtm <- DocumentTermMatrix(clean_corp)

# Print out coffee_dtm data
coffee_dtm

# Convert coffee_dtm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_dtm)

# Print the dimensions of coffee_m
dim(coffee_m)

# Review a portion of the matrix to get some Starbucks
coffee_m[475:478,2593:2594]

######################################################################
# Make a term document matrix
# Create a TDM from clean_corp: coffee_tdm
coffee_tdm <- TermDocumentMatrix(clean_corp)

# Print coffee_tdm data
coffee_tdm

# Convert coffee_tdm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_tdm)

# Print the dimensions of the matrix
dim(coffee_m)

# Review a portion of the matrix
coffee_m[2593:2594,475:478]


######################################################################
# Back to term frequency

# Create a matrix: coffee_m
coffee_m <- as.matrix(coffee_tdm)

# Calculate the rowSums: term_frequency
term_frequency <- rowSums(coffee_m)

# Sort term_frequency in descending order
term_frequency <- sort(term_frequency, decreasing=TRUE)

# View the top 10 most common words
term_frequency[1:10]

# Plot a barchart of the 10 most common words
barplot(term_frequency[1:10],col ='tan',las =2)

######################################################################
# term frequency with qdap

# Create frequency
frequency <- freq_terms(
  tweets$text, 
  top = 10, 
  at.least = 3, 
  stopwords = 'Top200Words'
)

# Make a frequency barchart
plot(frequency)

######################################################################
# wordclouds

# Load wordcloud package
library(wordcloud)

# Print the first 10 entries in term_frequency
term_frequency[1:10]

# Vector of terms
terms_vec <- names(term_frequency)

# Create a wordcloud for the values in word_freqs
wordcloud(terms_vec, term_frequency, max.words = 50, colors = 'red')

######################################################################
# wordclouds and stop words

# Review a "cleaned" tweet
content(chardonnay_corp[[24]])

# Add to stopwords
stops <- c(stopwords(kind = 'en'), 'chardonnay')

# Review last 6 stopwords 
tail(stops)

# Apply to a corpus
cleaned_chardonnay_corp <- tm_map(chardonnay_corp, removeWords, stops)

# Review a "cleaned" tweet again
content(cleaned_chardonnay_corp[[24]])

######################################################################
# plot a better wordcloud

# Sort the chardonnay_words in descending order
sorted_chardonnay_words <- sort(chardonnay_words,decreasing = TRUE)

# Print the 6 most frequent chardonnay terms
head(sorted_chardonnay_words)

# Get a terms vector
terms_vec <- names(chardonnay_words)

# Create a wordcloud for the values in word_freqs
wordcloud(terms_vec, chardonnay_words, 
          max.words = 50, colors = "red")
          
######################################################################
# wordcloud color
 
 # Print the list of colors
colors()

# Print the wordcloud with the specified colors
wordcloud(chardonnay_freqs$term, chardonnay_freqs$num, max.words = 100, colors = c("grey80","darkgoldenrod1",'tomato'))

######################################################################
# wordcloud color palettes

# Select 5 colors 
color_pal <- cividis(n = 5)

# Examine the palette output
color_pal

# Create a wordcloud with the selected paletteNLP
wordcloud(chardonnay_freqs$term, chardonnay_freqs$num, max.words = 100, colors = color_pal)


######################################################################
# find common words

# Create all_coffee
all_coffee <- paste(coffee_tweets$text,collapse = ' ')

# Create all_chardonnay
all_chardonnay <- paste(chardonnay_tweets$text,collapse = ' ')

# Create all_tweets
all_tweets <- c(all_coffee,all_chardonnay)

# Convert to a vector source
all_tweets <- VectorSource(all_tweets)

# Create all_corpus
all_corpus <- VCorpus(all_tweets)


######################################################################
# visualize common words

# Clean the corpus
all_clean <- clean_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Create all_m
all_m <- as.matrix(all_tdm)

# Print a commonality cloud
commonality.cloud(all_m,max.words = 100, colors = 'steelblue1')


######################################################################
# visualize dissimilar words
# Clean the corpus
all_clean <- clean_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Give the columns distinct names
colnames(all_tdm) <- c("coffee","chardonnay")

# Create all_m
all_m <- as.matrix(all_tdm)

# Create comparison cloud
comparison.cloud(all_m, max.words = 50, colors = c('orange','blue'))


######################################################################
# plarized word clouds
top25_df <- all_tdm_m %>%
  # Convert to data frame
  as_data_frame(rownames = "word") %>% 
  # Keep rows where word appears everywhere
  filter_all(all_vars(. > 0)) %>% 
  # Get difference in counts
  mutate(difference = chardonnay - coffee) %>% 
  # Keep rows with biggest difference
  top_n(25, wt = difference) %>% 
  # Arrange by descending difference
  arrange(desc(difference))
  
pyramid.plot(
  # Chardonnay counts
  top25_df$chardonnay, 
  # Coffee counts
  top25_df$coffee, 
  # Words
  labels = top25_df$word, 
  top.labels = c("Chardonnay", "Words", "Coffee"), 
  main = "Words in Common", 
  unit = NULL,
  gap = 8,
)


######################################################################
# Word association
word_associate(coffee_tweets$text, match.string = "barista", 
               stopwords = c(Top200Words, "coffee", "amp"), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

# Add title
title(main = "Barista Coffee Tweet Associations")


######################################################################
# Word clustering basics - Distance matrix and dendrogram

# Create dist_rain
dist_rain <- dist(rain$rainfall)

# View the distance matrix
dist_rain

# Create hc
hc <- hclust(dist_rain)

# Plot hc
plot(hc, labels = rain$city)


######################################################################
# Make dendrogram-friendly TDM
# Print the dimensions of tweets_tdm
dim(tweets_tdm)

# Create tdm1
tdm1 <- removeSparseTerms(tweets_tdm, sparse = 0.95)

# Create tdm2
tdm2 <- removeSparseTerms(tweets_tdm, sparse = 0.975)

# Print tdm1
tdm1

# Print tdm2
tdm2

####################################################################
### Putting it all together: a text dendrogram
# Create tweets_tdm2
tweets_tdm2 <- removeSparseTerms(tweets_tdm,sparse = 0.975)

# Create tdm_m
tdm_m <- as.matrix(tweets_tdm2)

# Create tweets_dist
tweets_dist <- dist(tdm_m)

# Create hc
hc <- hclust(tweets_dist)

# Plot the dendrogram
plot(hc)

####################################################################
# Dendrogram aesthetics
# Create hcd
hcd <- as.dendrogram(hc)

# Print the labels in hcd
labels(hcd)

# Change the branch color to red for "marvin" and "gaye"
hcd_colored <- branches_attr_by_labels(hcd,c('marvin','gaye'),'red')

# Plot hcd
plot(hcd_colored,main = 'Better Dendrogram')

# Add cluster rectangles
rect.dendrogram(hcd_colored,k = 2, border = 'grey50')

####################################################################
# Using word association
# Create associations
associations <- findAssocs(tweets_tdm,'venti',0.2)

# View the venti associations
associations

# Create associations_df
associations_df <- list_vect2df(associations,col2 = 'word',col3 = 'score')

# Plot the associations_df values
ggplot(associations_df, aes(score, word)) + 
  geom_point(size = 3) + 
  theme_gdocs()
  

####################################################################
# Changing n-grams
  # Make tokenizer function 
tokenizer <- function(x){
    NGramTokenizer(x,Weka_control(min = 2, max = 2))
}

# Create unigram_dtm
unigram_dtm <- DocumentTermMatrix(text_corp)

# Create bigram_dtm
bigram_dtm <- DocumentTermMatrix(text_corp, control = list(tokenize = tokenizer))

# Print unigram_dtm
unigram_dtm

# Print bigram_dtm
bigram_dtm

####################################################################
# bigrams (using two words)
# Create bigram_dtm_m
bigram_dtm_m <- as.matrix(bigram_dtm)

# Create freq
freq <- colSums(bigram_dtm_m)

# Create bi_words
bi_words <- names(freq)

# Examine part of bi_words
str_subset(bi_words,'^marvin')

# Plot a wordcloud
wordcloud(bi_words,freq,max.words = 15)


####################################################################
# Changing frequency weights
# Create a TDM
tdm <- TermDocumentMatrix(text_corp)

# Convert it to a matrix
tdm_m <- as.matrix(tdm)

# Examine part of the matrix
tdm_m[c('coffee','espresso','latte'),161:166]


####################################################################
# Capturing metadata
# Rename columns
names(tweets)[1] <- "doc_id"

# Set the schema: docs
docs <- DataframeSource(tweets)

# Make a clean volatile corpus: text_corpus
text_corpus <- clean_corpus(VCorpus(docs))

# Examine the first doc content
content(text_corpus[[1]])

# Access the first doc metadata
meta(text_corpus[1])


####################################################################
# Case study: Amazon vs Google for HR analytics
# Using data from glassdoor
# Print the structure of amzn
str(amzn)

# Create amzn_pros
amzn_pros <- amzn$pros

# Create amzn_cons
amzn_cons <- amzn$cons

# Print the structure of goog
str(goog)

# Create goog_pros
goog_pros <- goog$pros

# Create goog_cons
goog_cons <- goog$cons

##############
# Text organization
# qdap_clean the text
qdap_cleaned_amzn_pros <- qdap_clean(amzn_pros)

# Source and create the corpus
amzn_p_corp <- VCorpus(VectorSource(qdap_cleaned_amzn_pros))

# tm_clean the corpus
amzn_pros_corp <- tm_clean(amzn_p_corp)

###############
# WOrking with Google reviews
# qdap_clean the text
qdap_cleaned_goog_pros <- qdap_clean(goog_pros)

# Source and create the corpus
goog_p_corp <- VCorpus(VectorSource(qdap_cleaned_goog_pros))

# tm_clean the corpus
goog_pros_corp <- tm_clean(goog_p_corp)


#################
# Feature extraction and analysis: Amazon pros
# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(amzn_pros_corp, control = list(tokenize = tokenizer))

# Create amzn_p_tdm_m
amzn_p_tdm_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_tdm_m)

# Plot a wordcloud using amzn_p_freq values
wordcloud(names(amzn_p_freq),amzn_p_freq,max.words = 25, color = 'blue')

#################
# Feature extraction and analysis: Amazon cons
# Create amzn_p_tdm
# Create amzn_c_tdm
amzn_c_tdm <- TermDocumentMatrix(amzn_cons_corp,control = list(tokenize = tokenizer))

# Create amzn_c_tdm_m
amzn_c_tdm_m <- as.matrix(amzn_c_tdm)

# Create amzn_c_freq
amzn_c_freq <- rowSums(amzn_c_tdm_m)

# Plot a wordcloud of negative Amazon bigrams
wordcloud(names(amzn_c_freq),amzn_c_freq, max.words = 25, color = 'red')

#####################
# Amazon con dendgrogram
# Create amzn_c_tdm
amzn_c_tdm <- TermDocumentMatrix(amzn_cons_corp,control = list(tokenize = tokenizer))

# Print amzn_c_tdm to the console
amzn_c_tdm

# Create amzn_c_tdm2 by removing sparse terms 
amzn_c_tdm2 <- removeSparseTerms(amzn_c_tdm, sparse = .993)

# Create hc as a cluster of distance values
hc <- hclust(dist(amzn_c_tdm2),method = 'complete')

# Produce a plot of hc
plot(hc)

#######################
# Word association
# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(amzn_pros_corp,control = list(tokenize = tokenizer))

# Create amzn_p_m
amzn_p_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_m)

# Create term_frequency
term_frequency <- sort(amzn_p_freq,decreasing = TRUE)

# Print the 5 most common terms
term_frequency[1:5]

# Find associations with fast paced
findAssocs(amzn_p_tdm,'fast paced', 0.2)

###########################
# Quick review of Google reviews
# Create all_goog_corp
all_goog_corp <- tm_clean(all_goog_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_goog_corp)

# Create all_m
all_m <- as.matrix(all_tdm)

# Build a comparison cloud
comparison.cloud(all_m, 
    max.words = 100, 
    colors = c("#F44336", "#2196f3"))
   
   
#################################
# Amazon vs Google pro reviews
  # Filter to words in common and create an absolute diff column
common_words <- all_tdm_df %>% 
  filter(
  AmazonPro != 0,
  GooglePro != 0
  ) %>%
  mutate(diff = abs(AmazonPro -GooglePro))

# Extract top 5 common bigrams
(top5_df <- top_n(common_words,5, diff))

# Create the pyramid plot
pyramid.plot(top5_df$AmazonPro, top5_df$GooglePro, 
             labels = top5_df$terms, gap = 12, 
             top.labels = c("Amzn", "Pro Words", "Goog"), 
             main = "Words in Common", unit = NULL)
             
             
#################################
# Amazon vs Google negative reviews
# Extract top 5 common bigrams
(top5_df <- top_n(common_words, 5, diff))

# Create a pyramid plot
pyramid.plot(
    # Amazon on the left
    top5_df$AmazonNeg,
    # Google on the right
    top5_df$GoogleNeg,
    # Use terms for labels
    labels = top5_df$terms,
    # Set the gap to 12
    gap = 12,
    # Set top.labels to "Amzn", "Neg words" & "Goog"
    top.labels = c('Amzn','Neg Words','Goog'),
    main = "Words in Common", 
    unit = NULL
)
