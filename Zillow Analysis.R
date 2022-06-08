names(final_zillow) <- final_zillow[1,]
final_zillow <- final_zillow[-1,]
city_count <- sort(table(final_zillow$City))
final_zillow$Price <- as.numeric(final_zillow$Price)
avg_price_city <- tapply(final_zillow$Price, final_zillow$City, mean)
avg_price_city <- sort(avg_price_city)
avg_price_city
bedroom_count <- sort(table(final_zillow$Bedrooms))
bedroom_count                      
avg_price_bed <- sort(tapply(final_zillow$Price, final_zillow$Bedrooms, mean))
avg_price_bed
bathroom_count <- sort(table(final_zillow$Bathrooms))
bathroom_count
avg_price_bath <- sort(tapply(final_zillow$Price, final_zillow$Bathrooms, mean))
avg_price_bath
home_type_count <- sort(table(final_zillow$`Property Type`))
home_type_count
avg_price_type <- sort(tapply(final_zillow$Price, final_zillow$`Property Type`, mean))
avg_price_type
description_num_words <- sapply(strsplit(final_zillow$Description, " "), length)
cor(description_num_words, final_zillow$Price, use = "complete.obs")
final_zillow$`Days On Zillow` <- as.numeric(final_zillow$`Days On Zillow`)
cor(final_zillow$`Days On Zillow`, description_num_words, use = "complete.obs")

library("wordcloud")
library("wordcloud2")
library("tm")

avg_days_city <- sort(tapply(final_zillow$`Days On Zillow`, final_zillow$City, mean))
avg_days_city

avg_days_type <- sort(tapply(final_zillow$`Days On Zillow`, final_zillow$`Property Type`, mean))
avg_days_type

final_zillow$`Year Built` <- as.numeric(final_zillow$`Year Built`)
cor(final_zillow$`Year Built`, final_zillow$Price, use = "complete.obs")

cor(final_zillow$`Year Built`, final_zillow$`Days On Zillow`, use = "complete.obs")

write.table(final_zillow$Description, "description.txt", sep = "\t", row.names = FALSE)
desc_words <- file.path("/Volumes/GoogleDrive-100138258112442419298/My Drive/Clubs/DataRes/Consulting/")
description <- Corpus(DirSource(desc_words, pattern = ".txt"))
description <- tm_map(description, removeWords, stopwords("english"))
description <- tm_map(description, removeWords, c("the", "throughout", "this", "located", "offers"))
description <- tm_map(description, removePunctuation)
description <- tm_map(description, stripWhitespace)
description <- tm_map(description, tolower)

wordcloud(description, max.words = 50, family = "serif")

install.packages("syuzhet")
install.packages("lubridate")
library(ggplot2)
library(scales)
install.packages("reshape2")
library(dplyr)
library(syuzhet)
library(lubridate)
library(reshape2)
s <- get_nrc_sentiment(final_zillow$Description)
head(s, 5)

barplot(colSums(s),
        las = 2,
        col = rainbow(10),
        ylab = 'Count',
        main = 'Description Sentiment Scores')

head(s['positive'])

final_zillow$`Positive Sentiment` <- s['positive']
final_zillow$`Negative Sentiment` <- s['negative']

cor(final_zillow$Price, final_zillow$`Positive Sentiment`, use = "complete.obs")
cor(final_zillow$Price, final_zillow$`Negative Sentiment`, use = "complete.obs")
cor(final_zillow$Price, final_zillow$`Days On Zillow`, use = "complete.obs")

install.packages("sentimentr")
library(sentimentr)
sentiment <- sentiment_by(final_zillow$Description)
head(sentiment, 5)
summary(sentiment$ave_sentiment)

final_zillow$`View Count` <- as.numeric(final_zillow$`View Count`)
final_zillow$`Favourite Count` <- as.numeric(final_zillow$`Favourite Count`)

avg_sent_agency <- sort(tapply(sentiment$ave_sentiment, final_zillow$Agency, mean))
head(avg_sent_agency,5)

agencies_negative_sent <- avg_sent_agency[which(avg_sent_agency < 0)]
agencies_pos_sent <- avg_sent_agency[which(avg_sent_agency > 0)]

agency_names_neg_sent <- names(agencies_negative_sent)
agencies_neg <- subset(final_zillow, final_zillow$Agency %in% agency_names_neg_sent)
neg_agency_price <- mean(agencies_neg$Price)

agency_names_pos_sent <- names(agencies_pos_sent)
agencies_pos <- subset(final_zillow, final_zillow$Agency %in% agency_names_pos_sent)
pos_agency_price <- mean(agencies_pos$Price)

mean_prices <- c(pos_agency_price, neg_agency_price)

pos_daysonz <- mean(agencies_neg$`Days On Zillow`)
neg_daysonz <- mean(agencies_pos$`Days On Zillow`)

mean_daysonz <- c(pos_daysonz, neg_daysonz)

