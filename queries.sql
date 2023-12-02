/* продажи задание 4 - подсчет всех покупателей в таблице customers */
select COUNT(customer_id) as customers_count
from customers c ;

/* продажи задание 5.1 -  отчет о десятке лучших продавцов */
select concat(employees.first_name, ' ',employees.last_name) as name,
    COUNT(sales.sales_person_id) as operations,
    FLOOR(SUM(products.price*sales.quantity)) as income
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
with DayProfit as 
(select concat(employees.first_name, ' ', employees.last_name) as name,
    to_char(sales.sale_date, 'ID') as weekday_num,
    to_char(sales.sale_date, 'day') as weekday,
    round(sum(sales.quantity*products.price),0) as income
from sales
join employees
on sales.sales_person_id = employees.employee_id
join products
on sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name),
    to_char(sales.sale_date, 'ID'), to_char(sales.sale_date, 'day')
order by to_char(sales.sale_date, 'ID'), to_char(sales.sale_date, 'day'), name)

select DayProfit.name,
       DayProfit.weekday,
       DayProfit.income
from DayProfit
order by DayProfit.weekday_num, DayProfit.name;

/* продажи задание 6.1  - количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+ */

select case  
	when age >= 16 and age <= 25 then '16-25'
	when age >= 26 and age <= 40 then '26-40'
	else '40+'
	end as age_category,
COUNT(*) as count
from customers c 
group by age_category
order by age_category;

/* продажи задание 6.2  - данные по количеству уникальных покупателей и выручке,
которую они принесли. Сгруппируйте данные по дате, которая представлена в числовом виде ГОД-МЕСЯЦ*/

select to_char(sale_date, 'YYYY-MM') as date,
       COUNT(distinct customer_id) as total_customers,
       FLOOR(SUM(p.price* s.quantity)) as income
from sales s 
left join products p 
on s.product_id = p.product_id
group by date
order by date ASC;

/* продажи задание 6.3  - первая покупка которых была в ходе проведения акций 
(акционные товары отпускали со стоимостью равной 0)*/

with tab as 
(select s.sales_person_id, s.customer_id, s.product_id, s.sale_date,
        SUM(p.price* s.quantity) as total_price,
        row_number() over (partition by customer_id order by sale_date) as rn
from sales s
inner join products p 
on p.product_id = s.product_id 
group by s.sales_person_id, s.customer_id, s.product_id, s.sale_date)

select CONCAT(c.first_name, ' ', c.last_name) as customer,
       tab.sale_date as sale_date,
       CONCAT(e.first_name, ' ', e.last_name) as seller
from tab
inner join customers c 
on c.customer_id = tab.customer_id
inner join employees e 
on e.employee_id = tab.sales_person_id
where rn = 1 and total_price = 0
order by tab.customer_id;