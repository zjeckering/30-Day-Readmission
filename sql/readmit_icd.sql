DROP VIEW IF EXISTS readmit_icd;

CREATE VIEW readmit_icd AS
SELECT
    CASE
        WHEN p.diag_1 LIKE '250%' THEN 'diabetes'
        WHEN p.diag_1 LIKE 'V%' OR p.diag_1 LIKE 'E%' THEN 'other'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 390 AND 459 
            OR CAST(p.diag_1 AS REAL) = 785 THEN 'circulatory'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 460 AND 519 
            OR CAST(p.diag_1 AS REAL) = 786 THEN 'respiratory'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 520 AND 579 
            OR CAST(p.diag_1 AS REAL) = 787 THEN 'digestive'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 800 AND 999 THEN 'injury'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 710 AND 739 THEN 'musculoskeletal'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 580 AND 629 
            OR CAST(p.diag_1 AS REAL) = 788 THEN 'genitourinary'
        WHEN CAST(p.diag_1 AS REAL) BETWEEN 140 AND 239 THEN 'neoplasms'
        ELSE 'other' END as primary_diagnosis,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate,
    COUNT(*) AS total_patients
FROM patient_data as p
GROUP BY 1
ORDER BY rate DESC;

SELECT * FROM readmit_icd;
