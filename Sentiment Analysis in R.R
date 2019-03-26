# Quickstart
# Examine the text data
text_df

# Calc overall polarity score
text_df %$% polarity(text)

# Calc polarity score by person
(datacamp_conversation <- text_df %$% polarity(text, person))

# Counts table from datacamp_conversation
counts(datacamp_conversation)

# Plot the conversation polarity
plot(datacamp_conversation)

#################################################################
# Tm Refresher Part 1
# clean_corpus(), tm_define are pre-defined
clean_corpus
tm_define

# Create a VectorSource
tm_vector <- VectorSource(tm_define)

# Apply VCorpus
tm_corpus <- VCorpus(tm_vector)

# Examine the first document's contents
content(tm_corpus[[1]])

# Clean the text
tm_clean <- clean_corpus(tm_corpus)

# Reexamine the contents of the first doc
content(tm_clean[[1]])

#############################################################
# Tm Refresher Part 2
# clean_text is pre-defined
clean_text

# Create tf_dtm
tf_dtm <- DocumentTermMatrix(clean_text)

# Create tf_dtm_m
tf_dtm_m <- as.matrix(tf_dtm)

# Dimensions of DTM matrix
dim(tf_dtm_m)

# Subset part of tf_dtm_m for comparison
tf_dtm_m[16:20, 2975:2985]

############################################################
# Zipf's Law (relative word frequency)
# Examine sb_words
head(sb_words)

# Create expectations
sb_words$expectations <- sb_words %$% 
  {freq[1] / sb_words$rank}

# Create metrics plot
sb_plot <- mjs_plot(sb_words, x = rank, y = freq, show_rollover_text = FALSE)

# Add 1st line
sb_plot <- mjs_line(sb_plot)

# Add 2nd line
sb_plot <- mjs_add_line(sb_plot,expectations)

# Add legend
sb_plot <- mjs_add_legend(sb_plot, legend = c('Frequency','Expectation'))

# Display plot
sb_plot

############################################################
# Polarity
# Example statement
positive <- "DataCamp courses are good for learning"

# Calculate polarity of statement
pos_score <- polarity(positive)

# Get counts
(pos_counts <- counts(pos_score))
  
# Number of positive words
n_good <- length(pos_counts$pos.words[[1]])
  
# Total number of words
n_words <- pos_counts$wc
  
# Verify polarity score
n_good / sqrt(n_words)


############################################################
# More polarity
# Examine conversation
conversation

# Polarity - All
polarity(conversation$text)

# Polarity - Grouped
student_pol <- conversation %$%
  polarity(text, student)

# Student results
scores(student_pol)

# Sentence by sentence
counts(student_pol)

# qdap plot
plot(student_pol)

############################################################
# Subjectivity lexicons

# Examine the key.pol
key.pol

# Negators
negation.words

# Amplifiers
amplification.words

# De-amplifiers
deamplification.words

# Examine
text

# Complete the polarity parameters
polarity(
  text.var       = text$words,
  grouping.var   = text$speaker,
  polarity.frame = key.pol,
  negators       = negation.words,
  amplifiers     = amplification.words,
  deamplifiers   = deamplification.words 
)
############################################################
# Analyzing lyrics of "Stressed Out"
# stressed_out has been pre-defined
head(stressed_out)

# Basic lexicon score
polarity(stressed_out)

# Check the subjectivity lexicon
key.pol[grep("stress", x)]

# New lexicon
custom_pol <- sentiment_frame(positive.words, c(negative.words, "stressed", "turn back"))

# Compare new score
polarity(stressed_out,polarity.frame = custom_pol)

##############################################################################################################################
# Tidytext
# As matrix
ag_dtm_m <- as.matrix(ag_dtm)

# Examine line 2206 and columns 245:250
ag_dtm_m[2206, 245:250]

# Tidy up the DTM
ag_tidy <- tidy(ag_dtm)

# Examine tidy with a word you saw
ag_tidy[831:835, ]

############################################################
# Examine sentiments dataframe
# Subset to AFINN
afinn_lex <- get_sentiments("afinn")

# Count AFINN scores
afinn_lex %>% 
  count(score)

# Subset to nrc
nrc_lex <- get_sentiments('nrc')

