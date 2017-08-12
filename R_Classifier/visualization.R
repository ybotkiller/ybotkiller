makeWordCloud <- function(corpus) {
  
  library(wordcloud)
  wordcloud(corpus, max.words = 100, random.order = FALSE)

}

makeWordsHist <- function(df) {
  
  library(ggplot2)
  df %>%
    count(word, sort = TRUE) %>%
    filter(n > 1) %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n)) +
    geom_col() +
    xlab(NULL) +
    coord_flip()
  
  
}

makeLikesHist <- function(df) {
  
  library(ggplot2)
  qplot(df$likes, geom="histogram", xlim=c(-50,50), binwidth = 1) 
  
}

makeBasicAnalytics <- function(df) {
  
  print(summary(df$likes))
  print(summary(df$hasReplies))
  print(summary(df$numberOfReplies))
  print(summary(df$replies.likes))

  
}