SET search_path TO public;

DROP TABLE IF EXISTS Order_Details CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Inventory CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Suppliers CASCADE;
DROP TABLE IF EXISTS Branches CASCADE;

/*
===========================================================
FRESHMART RETAIL ANALYTICS – BRANCH EXPANSION DECISION
===========================================================
*/

--

-- =========================================================
-- TABLE 1: BRANCHES
-- =========================================================

CREATE TABLE Branches (
    Branch_ID INTEGER PRIMARY KEY,
    Branch_Name VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Opening_Date DATE NOT NULL
);


-- =========================================================
-- TABLE 2: SUPPLIERS
-- =========================================================

CREATE TABLE Suppliers (
    Supplier_ID INTEGER PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABLE 3: CUSTOMERS
-- =========================================================

CREATE TABLE Customers (
    Customer_ID INTEGER PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(20),
    City VARCHAR(100),
    Join_Date DATE NOT NULL
);


-- =========================================================
-- TABLE 4: EMPLOYEES
-- =========================================================

CREATE TABLE Employees (
    Employee_ID INTEGER PRIMARY KEY,
    Employee_Name VARCHAR(100) NOT NULL,
    Designation VARCHAR(100),
    Department VARCHAR(100),
    Salary NUMERIC(12,2),
    Manager_ID INTEGER,
    Branch_ID INTEGER NOT NULL,
    CONSTRAINT fk_employee_branch
        FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID),
    CONSTRAINT fk_employee_manager
        FOREIGN KEY (Manager_ID) REFERENCES Employees(Employee_ID)
);


-- =========================================================
-- TABLE 5: PRODUCTS
-- =========================================================

CREATE TABLE Products (
    Product_ID INTEGER PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Brand VARCHAR(100) NOT NULL,
    Cost_Price NUMERIC(12,2) NOT NULL,
    Selling_Price NUMERIC(12,2) NOT NULL,
    Supplier_ID INTEGER NOT NULL,
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID)
);


-- =========================================================
-- TABLE 6: ORDERS
-- =========================================================

CREATE TABLE Orders (
    Order_ID INTEGER PRIMARY KEY,
    Customer_ID INTEGER NOT NULL,
    Employee_ID INTEGER NOT NULL,
    Order_Date DATE NOT NULL,
    Payment_Mode VARCHAR(50) NOT NULL,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    CONSTRAINT fk_order_employee
        FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);


-- =========================================================
-- TABLE 7: ORDER_DETAILS
-- =========================================================

CREATE TABLE Order_Details (
    Order_Detail_ID INTEGER PRIMARY KEY,
    Order_ID INTEGER NOT NULL,
    Product_ID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    Discount NUMERIC(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_orderdetails_order
        FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CONSTRAINT fk_orderdetails_product
        FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);


-- =========================================================
-- TABLE 8: INVENTORY
-- =========================================================

CREATE TABLE Inventory (
    Product_ID INTEGER NOT NULL,
    Branch_ID INTEGER NOT NULL,
    Stock_Quantity INTEGER NOT NULL,
    Reorder_Level INTEGER NOT NULL,
    PRIMARY KEY (Product_ID, Branch_ID),
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    CONSTRAINT fk_inventory_branch
        FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID)
);


-- =========================================================
-- INSERT BRANCHES
-- =========================================================

INSERT INTO Branches
(Branch_ID, Branch_Name, City, State, Region, Opening_Date)
VALUES
(1, 'FreshMart Kochi', 'Kochi', 'Kerala', 'South', '2021-01-15'),
(2, 'FreshMart Kannur', 'Kannur', 'Kerala', 'South', '2021-03-10'),
(3, 'FreshMart Kozhikode', 'Kozhikode', 'Kerala', 'South', '2020-11-20'),
(4, 'FreshMart Trivandrum', 'Thiruvananthapuram', 'Kerala', 'South', '2020-06-05'),
(5, 'FreshMart Thrissur', 'Thrissur', 'Kerala', 'South', '2022-02-18'),
(6, 'FreshMart Mangalore', 'Mangaluru', 'Karnataka', 'South', '2021-08-12'),
(7, 'FreshMart Bengaluru', 'Bengaluru', 'Karnataka', 'South', '2019-09-25'),
(8, 'FreshMart Chennai', 'Chennai', 'Tamil Nadu', 'South', '2020-04-14'),
(9, 'FreshMart Mumbai', 'Mumbai', 'Maharashtra', 'West', '2019-12-01'),
(10, 'FreshMart Pune', 'Pune', 'Maharashtra', 'West', '2021-05-22'),
(11, 'FreshMart Ahmedabad', 'Ahmedabad', 'Gujarat', 'West', '2022-07-08'),
(12, 'FreshMart Delhi', 'New Delhi', 'Delhi', 'North', '2019-07-17'),
(13, 'FreshMart Jaipur', 'Jaipur', 'Rajasthan', 'North', '2022-10-11'),
(14, 'FreshMart Hyderabad', 'Hyderabad', 'Telangana', 'South', '2020-10-30'),
(15, 'FreshMart Lucknow', 'Lucknow', 'Uttar Pradesh', 'North', '2023-01-20');


-- =========================================================
-- INSERT SUPPLIERS
-- =========================================================

INSERT INTO Suppliers (Supplier_ID, Supplier_Name, City)
SELECT
    gs,
    'Supplier ' || LPAD(gs::TEXT, 2, '0'),
    CASE ((gs - 1) % 8)
        WHEN 0 THEN 'Kochi'
        WHEN 1 THEN 'Mumbai'
        WHEN 2 THEN 'Delhi'
        WHEN 3 THEN 'Bengaluru'
        WHEN 4 THEN 'Chennai'
        WHEN 5 THEN 'Hyderabad'
        WHEN 6 THEN 'Ahmedabad'
        ELSE 'Pune'
    END
