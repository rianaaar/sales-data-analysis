#eksplor Data
data <- read.csv("train_data_de.csv", sep=';')
str(data)
dataset <- data
####praproses data#####
#cek missing value
library(mice)
md.pattern(dataset)
#trasformasi data
dataset$date <- as.Date(dataset$date,format = "%d/%m/%Y")
dataset$sku <- as.factor(dataset$sku)
dataset$Store <- as.factor(dataset$Store)
dataset$promo_item <- as.factor(dataset$promo_item)
dataset$promo_card <- as.factor(dataset$promo_card)
str(dataset)
summary(dataset)

##korelasi antar fitur
library("ggplot2")
library("cowplot")
library(ggthemes)
#par(mfrow=c(1,2))  
#penjualan dengan tanggal transaksi
ggplot(data=dataset)+
  geom_smooth(mapping=aes(x=date, y=qty))
#penjualan dengan harga
viz2 <- ggplot(dataset,aes(x = Price,y = qty, color=Store)) + geom_point() +
  scale_color_discrete(name="") + theme(legend.position="top")
cor(dataset$Price, dataset$qty)
#penjualan dengan store
viz3 <- ggplot(dataset,aes(x = Store,y = qty, color = Store)) + geom_point() +
  scale_color_discrete(name="") + theme(legend.position="top")
#penjualan dengan promo item
viz4 <- ggplot(dataset,aes(x = promo_item,y = qty, color = promo_item)) + geom_point() +
  scale_color_discrete(name="") + theme(legend.position="top")
#penjualan dengan promo card
viz5 <- ggplot(dataset,aes(x = promo_card,y = qty, color = promo_card)) + geom_point() +
  scale_color_discrete(name="") + theme(legend.position="top")
plot_grid(viz2, viz3,labels = "AUTO")

ggplot(data=dataset)+
  geom_point(mapping=aes(x=date, y=qty, color= promo_card)) +
  theme_few() +
  xlab("Date") +
  ylab("Qty") +
  facet_wrap(~Store) + 
  scale_fill_discrete(name = "promo_card")

ggplot(data=dataset)+
  geom_smooth(mapping=aes(x=date, y=qty, color= promo_item)) + 
  theme_few() +
  xlab("Date") +
  ylab("Qty") +
  #facet_wrap(~Store) + 
  scale_fill_discrete(name = "promo_item")

ggplot(data=dataset)+
  geom_point(mapping=aes(x=Price, y=qty, color= promo_item)) + 
  theme_few() +
  xlab("Price") +
  ylab("Qty") +
  #facet_wrap(~Store) + 
  scale_fill_discrete(name = "promo_item")

ggplot(data=dataset)+
  geom_point(mapping=aes(x=Price, y=qty, color= promo_card)) + 
  theme_few() +
  xlab("Price") +
  ylab("Qty") +
  #facet_wrap(~Store) + 
  scale_fill_discrete(name = "promo_card")
group_by(df$Store)
df <-dataset[order(dataset$qty,dataset$date,decreasing = T),]
head(df,10)
head(df[which(df$promo_item==1 & df$promo_card==0),],10)
View(df)
#df %>% mutate(year=format(as.Date(df$date, format="%d/%m/%Y"),"%Y")) %>% group_by(year,qty)
df %>% sort(date)
##penjualan terbanyak di toko
library("dplyr")
TA<- filter(dataset, dataset$Store=='ta')
TB<- filter(dataset, dataset$Store=='tb')
TC<- filter(dataset, dataset$Store=='tc')

TAsum <- TA %>% group_by(date) %>% 
  summarise(total_penjualan=sum(qty)) 
TBsum <- TB %>% group_by(date) %>% 
  summarise(total_penjualan=sum(qty)) 
TCsum <- TC %>% group_by(date) %>% 
  summarise(total_penjualan=sum(qty)) 
## Tabulate
tab <- table(cut(TC$date, 'day'))
## Format
freq_date <- data.frame(Date=format(as.Date(names(tab)), '%d%m/%Y'), Frequency=as.vector(tab))
freq_date[which(freq_date$Frequency > 1),]
TC[which(TC$date == '2016-12-07'),]
TC[which(TC$date == '2016-12-08'),]
TC[which(TC$date == '2017-07-13'),]

