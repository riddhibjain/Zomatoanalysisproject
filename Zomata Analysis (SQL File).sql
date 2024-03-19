create database Zomato_analysis ;
use Zomato_analysis ;
select * from main ;

set sql_safe_updates=0 ;
ALTER TABLE main ADD COLUMN Datekey_opening DATE;
UPDATE MAIN SET Datekey_opening = concat(yearopening,'-',monthopening,'-',dayopening) ;
select * from main ;


-- 2)Date Calendar.

select datekey_opening,
year(Datekey_Opening) as Years,
month(Datekey_Opening) as Monthno,
monthname(Datekey_Opening) as Monthname,
CONCAT("Q",Quarter(Datekey_Opening)) as Quarters,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) AS YearMonth, 
weekday(Datekey_Opening) as Weekday,
dayname(datekey_opening) as WeekdayName,

CASE when month(Datekey_Opening)>=4 then 
concat("FM",month(Datekey_Opening)-3) else 
concat("FM",month(Datekey_Opening)+9)  end as FM_Months ,

CASE when quarter(Datekey_Opening)= 1 THEN 'F-Q4'
WHEN quarter(Datekey_Opening)=2 THEN 'F-Q1'
WHEN quarter(Datekey_Opening)=3 THEN 'F-Q2'
WHEN quarter(Datekey_Opening)=4 THEN 'F-Q3' 
 end as F_Quarters  
from main  ;


-- 3)Currency Conversion.

select c.countryname , m.currency , m.Average_Cost_for_two , m.Average_Cost_for_two * cr.usdrate as Average_Cost_for_two_USD
from main as m join currency as cr using (currency) join country as c on m.countrycode = c.countryid ;


-- 4)Find the Numbers of Resturants based on City and Country.

Select c.countryname , m.city , count(m.restaurantid) as Count_of_restaurant 
from main as m join country as c on m.countrycode = c.countryid
group by c.countryname , m.city order by c.countryname ;


-- 5)Find the Numbers of Restaurants opening based on Year , Quarter , Month.

set sql_mode = " " ;
select year(Datekey_Opening) as Years,
CONCAT("Q",Quarter(Datekey_Opening)) as Quarters,
month(Datekey_Opening) as Months,
count(restaurantid) as Count_of_restaurant from main
group by years,months,quarters
order by Count_of_restaurant desc ;


-- 6)find the Count of Restaurants based on Average Ratings.

select case 
when rating <=2 then "0-2" 
when rating <=3 then "2-3" 
when rating <=4 then "3-4" 
when Rating<=5 then "4-5" 
end as Ratings,count(restaurantid) as Count_of_restaurant 
from main group by ratings ;


-- 7) Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets.

select case 
when price_range=1 then "<500" 
when price_range=2 then "500-5000" 
when Price_range=3 then "5000-10000" 
when Price_range=4 then ">10000" 
end as Average_Price_Buckets ,count(restaurantid) as Count_of_restaurant 
from main
group by Average_Price_Buckets
order by Count_of_restaurant desc;


-- 8)Percentage of Restaurants based on "Has_Online_Delivery".

select Has_Online_Delivery,concat(round(count(Has_Online_delivery)/100,1),"%") as Percentage 
from main group by has_online_delivery;


-- 9)Percentage of Restaurants based on "Has_Table_booking".

select Has_Table_booking,concat(round(count(Has_Table_booking)/100,1),"%") as Percentage 
from main group by Has_Table_booking ;


-- 10) Highest rated restaurants in each country.

select  c.CountryName,m.RestaurantName,max(m.rating) as Ratings from main as m join country as c
on m.countrycode = c.countryid
group by c.countryname order by RATINGS DESC ;


-- 11) Top 5 highest Voted Restaurants with their Ratings.

select CONCAT(RestaurantName," - ","(",City,")") AS Restaurant ,
max(votes) as Votes , Rating 
from main group by restaurantname order by votes desc limit 5 ;


-- 12) Top Rated Cuisine in each country.

select c.countryname,m.cuisines,max(m.rating) as Ratings from main as m join country as c
on m.countrycode = c.countryid
group by c.countryname order by RATINGS DESC ;