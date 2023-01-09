--- 1. Top 10 best selling products
SELECT TOP 10 
	p.product_id As 'Product ID', 
	cd.product_category_name_translation AS 'Product Category Name', 
	SUM(oi.order_item_id) AS 'Order Qty'
FROM Order_Items AS oi
	JOIN Products AS p
	ON oi.product_id = p.product_id
	JOIN Category_Desc AS cd
	ON p.product_category_name = cd.product_category_name
GROUP BY p.product_id, cd.product_category_name_translation
ORDER BY SUM(order_item_id) DESC;

--- 2. Top 10 best-selling product categories
SELECT TOP 10 
	cd.product_category_name_translation AS 'Product Category Name', 
	SUM(oi.order_item_id) AS 'Order Qty'
FROM Order_Items AS oi
	JOIN Products AS p
	ON oi.product_id = p.product_id
	JOIN Category_Desc AS cd
	ON p.product_category_name = cd.product_category_name
GROUP BY cd.product_category_name_translation
ORDER BY SUM(order_item_id) DESC;

--- 3. Top 10 products by profit
SELECT TOP 10 
	op.product_id AS 'Product ID', 
	op.product_category_name_translation AS 'Product Category Name', 
	SUM(price) AS 'Profits'
FROM	
	(SELECT 
		oi.product_id, 
		p.product_category_name, 
		cd.product_category_name_translation, 
		oi.price
	FROM Order_Items AS oi
		JOIN Products AS p
		ON oi.product_id = p.product_id
		JOIN Category_Desc AS cd
		ON p.product_category_name = cd.product_category_name) AS op
GROUP BY op.product_id, op.product_category_name_translation
ORDER BY profits DESC;

--- 4. Top 10 product categories by profit
SELECT TOP 10 
	op.product_category_name_translation AS 'Product Category Name', 
	SUM(price) AS 'Profits'
FROM	
	(SELECT 
		oi.product_id, p.product_category_name, 
		cd.product_category_name_translation, 
		oi.price
	FROM Order_Items AS oi
		JOIN Products AS p
		ON oi.product_id = p.product_id
		JOIN Category_Desc AS cd
		ON p.product_category_name = cd.product_category_name) AS op
GROUP BY op.product_category_name_translation
ORDER BY profits DESC;

--- 5. Total profit per year
SELECT 
	YEAR(o.order_approved_at) AS 'Order Year', 
	SUM(oi.price) AS 'Profits'
FROM Orders AS o
	JOIN Order_Items AS oi
	ON o.order_id = oi.order_id
WHERE o.order_approved_at IS NOT NULL
GROUP BY YEAR(o.order_approved_at);

--- 6. Total profit per month
SELECT 
	MONTH(o.order_approved_at) AS 'Order Month', 
	DATENAME(MONTH,o.order_approved_at) AS 'Month Name',
	YEAR(o.order_approved_at) AS 'Order Year', 
	SUM(oi.price) AS 'Profits'
FROM Orders AS o
	JOIN Order_Items AS oi
	ON o.order_id = oi.order_id
WHERE o.order_approved_at IS NOT NULL
GROUP BY 
	MONTH(o.order_approved_at),
	DATENAME(MONTH,o.order_approved_at), 
	YEAR(o.order_approved_at)
ORDER BY 
	YEAR(o.order_approved_at),
	MONTH(o.order_approved_at);

--- 7. Top 10 customers by order quantity
SELECT TOP 10 
	c.customer_id AS ' Customer ID',
	c.customer_city AS 'City',
	c.customer_state AS 'State',
	SUM(oi.order_item_id) AS 'Order Qty'
FROM Customers AS c
	JOIN Orders AS o
	ON c.customer_id = o.customer_id
	JOIN Order_Items AS oi
	ON o.order_id = oi.order_id
GROUP BY 
	c.customer_id,
	c.customer_city,
	c.customer_state
ORDER BY SUM(oi.order_item_id) DESC;

--- 8. Top 10 sellers by order quantity
SELECT TOP 10 
	oi.seller_id AS 'Seller ID', 
	SUM(oi.order_item_id) AS 'Order Qty'
FROM Order_Items AS oi
GROUP BY oi.seller_id
ORDER BY SUM(oi.order_item_id) DESC;

--- 9. Top 10 cities by profit
SELECT TOP 10 
	c.customer_city AS 'City',
	c.customer_state AS 'State',
	SUM(oi.price) AS 'Profits'
FROM Customers AS c
	JOIN Orders AS o
	ON c.customer_id = o.customer_id
	JOIN Order_Items AS oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_city,c.customer_state
ORDER BY SUM(oi.price) DESC;

--- 10. Most commonly used payment types
SELECT 
	payment_type AS 'Payment Type', 
	COUNT(payment_type) AS 'Number of Users'
FROM Order_Payments
GROUP BY payment_type
ORDER BY COUNT(payment_type) DESC;

--- 11. The product categoriy that has a review score of less than 3
SELECT 
	cd.product_category_name_translation AS 'Product Category Name', 
	AVG(ore.review_score) AS 'Average of Review Score'
FROM Order_Items AS oi
	JOIN Order_Reviews AS ore
	ON oi.order_id = ore.order_id
	JOIN Products AS p
	ON oi.product_id = p.product_id
	JOIN Category_Desc AS cd
	ON p.product_category_name = cd.product_category_name
WHERE p.product_category_name IS NOT NULL
GROUP BY cd.product_category_name_translation
HAVING AVG(ore.review_score)<3;

--- 12. Sellers who have a review score less than 3 and total reviews greater than 10
SELECT 
	oi.seller_id AS 'Sellers ID', 
	COUNT(ore.review_score) AS 'Review Count',
	AVG(ore.review_score) AS 'Average of Review Score'
FROM Order_Items AS oi
	JOIN Order_Reviews AS ore
	ON oi.order_id = ore.order_id

WHERE YEAR(ore.review_creation_date) = '2018'
GROUP BY oi.seller_id
HAVING 
	(COUNT(ore.review_score)>10) AND 
	(AVG(ore.review_score)<3)
ORDER BY COUNT(ore.review_score) DESC;