FROM generate_series(1,45) AS gs;


-- =========================================================
-- INSERT CUSTOMERS
-- =========================================================

INSERT INTO Customers
(Customer_ID, Customer_Name, Gender, City, Join_Date)
SELECT
    gs,
    CASE (gs % 10)
        WHEN 0 THEN 'Arun Customer '
        WHEN 1 THEN 'Rahul Customer '
        WHEN 2 THEN 'Anjali Customer '
        WHEN 3 THEN 'Sneha Customer '
        WHEN 4 THEN 'Akhil Customer '
        WHEN 5 THEN 'Fathima Customer '
        WHEN 6 THEN 'Neha Customer '
        WHEN 7 THEN 'Vishnu Customer '
        WHEN 8 THEN 'Aisha Customer '
        ELSE 'Nikhil Customer '
    END || gs,
    CASE WHEN gs % 2 = 0 THEN 'Female' ELSE 'Male' END,
    CASE ((gs - 1) % 15)
        WHEN 0 THEN 'Kochi'
        WHEN 1 THEN 'Kannur'
        WHEN 2 THEN 'Kozhikode'
        WHEN 3 THEN 'Thiruvananthapuram'
        WHEN 4 THEN 'Thrissur'
        WHEN 5 THEN 'Mangaluru'
        WHEN 6 THEN 'Bengaluru'
        WHEN 7 THEN 'Chennai'
        WHEN 8 THEN 'Mumbai'
        WHEN 9 THEN 'Pune'
        WHEN 10 THEN 'Ahmedabad'
        WHEN 11 THEN 'New Delhi'
        WHEN 12 THEN 'Jaipur'
        WHEN 13 THEN 'Hyderabad'
        ELSE 'Lucknow'
    END,
    DATE '2023-01-01' + ((gs * 17) % 1095)::INTEGER
FROM generate_series(1,2500) AS gs;


-- =========================================================
-- INSERT EMPLOYEES
-- =========================================================

INSERT INTO Employees
(Employee_ID, Employee_Name, Designation, Department, Salary, Manager_ID, Branch_ID)
SELECT
    gs,
    'Employee ' || LPAD(gs::TEXT,3,'0'),
    CASE ((gs - 1) % 12)
        WHEN 0 THEN 'Branch Manager'
        WHEN 1 THEN 'Assistant Manager'
        WHEN 2 THEN 'Sales Executive'
        WHEN 3 THEN 'Sales Executive'
        WHEN 4 THEN 'Sales Executive'
        WHEN 5 THEN 'Sales Executive'
        WHEN 6 THEN 'Sales Executive'
        WHEN 7 THEN 'Sales Executive'
        WHEN 8 THEN 'Cashier'
        WHEN 9 THEN 'Inventory Executive'
        WHEN 10 THEN 'Customer Service Executive'
        ELSE 'Assistant Manager'
    END,
    CASE ((gs - 1) % 12)
        WHEN 0 THEN 'Management'
        WHEN 1 THEN 'Management'
        WHEN 2 THEN 'Sales'
        WHEN 3 THEN 'Sales'
        WHEN 4 THEN 'Sales'
        WHEN 5 THEN 'Sales'
        WHEN 6 THEN 'Sales'
        WHEN 7 THEN 'Sales'
        ELSE 'Management'
    END,
    CASE ((gs - 1) % 12)
        WHEN 0 THEN 65000
        WHEN 1 THEN 50000
        WHEN 2 THEN 30000
        WHEN 3 THEN 31000
        WHEN 4 THEN 32000
        WHEN 5 THEN 30000
        WHEN 6 THEN 33000
        WHEN 7 THEN 31500
        WHEN 8 THEN 28000
        WHEN 9 THEN 32000
        WHEN 10 THEN 29000
        ELSE 48000
    END,
    CASE
        WHEN ((gs - 1) % 12) = 0 THEN NULL
        ELSE FLOOR((gs - 1) / 12) * 12 + 1
    END,
    FLOOR((gs - 1) / 12) + 1
FROM generate_series(1,180) AS gs;


-- =========================================================
-- INSERT PRODUCTS
-- =========================================================

INSERT INTO Products
(Product_ID, Product_Name, Category, Brand, Cost_Price, Selling_Price, Supplier_ID)
SELECT
    gs,
    CASE
        WHEN gs BETWEEN 1 AND 50 THEN 'Grocery Product '
        WHEN gs BETWEEN 51 AND 100 THEN 'Beverage Product '
        WHEN gs BETWEEN 101 AND 150 THEN 'Personal Care Product '
        WHEN gs BETWEEN 151 AND 200 THEN 'Household Product '
        WHEN gs BETWEEN 201 AND 250 THEN 'Electronics Product '
        WHEN gs BETWEEN 251 AND 300 THEN 'Dairy Product '
        WHEN gs BETWEEN 301 AND 350 THEN 'Bakery Product '
        ELSE 'Snack Product '
    END || gs,
    CASE
        WHEN gs BETWEEN 1 AND 50 THEN 'Groceries'
        WHEN gs BETWEEN 51 AND 100 THEN 'Beverages'
        WHEN gs BETWEEN 101 AND 150 THEN 'Personal Care'
        WHEN gs BETWEEN 151 AND 200 THEN 'Household'
        WHEN gs BETWEEN 201 AND 250 THEN 'Electronics'
        WHEN gs BETWEEN 251 AND 300 THEN 'Dairy'
        WHEN gs BETWEEN 301 AND 350 THEN 'Bakery'
        ELSE 'Snacks'
    END,
    CASE ((gs - 1) % 8)
        WHEN 0 THEN 'DailyFresh'
        WHEN 1 THEN 'HomePlus'
        WHEN 2 THEN 'NutriChoice'
        WHEN 3 THEN 'UrbanLife'
        WHEN 4 THEN 'SmartBuy'
        WHEN 5 THEN 'PureMart'
        WHEN 6 THEN 'ValueChoice'
        ELSE 'FreshChoice'
    END,
    ROUND((50 + ((gs * 37) % 950))::NUMERIC, 2),
    ROUND(
        ((50 + ((gs * 37) % 950)) *
        (1.12 + ((gs % 27)::NUMERIC / 100)))::NUMERIC,
        2
    ),
    1 + ((gs - 1) % 45)
