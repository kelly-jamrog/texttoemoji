##-------------------------------
## Create emoji reference dataframe
##---------------------------------
## import emoji reference dataframe
library(dplyr)
#comment
library(stringr)
lines <- readLines("data/emoji-test_edit.txt")
df <- as.data.frame(do.call(rbind, strsplit(lines, split=" {2,40}")), stringsAsFactors=FALSE)
df$V4 <- gsub("[^A-Za-z0-9,*\\: \\.\\-]", "", df$V3)
df$V5 <- gsub("[#A-Za-z0-9,*\\: \\.\\-]", "", df$V3)

emoji_df <- df[c(1,4:5)]
names(emoji_df) <- c("unicode","words", "emoji")

# add separators around description
emoji_df$words <- str_trim(emoji_df$words)
emoji_df$words <- paste0("(", emoji_df$words, ")")

emoji_df$byte <- iconv(emoji_df$emoji, "UTF8", "ASCII", "byte")

# sort by longest sequence first 
emoji_df <- emoji_df %>%
  mutate(nchar = nchar(byte)) %>%
  arrange(desc(nchar))

save(emoji_df, file = "emoji_ref_df.rda", compress = "xz")
##-------------------------------
## Get sample data
##---------------------------------
load("data/sample_tweets.rdata")
raw_tweets <- tweets

tweets_2 <- raw_tweets %>% 
  mutate(text = iconv(text, from = "UTF8", to = "ascii", sub = "byte"))


# for (i in 1:length(emoji_df$byte)) {
#   try(if (str_detect(tweets$text[4], emoji_df$byte[i])) {
#     tweets$text[4] <- str_replace_all(tweets$text[4], emoji_df$byte[i], emoji_df$words[i])
#   })
#   next
#   print(i)
# }

texttoemoji_for_one <- function(text){
  for (i in 1:length(emoji_df$byte)) {
    print(i)
    if (str_detect(text, emoji_df$byte[i])) {
      text <- str_replace_all(text, emoji_df$byte[i], emoji_df$words[i])
    }
    next
  }
  return(text)
}


texttoemoji <- function(column) {
  # add catch for if do not enter a string
  if(!inherits(column, "str")) stop("Column must be type str")
  lapply(column, function(x){ texttoemoji_for_one(x)})
}

tweets$text <- texttoemoji(tweets$text)

texttoemoji(mtcars$mpg)

##-------------------------------
## JUNK: DELETE ME
##---------------------------------

test <- "i 😍 can't wait . ? !"
iconv(test, "UTF8", "ASCII", "byte")

replace_emoji <- function(byte_seq, text) {
  if (str_detect(text, byte_seq)) {
    replace_with <- emoji_df$words[emoji_df$byte == byte_seq]
    text <- str_replace_all(text, byte_seq, replace_with)
  }
  return(text)
}


test_text <- "hi this should be replaced <f0><9f><91><a8><e2><80><8d><f0><9f><91><a9><e2><80><8d><f0><9f><91><a7><e2><80><8d><f0><9f><91><a6>"
replace_emoji(emoji_df$byte[1], test_text)

x <- lapply(emoji_df$byte, function(x){ replace_emoji(x, test_text)})

x[3567]

tweets$text[4]



texttoemoji_for_one <- function(text){
  for (i in 1:length(emoji_df$byte)) {
    print(i)
    if (str_detect(text, emoji_df$byte[i])) {
      text <- str_replace_all(text, emoji_df$byte[i], emoji_df$words[i])
    }
    next
  }
  return(text)
}

# texttoemoji <- function(column) {
#   for (i in 1:length(column)){
#     column[i] <- texttoemoji_for_one(column[i])
#   }
#   return(column)
# }

texttoemoji <- function(column) {
  lapply(column, function(x){ texttoemoji_for_one(x)})
}

tweets_subset <- tweets[1:100,]

tweets$text[4] <- texttoemoji_for_one(tweets$text[4])
tweets$text[4]

tweets_subset$text <- texttoemoji(tweets_subset$text)

