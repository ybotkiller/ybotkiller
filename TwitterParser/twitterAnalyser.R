rm(list = ls())

library("RSelenium")
library("xlsx")
library("tcltk")

# Initialization
Sys.setlocale("LC_CTYPE","russian")

TABLEFILEPATH = "navalny.xlsx"
TABLEFILEPATH1 = "C:/projects/r/topAnalytics/tvrain.xlsx"
TABLEFILEPATH2 = "C:/projects/r/topAnalytics/EchoMskRu.xlsx"
TABLEFILEPATH3 = "C:/projects/r/topAnalytics/meduzaproject.xlsx"
TABLEFILEPATH4 = "C:/projects/r/topAnalytics/novaya_gazeta.xlsx"
TABLEFILEPATH5 = "C:/projects/r/topAnalytics/villagemsk.xlsx"
TABLEFILEPATH6 = "C:/projects/r/topAnalytics/ru_rbc.xlsx"

TABLEFILEPATH7 = "C:/projects/r/topAnalytics/bigDataSet.xlsx"

link <- "https://twitter.com/navalny?lang=ru"
link1 <- "https://twitter.com/tvrain"
link2 <- "https://twitter.com/EchoMskRu"
link3 <- "https://twitter.com/meduzaproject"
link4 <- "https://twitter.com/novaya_gazeta"
link5 <- "https://twitter.com/villagemsk"
link6 <- "https://twitter.com/ru_rbc"

link7 <- "https://twitter.com/novaya_gazeta"

