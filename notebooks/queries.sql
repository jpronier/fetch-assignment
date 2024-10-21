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