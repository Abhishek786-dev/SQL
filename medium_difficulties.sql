-- 1.
-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.
--> 

select
  patients.patient_id,
  first_name,
  last_name
from patients
  INNER JOIN admissions on patients.patient_id = admissions.patient_id
where diagnosis is 'Dementia'
