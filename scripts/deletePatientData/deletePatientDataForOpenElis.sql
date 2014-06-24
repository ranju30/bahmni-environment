truncate table result_signature,
	referral_result,
	referral,
	result_inventory,
	result,
	worksheet_analyte,
	note,
	report_external_export,
	report_external_import,
	analysis_qaevent,
	analysis_storages,
	analysis_users,
	analysis,
	sample_qaevent,
	sample_requester,
	sample_human,
	sample_newborn,
	sample_animal,
	sample_environmental,
	sample_item,
	sample_organization,
	sample_projects,
	sample,
	observation_history,
	patient,
	patient_identity,
	patient_occupation,
	person_address,
	patient_patient_type,
	patient_relations,
	organization_contact;

delete from person where not exists (select p.person_id from provider p where p.person_id = person.id);

delete from event_records where id != (select min(id) from event_records where category='patient');

update markers set last_read_entry_id='tag:atomfeed.ict4h.org:c1051da6-8ed9-4f6e-a576-bbe8186ea5f4', feed_uri_for_last_read_entry='http://localhost:8080/openmrs/ws/atomfeed/patient/1' where feed_uri='http://localhost:8080/openmrs/ws/atomfeed/patient/recent';	

update markers set last_read_entry_id='tag:atomfeed.ict4h.org:c8b00764-197b-4195-8ffe-81c01b398f4a', feed_uri_for_last_read_entry='http://localhost:8080/openmrs/ws/atomfeed/encounter/1' where feed_uri='http://localhost:8080/openmrs/ws/atomfeed/encounter/recent';	