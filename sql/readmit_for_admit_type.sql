DROP VIEW IF EXISTS readmit_admit_type;

CREATE VIEW readmit_admit_type AS
SELECT
    p.admission_type,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY p.admission_type
ORDER BY rate DESC;

SELECT * FROM readmit_admit_type;
