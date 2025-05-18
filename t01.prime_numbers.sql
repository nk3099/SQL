-- Write a query to print all prime numbers less than or equal to . Print your result on a single line, and use the ampersand () character as your separator (instead of a space).
-- For example, the output for all prime numbers  would be: 2&3&5&7

-- Declare the limit
DECLARE @N INT = 1000;

--OR-- Generate numbers from 2 to @N using system table
-- WITH CTE AS (
--     SELECT TOP (@N - 1) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 1 AS num
--     FROM sys.all_objects

-- Generate numbers from 2 to @N and filter primes
WITH CTE AS (
    SELECT 2 AS num
    UNION ALL
    SELECT num + 1
    FROM CTE
    WHERE num + 1 <= @N
),
Primes AS (
    SELECT num
    FROM CTE
    WHERE NOT EXISTS (
        SELECT 1
        FROM CTE AS Divisors
        WHERE Divisors.num < CTE.num AND Divisors.num > 1 AND CTE.num % Divisors.num = 0
    )
 )
SELECT STRING_AGG(CAST(num AS VARCHAR), '&') AS PrimeList
FROM Primes
OPTION (MAXRECURSION 0);
