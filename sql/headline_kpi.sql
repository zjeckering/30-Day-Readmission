DROP VIEW IF EXISTS headline_kpi;

CREATE VIEW headline_kpi AS 
SELECT
    COUNT(*) as total_encounters,
    SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END) as total_readmitted,
    ROUND(
        100.0 * SUM(CASE WHEN p.readmitted_30d = 1 THEN 1 ELSE 0 END)/COUNT(*), 1
    )
    as readmission_rate
FROM patient_data as p;

SELECT * FROM headline_kpi;