/*1. Create the database and schema. Populate the Schema:
●	Create a Database for this project and
●	Create all three tables in MySQL with appropriate data types and relationships.
●	Insert sample data covering at least:
		○	4–5 learners
		○	4–5 courses (spread across multiple categories)
		○	6–8 purchase records */

Create database Learning;

Use Learning;

Create Table learners (
learner_id Int Primary Key,
full_name Varchar(50) not null,
Country Varchar(50) not null
);

Create Table courses (
course_id int Primary Key,
course_name varchar(50) not null,
category varchar(50) not null,
unit_price Decimal(10,2) not null
);

Create table purchases (
purchase_id int Primary Key,
Quantity int not null,
purchase_date Date not null,
course_id int,
learner_id  int,
Foreign Key (learner_id) References learners(learner_id),
Foreign Key (course_id) References courses(course_id)
);


Insert into learners (learner_id, full_name, country) values
(1, 'Amit Sharma','India'),
(2, 'Sarah Johnson','USA'),
(3, 'Priya Verma','India'),
(4, 'David Miller','UK'),
(5, 'Carlos Martinez','Spain');

INSERT INTO courses (course_id, course_name, category, unit_price) VALUES
(101, 'Python for Beginners','Programming',49.99),
(102, 'Advanced SQL Analytics','Data',59.99),
(103, 'Excel for Business','Business',39.99),
(104, 'Machine Learning 101','Data',79.99),
(105, 'Digital Marketing Basics','Marketing',29.99),
(106, 'Web Development Basics', 'Programming', 69.99);

INSERT INTO purchases (purchase_id, learner_id, course_id, quantity, purchase_date) VALUES
(1001, 1, 101, 1, '2025-01-05'),
(1002, 1, 102, 2, '2025-01-10'),
(1003, 2, 103, 1, '2025-01-11'),
(1004, 2, 104, 1, '2025-01-15'),
(1005, 3, 101, 1, '2025-01-18'),
(1006, 3, 105, 3, '2025-01-20'),
(1007, 4, 104, 2, '2025-01-22'),
(1008, 5, 105, 1, '2025-01-25');

/*2. Data Exploration Using Joins : Data Presentation Guidelines for the following query 
	●	Format currency values to 2 decimal places.
	●	Use aliases for column names (e.g., AS total_revenue).
	●	Sort results appropriately (e.g., highest total_spent first).
Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
	●	Combine learner, course, and purchase data.
	●	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).
*/
-- Inner Join
select l.*, c.course_name, c.category, p.quantity, p.purchase_date, (p.quantity*c.unit_price) as total_amount from learners l
Inner Join purchases p on l.learner_id = p.learner_id
Inner Join courses c on c.course_id = p.course_id
Order by total_amount desc;

-- Left Join
select l.*, c.course_name, c.category, p.quantity, p.purchase_date, (p.quantity*c.unit_price) as total_amount from learners l
Left Join purchases p on l.learner_id = p.learner_id
Left Join courses c on c.course_id = p.course_id
Order by total_amount desc;

-- Right Join
select l.*, c.course_name, c.category, p.quantity, p.purchase_date, (p.quantity*c.unit_price) as total_amount from learners l
Right Join purchases p on l.learner_id = p.learner_id
Right Join courses c on c.course_id = p.course_id
Order by total_amount desc;

-- 3. Analytical Queries : Write SQL queries to answer the following questions:

-- Q1. Display each learner’s total spending (quantity × unit_price) along with their country.
Select sum(p.quantity*c.unit_price) As Total_Spend, l.full_name AS Learner_Name, l.Country as Country from Learners l 
Inner Join purchases P on l.learner_id = P.learner_id
Inner Join courses c on p.course_id = c.course_id
Group by l.full_name, l.country Order by Total_Spend desc;

-- Q2. Find the top 3 most purchased courses based on total quantity sold.
Select sum(p.quantity) As Total_Qty_Sold, c.course_name from courses c
Inner join purchases p on p.course_id = c.course_id 
Group by c.course_name Order by Total_Qty_Sold desc Limit 3;

-- Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.
Select sum(p.quantity*c.unit_price) As Total_Revenue, c.category, Count(Distinct(l.learner_id)) As Unique_Leaners  from courses c 
Inner Join purchases P on p.course_id = c.course_id 
Inner Join learners l on l.learner_id = P.learner_id
Group by c.category Order by Total_Revenue desc;

-- Q4. List all learners who have purchased courses from more than one category.
select l.*, count(distinct category) as category_count from learners l 
Inner Join purchases P on l.learner_id = P.learner_id
Inner Join courses c on p.course_id = c.course_id
Group by l.learner_id
Having count(distinct c.category)>1;
-- ing count(P.learner_id)>1;

-- Q5. Identify courses that have not been purchased at all.
select * from courses where course_id not in (select course_id from purchases);