FROM generate_series(1,400) AS gs;


-- =========================================================
-- INSERT ORDERS
-- =========================================================

INSERT INTO Orders
(Order_ID, Customer_ID, Employee_ID, Order_Date, Payment_Mode)
SELECT
    gs,
    c.Customer_ID,
    e.Employee_ID,
    DATE '2025-01-01' + ((gs * 13) % 365)::INTEGER,
    CASE (gs % 5)
        WHEN 0 THEN 'UPI'
        WHEN 1 THEN 'Card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'Wallet'
        ELSE 'Net Banking'
    END
FROM generate_series(1,20000) AS gs
CROSS JOIN LATERAL
(
    SELECT Customer_ID
    FROM Customers
    WHERE Customer_ID <= 2350
    ORDER BY Customer_ID
    OFFSET ((gs - 1) % 2350)
    LIMIT 1
) c
CROSS JOIN LATERAL
(
    SELECT Employee_ID
    FROM Employees
    WHERE Designation = 'Sales Executive'
    ORDER BY Employee_ID
    OFFSET ((gs - 1) % 90)
    LIMIT 1
) e;


-- =========================================================
-- INSERT ORDER DETAILS
-- =========================================================

INSERT INTO Order_Details
(Order_Detail_ID, Order_ID, Product_ID, Quantity, Discount)
SELECT
    gs,
    1 + ((gs - 1) % 20000),
    CASE
        WHEN gs <= 39880 THEN 1 + ((gs - 1) % 388)
        ELSE 389 + ((gs - 39881) % 12)
    END,
    1 + ((gs - 1) % 10),
    CASE (gs % 5)
        WHEN 0 THEN 0.00
        WHEN 1 THEN 0.02
        WHEN 2 THEN 0.05
        WHEN 3 THEN 0.10
        ELSE 0.15
    END
FROM generate_series(1,40000) AS gs;


-- =========================================================
-- INSERT INVENTORY
-- =========================================================

INSERT INTO Inventory
(Product_ID, Branch_ID, Stock_Quantity, Reorder_Level)
SELECT
    p.Product_ID,
    b.Branch_ID,
    CASE
        WHEN ((p.Product_ID * b.Branch_ID) % 29) = 0
        THEN 0
        ELSE ((p.Product_ID * 17 + b.Branch_ID * 13) % 150)
    END,
    20 + ((p.Product_ID * 7 + b.Branch_ID) % 50)
FROM Products p
CROSS JOIN Branches b;


-- =========================================================
-- DATA VERIFICATION
-- =========================================================

SELECT 'Branches' AS table_name, COUNT(*) AS records FROM Branches
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM Suppliers
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order_Details', COUNT(*) FROM Order_Details
UNION ALL
SELECT 'Inventory', COUNT(*) FROM Inventory;


-- =========================================================
-- SECTION 1 – BRANCH PERFORMANCE ANALYSIS
-- =========================================================

-- Q1. Calculate the total revenue generated by each branch.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ),
        2
    ) AS total_revenue
FROM branches b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
LEFT JOIN order_details od
    ON o.order_id = od.order_id
LEFT JOIN products p
    ON od.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_revenue DESC;


-- Q2. Calculate the total profit earned by each branch.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ),
        2
    ) AS total_profit
FROM branches b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
LEFT JOIN order_details od
    ON o.order_id = od.order_id
LEFT JOIN products p
    ON od.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_profit DESC;


-- Q3. Calculate the profit percentage of every branch.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ),
        2
    ) AS total_revenue,
    ROUND(
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ),
        2
    ) AS total_profit,
    ROUND(
        CASE
            WHEN SUM(p.selling_price * od.quantity * (1 - od.discount)) = 0
            THEN 0
            ELSE
                SUM(
                    (
                        p.selling_price * (1 - od.discount)
                        - p.cost_price
                    ) * od.quantity
                )
                /
                SUM(p.selling_price * od.quantity * (1 - od.discount))
                * 100
        END,
        2
    ) AS profit_percentage
FROM branches b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
LEFT JOIN order_details od
    ON o.order_id = od.order_id
LEFT JOIN products p
    ON od.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY profit_percentage DESC;


-- Q4. Identify the branch with the highest revenue.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS total_revenue
FROM branches b
JOIN employees e ON b.branch_id = e.branch_id
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_revenue DESC
LIMIT 1;


-- Q5. Identify the branch with the highest profit.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        SUM(
            (
                p.selling_price * (1 - od.discount)
                - p.cost_price
            ) * od.quantity
        ),
        2
    ) AS total_profit
FROM branches b
JOIN employees e ON b.branch_id = e.branch_id
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_profit DESC
LIMIT 1;


-- Q6. Identify branches whose revenue is greater than the company average.

WITH branch_revenue AS (
    SELECT
        b.branch_id,
        b.branch_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_revenue
    FROM branches b
    LEFT JOIN employees e ON b.branch_id = e.branch_id
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT
    branch_id,
    branch_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM branch_revenue
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM branch_revenue
)
ORDER BY total_revenue DESC;


-- Q7. Identify branches whose profit percentage is below the company average.

