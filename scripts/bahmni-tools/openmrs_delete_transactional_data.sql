UPDATE obs SET obs_group_id = NULL ;
DELETE from obs;
DELETE from obs_relationship;
DELETE FROM drug_order;
DELETE FROM test_order;
DELETE from orders;
DELETE FROM encounter_provider;
DELETE FROM encounter;
DELETE FROM visit;
DELETE FROM person_attribute;
DELETE from person_name where person_id not in(select person_id from users union select person_id from provider);
DELETE FROM patient where patient_id not in(select person_id from users union select person_id from provider);
DELETE from person_address where person_id not in (select person_id from users union select person_id from provider);
DELETE from person where person_id not in(select person_id from users union select person_id from provider);


update users
set	password = '4a1750c8607dfa237de36c6305715c223415189',
  salt = 'c788c6ad82a157b712392ca695dfcf2eed193d7f',
  secret_question = null,
  secret_answer = null
where username NOT IN ('admin', 'superman', 'superuser');