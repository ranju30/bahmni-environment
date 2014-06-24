use openmrs;
set foreign_key_checks=0;
truncate table test_order;
truncate table drug_order;
truncate table obs;
truncate table orders;
truncate table bed_patient_assignment_map;
truncate table encounter_provider;
truncate table encounter;
truncate table visit;
truncate table patient_identifier;
truncate table patient;
delete from person_address where person_id <> 1;
delete from person_attribute where person_id <> 1;
delete from person_name where not exists 
	(select u.person_id from users u where person_name.person_id = u.person_id or person_name.person_id = 1) 
	and not exists (select p.person_id from provider p where person_name.person_id = p.person_id or person_name.person_id = 1);
delete from person where not exists 
	(select u.person_id from users u where person.person_id = u.person_id or person.person_id = 1) 
	and not exists (select p.person_id from provider p where person.person_id = p.person_id or person.person_id = 1);


delete from event_records where id not in (1, 2);

update markers set last_read_entry_id='tag:atomfeed.ict4h.org:62778482-e108-451e-b59b-34cf912d9c63', feed_uri_for_last_read_entry='http://localhost:8080/openerp-atomfeed-service/feed/sale_order/1' where feed_uri='http://localhost:8080/openerp-atomfeed-service/feed/sale_order/recent';	
	
update markers set last_read_entry_id='tag:atomfeed.ict4h.org:d354cbe0-5619-478d-82e5-3b42c7a0ca47', feed_uri_for_last_read_entry='http://localhost:8080/openelis/ws/feed/patient/1' where feed_uri='http://localhost:8080/openelis/ws/feed/patient/recent';	

set foreign_key_checks=1;