WITH branch_profit AS (
    SELECT
        b.branch_id,
        b.branch_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS revenue,
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ) AS profit
    FROM branches b
    LEFT JOIN employees e ON b.branch_id = e.branch_id
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY b.branch_id, b.branch_name
),
branch_margin AS (
    SELECT
        branch_id,
        branch_name,
        CASE
            WHEN revenue = 0 THEN 0
            ELSE profit / revenue * 100
        END AS profit_percentage
    FROM branch_profit
)
SELECT
    branch_id,
    branch_name,
    ROUND(profit_percentage, 2) AS profit_percentage
FROM branch_margin
WHERE profit_percentage < (
    SELECT AVG(profit_percentage)
    FROM branch_margin
)
ORDER BY profit_percentage;


-- Q8. Rank all branches based on revenue.

WITH branch_revenue AS (
    SELECT
        b.branch_id,
        b.branch_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_revenue
    FROM branches b
    LEFT JOIN employees e ON b.branch_id = e.branch_id
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT
    branch_id,
    branch_name,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM branch_revenue
ORDER BY revenue_rank;


-- Q9. Rank all branches based on profit.

WITH branch_profit AS (
    SELECT
        b.branch_id,
        b.branch_name,
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ) AS total_profit
    FROM branches b
    LEFT JOIN employees e ON b.branch_id = e.branch_id
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT
    branch_id,
    branch_name,
    ROUND(total_profit, 2) AS total_profit,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM branch_profit
ORDER BY profit_rank;


-- Q10. Recommend the best branch for future expansion with proper SQL evidence.

WITH branch_metrics AS (
    SELECT
        b.branch_id,
        b.branch_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS revenue,
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ) AS profit
    FROM branches b
    LEFT JOIN employees e ON b.branch_id = e.branch_id
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT
    branch_id,
    branch_name,
    ROUND(revenue, 2) AS total_revenue,
    ROUND(profit, 2) AS total_profit,
    ROUND(
        CASE
            WHEN revenue = 0 THEN 0
            ELSE profit / revenue * 100
        END,
        2
    ) AS profit_percentage,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY profit DESC) AS profit_rank
FROM branch_metrics
ORDER BY revenue_rank;


-- =========================================================
-- SECTION 2 – EMPLOYEE PERFORMANCE
-- =========================================================

-- Q1. Calculate total sales generated by every employee.

SELECT
    e.employee_id,
    e.employee_name,
    e.branch_id,
    e.designation,
    COALESCE(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        0
    ) AS total_sales
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY
    e.employee_id,
    e.employee_name,
    e.branch_id,
    e.designation
ORDER BY total_sales DESC;


-- Q2. Find the top-selling employee in every branch.

WITH employee_sales AS (
    SELECT
        e.branch_id,
        e.employee_id,
        e.employee_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_sales
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY e.branch_id, e.employee_id, e.employee_name
),
ranked_employees AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY branch_id
            ORDER BY total_sales DESC
        ) AS rn
    FROM employee_sales
)
SELECT
    branch_id,
    employee_id,
    employee_name,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_employees
WHERE rn = 1
ORDER BY branch_id;


-- Q3. Find employees whose sales exceed the branch average.

WITH employee_sales AS (
    SELECT
        e.branch_id,
        e.employee_id,
        e.employee_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_sales
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY e.branch_id, e.employee_id, e.employee_name
),
branch_average AS (
    SELECT
        branch_id,
        AVG(total_sales) AS average_sales
    FROM employee_sales
    GROUP BY branch_id
)
SELECT
    es.branch_id,
    es.employee_id,
    es.employee_name,
    ROUND(es.total_sales, 2) AS total_sales,
    ROUND(ba.average_sales, 2) AS branch_average_sales
FROM employee_sales es
JOIN branch_average ba
    ON es.branch_id = ba.branch_id
WHERE es.total_sales > ba.average_sales
ORDER BY es.branch_id, es.total_sales DESC;


-- Q4. Find employees earning more than their department average salary.

SELECT
    employee_id,
    employee_name,
    department,
    salary
FROM employees e
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
)
ORDER BY department, salary DESC;


-- Q5. Identify employees who have never handled an order.

SELECT
    e.employee_id,
    e.employee_name,
    e.designation,
    e.department,
    e.branch_id
FROM employees e
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
WHERE o.order_id IS NULL
ORDER BY e.employee_id;


-- Q6. Rank employees within every branch based on sales.

WITH employee_sales AS (
    SELECT
        e.branch_id,
        e.employee_id,
        e.employee_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_sales
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY e.branch_id, e.employee_id, e.employee_name
)
SELECT
    branch_id,
    employee_id,
    employee_name,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (
        PARTITION BY branch_id
        ORDER BY total_sales DESC
    ) AS branch_sales_rank
FROM employee_sales
ORDER BY branch_id, branch_sales_rank;


-- Q7. Find the second-best employee in every branch.

WITH employee_sales AS (
    SELECT
        e.branch_id,
        e.employee_id,
        e.employee_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_sales
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY e.branch_id, e.employee_id, e.employee_name
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY branch_id
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM employee_sales
)
SELECT
    branch_id,
    employee_id,
    employee_name,
    ROUND(total_sales, 2) AS total_sales
FROM ranked
WHERE sales_rank = 2
ORDER BY branch_id;


-- Q8. Find managers whose teams generated the highest revenue.

WITH employee_sales AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.branch_id,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS employee_sales
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.branch_id
),
manager_team_sales AS (
    SELECT
        m.employee_id AS manager_id,
        m.employee_name AS manager_name,
        m.branch_id,
        SUM(es.employee_sales) AS team_revenue
    FROM employees m
    JOIN employee_sales es
        ON es.manager_id = m.employee_id
    WHERE m.designation IN ('Branch Manager', 'Assistant Manager')
    GROUP BY m.employee_id, m.employee_name, m.branch_id
)
SELECT
    manager_id,
    manager_name,
    branch_id,
    ROUND(team_revenue, 2) AS team_revenue,
    RANK() OVER (ORDER BY team_revenue DESC) AS team_revenue_rank
