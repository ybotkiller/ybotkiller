# rm(list = ls())
source("visualization.R")

# df <- read.csv(file = "data/comments.csv", encoding = "UTF-8")
# save(df, file = "df.RData")
# library("xlsx")
# df <- read.xlsx(file = "data/classified2000_2.xlsx", sheetIndex = 1, header = TRUE, encoding = "UTF-8")
# save(df, file = "df.RData")
load("df.RData")


df_1 <- df[!is.na(df$class),]
df_1 <- df_1[,1:9]

# 
# df_2_Ok <- df[df$replies.class == 0, ]
# df_2_Ok <- df_2_Ok[!is.na(df_2_Ok$replies.class),]
# df_2_Bot <- df[df$replies.class == 1, ]
# df_2_Bot <- df_2_Bot[!is.na(df_2_Bot$replies.class),]


evaluateResults <- function(df_test_pred, df_test_labels) {
  
  library("gmodels")
  CrossTable(df_test_pred, df_test_labels,
             prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE,
             dnn = c('predicted', 'actual'))
  tbl <- table(df_test_pred, df_test_labels)
  mistakes = sum(tbl) - sum(diag(tbl))
  effectiveness = sum(diag(tbl)) / (sum(tbl))
  print(str(mistakes))
  print(str(effectiveness))
  
  library(ROCR);
  pred <- prediction(as.numeric(df_test_pred), as.numeric(df_test_labels));
  perf1 <- performance(pred, "prec", "rec");
  plot(perf1);
  perf2 <- performance(pred, "tpr", "fpr");
  plot(perf2);
  auc.tmp <- performance(pred,"auc");
  auc <- as.numeric(auc.tmp@y.values);
  
  #library("vcd")
  #library("caret")
  #library("ROCR")
  
  #print(kappa(table(df_test_labels,df_test_pred)))
  #print(sensitivity(df_test_labels,df_test_pred))
  #print(specificity(df_test_labels,df_test_pred))
  #print(posPredValue(df_test_labels,df_test_pred))
  
}



# set.seed(1)
# data <- data[sample(nrow(data)),]

# Create corpus
library("tm")
library("stringr")
library("SnowballC")
# df$commentText <- sapply(df$commentText,function(row) iconv(row, "utf-8", "utf-8", sub=""))
# usableText <- iconv(df$commentText, 'UTF-8', 'UTF-8')


# df <- df_2_Bot
df <- df_1

usableText = str_replace_all(df$commentText,"[^[:graph:]]", " ") 
corpus <- VCorpus(VectorSource(usableText))
corpus_clean <- tm_map(corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords("russian"))
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stemDocument, "russian")
corpus_clean <- tm_map(corpus_clean, stripWhitespace)
replacePunctuation <- function(x) {
  gsub("[[:punct:]]+", " ", x)
}



# Create document term matrix
dtm <- DocumentTermMatrix(corpus_clean, control = list(removePunctuation = TRUE,
                                                       stopwords = TRUE,
                                                       tolower=FALSE))

sparse <- 0.999
dtm2 <- removeSparseTerms(dtm, sparse)
data_dtm <- as.data.frame(as.matrix(dtm2)) 

data_dtm <- data_dtm[, !duplicated(colnames(data_dtm))]
for (i in 1:ncol(data_dtm)) {
  data_dtm[,i] <- as.factor(as.character(data_dtm[,i]))
}
# data_dtm <- data[ , (names(data) %in% c("блять", "молодцы", "тупая"))]


# listBad <- c("")
# listSwearing <- c("")

data <- cbind(df, data_dtm)
data$class <- as.factor(as.character(data$class))

# Visualize data
# makeWordCloud(corpus_clean)
# makeWordsHist(data_dtm)


# # Make terms table
#
# df_terms <- data.frame(term = character(ncol(data_dtm)),
#                  ok = integer(ncol(data_dtm)), 
#                  bot = integer(ncol(data_dtm)), stringsAsFactors = FALSE)
# 
# df_1_Ok <- data[data$class == 0, ]
# df_1_Ok <- df_1_Ok[!is.na(df_1_Ok$class),]
# df_1_Bot <- data[data$class == 1, ]
# df_1_Bot <- df_1_Bot[!is.na(df_1_Bot$class),]
# 
# for (i in 1:ncol(data_dtm)) {
#   df_terms$term[i] = as.character(unlist(colnames(data_dtm[i])))
#   df_terms$ok[i] = sum(as.numeric(as.character(df_1_Ok[,9+i])))
#   df_terms$bot[i] = sum(as.numeric(as.character(df_1_Bot[,9+i])))
# }
# 
# library(xlsx)
# write.xlsx2(df_terms, file = "data/terms.xlsx", sheetName="data", col.names=TRUE, row.names=FALSE, append=FALSE)

# # Make df of equal size of classes
# data <- rbind(df_1_Ok[1:nrow(df_1_Bot),], df_1_Bot)

set.seed(2)
sampleForData <- sample(nrow(data), round(nrow(data) * 0.8))
data_train1 <- data[sampleForData,]
data_test1 <- data[-sampleForData,]
data_train = data_train1[ , !(names(data_train1) %in% c("id", "user", "date", "timestamp", "commentText"))]
data_test = data_test1[ , !(names(data_test1) %in% c("id", "user", "date", "timestamp", "commentText"))]

data_train_labels <- factor(data_train$class)
data_test_labels <- factor(data_test$class)

start.time <- Sys.time()


# library("class")
# data_test_pred <- knn(train = data_train, test = data_test,
#                       cl = data_train_labels, k = 10)
# evaluateResults(data_test_labels, data_test_pred)
# 
# library("C50")
# tree_model <- C5.0(data_train, data_train_labels, trials = 100)
# data_test_pred <- predict(tree_model, data_test, type = "class")
# evaluateResults(data_test_labels, data_test_pred)


# library("kernlab")
# data_train <- data_train[, !duplicated(colnames(data_train))]
# # svm_classifier <- ksvm(class ~ ., data = data_train, kernel = "polydot", C = 1, sigma = 1)
# svm_classifier <- ksvm(class ~ ., data = data_train, kernel = "polydot")
# data_test_pred <- predict(svm_classifier, data_test)
# evaluateResults(data_test_labels, data_test_pred)

require("caret")
fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 1)
# fitControl <- trainControl(method = "none")
model <- train(class ~ ., data = data_train,
               # tuneLength = 1,
               method = "naive_bayes", na.action = na.omit,
               trControl = fitControl)

df_test_pred <- predict(model, data_test)
evaluateResults(df_test_pred, data_test_labels)


# for (i in 1:length(df_test_pred)) {
#   if (df_test_pred[i] == 1) {
#     print(i)
#   }
# }
# 
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# library("xlsx")
# write.xlsx2(df, file = "data/classified.xlsx", sheetName="data", col.names=TRUE, row.names=FALSE, append=FALSE)