# Make the nrc counts object
nrc_counts <- nrc_lex %>% count(sentiment)

# From previous step
nrc_counts <- get_sentiments("nrc") %>% 
  count(sentiment)
  
# Plot n vs. sentiment
ggplot(nrc_counts, aes(x = sentiment, y = n)) +
  # Add a col layer
  geom_col() +
  theme_gdocs()

############################################################
# Bing tidy polarity
# Qdap polarity
polarity(ag_txt)

# Get Bing lexicon
bing <- get_sentiments("bing")

# Join text to lexicon
ag_bing_words <- inner_join(ag_tidy, bing, by = c("term" = "word"))

# Examine
ag_bing_words

# Get counts by sentiment
ag_bing_words %>%
  count(sentiment)
 
############################################################
# Bing tidy polarity (cont'd)
# Inner join
moby_lex_words <- inner_join(m_dick_tidy, bing, by = c("term" = "word"))

moby_lex_words <- moby_lex_words %>%
  # Set index to numeric document
  mutate(index = as.numeric(document))

moby_count <- moby_lex_words %>%
  # Count by sentiment, index
  count(sentiment, index)

# Examine the counts
moby_count

moby_spread <- moby_count %>%
  # Spread sentiments
  spread(sentiment, n, fill = 0)

# Review the spread data
moby_spread

############################################################
# Bing tidy polarity continued
moby_polarity <- moby %>%
  # Inner join to lexicon
  inner_join(bing, by = c('term' = 'word')) %>%
  # Count the sentiment scores
  count(sentiment,index) %>% 
  # Spread the sentiment into positive and negative columns
  spread(sentiment, n, fill = 0) %>%
  # Add polarity column
  mutate(polarity = positive - negative)
  
  # From previous step
moby_polarity <- moby %>%
  inner_join(bing, by = c("term" = "word")) %>%
  count(sentiment, index) %>% 
  spread(sentiment, n, fill = 0) %>%
  mutate(polarity = positive - negative)
  
# Plot polarity vs. index
ggplot(moby_polarity, aes(index, polarity)) + 
  # Add a smooth trend curve
  geom_smooth()
  
############################################################
# Afinn tidy polarity
# See abbreviated line 5400
huck %>% filter(line == 5400)

# What are the scores of the sentiment words?
afinn %>% filter(word %in% c("fun", "glad"))

huck_afinn <- huck %>% 
  # Inner Join to AFINN lexicon
  inner_join(afinn, by = c("term" = "word")) %>%
  # Count by score and line
  count(score, line)

# From previous step
huck_afinn <- huck %>% 
  inner_join(afinn, by = c("term" = "word")) %>%
  count(score, line)
  
huck_afinn_agg <- huck_afinn %>% 
  # Group by line
  group_by(line) %>%
  # Sum scores times n (by line)
  summarize(total_score = sum(score * n))
  
huck_afinn_agg %>% 
  # Filter for line 5400
  filter(line == 5400)
  
  # From previous steps
huck_afinn_agg <- huck %>% 
  inner_join(afinn, by = c("term" = "word")) %>%
  count(score, line) %>% 
  group_by(line) %>%
  summarize(total_score = sum(score * n))
  
# Plot total_score vs. line
ggplot(huck_afinn_agg, aes(line, total_score)) + 
  # Add a smooth trend curve
  geom_smooth()
  
############################################################
# NRC tidytext polarity
oz_plutchik <- oz %>% 
  # Join to nrc lexicon by term = word
  inner_join(nrc, by = c("term" = "word")) %>% 
  # Only consider Plutchik sentiments
  filter(!sentiment %in% c("positive", "negative")) %>%
  # Group by sentiment
  group_by(sentiment) %>% 
  # Get total count by sentiment
  summarize(total_count = sum(count))
  
  # From previous step
oz_plutchik <- oz %>% 
  inner_join(nrc, by = c("term" = "word")) %>% 
  filter(!sentiment %in% c("positive", "negative")) %>%
  group_by(sentiment) %>% 
  summarize(total_count = sum(count))
  
# Plot total_count vs. sentiment
ggplot(oz_plutchik, aes(x = sentiment, y = total_count)) +
  # Add a column geom
 geom_col()
   

