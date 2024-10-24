-- What are the top 5 brands by receipts scanned for most recent month?
-- How do we define being a top brand? let's decide that we want to look at the total number of items purchased per brand
SELECT 
    brandCode,
    brandName,
    SUM(purchasedItemCount) AS total_purchased_items
FROM receipts
WHERE receiptDate >= DATEADD(month, -1, GETDATE())
GROUP BY brandCode, brandName
ORDER BY total_purchased_items DESC
LIMIT 5;


--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

WITH current_month AS (
    SELECT 
        brandCode,
        brandName,
        SUM(purchasedItemCount) AS total_purchased_items,
        RANK() OVER (ORDER BY SUM(purchasedItemCount) DESC) AS rank
    FROM receipts 
    WHERE receiptDate >= DATEADD(month, -1, GETDATE())
    GROUP BY brandCode, brandName
),
previous_month AS (
    SELECT 
        brandCode,
        brandName,
        SUM(purchasedItemCount) AS total_purchased_items,
        RANK() OVER (ORDER BY SUM(purchasedItemCount) DESC) AS rank
    FROM receipts 
    WHERE receiptDate >= DATEADD(month, -2, GETDATE()) AND receiptDate < DATEADD(month, -1, GETDATE())
    GROUP BY brandCode, brandName
)
SELECT 
    c.brandCode,
    c.brandName,
    c.total_purchased_items AS current_month_items,
    c.rank AS current_month_rank,
    p.total_purchased_items AS previous_month_items,
    p.rank AS previous_month_rank,
    c.rank - p.rank AS rank_change
FROM current_month c
LEFT JOIN previous_month p ON c.brandCode = p.brandCode
WHERE c.rank <= 5 OR p.rank <= 5
ORDER BY c.rank, p.rank;