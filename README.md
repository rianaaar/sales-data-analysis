<h1>Sales Data Analysis</h1>
Sales Data Analysis and Forecasting using ARIMA

<h3>Dataset</h3>
Data Description: 
<ul>1. Date : Date of transaction <br>
2. SKU : Name of product <br>
3. Price : Price of product <br>
4. Store : Code of the store <br>
5. Promo_item : Whether product have promo or not (1 : yes, 2 : no) <br>
6. Promo_card : Whether Mega card have promo or not (1 : yes, 2 : no) <br>
7. Qty : Number of items that success in transactions <br> </ul>


<h3>Benefit of analysis</h3>
Analysis was carried out to:
<ul>1. Estimating future sales<br>
2. Does the promo item and card promo affect the number of items sold? <br> </ul>
These results can be used to determine good strategies to increase sales.

<h2>Result</h2>
<h3> Descriptive Analysisis</h3>
Summary Statistic:
<img src="usecase(1).png">
correlation between Number of items that success in transactions and other feature<br>
Prices that have the most sales are in the range of Rp.2,000-2300. However, there are few sales at prices of more than Rp.4,000. price is quite influential on sales. <br>
The store with the most sales is store B. needs to be seen further what makes store B have the most sales.<br>

Trend Sales
<img src="usecase(1).png">
The number of items that success in transactions decreased at the end of 2016 and at the beginning of 2017 was almost stable and decreased again until early 2019.<br>
Trend Sales based on Store
<img src="usecase(1).png">
The number of items that success in transactions in store A began to decline in mid-2017, while in Stores B and C the trend was the same as the overall sales. <br>

Does the promo item and card promo affect the number of items that success in transactions.
<img src="usecase(1).png">
<img src="usecase(1).png">
Lets check top 10 the highers number of items sales.
<img src="usecase(1).png">
<img src="usecase(1).png">
<img src="usecase(1).png">
Toko B has more sales because it has more promos.

<h3> Statistic Test </h3>
Does the promo item and card promo affect the number of items that success in transactions?
<img src="usecase(1).png">
The existence of promo items will increase the chance of increasing the number of items sold, this opportunity is significant in the real level of 0.01 and the presence of promo cards will increase the number of items sold, this opportunity is significant in the significance level of 0.01. then the existence of both will increase the chance of increasing the number of items sold, but this opportunity is not significant in the significance level of 0.01.

Check the relationship between variables, whether interdependent:
<img src="usecase(1).png">
p-Value less than the significance level of 0.01., i conclude that the two variables are dependent.<br>

Sales Forecasting
<img src="usecase(1).png">
Estimated sales of 2019-2022 will decrease and increase. This estimate is based on data from previous years.

<h3> Conclusion </h3>
For the sale of sg products (name of product), the price is suitable between 2000-23000. Total sales depends on promo items and promo cards. Promo cards are more influential when compared to promo items. I suggest using promo cards or promo items to increase sales, preferably promo cards especially for prices above the average price. Further analysis regarding customer behavior must be done to determine when the right time to give promo items or promo cards and whoever we have to give promo because not everyone uses card to shop. Temporary assumption, promos are given at the beginning of the month because people tend to have money and have needs at the beginning of the month.
<h3>Reference:</h3>
<ul>
<li> <a href="http://r-statistics.co/Time-Series-Forecasting-With-R.html"> Time Series Forecasting</a> </li><br>
<li> <a href="https://data-flair.training/blogs/chi-square-test-in-r/">Chi Square Test</a></ul> </li>