############################################################
# Chronological Polarity
moby_polarity <- moby %>%
  # Inner join to the lexicon
  inner_join(bing,by = c('term' = 'word')) %>%
  # Count by sentiment, index
  count(sentiment,index) %>%
  # Spread sentiments
  spread(sentiment,n,fill = 0) %>%
  mutate(
    # Add polarity field
    polarity = positive - negative,
    # Add line number field
    line_number = row_number()
  )
  
  # From previous step
moby_polarity <- moby %>%
  inner_join(bing, by = c("term" = "word")) %>%
  count(sentiment, index) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(
    polarity = positive - negative,
    line_number = row_number()
  )
  
# Plot polarity vs. line_number
ggplot(moby_polarity, aes(line_number,polarity)) + 
  # Add a smooth trend curve
  geom_smooth() +
  # Add a horizontal line at y = 0
  geom_hline(yintercept = 0, color = "red") +
  # Add a plot title
  ggtitle("Moby Dick Chronological Polarity") +
  theme_gdocs()
  ############################################################
  # Word impact, frequency analysis
  
  moby_tidy_sentiment <- moby %>% 
  # Inner join to bing lexicon by term = word
  inner_join(bing, by = c("term" = "word")) %>% 
  # Count by term and sentiment, weighted by count
  count(term, sentiment, wt = count) %>%
  # Spread sentiment, using n as values
  spread(sentiment, n, fill = 0) %>%
  # Mutate to add a polarity column
  mutate(polarity = positive - negative)

# Review
moby_tidy_sentiment
  
 # From previous step