FROM manager_team_sales
ORDER BY team_revenue_rank;


-- =========================================================
-- SECTION 3 – CUSTOMER ANALYSIS
-- =========================================================

-- Q1. Identify repeat customers.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;


-- Q2. Identify one-time customers.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) = 1
ORDER BY c.customer_id;


-- Q3. Calculate the total amount spent by every customer.

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ),
        2
    ) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;


-- Q4. Find the top 20 customers based on spending.

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 20;


-- Q5. Identify customers who spent more than the average customer.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    LEFT JOIN products p ON od.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent
FROM customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_spending
)
ORDER BY total_spent DESC;


-- Q6. Find customers who never placed an order.

SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;


-- Q7. Calculate the average order value of every customer.

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        )
        /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY average_order_value DESC NULLS LAST;


-- Q8. Identify customers purchasing from multiple product categories.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT p.category) AS category_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) > 1
ORDER BY category_count DESC;


-- =========================================================
-- SECTION 4 – PRODUCT ANALYSIS
-- =========================================================

-- Q1. Calculate revenue generated by every product.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    ROUND(
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ),
        2
    ) AS total_revenue
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;


-- Q2. Calculate profit generated by every product.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    ROUND(
        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ),
        2
    ) AS total_profit
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC;


-- Q3. Identify the highest-selling product.

SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS total_revenue
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;


-- Q4. Identify the highest-selling product in every category.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(od.quantity) AS quantity_sold
    FROM products p
    JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY quantity_sold DESC
        ) AS rn
    FROM product_sales
)
SELECT
    category,
    product_id,
    product_name,
    quantity_sold
FROM ranked
WHERE rn = 1
ORDER BY category;


-- Q5. Find products never sold.

SELECT
    p.product_id,
    p.product_name,
    p.category
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL
ORDER BY p.product_id;


-- Q6. Find products whose revenue is below the category average.

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS revenue
    FROM products p
    LEFT JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
category_average AS (
    SELECT
        category,
        AVG(revenue) AS average_category_revenue
    FROM product_revenue
    GROUP BY category
)
SELECT
    pr.product_id,
    pr.product_name,
    pr.category,
    ROUND(pr.revenue, 2) AS revenue,
    ROUND(ca.average_category_revenue, 2) AS category_average_revenue
FROM product_revenue pr
JOIN category_average ca
    ON pr.category = ca.category
WHERE pr.revenue < ca.average_category_revenue
ORDER BY pr.category, pr.revenue;


-- Q7. Find the second highest-selling product in every category.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS revenue
    FROM products p
    LEFT JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS sales_rank
    FROM product_sales
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(revenue, 2) AS revenue
FROM ranked
WHERE sales_rank = 2
ORDER BY category;


-- Q8. Identify slow-moving products.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(SUM(od.quantity), 0) AS quantity_sold
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY quantity_sold ASC, p.product_id;


-- Q9. Identify fast-moving products.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity) AS quantity_sold
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY quantity_sold DESC;


-- Q10. Rank products based on revenue.

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        COALESCE(
            SUM(p.selling_price * od.quantity * (1 - od.discount)),
            0
        ) AS revenue
    FROM products p
    LEFT JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT
    product_id,
    product_name,
    category,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank;


-- =========================================================
-- SECTION 5 – CATEGORY ANALYSIS
-- =========================================================

-- Q1. Calculate revenue generated by each category.

SELECT
    p.category,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS total_revenue
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q2. Calculate profit generated by each category.

SELECT
    p.category,
    ROUND(
        SUM(
            (
                p.selling_price * (1 - od.discount)
                - p.cost_price
            ) * od.quantity
        ),
        2
    ) AS total_profit
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_profit DESC;


-- Q3. Find the best-performing category.

SELECT
    p.category,
    ROUND(
        SUM(
            (
                p.selling_price * (1 - od.discount)
                - p.cost_price
            ) * od.quantity
        ),
        2
    ) AS total_profit
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_profit DESC
LIMIT 1;


-- Q4. Find categories whose revenue exceeds the company average.

WITH category_revenue AS (
    SELECT
        p.category,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM products p
    JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY p.category
)
SELECT
    category,
    ROUND(revenue, 2) AS total_revenue
FROM category_revenue
WHERE revenue > (
    SELECT AVG(revenue)
    FROM category_revenue
)
ORDER BY revenue DESC;


-- Q5. Rank categories by revenue.

SELECT
    p.category,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) DESC
    ) AS revenue_rank
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY revenue_rank;


-- =========================================================
-- SECTION 6 – SUPPLIER ANALYSIS
-- =========================================================

-- Q1. Calculate revenue generated from products supplied by every supplier.

SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(
        COALESCE(
            SUM(
                p.selling_price * od.quantity * (1 - od.discount)
            ),
            0
        ),
        2
    ) AS total_revenue
FROM suppliers s
LEFT JOIN products p
    ON s.supplier_id = p.supplier_id
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_revenue DESC;


-- Q2. Find suppliers contributing the highest revenue.

WITH supplier_revenue AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        COALESCE(
            SUM(
                p.selling_price * od.quantity * (1 - od.discount)
            ),
            0
        ) AS total_revenue
    FROM suppliers s
    LEFT JOIN products p
        ON s.supplier_id = p.supplier_id
    LEFT JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY s.supplier_id, s.supplier_name
)
SELECT
    supplier_id,
    supplier_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM supplier_revenue
