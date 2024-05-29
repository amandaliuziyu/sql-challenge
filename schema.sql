-- Drop tables if they exist
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS titles;

CREATE TABLE departments (
    dept_no VARCHAR PRIMARY KEY,
    dept_name VARCHAR(30)
);

CREATE TABLE titles (
    title_id VARCHAR PRIMARY KEY,
    title VARCHAR(30)
);

CREATE TABLE employees (
    emp_no BIGINT PRIMARY KEY,
    emp_title VARCHAR(50),
    birth_date DATE not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    sex VARCHAR(30),
    hire_date DATE not null,
    FOREIGN KEY (emp_title) REFERENCES titles(title_id)
);

CREATE TABLE dept_emp (
    emp_no BIGINT,
    dept_no VARCHAR,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR,
    emp_no BIGINT,
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE salaries (
    emp_no BIGINT,
    salary FLOAT,
    PRIMARY KEY (emp_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

select * from employees
ALTER DATABASE sql_challenge_db SET datestyle TO "ISO, MDY";


--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name,employees.sex, salaries.salary
FROM employees JOIN salaries ON employees.emp_no = salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date;

--List the manager of each department along with their department number, department name, employee number, 
--last name, and first name.
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

--List the department number for each employee along with that employee’s employee number, last name, 
--first name, and department name.
SELECT departments.dept_no, departments.dept_name, dept_emp.emp_no, employees.first_name, employees.last_name
FROM departments
JOIN dept_emp
ON departments.dept_no = dept_emp.dept_no
JOIN employees on dept_emp.emp_no = employees.emp_no;

--List first name, last name, and sex of each employee whose first name is Hercules 
--and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
  AND last_name LIKE 'B%';
  
--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

--List the frequency counts, in descending order, 
--of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
