-- Major Characteristics of MIMIC-III Database

-- Code used to extract data related to Figure 1: Top Five Patient Diagnoses 

SELECT diagnosis, COUNT(diagnosis) AS count_of_diagnosis
FROM admissions
GROUP BY diagnosis
ORDER BY count_of_diagnosis DESC
LIMIT 5;

-- Code used to extract data related to Figure 2: Top Ten Procedures for a Diagnosis of Pneumonia 

WITH pneumonia_diagnosis AS 
(
	SELECT diagnosis, a.subject_id, a.hadm_id, icd9_code
    FROM admissions a
		INNER JOIN procedures_icd p 
			ON a.hadm_id = p.hadm_id
    WHERE diagnosis = 'PNEUMONIA'
)
SELECT short_title, COUNT(short_title) AS count_of_procedure
FROM pneumonia_diagnosis pd
	INNER JOIN d_icd_procedures d
		ON pd.icd9_code = d.icd9_code
GROUP BY short_title
ORDER BY count_of_procedure DESC
LIMIT 10;

-- Code used to extract data related to Figure 3: Overview of Deaths by Service 

WITH service_deaths AS
(
	SELECT 	CURR_SERVICE, 
			GENDER,
			COUNT(CURR_SERVICE) AS service_count, 
			SUM(HOSPITAL_EXPIRE_FLAG) AS number_of_deaths,
            ROUND(SUM(HOSPITAL_EXPIRE_FLAG) / COUNT(CURR_SERVICE), 2) AS percent_died
	FROM admissions a
		JOIN patients p 
			ON a.subject_id = p.subject_id
		JOIN services s 
			ON p.subject_id = s.subject_id
	GROUP BY CURR_SERVICE, GENDER 
	ORDER BY CURR_SERVICE, GENDER DESC
)
SELECT CURR_SERVICE,
	GENDER,
    service_count,
    number_of_deaths,
    percent_died
FROM service_deaths
ORDER BY CURR_SERVICE, GENDER DESC;
