\set ON_ERROR_STOP true

TRUNCATE failed_events;

UPDATE person_address
SET value = concat('address1-', person_id)
FROM address_part
WHERE part_name = 'level1' AND person_address.address_part_id = address_part.id 
AND person_address.value IS NOT NULL;

UPDATE patient_identity
SET identity_data = concat('PRIMARYRELATIVE-', patient_id)
FROM patient_identity_type 
WHERE patient_identity_type.id = patient_identity.identity_type_id 
AND patient_identity_type.identity_type = 'PRIMARYRELATIVE';

UPDATE login_user
SET login_name = concat('user-', id)
WHERE login_name NOT IN ('admin');

-- Set every one's password as Admin123
UPDATE login_user
SET password = 'n2OrWHXVm/BQsgd1YZJoCA==';