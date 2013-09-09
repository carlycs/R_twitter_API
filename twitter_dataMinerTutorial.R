#reference: 
# R and Data Mining: Examples and Case Studies1 2
# Yanchang Zhao
# yanchangzhao@gmail.com
# http://www.RDataMining.com
###############################################

install.packages("twitteR")
install.packages("RCurl")
install.packages("XML")
library(twitteR)
library(RCurl)
library(XML)
library(ROAuth)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL = "http://api.twitter.com/oauth/access_token"
authURL = "http://api.twitter.com/oauth/authorize"
consumerKey = "qbnVaHtXMaz40OiWlA"
consumerSecret = "XtNtyVRQJPR3xRq1cdjkwmsJA2zyJ94TepZRiAWz4"
Cred <- OAuthFactory$new(consumerKey=consumerKey,
                         consumerSecret=consumerSecret,
                         requestURL=requestURL,
                         accessURL=accessURL, 
                         authURL=authURL)
#The next command provides a URL which you will need to copy and paste into your favourite browser
#Assuming you are logged into Twitter you will then be provided a PIN number to type into the R command line
Cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl") );
# Checks that you are authorised
registerTwitterOAuth(Cred)

rdmTweets <- userTimeline("hoofar", n=200)
(nDocs <- length(rdmTweets))

rdmTweets[11:15]

for (i in 11:15) {
  cat(paste("[[", i, "]] ", sep=""))
  writeLines(strwrap(rdmTweets[[i]]$getText(), width=73))
  }


# convert tweets to a data frame
df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)
install.packages("tm")
library(tm)
# build a corpus, and specify the source to be character vectors
 myCorpus <- Corpus(VectorSource(df$text))

# convert to lower case
   myCorpus <- tm_map(myCorpus, tolower)
# remove punctuation
   myCorpus <- tm_map(myCorpus, removePunctuation)
# remove numbers
   myCorpus <- tm_map(myCorpus, removeNumbers)
# remove URLs
   removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
 myCorpus <- tm_map(myCorpus, removeURL)
# add two extra stop words: "available" and "via"
   myStopwords <- c(stopwords('english'), "available", "via")
# remove "r" and "big" from stopwords
   idx <- which(myStopwords %in% c("r", "big"))
 myStopwords <- myStopwords[-idx]
# remove stopwords from corpus
   myCorpus <- tm_map(myCorpus, removeWords, myStopwords)


# keep a copy of corpus to use later as a dictionary for stem completion
   myCorpusCopy <- myCorpus
# stem words
   myCorpus <- tm_map(myCorpus, stemDocument)
# inspect documents (tweets) numbered 11 to 15
# inspect(myCorpus[11:15])
# The code below is used for to make text fit for paper width
  for (i in 11:15) {
     cat(paste("[[", i, "]] ", sep=""))
     writeLines(strwrap(myCorpus[[i]], width=73))
     }

myTdm <- TermDocumentMatrix(myCorpus, control = list(wordLengths=c(1,Inf)))
myTdm

idx <- which(dimnames(myTdm)$Terms == "r")
inspect(myTdm[idx+(0:5),101:110])


termFrequency <- rowSums(as.matrix(myTdm))
termFrequency <- subset(termFrequency, termFrequency>=10)
#######ggplot Example
install.packages("ggplot2")
library(ggplot2)
qplot(names(termFrequency), termFrequency, geom="bar") + coord_flip()


######word cloud 
install.packages("wordcloud")
library(wordcloud)
m <- as.matrix(myTdm)
# calculate the frequency of words and sort it descendingly by frequency
wordFreq <- sort(rowSums(m), decreasing=TRUE)
# word cloud
set.seed(375) # to make it reproducible
grayLevels <- gray( (wordFreq+10) / (max(wordFreq)+10) )
wordcloud(words=names(wordFreq), freq=wordFreq, min.freq=3, random.order=F,
             colors=grayLevels)


