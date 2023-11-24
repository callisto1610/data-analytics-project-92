/* продажи задание 4 - подсчет всех покупателей в таблице customers */
select COUNT(customer_id) as customers_count
from customers c ;

/* продажи задание 5.1 -  отчет о десятке лучших продавцов */
select concat(employees.first_name, ' ',employees.last_name) as name,
    SUM(sales.quantity) as operations,
    SUM(products.price*sales.quantity) as income
from sales
join employees
on sales.sales_person_id = employees.employee_id
join products
on sales.product_id = products.product_id 
group by concat(employees.first_name, ' ',employees.last_name)
order by income desc 
limit 10;

/* продажи задание 5.2 -   отчет о продавцах, чья средняя выручка за сделку меньше 
средней выручки за сделку по всем продавцам. */

select concat(employees.first_name, ' ', employees.last_name) as name,
    round(AVG(sales.quantity*products.price),0) as average_income
from sales
join products 
on products.product_id = sales.product_id 
join employees 
on employees.employee_id = sales.sales_person_id
group by concat(employees.first_name, ' ', employees.last_name)
having round(AVG(sales.quantity*products.price),0) <
(select round(avg(sales.quantity*products.price),0) 
from sales 
join products
on sales.product_id = products.product_id)
order by average_income asc;

/* продажи задание 5.3 -  отчет о выручке по дням недели */
create view DayProfit as 
select concat(employees.first_name, ' ', employees.last_name) as name,
    to_char(sales.sale_date, 'ID') as weekday_num,
    to_char(sales.sale_date, 'Day') as weekday,
    round(sum(sales.quantity*products.price),0) as income
from sales
join employees
on sales.sales_person_id = employees.employee_id
join products
on sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name),
    to_char(sales.sale_date, 'ID'), to_char(sales.sale_date, 'Day')
order by to_char(sales.sale_date, 'ID'), to_char(sales.sale_date, 'Day'), name;

select DayProfit.name,
       DayProfit.weekday,
       DayProfit.income
from DayProfit
order by DayProfit.weekday_num, DayProfit.name;

/* продажи задание 6.1  - количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+ */

select case  
	when c.age >= 16 and c.age <= 25 then '16-25'
	when c.age >= 26 and c.age <= 40 then '26-40'
	else '40+'
	end as age_category,
COUNT(*) as count
from sales s 
left join customers c 
on s.customer_id = c.customer_id
group by age_category
order by age_category;

/* продажи задание 6.2  - данные по количеству уникальных покупателей и выручке,
которую они принесли. Сгруппируйте данные по дате, которая представлена в числовом виде ГОД-МЕСЯЦ*/

select to_char(sale_date, 'YYYY-MM') as date,
       COUNT(distinct customer_id) as total_customers,
       SUM(p.price* s.quantity) as income
from sales s 
left join products p 
on s.product_id = p.product_id
group by date
order by date ASC;

/* продажи задание 6.3  - первая покупка которых была в ходе проведения акций 
(акционные товары отпускали со стоимостью равной 0)*/

with tab as 
(select CONCAT(c.first_name, ' ', c.last_name) as customer,
       s.sale_date as sale_date,
       CONCAT(e.first_name, ' ', e.last_name) as seller,
       row_number() over (partition by s.customer_id order by s.sale_date) as rn 
from sales s 
left join products p 
on s.product_id = s.product_id 
left join customers c 
on c.customer_id = s.customer_id
left join employees e 
on e.employee_id = s.sales_person_id 
where (p.price*s.quantity) = 0
order by s.customer_id)

select customer,
       sale_date,
       seller
from tab
where rn = 1;

/* продажи задание 7  - Результаты проведенного исследования продавцов 
и покупателей следует представить в виде дашборда. Ссылка на дашборд ниже.*/

https://e79fd5a4.eu5a.app.preset.io/superset/dashboard/11/?native_filters_key=V59TmHANSGnofxa0dMQkdMdhcHSKzxc0C6mPi_OaLZZWvVwG_sAWy8FbODZBg3bm