neg_viewcount <- mean(agencies_neg$`View Count`)
pos_viewcount <- mean(agencies_pos$`View Count`, na.rm = TRUE)
mean_viewcount <- c(pos_viewcount, neg_viewcount)

neg_favcount <- mean(agencies_neg$`Favourite Count`)
pos_favcount <- mean(agencies_pos$`Favourite Count`, na.rm = TRUE)
mean_favcount <- c(pos_favcount, neg_favcount)

barplot(mean_prices,
        main = "Average Listing Price for Agencies with Average Positive/Negative Description Sentiment",
        ylab = "Average Price ($)",
        col = c("#ffb55a", "#fd7f6f"),
        names = c("Positive Description Sentiment", "Negative Description Sentiment"))

barplot(mean_daysonz,
        main = "Average Days on Zillow for Agencies with Average Positive/Negative Description Sentiment",
        ylab = "Average Number of Days",
        col = c("coral", "lightblue"),
        names = c("Positive Description Sentiment", "Negative Description Sentiment"))

barplot(mean_viewcount,
        main = "Average Listing View Count for Agencies with Average Positive/Negative Description Sentiment",
        ylab = "Average Number of Views",
        col = c("#beb9db", "#d7e1ee"),
        names = c("Positive Description Sentiment", "Negative Description Sentiment"))

barplot(mean_favcount,
        main = "Average Listing Favourite Count for Agencies with Average Positive/Negative Description Sentiment",
        ylab = "Average Number of Favourites",
        col = c("#bad0af", "#f3babc"),
        names = c("Positive Description Sentiment", "Negative Description Sentiment"))

final_zillow$Sentiment <- sentiment$ave_sentiment

sentiment_price_lm <- lm(final_zillow$Sentiment ~ final_zillow$Price)
summary(sentiment_price_lm)

sentiment_favecount_lm <- lm(final_zillow$Sentiment ~ final_zillow$`Favourite Count`)
summary(sentiment_favecount_lm)

sentiment_viewcount_lm <- lm(final_zillow$Sentiment ~ final_zillow$`View Count`)
summary(sentiment_viewcount_lm)

install.packages("party")
library(party)
library(plyr)
library(readr)

input.data <- final_zillow
output.tree <- ctree(Price ~ Sentiment, data = input.data)
output.tree
plot(output.tree)

final_zillow <- final_zillow[!is.na(final_zillow$Sentiment), ]
final_zillow <- final_zillow[!is.na(final_zillow$Price), ]

above <- final_zillow[final_zillow$Sentiment > 0.377, ]
quartiles_above <- quantile(above$Price, probs = c(.25, .75), na.rm = FALSE)
iqr_above <- IQR(above$Price)
lower_above <- quartiles_above[1] - 1.5*iqr_above
upper_above <- quartiles_above[2] + 1.5*iqr_above
above_no_outlier <- subset(above, above$Price > lower_above & above$Price < upper_above)
nrow(above_no_outlier)
boxplot(above_no_outlier$Price)
above_ave_price <- mean(above_no_outlier$Price)

between <- final_zillow[(final_zillow$Sentiment <= 0.377 & final_zillow$Sentiment > 0.001), ]
quartiles_between <- quantile(between$Price, probs = c(.25, .75), na.rm = FALSE)
iqr_between <- IQR(between$Price)
lower_between <- quartiles_between[1] - 1.5*iqr_between
upper_between <- quartiles_between[2] + 1.5*iqr_between
between_no_outlier <- subset(between, between$Price > lower_between & between$Price < upper_between)
nrow(between_no_outlier)
boxplot(between_no_outlier$Price)
between_ave_price <- mean(between_no_outlier$Price)

below <- final_zillow[final_zillow$Sentiment <= 0.001, ]
quartiles_below <- quantile(below$Price, probs = c(.25, .75), na.rm = FALSE)
iqr_below <- IQR(below$Price)
lower_below <- quartiles_below[1] - 1.5*iqr_below
upper_below <- quartiles_below[2] + 1.5*iqr_below
below_no_outlier <- subset(below, below$Price > lower_below & below$Price < upper_below)
nrow(below_no_outlier)
boxplot(below_no_outlier$Price)
below_ave_price <- mean(below_no_outlier$Price)
below_ave_price

table_price <- data.frame(above_no_outlier$Price, between_no_outlier$Price, below_no_outlier$Price)
head(table_price, 5)
boxplot(table_price, main = "Range of Prices Depending on Description Sentiments",
        xlab = "Sentiment", ylab = "Price ($)",
        names = c("Above 0.377", "Between 0.01 and 0.377", "Below 0.01"),
        col = c("#bad0af", "#f3babc", "#ffb55a"))
means <- c(above_ave_price, between_ave_price, below_ave_price)
text(means, labels = paste("Mean:", signif(means, 3)), font = 10)

quartzFonts(avenir = c("Avenir Book", "Avenir Black", "Avenir Book Oblique", "Avenir Black Oblique"))
par(family = 'avenir')
