##-------------------------------
## Create emoji reference dataframe
##---------------------------------
## import emoji reference dataframe
#comment
library(stringr)
lines <- readLines("data/emoji-test_edit.txt")
df <- as.data.frame(do.call(rbind, strsplit(lines, split=" {2,40}")), stringsAsFactors=FALSE)
df$V4 <- gsub("[^A-Za-z,\\: \\.\\-]", "", df$V3)
df$V5 <- gsub("[#A-Za-z,\\: \\.\\-]", "", df$V3)

emoji_df <- df[c(1,4:5)]
names(emoji_df) <- c("unicode","words", "emoji")

# add separators around description
emoji_df$words <- str_trim(emoji_df$words)
emoji_df$words <- paste0("(", emoji_df$words, ")")

emoji_df$byte <- iconv(emoji_df$emoji, "UTF8", "ASCII", "byte")

##-------------------------------
## Get sample data
##---------------------------------
load("data/sample_tweets.rdata")
raw_tweets <- tweets

tweets <- raw_tweets %>% 
  mutate(text = iconv(text, from = "latin1", to = "ascii", sub = "byte"))

# sort by longest sequence first 
emoji_df <- emoji_df %>%
  mutate(nchar = nchar(byte)) %>%
  arrange(desc(nchar))

for (i in 1:length(emoji_df$byte)) {
  try(if (str_detect(tweets$text[4], emoji_df$byte[i])) {
    tweets$text[4] <- str_replace_all(tweets$text[4], emoji_df$byte[i], emoji_df$words[i])
  })
  next
  # print(i)
}

### for some reason doesn't replace all of them

tweets$text[4]