WHERE total_revenue = (
    SELECT MAX(total_revenue)
    FROM supplier_revenue
);


-- Q3. Identify suppliers supplying products that were never sold.

SELECT DISTINCT
    s.supplier_id,
    s.supplier_name
FROM suppliers s
JOIN products p
    ON s.supplier_id = p.supplier_id
LEFT JOIN order_details od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL
ORDER BY s.supplier_id;


-- Q4. Find suppliers supplying products to multiple categories.

SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(DISTINCT p.category) AS category_count
FROM suppliers s
JOIN products p
    ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name
HAVING COUNT(DISTINCT p.category) > 1
ORDER BY category_count DESC, s.supplier_id;


-- =========================================================
-- SECTION 7 – INVENTORY ANALYSIS
-- =========================================================

-- Q1. Find products that are out of stock.

SELECT
    i.product_id,
    p.product_name,
    i.branch_id,
    b.branch_name,
    i.stock_quantity
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN branches b
    ON i.branch_id = b.branch_id
WHERE i.stock_quantity = 0
ORDER BY i.branch_id, i.product_id;


-- Q2. Find products below reorder level.

SELECT
    i.product_id,
    p.product_name,
    i.branch_id,
    b.branch_name,
    i.stock_quantity,
    i.reorder_level
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN branches b
    ON i.branch_id = b.branch_id
WHERE i.stock_quantity < i.reorder_level
ORDER BY i.branch_id, i.product_id;


-- Q3. Find products never ordered.

SELECT
    p.product_id,
    p.product_name,
    p.category
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL
ORDER BY p.product_id;


-- Q4. Find branches having the highest inventory.

SELECT
    b.branch_id,
    b.branch_name,
    SUM(i.stock_quantity) AS total_stock_units
FROM branches b
JOIN inventory i
    ON b.branch_id = i.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_stock_units DESC;


-- Q5. Calculate stock value for every branch.

SELECT
    b.branch_id,
    b.branch_name,
    ROUND(
        SUM(i.stock_quantity * p.cost_price),
        2
    ) AS total_inventory_value
FROM branches b
JOIN inventory i
    ON b.branch_id = i.branch_id
JOIN products p
    ON i.product_id = p.product_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_inventory_value DESC;


-- =========================================================
-- SECTION 8 – SALES TREND ANALYSIS
-- =========================================================

-- Q1. Calculate monthly sales.

SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
    ROUND(
        SUM(p.selling_price * od.quantity * (1 - od.discount)),
        2
    ) AS monthly_sales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;


-- Q2. Calculate monthly profit.

SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
    ROUND(
        SUM(
            (
                p.selling_price * (1 - od.discount)
                - p.cost_price
            ) * od.quantity
        ),
        2
    ) AS monthly_profit
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;


-- Q3. Calculate running monthly revenue.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) AS monthly_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;


-- Q4. Compare current month sales with previous month.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) AS monthly_sales
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS current_month_sales,
    ROUND(
        LAG(monthly_sales) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS previous_month_sales
FROM monthly_sales
ORDER BY sales_month;


-- Q5. Calculate month-over-month growth percentage.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) AS monthly_sales
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', o.order_date)
),
sales_comparison AS (
    SELECT
        sales_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS current_month_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        CASE
            WHEN previous_month_sales IS NULL
                 OR previous_month_sales = 0
            THEN NULL
            ELSE
                (monthly_sales - previous_month_sales)
                / previous_month_sales * 100
        END,
        2
    ) AS mom_growth_percentage
FROM sales_comparison
ORDER BY sales_month;


-- Q6. Identify the best sales month.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount)
        ) AS monthly_sales
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales
FROM monthly_sales
ORDER BY monthly_sales DESC
LIMIT 1;


-- =========================================================
-- SECTION 9 – EXECUTIVE SUMMARY
-- =========================================================
-- Required View:
-- Branch_Expansion_Report
--
-- Columns:
-- Branch Name
-- City
-- Region
-- Total Revenue
-- Total Profit
-- Profit Percentage
-- Total Orders
-- Total Customers
-- Average Order Value
-- Top Employee
-- Top Product
-- Best Category
-- Repeat Customer Percentage
-- Total Inventory Value
-- Branch Revenue Rank
-- Branch Profit Rank
-- =========================================================


CREATE OR REPLACE VIEW Branch_Expansion_Report AS

WITH branch_sales AS (
    SELECT
        b.branch_id,
        b.branch_name,
        b.city,
        b.region,

        COALESCE(
            SUM(
                p.selling_price
                * od.quantity
                * (1 - od.discount)
            ),
            0
        ) AS total_revenue,

        COALESCE(
            SUM(
                (
                    p.selling_price * (1 - od.discount)
                    - p.cost_price
                ) * od.quantity
            ),
            0
        ) AS total_profit,

        COUNT(DISTINCT o.order_id) AS total_orders,

        COUNT(DISTINCT o.customer_id) AS total_customers,

        COUNT(
            DISTINCT CASE
                WHEN customer_order_count.order_count > 1
                THEN o.customer_id
            END
        ) AS repeat_customers

    FROM branches b

    LEFT JOIN employees e
        ON b.branch_id = e.branch_id

    LEFT JOIN orders o
        ON e.employee_id = o.employee_id

    LEFT JOIN order_details od
        ON o.order_id = od.order_id

    LEFT JOIN products p
        ON od.product_id = p.product_id

    LEFT JOIN (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) customer_order_count
        ON o.customer_id = customer_order_count.customer_id

    GROUP BY
        b.branch_id,
        b.branch_name,
        b.city,
        b.region
),