p <- ggplot() +
  # blue plot
  #geom_line(data=TAsum, aes(x=date, y=total_penjualan)) + 
  geom_smooth(data=TAsum, aes(x=date, y=total_penjualan,
                              colour="Sales Store A"), fill="blue", size=1) +
  # red plot
  #geom_line(data=TBsum, aes(x=date, y=total_penjualan)) + 
  geom_smooth(data=TBsum, aes(x=date, y=total_penjualan,
                              colour="Sales Store B"), fill="red", size=1) +
  # green plot
  #geom_line(data=TCsum, aes(x=date, y=total_penjualan)) + 
  geom_smooth(data=TCsum, aes(x=date, y=total_penjualan, colour="Sales Store C"), fill="green",
              size=1) +
  labs(title = "Total Penjualan") + scale_colour_manual(name="legend", values=c("blue", "red", "green"))
p
#apakah harga mempengaruhi penjualan

#apakah promo_item and promo_card mempengaruhi transaksi yang sukses
data_sales <- dataset[1:2397,c("promo_item","promo_card","qty")]
hist(data_sales$qty)
median(data_sales$qty)
#1=high transaction, 0=low
data_sales$transaction <- ifelse(data_sales$qty>median(data_sales$qty),"1","0")
data_sales$transaction <- as.factor(data_sales$transaction)
summary(data_sales)
table(data_sales$transaction, data_sales$promo_card)
xtabs(~transaction + promo_item, data = data_sales)
#
modeling <- glm(transaction ~ promo_item+promo_card+promo_item*promo_card , data = data_sales, family = "binomial") #Regresi Logisitik Biner
summary(modeling)
chisq.test(data_sales$transaction,data_sales$promo_item,correct=FALSE)
chisq.test(data_sales$transaction,data_sales$promo_card,correct=FALSE)
chisq.test(data_sales$promo,data_sales$promo_card,correct=FALSE)
ggplot() + geom_point(data=data_sales, aes(x=promo_card, y=qty,
                            colour=transaction), fill="red", size=1)
## forcast
library(forecast)
library(ggfortify)

##Convert to time series data
data_ts <- dataset ; data_ts$sku <- NULL ; dataset$month <- NULL
data_ts$Price <- NULL ; data_ts$Store <- NULL
data_ts$promo_card <- NULL ; data_ts$promo_item <- NULL
data_ts <-ts(data_ts$qty, start=c(2016,1),  frequency=12)
data.train <- window(data_ts,star=2016,end=c(2019,3))
# implementing auto.arima() to forecast
Fit <- auto.arima(data.train, seasonal=FALSE, xreg=fourier(data.train,4))  # fit auto.arima model
summary(Fit)
library(highcharter) 
# Set highcharter options
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))
result_pred <- forecast(Fit, h=15*3, xreg=fourierf(data.train,4,15*3))
result_pred
hchart(result_pred)
# 
library(gganimate)
library(png)
library(gifski)
library(plotly)
result <- ggplot(data=dataset)+
  geom_smooth(mapping=aes(x=date, y=qty, color= Store))
result + transition_time(year) +
  labs(title = "Date: {frame_time}")
dataset %>% hchart( "line", hcaes(x = date, y = qty, group = Store))
ggplotly(result)
# data.test <- window(data_ts, star = 2019)
#Using the training data, develop a forecast based on STL decomposition
# myts_SeasonalNaive <- snaive(data.train, 12*2)
# myts_SeasonalNaive
# plot(myts_SeasonalNaive)
#Seri data stasioner, yang berarti bahwa mean dan varians tidak boleh berbeda dengan waktu.  Seri dapat dibuat diam dengan menggunakan transformasi log atau membedakan seri.
#Data yang diberikan sebagai input harus berupa seri univariat, karena arima menggunakan nilai masa lalu untuk memprediksi nilai masa depan.
####Prediksi Qty###
# training = dataset[3:7]
# testing = data_test[3:6]
# levels(testing$promo_item) <- levels(training$promo_item)
# modeling <- lm(qty~. ,data=training)
# summary(modeling)
# plot(modeling)
# sqrt(mean(modeling$residuals^2))
# #Adjusted R square yaitu 0.223 yang artinya sebanyak 22.3% keragaman jumlah penjualan mampu dijelaskan oleh jumlah pengangguran dan sisanya dijelaskan oleh faktor lainnya
# prediksi <- predict(modeling,testing)
# prediksi <- round(prediksi)
# data_test$qty <- prediksi
# ggplot(data=data_test)+
#   geom_smooth(mapping=aes(x=date, y=qty))
# merge_data <- rbind(dataset,data_test)
# str(merge_data)