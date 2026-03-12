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

-- 2.
-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.

SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;

-- 3.
-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.

select 
  sum(case when gender = 'M' then 1 end) as male_count,
  sum(case when gender = 'F' then 1 end) as female_count 
from patients;

-- OR

SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients

-- 4.
-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
-- Show results ordered ascending by allergies then by first_name then by last_name.

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies ASC,
  first_name ASC,
  last_name ASC;

-- 5.
-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

-- 6.
-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.
SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city asc;

-- 7.
-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;

-- 8.
-- Show all allergies ordered by popularity. Remove NULL values from query.
SELECT
  allergies,
  count(*)
FROM patients
WHERE allergies NOT NULL
GROUP BY allergies
ORDER BY count(*) DESC

-- OR
SELECT
  allergies,
  count(allergies) AS total_diagnosis
FROM patients
GROUP BY allergies
HAVING
  allergies IS NOT NULL
ORDER BY total_diagnosis DESC

-- OR
SELECT
  allergies,
  count(*)
FROM patients
WHERE allergies NOT NULL
GROUP BY allergies
ORDER BY count(*) DESC

-- 9.
-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
-- Sort the list starting from the earliest birth_date.
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

-- OR
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE year(birth_date) LIKE '197%'
ORDER BY birth_date ASC

-- 10.
-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
--   Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;

-- OR

SELECT
  UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format
FROM patients
ORDER BY first_name DESC;
EX: SMITH,jane

-- 11. 
-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000

-- OR

select *
from (
    select
      province_id,
      SUM(height) as sum_height
    FROM patients
    group by province_id
  )
where sum_height >= 7000;

-- 12.
-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

-- 13.
-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC

14.
-- Show all columns for patient_id 542's most recent admission_date.

SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);

-- OR

SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1

-- OR
  
SELECT *
FROM admissions
GROUP BY patient_id
HAVING
  patient_id = 542
  AND max(admission_date)

-- 15. 
-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  )
