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
wordcloud(final_zillow$Description, min.freq = 50)
avg_days_city <- sort(tapply(final_zillow$`Days On Zillow`, final_zillow$City, mean))
avg_days_city

avg_days_type <- sort(tapply(final_zillow$`Days On Zillow`, final_zillow$`Property Type`, mean))
avg_days_type

final_zillow$`Year Built` <- as.numeric(final_zillow$`Year Built`)
cor(final_zillow$`Year Built`, final_zillow$Price, use = "complete.obs")

cor(final_zillow$`Year Built`, final_zillow$`Days On Zillow`, use = "complete.obs")
