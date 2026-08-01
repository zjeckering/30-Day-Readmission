DROP VIEW IF EXISTS readmit_los;

CREATE VIEW readmit_los AS
SELECT
    p.time_in_hospital,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY p.time_in_hospital
ORDER BY rate DESC;

SELECT * FROM readmit_los;