branch_employees AS (
    SELECT
        e.branch_id,
        e.employee_id,
        e.employee_name,

        COALESCE(
            SUM(
                p.selling_price
                * od.quantity
                * (1 - od.discount)
            ),
            0
        ) AS employee_sales

    FROM employees e

    LEFT JOIN orders o
        ON e.employee_id = o.employee_id

    LEFT JOIN order_details od
        ON o.order_id = od.order_id

    LEFT JOIN products p
        ON od.product_id = p.product_id

    GROUP BY
        e.branch_id,
        e.employee_id,
        e.employee_name
),

top_employee AS (
    SELECT
        branch_id,
        employee_name AS top_employee

    FROM (
        SELECT
            branch_id,
            employee_name,
            employee_sales,

            ROW_NUMBER() OVER (
                PARTITION BY branch_id
                ORDER BY employee_sales DESC NULLS LAST
            ) AS rn

        FROM branch_employees
    ) x

    WHERE rn = 1
),

product_sales AS (
    SELECT
        e.branch_id,
        p.product_id,
        p.product_name,

        SUM(
            od.quantity
            * p.selling_price
            * (1 - od.discount)
        ) AS product_revenue

    FROM employees e

    JOIN orders o
        ON e.employee_id = o.employee_id

    JOIN order_details od
        ON o.order_id = od.order_id

    JOIN products p
        ON od.product_id = p.product_id

    GROUP BY
        e.branch_id,
        p.product_id,
        p.product_name
),

top_product AS (
    SELECT
        branch_id,
        product_name AS top_product

    FROM (
        SELECT
            branch_id,
            product_name,
            product_revenue,

            ROW_NUMBER() OVER (
                PARTITION BY branch_id
                ORDER BY product_revenue DESC
            ) AS rn

        FROM product_sales
    ) x

    WHERE rn = 1
),

category_sales AS (
    SELECT
        e.branch_id,
        p.category,

        SUM(
            od.quantity
            * p.selling_price
            * (1 - od.discount)
        ) AS category_revenue

    FROM employees e

    JOIN orders o
        ON e.employee_id = o.employee_id

    JOIN order_details od
        ON o.order_id = od.order_id

    JOIN products p
        ON od.product_id = p.product_id

    GROUP BY
        e.branch_id,
        p.category
),

best_category AS (
    SELECT
        branch_id,
        category AS best_category

    FROM (
        SELECT
            branch_id,
            category,
            category_revenue,

            ROW_NUMBER() OVER (
                PARTITION BY branch_id
                ORDER BY category_revenue DESC
            ) AS rn

        FROM category_sales
    ) x

    WHERE rn = 1
),

inventory_value AS (
    SELECT
        i.branch_id,

        SUM(
            i.stock_quantity * p.cost_price
        ) AS total_inventory_value

    FROM inventory i

    JOIN products p
        ON i.product_id = p.product_id

    GROUP BY i.branch_id
)

SELECT
    bs.branch_name,
    bs.city,
    bs.region,

    ROUND(bs.total_revenue, 2)
        AS total_revenue,

    ROUND(bs.total_profit, 2)
        AS total_profit,

    ROUND(
        CASE
            WHEN bs.total_revenue = 0
            THEN 0
            ELSE
                (bs.total_profit / bs.total_revenue) * 100
        END,
        2
    ) AS profit_percentage,

    bs.total_orders,

    bs.total_customers,

    ROUND(
        CASE
            WHEN bs.total_orders = 0
            THEN 0
            ELSE
                bs.total_revenue / bs.total_orders
        END,
        2
    ) AS average_order_value,

    te.top_employee,

    tp.top_product,

    bc.best_category,

    ROUND(
        CASE
            WHEN bs.total_customers = 0
            THEN 0
            ELSE
                (
                    bs.repeat_customers::NUMERIC
                    / bs.total_customers
                ) * 100
        END,
        2
    ) AS repeat_customer_percentage,

    ROUND(
        COALESCE(iv.total_inventory_value, 0),
        2
    ) AS total_inventory_value,

    RANK() OVER (
        ORDER BY bs.total_revenue DESC
    ) AS branch_revenue_rank,

    RANK() OVER (
        ORDER BY bs.total_profit DESC
    ) AS branch_profit_rank

FROM branch_sales bs

LEFT JOIN top_employee te
    ON bs.branch_id = te.branch_id

LEFT JOIN top_product tp
    ON bs.branch_id = tp.branch_id

LEFT JOIN best_category bc
    ON bs.branch_id = bc.branch_id

LEFT JOIN inventory_value iv
    ON bs.branch_id = iv.branch_id;


-- =========================================================
-- FINAL CHECK OF THE REQUIRED VIEW
-- =========================================================

SELECT *
FROM Branch_Expansion_Report
ORDER BY branch_revenue_rank;


-- =========================================================
-- OPTIONAL: CHECK NUMBER OF BRANCHES IN FINAL REPORT
-- =========================================================

SELECT COUNT(*) AS branch_count
FROM Branch_Expansion_Report;
SELECT *
FROM public.Branch_Expansion_Report
ORDER BY branch_revenue_rank;


--------------------------------------------------
SELECT *
FROM public.Branch_Expansion_Report
ORDER BY branch_revenue_rank;

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 20;


SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        WHEN order_count > 1 THEN 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        WHEN order_count > 1 THEN 'Repeat Customer'
    END
ORDER BY customer_type;

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count = 1)
        / COUNT(*),
        2
    ) AS one_time_customer_percentage
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x;
SELECT
    COUNT(*) AS customers_buying_multiple_categories
FROM (
    SELECT
        o.customer_id
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY o.customer_id
    HAVING COUNT(DISTINCT p.category) > 1
) x;

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_id IN (SELECT customer_id FROM orders)
    ) AS customers_with_orders,
    COUNT(*) FILTER (
        WHERE customer_id NOT IN (SELECT customer_id FROM orders)
    ) AS customers_without_orders
