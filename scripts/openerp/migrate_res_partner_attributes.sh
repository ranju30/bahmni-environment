#!/bin/bash

set -e

rm -rf /tmp/res_partner_attributes.sql

echo "Please enter MySQl password when prompted."


mysql -uroot -p openmrs -e "
select \"alter table res_partner_attributes RENAME  to res_partner_attributes_old;\" from dual
union
select \"alter index IF EXISTS res_partner_attributes_partner_id_index rename to res_partner_attributes_partner_id_index_old;\" from dual
union
select \"CREATE TABLE res_partner_attributes (id serial NOT NULL PRIMARY KEY,create_uid integer REFERENCES res_users(id) ON DELETE SET NULL,create_date timestamp without time zone,write_date timestamp without time zone,write_uid integer REFERENCES res_users(id) ON DELETE SET NULL,partner_id integer NOT NULL REFERENCES res_partner(id) ON DELETE SET NULL);\" from dual
union
select
  concat(\"alter table res_partner_attributes add column \",
         \"\\\"x_\", name,\"\\\"\",
         \" character varying;\",
         \"insert into ir_model_fields(model, model_id, name, ttype, state,select_level, field_description) VALUES ('res.partner.attributes', (select id from ir_model where model='res.partner.attributes'),'\",
         \"x_\",name,
         \"', 'char', 'manual',0, '\",
         name, \"');\")
 INTO OUTFILE '/tmp/res_partner_attributes.sql'
      LINES TERMINATED BY '\n'
 FROM person_attribute_type";


psql -l -Upostgres openerp -f /tmp/res_partner_attributes.sql







