-- Sales report by country
SELECT 
    customers.Country,
    COUNT(DISTINCT customers.CustomerId) as TotalCustomers,
    COUNT(invoices.InvoiceId) as TotalInvoices,
    ROUND(SUM(invoices.Total), 2) as TotalRevenue,
    ROUND(AVG(invoices.Total), 2) as AvgInvoiceAmount
FROM customers
JOIN invoices ON customers.CustomerId = invoices.CustomerId
GROUP BY customers.Country
ORDER BY TotalRevenue DESC
LIMIT 10;
