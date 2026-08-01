DROP VIEW IF EXISTS readmit_lab;

CREATE VIEW readmit_lab AS
SELECT
    CASE
        WHEN p.num_lab_procedures BETWEEN 1 AND 15 THEN '1-15'
        WHEN p.num_lab_procedures BETWEEN 16 AND 30 THEN '16-30'
        WHEN p.num_lab_procedures BETWEEN 31 AND 45 THEN '31-45'
        WHEN p.num_lab_procedures BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS lab_bucket,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END) / COUNT(*), 1
    ) AS rate
FROM patient_data AS p
GROUP BY 1
ORDER BY rate DESC;

SELECT * FROM readmit_lab;