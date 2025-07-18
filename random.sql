/*
JOINS
--Inner Join
*/
Select e.name,d.name,d.department_id 
from employee e
inner join department d on e.dept_id = d.id;

/*
--Left Join (Outer Join),left join  = inner join + remaining values from the left table
*/
Select e.name,d.name, d.deptartment_id
from employee e 
left join deptartment d on e.dept_id = d.id;

/*
--Right Join (Outer Join)
*/
Select e.name,d.name,d.id 
from employee e 
right join department d on e.dept_id = d.id;

/*
--FULL Outer Join
*/
select e.name,d.name,d.id 
from employee e 
left join department d on e.dept_id = d.id 
UNION
select e.name,d.name,d.id 
from employee e 
right join department d on e.dept_id = d.id;

/*
Subqueries: There are six tpyes of Subqueries in SQL:
1 Scalar Subquery
2 Row Subquery
3 Column Subquery
4 Table Subquery
5 Correlated Subquery
6 Subquery in FROM Clause
*/

--1)Scalar Subquery returns a sigluar value.
SELECT FirstName,LastName,
    (Select avg(salary) from employee as average_salary)
from employee e;

--2)Row Subquery, return 1 column with multiple rows
SELECT name
from 
employee e
where dept_id  in
    (select dept_id from employee where salary > 50000);

--3)Column Subquery, returns single row with multiple columns
Select name,age, from employee
where (dept_id,salary) in 
    (select dept_id,salary from employee where salary>50000 limit 1);

--4)Table Subquery, returns multiple rows and columns
Select name,age,salary from employee
where dept_id in 
    (select dept_id from employee where salary>50000);

--5)Correlated Subquery, a subquery that references columns from the outer query
Select name,salary
from employee e 
where salary >
    (select avg(salary) from employee where dept_id = e.dept_id);

--6)Subquery in FROM Clause, a subquery that is used as a table in the FROM clause
Select dept_id, avg(salary) as avg_salary,
FROM (
Select * from employee where active = true
) as active_employees
group by dept_id;

--window functions
--1) Row_number() -assigns a unique sequential integer to rows no matter how many rows are returned based on if the values are same or unique
Select name,salary,
row_number() over (order by salary desc) as row_num
from employee;

--2) rank() - assigns a unique rank to each row within a partition of a result set, with gaps in the ranking for ties. meaning, if two rows have the same value, its given the same rank ,and th next value is given the nth rank.1,2,2,2,5,5,7 
Select name,salary,
rank() over (order by salary desc) as rank_num
from employee;

-- 3) dense_rank() - similar to rank() but does not leave gaps in the ranking for ties. meaning, if two rows have the same value, its given the same rank ,and the next value is given the next rank. 1,2,2,2,3,3,3,3,4
Select name,salary,
dense_rank() over (order by salary desc) as dense_rank_num
from employee;

-- 4) lead() - return the value of the next row in the result set, based on the order specified in the OVER clause.
Select name,salary,
lead(salary) over (order by salary desc) as next_salary
from employee;

-- 5) lag() - return the value of the previous row in the result set, based on the order specified in the OVER clause.
Select name,salary,
lag(salary) over (order by salary desc) as previous_salary
from employee;

-- 6) first_value() - returns the first value which is present in the result set/or the partition window. returns the value of the column whichi is present in the first_value() function.ABORT
select *,
first_value(product_name) over(partition by product_category order by product_price) as most_expensive_product
from products;

-- 7) last_value()- returns the last value which is present in the result set/or the partition window. returns the value of the column which is mentioned in the last_value() fucntion
select *,
last_value(product_name) over(partition by product_category order by product_price) as cheapest_product
from products;

--frame clause - writing the frame of the partition in the window function, so after fixinght of the last_value fucntion,
select *,
last_value(product_name) over(partition by product_category order by price DESC
                            RANGE between unbounded preceding and unbounded following) as cheapest_product
from products;

--alternate way to write window functions is:
select *,
first_value(product_name) over w as most_expensive_product,
last_value(product_name) over w as cheapest_product
from products
window w as (partition by product_category order by product_price DESC 
            range between unbounded preceding and unbounded following);

-- 8) nth_value() - return the nth value in the result set
select *,
nth_value(product_name,2) over(PARTITION by product_category order by product_price) as second_most_expensive_product
from products;

--9th) ntile() - divides the result set into a specified number of buckets and assigns a bucket number to each row.
select *,
ntile(4) over(order by salary) as quartile
from employee;

--10) cume_dist() - calulates the cumulative distribution of a value in a result set. meaning how much it contributes according to the total number of rows inthe result set.
-- formuala for cume_dist() is : cumulative distance = (current row number -1) / (total number of rows)
select *,
cume_dist() over(order by salary) as cumulative_distribution
from employee;
--to round off the value in percentage,

,round( cume_dist() over (order by salary)::numeric *100,2) as cumulative_distribution)

--11) percent_rank() - calculates the relative rank of a row within a result set a relative percentage.
-- formula for percent_rank() is : (current row number -1) / (total number of rows -1)
select *,
round(percent_rank() over(order by salary)::numeric *100,2) as percentage_rank
from product;

/*
Views is a database object. view doesnt store data, it is a virtual table that is based on the result of a query.
-- create view
as {sql query}

Advantages of using  views:
1. Security: veiws can restrict access based on the roles given and the data that is neede to be accessed.
2. to simplify complex queries

you can create or replace a view using the CREATE OR REPLACE VIEW statement.
--create or replace view view_name
as (sql query);

rules to use create or replace view:
1. you cannot change or replace column names you have to use the same column names
2. you cannot change the datatype of the columns
3. you cannot change the order of the columns being mentioned in the view. but you can add new columns to the view at the end

changing view is done by using the alter view command
alter view view_name rename column old_column_name to new_column_name;
drop view view_name;

only the structure of the view is stored. if new columns are added to the table, they will not be reflected in the view. the records will be updated but not the columns
rules for update table views:
1. the view should be based on a single table, the changes made with the update view statement will be reflected in the table.
2. the view should not contain any with clause
3. the view shouldnt contain any group by
4 the view shouldnt contain any distinct
5. the view shouldnt contain any window functions

with check clause you can check or restrict what kind of data is being inserted or updated in the view.
create or replace veiw view_name
as (sql query)
with check option; goes through the view and check all the where conditions in the view and see if it satisfies the conditions or not.
*/