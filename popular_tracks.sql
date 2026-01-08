-- Most purchased tracks
SELECT 
    tracks.Name as Track,
    artists.Name as Artist,
    COUNT(invoice_items.InvoiceLineId) as TimesPurchased,
    ROUND(SUM(invoice_items.UnitPrice * invoice_items.Quantity), 2) as TotalRevenue
FROM tracks
JOIN albums ON tracks.AlbumId = albums.AlbumId
JOIN artists ON albums.ArtistId = artists.ArtistId
JOIN invoice_items ON tracks.TrackId = invoice_items.TrackId
GROUP BY tracks.TrackId, tracks.Name, artists.Name
ORDER BY TimesPurchased DESC
LIMIT 15;
