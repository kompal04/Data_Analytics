use blinkit;
-- data cleaning
select * from grocery_data;

-- renaming col names for fat content
update grocery_data
set `ï»¿Item Fat Content` = 
case 
when `ï»¿Item Fat Content` in ('LF', 'low fat') then 'Low Fat'
when `ï»¿Item Fat Content` in ('reg') then 'Regular'
else
`ï»¿Item Fat Content`
end;

-- renaming columns
alter table grocery_data rename column `ï»¿Item Fat Content` 
to item_fat_content;

alter table grocery_data rename column `Item Identifier`
to item_identifier;

alter table grocery_data rename column `Item Type`
to item_type;

alter table grocery_data rename column `Outlet Establishment Year`
to outlet_est_year;

alter table grocery_data rename column `Outlet Identifier` 
to outlet_identifier;

alter table grocery_data rename column `Outlet Location Type`
to outlet_location_type;

alter table grocery_data rename column `Outlet Size`
to outlet_size;

alter table grocery_data rename column `Outlet Type` 
to outlet_type;

alter table grocery_data rename column `Item Visibility` 
to item_visibility;

alter table grocery_data rename column `Item Weight`
to item_weight;

alter table grocery_data rename column `Total Sales`
to total_sales;


-- KPIs
-- 1 Total Sales
select cast(sum(total_sales) / 1000000.0 as decimal(10, 2))
as Total_Sales_Million from grocery_data;

-- 2 Avg sales
select cast(avg(total_sales) as decimal(10, 2)) as avg_sales from grocery_data;

-- 3. No, of items
select count(*) as no_of_items from grocery_data;

-- 4. avg rating
select cast(avg(rating) as decimal(10, 1)) as Avg_Rating from
grocery_data;

-- granular queries
-- 1. total sales by fat content
select item_fat_content, cast(sum(total_sales) 
as decimal(10, 2)) as total_sales from 
grocery_data group by item_fat_content;

-- 2. total sales by item type
select item_type, cast(sum(total_sales) as decimal(10, 2))
as total_sales from grocery_data
group by item_type 
order by total_sales desc;

-- 3. Fat content by outlet for total sales
select outlet_location_type, 
round(sum(case when item_fat_content = 'Low Fat' 
then total_sales else 0 end), 2) as Low_Fat,
round(sum(case when item_fat_content = 'Regular'
then total_sales else 0 end), 2) as Regular
from grocery_data
group by outlet_location_type
order by outlet_location_type;

-- 4. total sales by outlet establishment
select outlet_est_year, cast(sum(total_sales) 
as decimal(10, 2)) as total_sales
from grocery_data
group by outlet_est_year
order by outlet_est_year;

-- 5. Percentage of sales by outlet size
select outlet_size,
cast(sum(total_sales) as decimal(10, 2)) as total_sales,
cast((sum(total_sales) * 100.0 / sum(sum(total_sales))
over()) as decimal(10, 2)) as sales_percentage
from grocery_data
group by outlet_size order by total_sales desc;

-- 6. sales by outlet location
select outlet_location_type, cast(sum(total_sales) 
as decimal(10, 2)) as total_sales from grocery_data
group by outlet_location_type order by total_sales desc;

-- 7. all metrics by outlet types
select outlet_type,
cast(sum(total_sales) as decimal(10, 2)) as total_sales, 
cast(avg(total_sales) as decimal(10, 0)) as avg_sales,
count(*) as no_of_items,
cast(avg(Rating) as decimal(10, 2)) as avg_rating,
cast(avg(item_visibility) as decimal(10, 2)) 
as item_visibility
from grocery_data
group by outlet_type
order by total_sales desc;