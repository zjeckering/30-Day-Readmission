-- SQLite
DROP VIEW IF EXISTS patient_data;

CREATE VIEW patient_data AS
SELECT p.encounter_id,
CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmitted_30d,
p.gender,
p.age,
a.description as admission_type,
d.description as discharge_type,
s.description as source_type,
p.time_in_hospital,
p.num_lab_procedures,
p.num_procedures,
p.num_medications,
p.number_outpatient,
p.number_emergency,
p.number_inpatient,
p.diag_1
FROM diabetic_data as p
LEFT JOIN admission_source_lookup as s ON p.admission_source_id = s.admission_source_id
LEFT JOIN admission_type_lookup as a ON p.admission_type_id = a.admission_type_id
LEFT JOIN discharge_disposition_lookup as d ON d.discharge_disposition_id = p.discharge_disposition_id;

SELECT * FROM patient_data;
