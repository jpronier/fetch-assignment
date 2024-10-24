-- What are the top 5 brands by receipts scanned for most recent month?

-- How do we define being a top brand? 
-- First, let's decide that we want to look at the total number of items purchased per brand
SELECT 
    brandCode,
    brandName,
    SUM(purchasedItemCount) AS total_purchased_items
FROM receipts
WHERE receiptDate >= DATEADD(month, -1, GETDATE())
GROUP BY brandCode, brandName
ORDER BY total_purchased_items DESC
LIMIT 5;

-- Now, this interpretation can lead to some issues. If a customer buys 100 items from a single brand A, but 100 customers
-- buy 1 item from brand B, brand A will be ranked higher than brand B, which is not a good interpretation of what a top brand is.

-- So now, let's decide that we want to look at the total number of receipts per brand and then the total number of items 
-- purchased per brand if there are multiple brands with the same number of receipts.

-- What are the top 5 brands by receipts scanned for most recent month?
SELECT 
    i.brandCode,
    b.name AS brandName,
    COUNT(DISTINCT r.receipt_id) AS receipts_scanned,
    SUM(i.quantityPurchased) AS total_items_purchased
FROM receipts r
JOIN items i ON r.receipt_id = i.receipt_id
JOIN brands b ON i.brandCode = b.brandCode
WHERE r.dateScanned >= DATEADD(month, -1, GETDATE())
GROUP BY i.brandCode, b.name
ORDER BY receipts_scanned DESC, total_items_purchased DESC
LIMIT 5;

-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

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