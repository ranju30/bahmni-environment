URL=http://vishal:9000
curl -X POST -d @new_unit.xml  $URL
curl -X POST -d @new_stock_group.xml  $URL
curl -X POST -d @new_stock_item.xml  $URL
curl -X POST -d @new_patient_ledger.xml  $URL