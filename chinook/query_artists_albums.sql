-- Query to get artists and their album counts
SELECT 
    artists.Name as Artist,
    COUNT(albums.AlbumId) as AlbumCount
FROM artists
LEFT JOIN albums ON artists.ArtistId = albums.ArtistId
GROUP BY artists.ArtistId, artists.Name
ORDER BY AlbumCount DESC
LIMIT 10;
