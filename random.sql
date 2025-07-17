/*
JOINS
--Inner Join
*/
Select e.name,d.name,d.department_id 
from employee e
inner join department d on e.dept_id = d.id;

/*
--Left Join (Outer Join)
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