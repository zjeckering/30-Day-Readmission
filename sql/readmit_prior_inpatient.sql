DROP VIEW IF EXISTS readmit_inpatient;

CREATE VIEW readmit_inpatient AS
SELECT
    p.number_inpatient,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY p.number_inpatient
ORDER BY rate DESC;

SELECT * FROM readmit_inpatient;
 
-- NOISY AROUND THE HIGH AND LOW ENDS