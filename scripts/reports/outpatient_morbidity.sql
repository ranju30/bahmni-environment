-- Views
CREATE OR REPLACE VIEW concept_mapping AS
SELECT concept_reference_map.concept_id, concept_map_type.name AS map_type, concept_reference_term.code, concept_reference_term.name AS term_name, concept_reference_source.name AS source_name
FROM concept_reference_term
JOIN concept_reference_map ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
JOIN concept_map_type ON concept_reference_map.concept_map_type_id = concept_map_type.concept_map_type_id
JOIN concept_reference_source ON concept_reference_source.concept_source_id = concept_reference_term.concept_source_id;

CREATE OR REPLACE VIEW concept_data AS
SELECT concept.concept_id, concept_full_name.name AS full_name, concept_short_name.name AS short_name, 
	   concept_class.name AS class, concept_datatype.name AS datatype, concept.retired
FROM concept
LEFT OUTER JOIN concept_name AS concept_full_name ON concept_full_name.concept_id = concept.concept_id 
			AND concept_full_name.concept_name_type = 'FULLY_SPECIFIED' 
			AND concept_full_name.locale = 'en'
			AND concept_full_name.voided = 0
LEFT OUTER JOIN concept_name AS concept_short_name ON concept_short_name.concept_id = concept.concept_id 
		    AND concept_short_name.concept_name_type = 'SHORT'
			AND concept_short_name.locale = 'en'
			AND concept_short_name.voided = 0 
LEFT OUTER JOIN concept_class ON concept_class.concept_class_id = concept.class_id
LEFT OUTER JOIN concept_datatype ON concept_datatype.concept_datatype_id = concept.datatype_id;

CREATE OR REPLACE VIEW coded_obs AS
SELECT obs.obs_id, obs.concept_id, obs.person_id, obs.value_coded, obs.obs_group_id, obs.obs_datetime,
	   reference_concept.full_name AS name, value_concept.full_name AS value
FROM obs
JOIN concept_data AS reference_concept ON reference_concept.concept_id = obs.concept_id AND reference_concept.datatype = 'Coded'
LEFT OUTER JOIN concept_data AS value_concept ON value_concept.concept_id = obs.value_coded
WHERE obs.voided = 0;

CREATE OR REPLACE VIEW patient_diagnosis AS
SELECT distinct diagnois_obs.value_coded AS diagnois_concept_id, diagnois_obs.person_id, diagnois_obs.value AS name,
		certainity_obs.value AS certainity,
	    order_obs.value AS `order`,
	    status_obs.value AS status,
		diagnois_obs.obs_datetime
FROM coded_obs AS diagnois_obs
JOIN obs AS diagnosis_parent_obs ON diagnois_obs.name = 'Coded Diagnosis' AND diagnois_obs.obs_group_id = diagnosis_parent_obs.obs_id
JOIN coded_obs AS certainity_obs ON certainity_obs.obs_group_id = diagnosis_parent_obs.obs_id AND certainity_obs.name = 'Diagnosis Certainty'
JOIN coded_obs AS order_obs ON order_obs.obs_group_id = diagnosis_parent_obs.obs_id AND order_obs.name = 'Diagnosis Order'
LEFT OUTER JOIN coded_obs AS status_obs ON status_obs.obs_group_id = diagnosis_parent_obs.obs_id AND status_obs.name = 'Bahmni Diagnosis Status';

CREATE OR REPLACE VIEW diagnosis AS
SELECT * FROM concept_data WHERE class = 'Diagnosis';

CREATE OR REPLACE VIEW diagnosis_icd10_mapping AS
SELECT diagnosis.*, concept_mapping.code
FROM diagnosis 
LEFT OUTER JOIN concept_mapping ON concept_mapping.concept_id = diagnosis.concept_id 
				AND concept_mapping.source_name = 'ICD 10 - WHO' AND concept_mapping.map_type = 'SAME-AS';


-- Parameters
SET @start_date = '2014-09-01';
SET @end_date = '2014-09-30';

-- Query
SELECT diagnosis.full_name, diagnosis.code, concept_mapping.term_name AS group_name,
SUM(CASE WHEN person.gender = 'F' THEN 1 ELSE 0 END) AS female,
SUM(CASE WHEN person.gender = 'M' THEN 1 ELSE 0 END) AS male
FROM diagnosis_icd10_mapping AS diagnosis
LEFT OUTER JOIN concept_mapping ON concept_mapping.concept_id = diagnosis.concept_id
			AND concept_mapping.source_name = 'ICD 10 - WHO' AND concept_mapping.map_type = 'NARROWER-THAN'
LEFT OUTER JOIN	patient_diagnosis ON patient_diagnosis.diagnois_concept_id = diagnosis.concept_id 
	AND patient_diagnosis.certainity = 'Confirmed'
	AND (patient_diagnosis.status IS NULL OR patient_diagnosis.status != 'Ruled Out Diagnosis')
	AND (patient_diagnosis.obs_datetime BETWEEN @start_date AND @end_date)
LEFT OUTER JOIN person ON patient_diagnosis.person_id = person.person_id
GROUP BY diagnosis.concept_id, diagnosis.full_name, diagnosis.code, concept_mapping.term_name;