fprof <- makeFirefoxProfile(list(browser.download.folderList = 2L,
                                 browser.download.manager.showWhenStarting = FALSE,
                                 browser.helperApps.neverAsk.saveToDisk = "application/vnd.android.package-archive,
                                 application/zip, application/octet-stream, text/csv, text/plain, application/xml,
                                 text/xml, text/comma-separated-values"))

mybrowser <- remoteDriver(extraCapabilities = fprof)
mybrowser$open()
mybrowser$setTimeout(type = "page load", milliseconds = 60000)
mybrowser$setImplicitWaitTimeout(milliseconds = 60000)
mybrowser2 <- remoteDriver(extraCapabilities = fprof)
mybrowser2$open()
mybrowser2$setTimeout(type = "page load", milliseconds = 60000)
mybrowser2$setImplicitWaitTimeout(milliseconds = 60000)
mybrowser3 <- remoteDriver(extraCapabilities = fprof)
mybrowser3$open()
mybrowser3$setTimeout(type = "page load", milliseconds = 60000)
mybrowser3$setImplicitWaitTimeout(milliseconds = 60000)

dfReplies <- data.frame(
  class = character(), number = numeric(), text = character(), 
  fullname = character(), username = character(), 
  retweets = numeric(), likes = numeric(), location = character(), time = character(),
  inText = character(), inRetweets = numeric(), inLikes = numeric(),
  uBio = character(), uCreated = character(), uLocation = character(), uWebsite = character(),
  uMedia = character(),
  uTweets = numeric(), uFollowing = numeric(), uFollowers = numeric(), uFavorites = numeric(), uLists = numeric()
)

mybrowser$navigate(link)
Sys.sleep(runif(1,40,60))

# Scroll the page fucking down
# for (i in 1:10) {
#   
#   mybrowser$executeScript("window.scrollTo(0, document.body.scrollHeight)")
# 
# }

tweets <- mybrowser$findElements(using = 'class name', "tweet")

for (i in 1:(length(tweets) - 1)) {

  # Collect the data about original tweet
  
  tweet <- tweets[[i]]
  tweetId <- tweet$getElementAttribute("data-item-id")
  tweetTextContainer <- tweet$findChildElement(using = "class name", value = "js-tweet-text-container")
  text <- unlist(tweetTextContainer$getElementText())
  tweetRetweets <- tweet$findChildElement(using = "class name", value = "ProfileTweet-action--retweet")
  tweetRetweets2 <- tweetRetweets$findChildElement(using = "class name", value = "ProfileTweet-actionCount")
  retweets <- unlist(tweetRetweets2$getElementAttribute("data-tweet-stat-count"))
  tweetLikes <- tweet$findChildElement(using = "class name", value = "ProfileTweet-action--favorite")
  tweetLikes2 <- tweetLikes$findChildElement(using = "class name", value = "ProfileTweet-actionCount")
  likes <- unlist(tweetLikes2$getElementAttribute("data-tweet-stat-count"))
  
  # Collect tweet replies
  
  mybrowser2$navigate(paste(link2, "/status/", tweetId, sep = ""))
  replies1 <- mybrowser2$findElements(using = 'class name', "ThreadedConversation")
  replies2 <- mybrowser2$findElements(using = 'class name', "ThreadedConversation--loneTweet")
  replies <- cbind(replies1, replies2)
  #replies <- replies1
  
  if (length(replies) != 0 ) {
    for (j in 1:length(replies)) {
      
      # Collect the data about every particular reply
      
      reply <- replies[[j]]
      replyNumber <- j
      replyTweet <- reply$findChildElement(using = "class name", value = "tweet")
      replyFullname <- unlist(replyTweet$getElementAttribute("data-name"))
      replyUsername <- unlist(replyTweet$getElementAttribute("data-screen-name"))
      replyTweetTextContainer <- replyTweet$findChildElement(using = "class name", value = "js-tweet-text-container")
      replyText <- unlist(replyTweetTextContainer$getElementText())
      replyTweetTime <- reply$findChildElement(using = "class name", value = "tweet-timestamp")
      replyTime <- unlist(replyTweetTime$getElementAttribute("title"))
      replyTweetRetweets <- replyTweet$findChildElement(using = "class name", value = "ProfileTweet-action--retweet")
      replyTweetRetweets2 <- replyTweet$findChildElement(using = "class name", value = "ProfileTweet-actionCount")
      replyRetweets <- unlist(replyTweetRetweets2$getElementAttribute("data-tweet-stat-count"))
      replyTweetLikes <- replyTweet$findChildElement(using = "class name", value = "ProfileTweet-action--favorite")
      replyTweetLikes2 <- replyTweetLikes$findChildElement(using = "class name", value = "ProfileTweet-actionCount")
      replyLikes <- unlist(replyTweetLikes2$getElementAttribute("data-tweet-stat-count"))
      replyTweetLocation <- replyTweet$findChildElements(using = "class name", value = "Tweet-geo")
      if (length(replyTweetLocation) == 0) {
        replyLocation <- ""
      } else {
        replyLocation <- unlist(replyTweetLocation[[1]]$getElementAttribute("title"))
      }
      replyClass <- ""
      
      # Collect the data about the author of each reply
      
      mybrowser3$navigate(paste("https://twitter.com/", replyUsername, sep = ""))
      uBioEl <- mybrowser3$findElement(using = 'class name', value = "ProfileHeaderCard-bio")
      uBio <- unlist(uBioEl$getElementText())
      uCreatedEl <- mybrowser3$findElement(using = 'class name', value = "ProfileHeaderCard-joinDateText")
      uCreated <- unlist(uCreatedEl$getElementAttribute("title"))
      
      uLocationEl <- mybrowser3$findElements(using = 'class name', value = "ProfileHeaderCard-locationText")
      if (length(uLocationEl) == 0) {
        uLocation <- ""
      } else {
        uLocation <- uLocationEl[[1]]$getElementText()
      }
      
      uWebsiteEl <- mybrowser3$findElements(using = 'class name', value = "ProfileHeaderCard-urlText")
      if (length(uWebsiteEl) == 0) {
        uWebsite <- ""
      } else {
        uWebsite <- uWebsiteEl[[1]]$getElementAttribute("title")
      }
      
      uMediaEl <- mybrowser3$findElements(using = 'class name', value = "PhotoRail-headingWithCount")
      if (length(uMediaEl) == 0) {
        uMedia = ""
      } else {
        uMedia <- unlist(uMediaEl[[1]]$getElementText())
      }

      uTweetsEl <- mybrowser3$findElements(using = 'class name', value = "ProfileNav-item--tweets")
      if (length(uTweetsEl) == 0) {
        uTweets <- ""
      } else {
        uTweetsEl2 <- uTweetsEl[[1]]$findChildElement(using = 'class name', value = "ProfileNav-stat")
        uTweets <- unlist(uTweetsEl2$getElementAttribute("title"))
      }
      
      uFollowingEl <- mybrowser3$findElements(using = 'class name', value = "ProfileNav-item--following")
      if (length(uFollowingEl) == 0) {
        uFollowing <- ""
      } else {
        uFollowingEl2 <- uFollowingEl[[1]]$findChildElement(using = 'class name', value = "ProfileNav-stat")
        uFollowing <- unlist(uFollowingEl2$getElementAttribute("title"))
      }
      
      uFollowersEl <- mybrowser3$findElements(using = 'class name', value = "ProfileNav-item--followers")
      if (length(uFollowersEl) == 0) {
        uFollowers = ""
      } else {
        uFollowersEl2 <- uFollowersEl[[1]]$findChildElement(using = 'class name', value = "ProfileNav-stat")
        uFollowers <- unlist(uFollowersEl2$getElementAttribute("title"))
      }
      
      uFavoritesEl <- mybrowser3$findElements(using = 'class name', value = "ProfileNav-item--favorites")
      if (length(uFavoritesEl) == 0) {
        uFavorites = ""
      } else {
        uFavoritesEl2 <- uFavoritesEl[[1]]$findChildElement(using = 'class name', value = "ProfileNav-stat")
        uFavorites <- unlist(uFavoritesEl2$getElementAttribute("title"))
      }
      
      uListsEl <- mybrowser3$findElements(using = 'class name', value = "ProfileNav-item--lists")
      if (length(uListsEl) == 0) {
        uLists = ""
      } else {
        uListsEl2 <- uListsEl[[1]]$findChildElement(using = 'class name', value = "ProfileNav-stat")
        uLists <- unlist(uListsEl2$getElementAttribute("title"))
      }

      # Trim all the values
      uMedia = gsub("[^0-9]", "", uMedia)
      uTweets = gsub("[^0-9]", "", uTweets)
      uFollowing = gsub("[^0-9]", "", uFollowing)
      uFollowers = gsub("[^0-9]", "", uFollowers)
      uFavorites = gsub("[^0-9]", "", uFavorites)
      uLists = gsub("[^0-9]", "", uLists)
      
      # Add collected data into the main table
      
      dfRepliesX <- data.frame(
        (replyClass), (replyNumber), (replyText), (replyFullname), (replyUsername), 
        (replyRetweets), (replyLikes), (replyLocation), (replyTime), (text), (retweets), (likes),
        (uBio), (uCreated), (uLocation), (uWebsite),
        (uMedia), (uTweets), (uFollowing), (uFollowers), (uFavorites), (uLists)
      )
      names(dfRepliesX) <- names(dfReplies)
      dfReplies <- rbind(dfReplies, dfRepliesX)
      save(dfReplies, file = "dfReplies.RData")
      
    }
  }
}

# Record tweet data into xls file
myfile <- file.path(TABLEFILEPATH)
sheetName = gsub(":", ".", format(Sys.time(), "%Y-%m-%d %X"))
write.xlsx(dfReplies, file = myfile, sheet = sheetName, col.names = TRUE, row.names = FALSE, append = TRUE)
wb <- loadWorkbook(myfile)
sheets <- getSheets(wb)
x <- length(sheets)
setColumnWidth(sheets[[x]], 1, colWidth = 10)
setColumnWidth(sheets[[x]], 2, colWidth = 4)
setColumnWidth(sheets[[x]], 3, colWidth = 80)
setColumnWidth(sheets[[x]], 4, colWidth = 20)
setColumnWidth(sheets[[x]], 5, colWidth = 20)
setColumnWidth(sheets[[x]], 6, colWidth = 4)
setColumnWidth(sheets[[x]], 7, colWidth = 4)
setColumnWidth(sheets[[x]], 8, colWidth = 15)
setColumnWidth(sheets[[x]], 9, colWidth = 15)
setColumnWidth(sheets[[x]], 10, colWidth = 20)
setColumnWidth(sheets[[x]], 11, colWidth = 4)
setColumnWidth(sheets[[x]], 12, colWidth = 4)
setColumnWidth(sheets[[x]], 13, colWidth = 10)
setColumnWidth(sheets[[x]], 14, colWidth = 8)
setColumnWidth(sheets[[x]], 15, colWidth = 8)
setColumnWidth(sheets[[x]], 16, colWidth = 8)
setColumnWidth(sheets[[x]], 17, colWidth = 5)
setColumnWidth(sheets[[x]], 18, colWidth = 5)
setColumnWidth(sheets[[x]], 19, colWidth = 5)
setColumnWidth(sheets[[x]], 20, colWidth = 5)
setColumnWidth(sheets[[x]], 21, colWidth = 5)
saveWorkbook(wb, myfile)

alarm()
cat('Hello world!\a')
tt <- tktoplevel()
tkpack( tkbutton(tt, text = 'Continue', command = function()tkdestroy(tt)),
        side = 'bottom')
tkbind(tt,'<Key>', function()tkdestroy(tt) )
print("CAPTCHA")

tkwait.window(tt)


# It works without this complicated function
getPageWithRandomUA <- function(url) {
  ua <-
    c(
      "Mac / Firefox 29: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0",
      "Mac / Chrome 34: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36",
      "Mac / Safari 7: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14",
      "Windows / Firefox 29: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20100101 Firefox/29.0",
      "Windows / Chrome 34: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36",
      "Windows / IE 9: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
      "Windows / IE 10: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)",
      "Windows / IE 11: Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
      "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
      "Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
    )
  doc <- GET(url, user_agent(ua[[sample(1:11,1)]]))
  if (doc$status_code == 404) {
    result <- "404"
    print(result)
  } else if (doc$status_code == 403) {
    result <- "403"
  } else {
    result <- read_html(doc)
  }
  
  return(result)
}

