# SWIGGY DATA ANALYSIS
CREATE DATABASE swiggyanalysis;
CREATE TABLE swiggy(
  restaurant_no   INTEGER  NOT NULL ,
  restaurant_name VARCHAR(50) NOT NULL,
  city            VARCHAR(9) NOT NULL,
  address         VARCHAR(204),
  rating          NUMERIC(3,1) NOT NULL,
  cost_per_person INTEGER ,
  cuisine         VARCHAR(49) NOT NULL,
  restaurant_link VARCHAR(136) NOT NULL,
  menu_category   VARCHAR(66),
  item            VARCHAR(188),
  price           VARCHAR(12) NOT NULL,
  veg_or_nonveg   VARCHAR(7)
);










select * from swiggy limit 10;

#Q1 How many restaurants have a rating greater than 4.5?
select count(distinct restaurant_name) as High_Rated_Restaurant 
from swiggy where rating>4.5;

#Q2 Which is the top 1 city with highest number of restaurants?
select city,count(distinct restaurant_name) as restaurant_count from swiggy
group by city
order by restaurant_count desc
limit 1;

#Q3. How many restaurants have the word 'pizza' in their name?
select count(distinct restaurant_name) as pizza_restaurant from swiggy
where restaurant_name like '%Pizza%';

#Q4 What is the most common cuisine among the restaurants in the dataset?
select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

#Q5 What is the average rating of restaurants in each city?
select city, avg(rating) as average_rating
from swiggy group by city;

#Q6 What is the highest price of item under the 'Recommended' menu category for each restaurant?
select distinct restaurant_name,
menu_category,max(price) as highestprice
from swiggy where menu_category='Recommended'
group by restaurant_name,menu_category;

#Q7 Find the top 5 most expensive restaurants that offer cuisine other than Indian cuisine?
select distinct restaurant_name,cost_per_person
from swiggy where cuisine<>'Indian'
order by cost_per_person desc
limit 5;

#Q8 Find the restaurants that have an average cost which is higher than the total average cost of all restaurants together?
select distinct restaurant_name,cost_per_person
from swiggy where cost_per_person>(
select avg(cost_per_person) from swiggy);

#Q9 Retrieve the details of restaurants that have the same name but are located in different cities?
select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

#Q10 Which restaurant offers the most number of items in the 'Main Course' category?
select distinct restaurant_name,menu_category,
count(item) as no_of_items from swiggy
where menu_category='Main Course' 
group by restaurant_name,menu_category
order by no_of_items desc limit 1;

#Q11 List the names of restaurants that are 100% vegeatarian in alphabetical order of restaurant name?
select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name;

#Q12 Which is the restaurant providing the lowest average price of all items?
select distinct restaurant_name,
avg(price) as average_price
from swiggy group by restaurant_name
order by average_price limit 1;

#Q13 Which top 5 restaurant offers hughest number of categories?
select distinct restaurant_name,
count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc limit 5;

#Q14 Which restaurant provides the highest percentage of Non-vegeatarian food?
select distinct restaurant_name,
(count(case when veg_or_nonveg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc limit 1; 