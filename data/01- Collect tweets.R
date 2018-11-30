## Collect tweets from twitter

library(twitteR)
library(dplyr)

c_key ="fuqMp3jOw51NQsH1pXyXHXCVB"
c_secret = "wwSZUrAWHhCODSAOT9HPAB6lb76aAMwd1ozo5HEzmozNb7H4VF"
access_token = "826591209359626240-RUI8DLJdztNn8uxu8mRvWaShUfJaTtz"
access_secret = "xbkhXcDoMNszeHQXSSSDB9ow0HEyi1PLHZ4wweqCI0Af1"

setup_twitter_oauth(consumer_key = c_key,
                    consumer_secret = c_secret,
                    access_token=access_token,
                    access_secret=access_secret)

raw_usermedia <- userTimeline(user = "parishilton", n = 3200) %>%
  twListToDF

tweets <- raw_usermedia
save(tweets, file = "data/sample_tweets.rdata")

tweets <- tweets %>% 
  mutate(text = iconv(text, from = "latin1", to = "ascii", sub = "byte"))

