-- What are the top 5 brands by receipts scanned for most recent month?

/* How do we define being a top brand? 
First, I wanted to look at the total number of items purchased per brand 

But, this interpretation can lead to some issues. If a customer buys 100 items 
from a single brand A, but 99 customers buy 1 item from brand B, brand A will 
be ranked higher than brand B, which is not a good interpretation of what a top 
brand is.

So as asked, let's decide that we want to look at the total number of receipts per 
brand and then the total number of items purchased per brand if there are 
multiple brands with the same number of receipts.
*/

SELECT 
    i.brandCode,
    b.name AS brandName,
    COUNT(DISTINCT r.receipt_id) AS receipts_scanned
FROM receipts r
JOIN items i ON r.receipt_id = i.receipt_id
JOIN brands b ON i.brandCode = b.brandCode
WHERE r.dateScanned >= current_date - interval '1 month'
GROUP BY i.brandCode, b.name
ORDER BY receipts_scanned DESC
LIMIT 5;

-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?


WITH current_month AS (
    SELECT 
        i.brandCode,
        i.brandName,
        COUNT(DISTINCT r.receipt_id) AS receipts_scanned,
        RANK() OVER (ORDER BY COUNT(DISTINCT r.receipt_id) DESC) AS rank
    FROM receipts r 
    JOIN items i ON r.receipt_id = i.receipt_id
    WHERE r.dateScanned >= current_date - interval '1 month'
    GROUP BY i.brandCode, i.brandName
),
previous_month AS (
    SELECT 
        i.brandCode,
        i.brandName,
        COUNT(DISTINCT r.receipt_id) AS receipts_scanned,
        RANK() OVER (ORDER BY COUNT(DISTINCT r.receipt_id) DESC) AS rank
    FROM receipts r 
    JOIN items i ON r.receipt_id = i.receipt_id
    WHERE r.dateScanned >= current_date - interval '2 months' 
    AND r.dateScanned < current_date - interval '1 month'
    GROUP BY i.brandCode, i.brandName
)
SELECT 
    c.brandCode,
    c.brandName,
    c.receipts_scanned AS current_month_receipts_scanned,
    c.rank AS current_month_rank,
    p.receipts_scanned AS previous_month_receipts_scanned,
    p.rank AS previous_month_rank,
    c.rank - p.rank AS rank_change
FROM current_month c
LEFT JOIN previous_month p ON c.brandCode = p.brandCode
WHERE c.rank <= 5 OR p.rank <= 5
ORDER BY c.rank, p.rank;


-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT 
    rewardsReceiptStatus,
    AVG(totalSpent) AS average_spend
FROM receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rewardsReceiptStatus
ORDER BY AVG(totalSpent) DESC;

-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT 
    r.rewardsReceiptStatus,
    SUM(i.quantityPurchased) AS total_items_purchased
FROM receipts r
JOIN items i ON r.receipt_id = i.receipt_id
WHERE r.rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY r.rewardsReceiptStatus
ORDER BY SUM(i.quantityPurchased) DESC;

-- Which brand has the most spend among users who were created within the past 6 months?

SELECT 
    b.name AS brand_name,
    SUM(r.totalSpent) AS total_spend
FROM users u
JOIN receipts r ON u.user_id = r.user_id
JOIN items i ON r.receipt_id = i.receipt_id
JOIN brands b ON i.brandCode = b.brandCode
WHERE u.createdDate >= current_date - interval '6 months'
GROUP BY b.name
ORDER BY total_spend DESC
LIMIT 1; 

-- Which brand has the most transactions among users who were created within the past 6 months?


SELECT 
    b.name AS brand_name,
    COUNT(DISTINCT r.receipt_id) AS transaction_count
FROM users u
JOIN receipts r ON u.user_id = r.user_id
JOIN items i ON r.receipt_id = i.receipt_id
JOIN brands b ON i.brandCode = b.brandCode
WHERE u.createdDate >= current_date - interval '6 months'
GROUP BY b.name
ORDER BY transaction_count DESC
LIMIT 1;