FROM customers;
SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 20;

-- ============================================================
-- FIX CUSTOMER ORDER DISTRIBUTION
-- Creates:
--   • One-time customers
--   • Repeat customers
--   • Customers with multiple orders
--   • 150 customers who never order
-- ============================================================

-- Remove existing order details first because they depend on Orders
DELETE FROM Order_Details;

-- Remove existing orders
DELETE FROM Orders;


-- ============================================================
-- CREATE NEW ORDERS
-- ============================================================

INSERT INTO Orders
(
    Order_ID,
    Customer_ID,
    Employee_ID,
    Order_Date,
    Payment_Mode
)

SELECT
    gs AS Order_ID,

    CASE
        -- ----------------------------------------------------
        -- 500 customers: ONE-TIME customers
        -- Customer IDs 1-500
        -- ----------------------------------------------------
        WHEN gs <= 500
            THEN gs

        -- ----------------------------------------------------
        -- 1000 customers: REPEAT customers
        -- Customer IDs 501-1500
        -- Each gets multiple orders
        -- ----------------------------------------------------
        WHEN gs <= 14500
            THEN 501 + ((gs - 501) % 1000)

        -- ----------------------------------------------------
        -- Additional orders for customers 1501-2350
        -- Creates another repeat-customer group
        -- ----------------------------------------------------
        ELSE
            1501 + ((gs - 14501) % 850)
    END AS Customer_ID,

    -- Sales employees only
    2 + ((gs - 1) % 90) AS Employee_ID,

    DATE '2025-01-01'
        + ((gs * 13) % 365)::INTEGER AS Order_Date,

    CASE (gs % 5)
        WHEN 0 THEN 'UPI'
        WHEN 1 THEN 'Card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'Wallet'
        ELSE 'Net Banking'
    END AS Payment_Mode

FROM generate_series(1, 20000) AS gs;

INSERT INTO Order_Details
(
    Order_Detail_ID,
    Order_ID,
    Product_ID,
    Quantity,
    Discount
)

SELECT
    gs AS Order_Detail_ID,

    1 + ((gs - 1) % 20000) AS Order_ID,

    -- Products 1-388 are sold.
    -- Products 389-400 remain NEVER SOLD.
    1 + ((gs - 1) % 388) AS Product_ID,

    1 + ((gs - 1) % 10) AS Quantity,

    CASE (gs % 5)
        WHEN 0 THEN 0.00
        WHEN 1 THEN 0.02
        WHEN 2 THEN 0.05
        WHEN 3 THEN 0.10
        ELSE 0.15
    END AS Discount

FROM generate_series(1, 40000) AS gs;
SELECT
    CASE
        WHEN order_count = 1
            THEN 'One-Time Customer'
        WHEN order_count > 1
            THEN 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x
GROUP BY
    CASE
        WHEN order_count = 1
            THEN 'One-Time Customer'
        WHEN order_count > 1
            THEN 'Repeat Customer'
    END
ORDER BY customer_type;

SELECT COUNT(*) AS never_ordered_customers
FROM customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER
    (
        WHERE customer_id IN
        (
            SELECT customer_id
            FROM orders
        )
    ) AS customers_with_orders,

    COUNT(*) FILTER
    (
        WHERE customer_id NOT IN
        (
            SELECT customer_id
            FROM orders
        )
    ) AS customers_without_orders

FROM customers;

SELECT
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE order_count > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE order_count = 1)
        / COUNT(*),
        2
    ) AS one_time_customer_percentage

FROM
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x;

SELECT
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE order_count > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE order_count = 1)
        / COUNT(*),
        2
    ) AS one_time_customer_percentage

FROM
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) x;

SELECT
    e.employee_id,
    e.employee_name,
    b.branch_name,
    ROUND(
        SUM(
            od.quantity * p.selling_price * (1 - od.discount)
        ),
        2
    ) AS total_sales
FROM employees e
JOIN branches b
    ON e.branch_id = b.branch_id
JOIN orders o
    ON e.employee_id = o.employee_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY
    e.employee_id,
    e.employee_name,
    b.branch_name
ORDER BY total_sales DESC
LIMIT 1;

SELECT
    p.category,
    ROUND(
        SUM(
            (p.selling_price * (1 - od.discount) - p.cost_price)
            * od.quantity
        ),
        2
    ) AS total_profit
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_profit DESC
LIMIT 1;
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_quantity_sold DESC
LIMIT 1;

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS order_count,
        COALESCE(
            SUM(
                od.quantity * p.selling_price * (1 - od.discount)
            ),
            0
        ) AS total_spend,
        COUNT(DISTINCT p.category) AS categories_purchased
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_details od
        ON o.order_id = od.order_id
    LEFT JOIN products p
        ON od.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE order_count = 0) AS customers_without_orders,
    ROUND(AVG(total_spend) FILTER (WHERE order_count > 0), 2)
        AS average_customer_spend,
    COUNT(*) FILTER (WHERE categories_purchased > 1)
        AS multi_category_customers
FROM customer_orders;

SELECT
    COUNT(*) FILTER (WHERE stock_quantity = 0) AS out_of_stock_products,
    COUNT(*) FILTER (
        WHERE stock_quantity > 0
          AND stock_quantity < reorder_level
    ) AS below_reorder_level_products,
    COUNT(*) FILTER (
        WHERE NOT EXISTS (
            SELECT 1
            FROM order_details od
            WHERE od.product_id = i.product_id
        )
    ) AS never_ordered_products
FROM inventory i;

SELECT
    p.category,
    ROUND(
        SUM(
            (p.selling_price * (1 - od.discount) - p.cost_price)
            * od.quantity
        ),
        2
    ) AS total_profit
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY total_profit DESC
LIMIT 1;