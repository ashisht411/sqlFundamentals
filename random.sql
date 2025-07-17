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