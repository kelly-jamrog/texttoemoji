##-------------------------------
## Create emoji reference dataframe
##---------------------------------
## import emoji reference dataframe
library(stringr)
lines <- readLines("data/emojicode_sample.txt")
df <- as.data.frame(do.call(rbind, strsplit(lines, split=" {2,10}")), stringsAsFactors=FALSE)

# just columns that we need
emoji <- df[c(1,6:7)]
names(emoji) <- c("unicode","code", "words")

# add separators around description
emoji$words <- paste0("(", emoji$words, ")")

emoji$byte <- iconv(emoji$code, "UTF8", "ASCII", "byte")

# extract only byte sequence
emoji$byte <- str_match(emoji$byte, "\\(([<>0-9a-z.]+)\\)")[,2]

# if two emojis on the same line, split
u <- strsplit(emoji$unicode, "\\.\\.")
b <- strsplit(emoji$byte, "\\.\\.")
c <- strsplit(emoji$code, "\\.\\.")
w <- strsplit(emoji$words, "\\.\\.")
separated_df <- data.frame(unicode = unlist(u), 
                           code = unlist(c), 
                           words = unlist(w), 
                           byte = unlist(b), 
                           stringsAsFactors = FALSE)
rm(u, b, c, w)
##------------------------------------
## Preparing test emoji string
##------------------------------------

## sample emoji line
txt <- "i will find out tomorrow 😬"
txt

txt <- "😬😘😖I hate everything"

##-------------------------------
## Function
##---------------------------------
# convert to bytes
txt <- iconv(txt, "UTF8", "ASCII", "byte")

for (i in 1:length(separated_df$byte)) {
  if (str_detect(txt, separated_df$byte[i])) {
    txt <- str_replace_all(txt, separated_df$byte[i], separated_df$words[i])
  }
}

txt

## add if not in bytes and need to use unicode column