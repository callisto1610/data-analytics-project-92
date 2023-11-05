/* продажи задание 4 - подсчет всех покупателей в таблице customers */
select COUNT(customer_id) as customers_count
from customers c ;

/* продажи задание 5 -  отчет о десятке лучших продавцов */
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

/* продажи задание 5 -   отчет о продавцах, чья средняя выручка за сделку меньше 
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

/* продажи задание 5 -  отчет о выручке по дням недели */
select concat(employees.first_name, ' ', employees.last_name) as name,
to_char(sales.sale_date, 'day') as weekday,
round(sum(sales.quantity*products.price),0) as income
from sales
join employees
on sales.sales_person_id = employees.employee_id
join products
on sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name),
to_char(sales.sale_date, 'day')
order by to_char(sales.sale_date, 'day'), name;