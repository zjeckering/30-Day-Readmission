DROP VIEW IF EXISTS rate_age;

CREATE VIEW rate_age as 
SELECT
    p.age,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY p.age
ORDER BY rate DESC;

SELECT * FROM rate_age;