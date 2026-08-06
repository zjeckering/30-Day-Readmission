DROP VIEW IF EXISTS readmit_inpatient;

CREATE VIEW readmit_inpatient AS
SELECT
    CASE
        WHEN p.number_inpatient = 0 THEN '0'
        WHEN p.number_inpatient = 1 THEN '1'
        WHEN p.number_inpatient = 2 THEN '2'
        WHEN p.number_inpatient = 3 THEN '3'
        WHEN p.number_inpatient = 4 THEN '4'
        WHEN p.number_inpatient BETWEEN 5 AND 8 THEN '5-8'
        ELSE '9+'
    END AS inpatient_bucket,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    ) as rate
FROM patient_data as p
GROUP BY 1
ORDER BY rate DESC;

SELECT * FROM readmit_inpatient;

--SELECT p.number_inpatient, COUNT(*) as people
--FROM patient_data as p
--GROUP BY p.number_inpatient
--ORDER BY people;
 
-- NOISY AROUND THE HIGH AND LOW ENDS