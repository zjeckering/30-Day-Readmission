DROP VIEW IF EXISTS readmit_procedure;

CREATE VIEW readmit_procedure AS
SELECT
    p.num_procedures,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY p.num_procedures
ORDER BY rate DESC;

SELECT * FROM readmit_procedure;
