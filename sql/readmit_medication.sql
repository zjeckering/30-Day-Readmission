DROP VIEW IF EXISTS readmit_med;

CREATE VIEW readmit_med AS
SELECT
    CASE
        WHEN p.num_medications < 11 THEN '1-10'
        WHEN p.num_medications BETWEEN 11 AND 20 THEN '11-20'
        WHEN p.num_medications BETWEEN 21 AND 30 THEN '21-30'
        ELSE '31+'
        END as med_bucket,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY 1
ORDER BY rate DESC;

SELECT * FROM readmit_med;