moby_tidy_sentiment <- moby %>% 
  inner_join(bing, by = c("term" = "word")) %>% 
  count(term, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(polarity = positive - negative)

moby_tidy_pol <- moby_tidy_sentiment %>% 
  # Filter for absolute polarity at least 50 
  filter(abs(polarity) >= 50) %>% 
  # Add positive/negative status
  mutate(
    pos_or_neg = ifelse(polarity > 0, "positive", "negative")
  )
  
  # From previous steps
moby_tidy_pol <- moby %>% 
  inner_join(bing, by = c("term" = "word")) %>% 
  count(term, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(polarity = positive - negative) %>% 
  filter(abs(polarity) >= 50) %>% 
  mutate(
    pos_or_neg = ifelse(polarity > 0, "positive", "negative")
  )
  
# Plot polarity vs. (term reordered by polarity), filled by pos_or_neg
ggplot(moby_tidy_pol, aes(reorder(term, polarity), polarity, fill = pos_or_neg)) +
  geom_col() + 
  ggtitle("Moby Dick: Sentiment Word Frequency") + 
  theme_gdocs() +
  # Rotate text and vertically justify
  theme(axis.text.x = element_text(angle = 90, vjust = -0.1))
  
  ############################################################
  # Polarity with a comparison cloud
  
  oz_df <- oz_pol$all %>%
  # Select text.var as text and polarity
  select(text = text.var, polarity = polarity)

# Apply custom function pol_subsections()
all_terms <- pol_subsections(oz_df)

all_corpus <- all_terms %>%
  # Source from a vector
  VectorSource() %>% 
  # Make a volatile corpus 
  VCorpus()
  
  # From previous step
all_corpus <- oz_pol$all %>%
  select(text = text.var, polarity = polarity) %>% 
  pol_subsections() %>%
  VectorSource() %>% 
  VCorpus()
  
all_tdm <- TermDocumentMatrix(
  # Create TDM from corpus
  all_corpus,
  control = list(
    # Yes, remove the punctuation
    removePunctuation = TRUE,
    # Use English stopwords
    stopwords = stopwords(kind = "en")
  )
) %>%
  # Convert to matrix
  as.matrix() %>%
  # Set column names
  set_colnames(c("positive", "negative"))
  
  # From previous steps
all_tdm <- oz_pol$all %>%
  select(text = text.var, polarity = polarity) %>% 
  pol_subsections() %>%
  VectorSource() %>% 
  VCorpus() %>% 
  TermDocumentMatrix(
    control = list(
      removePunctuation = TRUE,
      stopwords = stopwords(kind = "en")
    )
  ) %>%
  as.matrix() %>%
  set_colnames(c("positive", "negative"))
  
comparison.cloud(
  # Create plot from the all_tdm matrix
  all_tdm,
  # Limit to 50 words
  max.words = 50,
  # Use darkgreen and darkred colors
  colors = c("darkgreen", "darkred")
)

  
  ############################################################
  # Subsetting on positive and negative language in Plutchik's emotional wheel
  moby_tidy <- moby %>%
  # Inner join to nrc lexicon
  inner_join(nrc, by = c("term" = "word")) %>% 
  # Drop positive or negative
  filter(!grepl("positive|negative", sentiment)) %>% 
  # Count by sentiment and term
  count(sentiment,term) %>% 
  # Spread sentiment, using n for values
  spread(sentiment,n, fill = 0)  %>% 
  # Convert to data.frame, making term the row names
  data.frame(row.names = "term")

# Examine
head(moby_tidy)

# From previous step
moby_tidy <- moby %>%
  inner_join(nrc, by = c("term" = "word")) %>% 
  filter(!grepl("positive|negative", sentiment)) %>% 
  count(sentiment, term) %>% 
  spread(sentiment, n, fill = 0) %>% 
  data.frame(row.names = "term")
  
# Plot comparison cloud
comparison.cloud(moby_tidy, max.words = 50, title.size = 1.5)

  
  ############################################################
 # Compare and contrast with stacked bar chart
 
 # Review tail of all_books
tail(all_books)

# Count by book & sentiment
books_sent_count <- all_books %>%
  # Inner join to nrc lexicon
  inner_join(nrc, by = c("term" = "word")) %>% 
  # Keep only positive or negative
  filter(grepl("positive|negative", sentiment)) %>% 
  # Count by book and by sentiment
  count(book,sentiment)
  
# Review entire object
books_sent_count

# From previous step
books_sent_count <- all_books %>%
  inner_join(nrc, by = c("term" = "word")) %>% 
  filter(grepl("positive|negative", sentiment)) %>% 
  count(book, sentiment)
  
book_pos <- books_sent_count %>%
  # Group by book
  group_by(book) %>% 
  # Mutate to add % positive column 
  mutate(percent_positive = 100 * n / sum(n) )
  
  # From previous steps
book_pos <- all_books %>%
  inner_join(nrc, by = c("term" = "word")) %>% 
  filter(grepl("positive|negative", sentiment)) %>% 
  count(book, sentiment) %>%
  group_by(book) %>% 
  mutate(percent_positive = 100 * n / sum(n))
  
# Plot percent_positive vs. book, filled by sentiment
ggplot(book_pos, aes(book, percent_positive, fill = sentiment)) +  
  # Add a col layer
  geom_col()
  
 ############################################################
  # Kernel density plot
  ag_afinn <- ag %>% 
  # Inner join to afinn lexicon
  inner_join(afinn, by = c("term" = "word")) 

oz_afinn <- oz %>% 
  # Inner join to afinn lexicon
 inner_join(afinn,by = c('term' = 'word'))

# Combine
all_df <- bind_rows(agamemnon = ag_afinn, oz = oz_afinn, .id = "book")

# From previous step
all_df <- bind_rows(
  agamemnon = ag %>% inner_join(afinn, by = c("term" = "word")), 
  oz = oz %>% inner_join(afinn, by = c("term" = "word")),
  .id = "book"
)

# Plot score, filled by book
ggplot(all_df, aes(score, fill = book)) + 
  # Set transparency to 0.3
  geom_density(alpha = 0.3) + 
  theme_gdocs() +
  ggtitle("AFINN Score Densities")
 
 ############################################################
 # Box plot
 
 # Examine
str(all_book_polarity)

# Summary by document
tapply(all_book_polarity$polarity,all_book_polarity$book,summary)

# Box plot
ggplot(all_book_polarity, aes(x = book, y = polarity)) +
  geom_boxplot(fill = c("#bada55", "#F00B42", "#F001ED", "#BA6E15"), col = "darkred") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 0.02) +
  theme_gdocs() +
  ggtitle("Book Polarity")
    
############################################################
 # Radar chart
 
 # Review tail of moby_huck
tail(moby_huck)

scores <- moby_huck %>% 
  # Inner join to lexicon
  inner_join(nrc, by = c("term" = "word")) %>% 
  # Drop positive or negative sentiments
  filter(!grepl("positive|negative", sentiment)) %>% 
  # Count by book and sentiment
  count(book,sentiment) %>% 
  # Spread book, using n as values
  spread(book, n)

# Review scores
scores

# From previous step
scores <- moby_huck %>% 
  inner_join(nrc, by = c("term" = "word")) %>% 
  filter(!grepl("positive|negative", sentiment)) %>% 
  count(book, sentiment) %>%
  spread(book, n)
  
# JavaScript radar chart
chartJSRadar(scores)
      
############################################################
# Treemaps

book_length <- all_books %>%
  # Count number of words per book
  count(book)
  
# Examine the results
book_length

# From previous step
book_length <- all_books %>%
  count(book)
  
book_tree <- all_books %>% 
  # Inner join to afinn lexicon
  inner_join(afinn, by = c("term" = "word")) %>% 
  # Group by author, book
  group_by(author,book) %>%
  # Calculate mean book score
  summarize(mean_score = mean(score)) %>% 
  # Inner join by book
  inner_join(book_length, by = "book")

# Examine the results
book_tree

# From previous steps
book_length <- all_books %>%
  count(book)
book_tree <- all_books %>% 
  inner_join(afinn, by = c("term" = "word")) %>% 
  group_by(author, book) %>%
  summarize(mean_score = mean(score)) %>% 
  inner_join(book_length, by = "book")

treemap(
  # Use the book tree
  book_tree,
  # Index by author and book
  index = c("author", "book"),
  # Use n as vertex size
  vSize = "n",
  # Color vertices by mean_score
  vColor = "mean_score",
  # Draw a value type
  type = "value",
  title = "Book Sentiment Scores",
  palette = c("red", "white", "green")
)

##################################################################################################################
# Airbnb Case Study: 
# Step 1 - Problem Identification:  Identify what defines a good rental

# Step 2: Identify text sources
# bos_reviews_file has been pre-defined
bos_reviews_file

# load raw text
bos_reviews <- read.csv(bos_reviews_file,stringsAsFactors = FALSE)

# Structure
str(bos_reviews)

# Dimensions
dim(bos_reviews)


############################################################
# Examine basic polarity
# Practice apply polarity to first 6 reviews
practice_pol <- polarity(bos_reviews$comments[1:6])

# Review the object
practice_pol

# Check out the practice polarity
summary(practice_pol$all$polarity)

# Summary for all reviews
summary(bos_pol$all$polarity)

# Plot Boston polarity all element
ggplot(bos_pol$all, aes(x = polarity, y = ..density..)) + 
  geom_histogram(binwidth = 0.25, fill = "#bada55", colour = "grey60") +
  geom_density(size = 0.75) +
  theme_gdocs() 

############################################################
# Step 3: Organize and clean the data
pos_terms <- bos_reviews %>%
  # Add polarity column
  mutate(polarity = bos_pol$all$polarity) %>%
  # Filter for positive polarity
  filter(polarity > 0) %>%
  # Extract comments column
  pull(comments) %>% 
  # Paste and collapse
  paste(collapse = " ")
  
  neg_terms <- bos_reviews %>%
  # Add polarity column
  mutate(polarity = bos_pol$all$polarity) %>%
  # Filter for negative polarity
  filter(polarity < 0) %>%
  # Extract comments column
  pull(comments) %>%
  # Paste and collapse
  paste(collapse = ' ')
  
  # From previous steps
pos_terms <- bos_reviews %>%
  mutate(polarity = bos_pol$all$polarity) %>%
  filter(polarity > 0) %>%
  pull(comments) %>% 
  paste(collapse = " ")
neg_terms <- bos_reviews %>%
  mutate(polarity = bos_pol$all$polarity) %>%
  filter(polarity < 0) %>%
  pull(comments) %>% 
  paste(collapse = " ")

# Concatenate the terms
all_corpus <- c(pos_terms, neg_terms) %>% 
  # Source from a vector
  VectorSource() %>% 
  # Create a volatile corpus
  VCorpus()
  
  # Tidy text tibble
  # Vector to tibble
tidy_reviews <- bos_reviews %>% 
  unnest_tokens(word, comments)

# Group by and mutate
tidy_reviews <- tidy_reviews %>% 
  group_by(id) %>% 
  mutate(original_word_order = seq_along(word))

# Quick review
tidy_reviews

# Load stopwords
data("stop_words")

# Perform anti-join
tidy_reviews_without_stopwords <- tidy_reviews %>% 
  anti_join(stop_words)
  
# Compare Tidy sentiment to Qdap Polarity
# Get the correct lexicon
bing <- get_sentiments('bing')

# Calculate polarity for each review
pos_neg <- tidy_reviews %>% 
  inner_join(bing) %>%
  count(sentiment) %>%
  spread(sentiment, n, fill = 0) %>% 
  mutate(polarity = positive - negative)

# Check outcome
summary(pos_neg)

############################################################
Steps 4 and 5: Feature Extraction and Analysis

# Review tidy_reviews and pos_neg
tidy_reviews
pos_neg

pos_neg_pol <- tidy_reviews %>% 
  # Effort is measured as count by id
  count(id) %>% 
  # Inner join to pos_neg
  inner_join(pos_neg) %>% 
  # Add polarity status
  mutate(pol = ifelse(polarity >= 0, "Positive", "Negative"))

# Examine results
pos_neg_pol

# From previous step
pos_neg_pol <- tidy_reviews %>% 
  count(id) %>% 
  inner_join(pos_neg) %>% 
  mutate(pol = ifelse(polarity >= 0, "Positive", "Negative"))
  
# Plot n vs. polarity, colored by pol
ggplot(pos_neg_pol, aes(polarity, n, color = pol)) + 
  # Add point layer
  geom_point(alpha = 0.25) +
  # Add smooth layer
  geom_smooth(method = "lm", se = FALSE) +
  theme_gdocs() +
  ggtitle("Relationship between word effort & polarity")
  
############################################################
# Comparison Cloud

# Matrix
all_tdm_m <- as.matrix(all_tdm)

# Column names
colnames(all_tdm_m) <- c('positive','negative')

# Top pos words
order_by_pos <- order(all_tdm_m[, 1], decreasing = TRUE)

# Review top 10 pos words
all_tdm_m[order_by_pos, ] %>% head(n = 10)

# Top neg words
order_by_neg <- order(all_tdm_m[,2], decreasing = TRUE)

# Review top 10 neg words
all_tdm_m[order_by_neg, ] %>% head(n = 10)

# From previous step
all_tdm_m <- as.matrix(all_tdm)
colnames(all_tdm_m) <- c("positive", "negative")

comparison.cloud(
  # Use the term-document matrix
  all_tdm_m,
  # Limit to 20 words
  max.words = 20,
  colors = c("darkgreen","darkred")
)


############################################################
# Scaled comparison cloud

# Review
bos_pol$all[1:6,1:3]

# Scale/center & append
bos_reviews$scaled_polarity <- scale(bos_pol$all$polarity)

# Subset positive comments
pos_comments <- subset(bos_reviews$comments, bos_reviews$scaled_polarity >0)

# Subset negative comments
neg_comments <- subset(bos_reviews$comments, bos_reviews$scaled_polarity < 0)

# Paste and collapse the positive comments
pos_terms <- paste(pos_comments, collapse = " ")

# Paste and collapse the negative comments
neg_terms <- paste(neg_comments, collapse = " ")

# Organize
all_terms<- c(pos_terms, neg_terms)

# VCorpus
all_corpus <- VCorpus(VectorSource(all_terms))

# TDM
all_tdm <- TermDocumentMatrix(
  all_corpus, 
  control = list(
    weighting = weightTfIdf, 
    removePunctuation = TRUE, 
    stopwords = stopwords(kind = "en")
  )
)

# Column names
all_tdm_m <- as.matrix(all_tdm)
colnames(all_tdm_m) <- c("positive", "negative")

# Comparison cloud
comparison.cloud(
  all_tdm_m, 
  max.words = 100,
  colors = c("darkgreen", "darkred")
)



