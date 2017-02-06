library(rtweet)
#library(twitteR)

### FIRST WHEN CREATING APP SET CALLBACK TO: http://127.0.0.1:1410


## create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

ecology_tweets <- search_tweets(
  q = "ecology", n = 15000, include_rts = FALSE,
  token = twitter_token, retryonratelimit = TRUE)
dim(ecology_tweets)

invasive_species_tweets <- search_tweets(
  q = "invasive species OR invasives OR #invasivespecies", n = 15000, include_rts = FALSE,
  token = twitter_token, retryonratelimit = TRUE)
dim(invasive_species_tweets)

# Plot multiple time series
ts_plot(invasive_species_tweets, by = "hours", theme = "spacegray", box = FALSE,
        main = "Tweets mentioning ecology capture by rtweet")

cycling_tweets <- search_tweets(
  q = "bikes OR cycling OR biking OR road bike", n = 15000, include_rts = FALSE,
  token = twitter_token, retryonratelimit = TRUE)
dim(cycling_tweets)


ts_plot(cycling_tweets, by = "hours", theme = "spacegray", box = FALSE,
        main = "Tweets mentioning cycling compiled by rtweet")
head(cycling_tweets)

superbowl_tweets <- search_tweets(
q = "superbowl", n = 250000, include_rts = FALSE,
token = twitter_token, retryonratelimit = TRUE)
dim(superbowl_tweets)

ts_plot(superbowl_tweets, by = "mins", theme = "spacegray", box = FALSE,
        main = "Tweets mentioning the Superbowl compiled by rtweet",
        filter = c("brady","ryan"))
dim(superbowl_tweets)

superbowl_stream_tweets <- stream_tweets(q = "superbowl", timeout = (1800))
dim(superbowl_stream_tweets)

ts_plot(superbowl_stream_tweets, by = "mins", theme = "spacegray", box = FALSE,
        #main = "Tweets mentioning the Superbowl compiled by rtweet",
        filter = c("brady","ryan"),
        cols = c("skyblue","red"))

ts_plot(superbowl_stream_tweets, by = "mins", theme = "spacegray", box = FALSE,
        #main = "Tweets mentioning the Superbowl compiled by rtweet",
        filter = c("patriots","falcons"),
        cols = c("skyblue","red"))


####

head(tweets.df)
userInfo <- lookupUsers(tweets.df$screen_name)  # Batch lookup of user info
head(userInfo)
userFrame <- twListToDF(userInfo)  # Convert to a nice dF

locatedUsers <- !is.na(userFrame$location)  # Keep only users with location info

locations <- geocode(userFrame$location[locatedUsers])  # Use amazing API to guess
# approximate lat/lon from textual location data.
with(locations, plot(lon, lat))

worldMap <- map_data("world")  # Easiest way to grab a world map shapefile

zp1 <- ggplot(worldMap)
zp1 <- zp1 + geom_path(aes(x = long, y = lat, group = group),  # Draw map
                       colour = gray(2/3), lwd = 1/3)
zp1 <- zp1 + geom_point(data = locations,  # Add points indicating users
                        aes(x = lon, y = lat),
                        colour = "RED", alpha = 1/2, size = 1)
zp1 <- zp1 + coord_equal()  # Better projections are left for a future post
zp1 <- zp1 + theme_minimal()  # Drop background annotations
print(zp1)
