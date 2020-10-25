-- 1. check book availability

SELECT 
	COUNT(DISTINCT(CASE WHEN DueDate is not NULL AND ReturnedDate is NULL THEN b.BookID END)) AS books_on_loan
	, COUNT(DISTINCT(b.BookID)) - COUNT(DISTINCT(CASE WHEN DueDate is not NULL AND ReturnedDate is NULL THEN b.BookID END)) AS books_available
	, Title 
FROM Books b 
LEFT JOIN Loans l
	ON b.BookID  = l.BookID
WHERE LOWER(Title) = 'dracula'
GROUP BY 
	Title
;

-- 2. Add new book to library

--checking if they exist already first

SELECT 
	*
FROM Books b 
WHERE Barcode IN (4819277482, 4899254401)
; -- no result

INSERT INTO Books (Title, Author, Published, Barcode)
VALUES 
	('Dracula', 'Bram Stoker', 1897, 4819277482)
	("Gulliver's Travel", 'Jonathan Swift', 1729, 4899254401)
;

-- 3. check out books 

--checking if book is already loaned

SELECT *
FROM Books b 
	JOIN Loans l
		ON b.BookID = l.BookID 
WHERE 
	b.Barcode IN (2855934983, 4043822646)
	AND DueDate iS NOT NULL
	AND ReturnedDate is NULL
; -- no result so books are available

--pulling patron's info

INSERT INTO Loans (BookID, PatronID, LoanDate, DueDate)
SELECT 
	BookID
	, (
		SELECT PatronID 
		FROM Patrons p 
		WHERE LOWER(Email) LIKE '%jvaan@wisdompets%'
	  )
	, '2020-08-25'
	, '2020-09-08'
FROM Books 
WHERE 
	Barcode IN (2855934983, 4043822646)
;


-- 4. Check for books due date

SELECT 
	p.FirstName
	, p.LastName 
	, p.Email 
	, b.Title 
	, b.Author 
	, b.Barcode 
	, l.LoanDate 
	, l.DueDate 
FROM Loans l 
	LEFT JOIN Patrons p
		ON l.PatronID = p.PatronID 
	LEFT JOIN Books b
		ON l.BookID = b.BookID 
WHERE 
	DueDate = '2020-07-13'
	AND l.ReturnedDate IS NULL 
;

-- 5. Return Books to Library

UPDATE Loans 
SET ReturnedDate = '2020-07-05'
WHERE BookID IN
	(
		SELECT b.BookID 
		FROM Loans l
			JOIN Books b
			ON l.BookID = b.BookID 
		WHERE Barcode IN (6435968624, 5677520613, 8730298424)
	)
	AND ReturnedDate is NULL --very important, without this it will update history records. please do select before update
;

-- 6. Encourage patrons to check out books

SELECT 
	COUNT(l.LoanID) AS loans
	, p.FirstName 
	, p.LastName 
	, p.Email 
FROM Loans l
	LEFT JOIN Patrons p
		ON l.PatronID = p.PatronID 
WHERE l.ReturnedDate IS NOT NULL
GROUP BY 
	p.FirstName 
	, p.LastName 
	, p.Email 
ORDER BY
	loans
LIMIT 10
;

-- 7. Find Books to feature for an event

SELECT BookID 
	, Title 
	, Author 
	, Barcode
	, Published 
FROM Books
WHERE BookID NOT IN 
( 
	SELECT BookID 
	FROM Loans 
	WHERE ReturnedDate IS NULL
)
	AND Published BETWEEN 1890 AND 1900
ORDER BY Title 
;

-- 8. Book Statistics

--report showing how many books were published each year

SELECT 
	Published 
	, COUNT(DISTINCT Title) AS TotalPublishedBooks
FROM Books
GROUP BY
	Published 
ORDER BY 
	TotalPublishedBooks DESC 
;

--report showing most popular books to check out

SELECT 
	b.Title 
	, b.Author 
	, COUNT(DISTINCT LoanID) AS TotalLoaned
FROM Loans l 
	JOIN Books b
	ON l.BookID = b.BookID 
GROUP BY
	b.Title 
	, b.Author
ORDER BY
	TotalLoaned DESC
;
	






	